module Support
    $id = -1

    #removes the outter enclosing {} or () of a string
    def removeOuter(str)
        striped = str.strip
        striped[1..-2]
    end

    def id=(n)
        $id = n
    end

    # get a new id
    def id
        $id += 1
        $id
    end

    # indent a block of text using rbpp_indent as indent spaces
    def indent(txt)
        txt.split("\n").map { |x| $rbpp_indent + x }.join("\n")
    end

    # check if the first n characters are spaces so we can deindent 
    # by that amount
    def canDeindent(txt, n)
        txt.split("\n").each { |x|
            unless x[0, n] =~ /\s*/
                return false
            end
        }
        return true
    end

    # deindent a block of text by as many characters as rbpp_indent
    def deindent(txt)
        n = $rbpp_indent.length
        if canDeindent(txt, n)
            txt.split("\n").map { |x| x[n..] }.join("\n")
        else
            txt
        end
    end
end
