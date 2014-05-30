CXXFLAGS=$(shell pkg-config --cflags libbitcoin) -ggdb
LIBS=$(shell pkg-config --libs libbitcoin)

default: all

pp_start.o: pp_start.cpp
	$(CXX) -o $@ -c $< $(CXXFLAGS)
pp_start: pp_start.o
	$(CXX) -o $@ pp_start.o $(LIBS)

all: pp_start

clean:
	rm -f pp_start
	rm -f *.o

