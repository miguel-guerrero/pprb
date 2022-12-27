#!/usr/bin/env ruby

require_relative "../pplib/stream"
require "test/unit/assertions"
include Test::Unit::Assertions

def test1
    puts "-- test1"
    s = Stream.new("asdfg")

    assert_equal s.peek(2), "as"
    assert_false s.eof

    assert_equal s.peek(2), "as"
    assert_false s.eof

    assert_equal s.pop(2), "as"
    assert_false s.eof

    assert_equal s.pop(2), "df"
    assert_false s.eof

    assert_equal s.pop(2), "g"
    assert_true s.eof
end

def test2
    puts "-- test2"
    s = Stream.new("line 1\nline 2")
    assert_equal s.peekline, "line 1\n"
    assert_false s.eof
    assert_equal s.lineNum, 1

    assert_equal s.peekline, "line 1\n"
    assert_false s.eof
    assert_equal s.lineNum, 1

    assert_equal s.popline, "line 1\n"
    assert_false s.eof
    assert_equal s.lineNum, 2

    assert_equal s.popline, "line 2"
    assert_true s.eof
    assert_equal s.lineNum, 2
end

test1
test2
