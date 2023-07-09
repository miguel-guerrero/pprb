# pprb
Text pre-processing with ruby as control language

# Introduction

Usage:

    $  ./pp.rb --help
    
    Usage: pp [options]
        -i, --input FILE_IN              The input file (default: /dev/stdin)
        -o, --output FILE_OUT            The output file (default: /dev/stdout)
        -m, --macros FILE_MACROS         The macro ruby file (default: macros/macros.rb)
        -n, --niters PASS2_ITERS         Macro substitution number of iterations, 0 for as many as required (default: 0)

The preprocessor performs 2 passes over the input file:

- Pass 1: ruby substitution pass. During this step any ruby control code is expanded. Ruby control code is
  provided in lines that start with '//>' character sequence. For example:

  <corpus/pp.example1.txt>
  
      //> 3.times do |i|
      This will generate 3 lines. This one is #{i+1}
      //> end

  When processed as follows:

      $ ./pp.rb -i orpus/pp.example1.txt -o example1.txt

  Will generate
  
  <example1.txt>
  
      This will generate 3 lines. This one is 1
      This will generate 3 lines. This one is 2
      This will generate 3 lines. This one is 3

Note that #{expr} can be used to interpolate the value on ruby expressions on the output text.

- Pass 2: Macro substitution. This step is repetead iteratively until no more expansions are possible. The
  parameter "-n" can be used to limit the number of iterations perfomed. The default value (0) implieas
  unlimted (as many as required)

## Testing

To run internal the regression:

    $ make

    
