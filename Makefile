CXXFLAGS=$(shell pkg-config --cflags libobelisk) -ggdb
LIBS=$(shell pkg-config --libs libobelisk) -lsodium

default: all

aes256.o: aes256.c
	$(CXX) -o $@ -c $<

pp_start.o: pp_start.cpp
	$(CXX) -o $@ -c $< $(CXXFLAGS)
pp_start: pp_start.o aes256.o
	$(CXX) -o $@ pp_start.o aes256.o $(LIBS)

all: pp_start

clean:
	rm -f pp_start
	rm -f *.o

