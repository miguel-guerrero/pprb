#!/usr/bin/env ruby

require_relative "pplib/preproc"
include PreProc

require 'optparse'
require 'ostruct'

options = OpenStruct.new

# set defaults
options.input = "/dev/stdin"
options.output = "/dev/stdout"
options.macros = "macros/macros.rb"
options.ms_iters = 0

OptionParser.new do |opt|
    opt.on(
        '-i', '--input FILE_IN',
        "The input file (default: #{options.input})",
    ) { |o| options.input = o }

    opt.on(
        '-o', '--output FILE_OUT',
        "The output file (default: #{options.output})",
    ) { |o| options.output = o }

    opt.on(
        '-m', '--macros FILE_MACROS',
        "The macro ruby file (default: #{options.macros})",
    ) { |o| options.macros = o }

    opt.on(
        '-n', '--niters PASS2_ITERS',
        "Macro substitution number of iterations, 0 for as many as required (default: #{options.ms_iters})",
    ) { |o| options.ms_iters = o.to_i }

end.parse!

PreProc.main(options)

# system("rm -f pass1.rb pass2.rb pass1.out pass2.out*")
