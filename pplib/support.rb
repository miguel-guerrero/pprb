module Support
    $id = -1
    def removeOuter(str)
        striped = str.strip
        striped[1..-2]
    end

    def id=(n)
        $id = n
    end

    def id
        $id += 1
        $id
    end

    def indent(txt)
        txt.split("\n").map { |x| $rbpp_indent + x }.join("\n")
    end

    def canDeindent(txt, n)
        txt.split("\n").each { |x|
            unless x[0, n] =~ /\s*/
                return false
            end
        }
        return true
    end

    def deindent(txt)
        n = $rbpp_indent.length
        if canDeindent(txt, n)
            txt.split("\n").map { |x| x[n..] }.join("\n")
        else
            txt
        end
    end
end
