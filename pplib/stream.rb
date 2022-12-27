class Stream
    attr_reader :pos, :lineNum

    def initialize(input)
        @input = input
        @pos = 0
        @lineNum = 1
    end

    def peek(n)
        e = @pos + n - 1
        if e >= @input.length
            e = @input.length - 1
        end
        @input[@pos..e]
    end

    def eof
        @pos == @input.length
    end

    def pop(n)
        s = peek(n)
        @lineNum += s.count("\n")
        @pos += s.length
        s
    end

    def unpop(n)
        @pos -= n
    end

    def popline
        s = ""
        while !eof
            c = pop(1)
            s += c
            if c == "\n"
                return s
            end
        end
        return s
    end

    def peekline
        saveNumLines = @lineNum
        line = popline
        unpop(line.length)
        @lineNum = saveNumLines
        line
    end

    def to_s
        @input[@pos..]
    end

    def fromto(b, e)
        @input[b..e]
    end
end
