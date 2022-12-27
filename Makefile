OUT=\
  out/example0.v \
  out/example1.v \
  out/example2.v \
  out/example3.v \


all: unit_test test

test: $(OUT)

out/%: corpus/pp.%
	./pp.rb -i $< -o $@
	echo "diff corpus/gold/$* out/$* -q"
	diff corpus/gold/$* out/$* -q || { echo "ERROR comparison with golden failed for $@"; exit 1; }

unit_test:
	./unit_test/test_stream.rb
	./unit_test/test_preproc.rb

clean:
	$(RM) pass[12].rb
	$(RM) pass[12].out*
	$(RM) out/*.v
