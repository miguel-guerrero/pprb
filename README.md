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
  provided in lines that start with `//>` character sequence. For example:

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

  Macros are invoked as `:macroName:` `arg1` `arg2` ...

  Each argument `argi` is a parenthesized expresion `(...)` or a block surrounded by brackets `{...}`. Either of them
  can be multiline. `pp.rb` collects the arguments and passes them to user defined code (in ruby). The ruby macro
  file can be passed to `pp.rb` with the `-m` command line argument. See `macros/macros.rb` for a default file
  used on internal regression. Once the macros are expanded another iteration of macro expansion is started to
  expand potentially nested macros.

## Testing

To run internal the regression:

    $ make

## Internals

Expansion is done by generating an intermediate ruby script. Code prefixed by `//>` is emited as-is without
the prefix. Text without this prefix is emitted as a print statement taking care of appropriate quoting where
needed.

Each iteration of macro expansion follows a similar process.

    
