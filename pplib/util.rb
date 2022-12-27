module Util

    def file2arr(fileName)
        out=[]
        File.open(fileName) do |file|
            out = file.readlines.map(&:chomp)
        end
        out
    end

    def file2str(fileName)
        File.open(fileName).read()
    end

    def obj2file(fileName, str)
        File.open(fileName, "w") do |file|
            file.puts(str)
        end
    end

    def showfile(fileName)
        File.open(fileOut).readlines.map(&:chomp).each do |line|
            puts line
        end
    end

    def execRuby(fileIn, fileOut)
        rc = system("ruby #{fileIn} > #{fileOut}")
        if not rc
            puts "Errors found. check #{fileIn}"
            exit 1
        end
    end

    def file_eq(a, b)
        system("diff -q #{a} #{b}")
    end

    def file_cp(a, b)
        system("cp -f #{a} #{b}")
    end

end
