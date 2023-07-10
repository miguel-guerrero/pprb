//> # example of macro definition
//>
//> def min(x, y)
//>   x = "(" + x.to_s + ")"
//>   y = "(" + y.to_s + ")"
//>   "#{x} < #{y} ? #{x} : #{y}"
//> end

//> 4.times do |i|

min_#{i}_2 = #{min(i, 2)}

inst #(.W(9)) inst_0 (
    .a(a#{i})
   ,.b(b#{i})
);
//> end

// end of file
