require_relative "stream"
require_relative "util"


module PreProc
    include Util

    $openchars  = "({"
    $closechars = ")}"

    def skipTill(closingChar, stream)
        while !stream.eof
            c = stream.pop(1)
            if c == closingChar
                return
            else 
                idx = $openchars.index(c)
                if idx
                    skipTill($closechars[idx], stream)
                end
            end
        end
        raise "Closing character '#{closingChar}' not found in: #{stream.to_s}"
    end

    def extractOneArgument(stream)
        b = stream.pos
        while !stream.eof
            c = stream.pop(1)
            idx = $openchars.index(c)
            if idx
                skipTill($closechars[idx], stream)
                return stream.fromto(b, stream.pos-1)
            elsif c == ","
                return stream.fromto(b, stream.pos-2)
            end
        end
        raise "Couldn't extract one argument from #{stream.to_s}"
    end

    def skipOptionalComma(stream)
        while !stream.eof
            c = stream.pop(1)
            if c == ","
                return
            elsif $openchars.index(c)
                stream.unpop(1)
                return
            end
        end
    end

    def extractCountArguments(wantedArgCnt, stream)
        args = []
        while !stream.eof
            arg = extractOneArgument(stream)
            args.append(arg)
            if args.length == wantedArgCnt
                return args
            end
            # skip optional comma
            skipOptionalComma(stream)
        end
        raise "Could not extract #{wantedArgCnt} arguments (only #{args.length}) following #{stream.to_s}"
    end

    def extractMacroCall(stream, funArities)
        line = stream.peekline.chomp
        macroCall = ""

        m = line.match(/^(\s*):(\w+):/)
        raise "Unexpected missmatch expecting macroName line=<#{line}>" unless m
        indent = m[1]
        macroName = "Macros._#{m[2]}_"
        stream.pop(m[0].length)

        arity = funArities[macroName]
        raise "Macro/def used but not defined #{macroName}" unless arity

        args = extractCountArguments(arity, stream)
        args = args.map { |x| x.gsub("\n", "\\n") }.map { |x| '"' + x + '"' }

        a = args.join(",")
        macroCall = "\#\{#{macroName}(#{a})\}"
        [macroCall, indent]
    end

    def isDef(line)
        line =~ /\s*def\s+/
    end

    def incl(lines)
        stream = Stream.new(lines)
        out=['require_relative "pplib/support"', 'include Support']
        prefix = "//>"
        while !stream.eof
            line = stream.peekline.chomp
            if line[0, prefix.length] == prefix
                ll = line[prefix.length..]
                m = ll.match(/^\s*incl_file\s+\"(.*)\"\s*$/)
                if m
                    # include and process the included file
                    fileName = m[1]
                    out += incl_file(fileName)
                else
                    # ruby out
                    out.append(ll)
                end
            else
                # verbatim entry
                ll = line
                out.append(" puts \"#{ll}\"")
            end
            stream.popline
        end
        out
    end

    def incl_file(fileName)
        puts "entering #{fileName}" 
        lines = file2str(fileName)
        out = incl(lines)
        puts "leaving #{fileName}" 
        out
    end

    def rubySubstPass(fileIn, fileOut)
        out = incl_file(fileIn)
        fileTmp = "pass1.rb"
        obj2file(fileTmp, out)
        execRuby(fileTmp, fileOut)
    end

    def getDefDetails(stream, line)
        m = line.match(/\s*def\s+(\w+)\s*\((.*)\)/)
        raise "Unexpected format for 'def' in line: #{stream.lineNum-1}: #{line}" unless m
        macroName, args = m[1..2]
        arity = args.split(",").length
        [macroName, arity]
    end 

    def extractArities(fileName)
        funArities = {}
        lines = file2str(fileName)
        stream = Stream.new(lines)
        while !stream.eof
            line = stream.peekline.chomp
            if isDef(line)
                # if defining a function, track number of parameters
                # to facilitate parsing of macro invokation later on
                macroName, arity = getDefDetails(stream, line)
                funArities["Macros.#{macroName}"] = arity
            end
            stream.popline
        end
        funArities
    end

    def hasMacroInvokation(s)
        s =~ /^\s*:\w+:/
    end

    def macroSubst(fileIn, fileTmp, fileOut, fileMacros, iter)
        lines = file2str(fileIn)
        stream = Stream.new(lines)
        funArities = extractArities(fileMacros)
        out=["require_relative \"#{fileMacros}\"", 'include Macros']
        out.append("$rbpp_iter = #{iter}")
        out.append("$rbpp_indent = ''")

        while !stream.eof
            line = stream.peekline.chomp
            indent = nil
            if hasMacroInvokation(line)
                ll, indent = extractMacroCall(stream, funArities)
            else
                ll = stream.popline
            end
            if ll != ""
                ll = ll.gsub("\n", "\\n")
                if indent
                    out.append("$rbpp_indent = '#{indent}'")
                end
                out.append(" puts \"#{ll}\"")
            end
        end
        obj2file(fileTmp, out)
        execRuby(fileTmp, fileOut)
    end

    def macroSubstPass(fileIn, fileOut, fileMacros, maxIters)
        a = fileIn
        t = "pass2.rb"
        b = "pass2.out"
        i = 1
        loop do
            puts "-- Iter #{i} --"
            macroSubst(a, t, b, fileMacros, i)
            if file_eq(a, b) or (maxIters > 0 and i == maxIters)
                file_cp(a, fileOut)
                return
            end
            a = b
            b = b + "t"
            i += 1
        end
    end

    def main(options)
        puts "== PASS 1 =="
        rubySubstPass(options.input, "pass1.out")
        puts "== PASS 2 =="
        macroSubstPass("pass1.out", options.output, options.macros, options.ms_iters)
    end
end
