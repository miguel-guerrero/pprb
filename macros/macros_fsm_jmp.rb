require_relative "../pplib/support"

module Macros
    include Support

    def _if_(c, t, f)
      c, t, f = [c, t, f].map { |x| Support.removeOuter(x) }
      id = "_#{$rbpp_iter}_#{Support.id}"
      Support.indent(
          "@if_cond#{id}:\n" +
          "    if (!(#{c}))\n" +
          "        ->if_false#{id}\n" +
          "@if_true#{id}:\n" +
          "    #{Support.deindent(t)}\n" +
          "    ->if_end#{id}\n" +
          "@if_false#{id}:\n" +
          "    #{Support.deindent(f)}\n" +
          "@if_end#{id}:\n"
      )
    end

    def _while_(c, b)
      c, b = [c, b].map { |x| Support.removeOuter(x) }
      id = "_#{$rbpp_iter}_#{Support.id}"
      Support.indent(
          "@while_cond#{id}:\n" +
          "    if (!(#{c}))\n" +
          "        ->while_end#{id}\n" +
          "@while_body#{id}:\n" +
          "    #{Support.deindent(b)}\n" +
          "    ->while_cond#{id}\n" +
          "@while_end#{id}:\n"
      )
    end

end
