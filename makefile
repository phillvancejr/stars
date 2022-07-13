default: ada

flags=-I/usr/local/include
libs=#-L/usr/local/lib -lminifb -framework Cocoa -framework IOKit -framework Metal -framework MetalKit

select:
	sudo xcode-select -s /Library/Developer/CommandLineTools

reset:
	sudo xcode-select -r

ada_libs=#$(foreach lib, $(libs), -largs $(lib))
ada: stars.adb
	gnatmake -f -D trash -Iminifb_ada -o ada_stars stars $(ada_libs)

cc: select stars.cc 
	clang++ -std=c++20 $(flags) $(libs) -o cc_stars stars.cc && \
	$(MAKE) reset


