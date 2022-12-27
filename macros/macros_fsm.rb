require_relative "../pplib/support"

module Macros
    include Support

    def _if_(c, t, f)
      c, t, f = [c, t, f].map { |x| Support.removeOuter(x) }
      id = "_#{$rbpp_iter}_#{Support.id}"
      Support.indent(
          "@if_cond#{id}:\n" +
          "    if (!(#{c}))\n" +
          "        ->else#{id}\n" +
          "@then#{id}:\n" +
          "    #{Support.deindent(t)}\n" +
          "    ->endif#{id}\n" +
          "@else#{id}:\n" +
          "    #{Support.deindent(f)}\n" +
          "@endif#{id}:\n"
      )
    end

    def _while_(c, b)
      c, b = [c, b].map { |x| Support.removeOuter(x) }
      id = "_#{$rbpp_iter}_#{Support.id}"
      Support.indent(
          "@while_cond#{id}:\n" +
          "    if (!(#{c}))\n" +
          "        ->while_end#{id}\n" +
          "@while_begin#{id}:\n" +
          "    #{Support.deindent(b)}\n" +
          "    ->while_cond#{id}\n" +
          "@while_end#{id}:\n"
      )
    end

end
