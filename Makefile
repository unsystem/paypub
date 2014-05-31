CXXFLAGS=$(shell pkg-config --cflags libobelisk) -ggdb
LIBS=$(shell pkg-config --libs libobelisk)

default: all

pp_unlock.o: pp_unlock.cpp
	$(CXX) -o $@ -c $< $(CXXFLAGS)
pp_unlock: pp_unlock.o aes256.o
	$(CXX) -o $@ pp_unlock.o aes256.o $(LIBS)

pp_prove.o: pp_prove.cpp
	$(CXX) -o $@ -c $< $(CXXFLAGS)
pp_prove: pp_prove.o
	$(CXX) -o $@ pp_prove.o $(LIBS)

aes256.o: aes256.c
	$(CXX) -o $@ -c $<

pp_start.o: pp_start.cpp
	$(CXX) -o $@ -c $< $(CXXFLAGS)
pp_start: pp_start.o aes256.o
	$(CXX) -o $@ pp_start.o aes256.o $(LIBS)

all: pp_start pp_prove pp_unlock

clean:
	rm -f pp_start pp_prove pp_unlock
	rm -f *.o

