#!/usr/bin/env ruby

require_relative "../pplib/stream"
require_relative "../pplib/preproc"
include PreProc


def test1()
    puts "-- test1"
    s = Stream.new("asd ,{xy} fgh), { asd }")
    PreProc.skipTill(")", s)
    puts s.to_s
    raise "test1 failed #{s.fromto(0,s.pos-1)}" unless s.to_s == ", { asd }"
    puts s.fromto(0, s.pos-1)
end

def test2()
    puts "-- test2"
    s = Stream.new(" , {asd }")
    PreProc.skipOptionalComma(s)
    puts "<"+s.to_s+">"
    raise "test2 failed" unless s.to_s == " {asd }"
end

def test2b()
    puts "-- test2b"
    s = Stream.new("  {asd }")
    PreProc.skipOptionalComma(s)
    puts "<"+s.to_s+">"
    raise "test2b failed" unless s.to_s == "{asd }"
end

def test3()
    puts "-- test3"
    s = Stream.new("(asd ,{xy} fgh), { asd }")
    args = PreProc.extractCountArguments(2, s)
    puts args
    raise "test3 failed" unless args[0] == "(asd ,{xy} fgh)"
    raise "test3 failed" unless args[1] == " { asd }"
end

def test4()
    puts "-- test4"
    s = Stream.new("(asdf), {asd }")
    args = PreProc.extractCountArguments(2, s)
    puts args[0]
    puts args[1]
    raise "test4 failed" unless args[0] == "(asdf)"
    raise "test4 failed" unless args[1] == " {asd }"
end

def test4b()
    puts "-- test4b"
    s = Stream.new("(asdf) \n {asd }")
    args = PreProc.extractCountArguments(2, s)
    puts args[0]
    puts args[1]
    raise "test4b failed" unless args[0] == "(asdf)"
    raise "test4b failed" unless args[1] == "{asd }"
end

test1
test2
test2b
test3
test4
test4b
