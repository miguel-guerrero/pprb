require_relative "pplib/support"

module Macros
    include Support

    def _if_(c, t, f)
      c, t, f = [c, t, f].map { |x| Support.removeOuter(x) }
      Support.indent(
          "if (#{c}) begin\n" +
          "   #{Support.deindent(t)}\n" +
          "end else begin\n" +
          "   #{Support.deindent(f)}\n" +
          "end\n"
      )
    end

    def _while_(c, b)
      c, b = [c, b].map { |x| Support.removeOuter(x) }
      Support.indent(
          "while (#{c}) begin\n" +
          "   #{Support.deindent(b)}\n" +
          "end\n"
      )
    end

end
