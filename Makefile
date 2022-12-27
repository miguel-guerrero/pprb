OUT=\
  out/example0.v \
  out/example1.v \
  out/example2.v \
  out/example3.v \


all: unit_test test

test: $(OUT)

out/%: corpus/pp.%
	./pp.rb -i $< -o $@


unit_test:
	./unit_test/test_stream.rb
	./unit_test/test_preproc.rb

clean:
	$(RM) pass[12].rb
	$(RM) pass[12].out*
	$(RM) out/*.v
