CXXFLAGS=$(shell pkg-config --cflags libobelisk libwallet) -ggdb
LIBS=$(shell pkg-config --libs libobelisk libwallet)

default: all

pp_check_addr.o: pp_check_addr.cpp
	$(CXX) -o $@ -c $< $(CXXFLAGS)
pp_check_addr: pp_check_addr.o
	$(CXX) -o $@ pp_check_addr.o $(LIBS)

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

pp_secrets.o: pp_secrets.cpp
	$(CXX) -o $@ -c $< $(CXXFLAGS)
pp_secrets: pp_secrets.o
	$(CXX) -o $@ pp_secrets.o $(LIBS)

pp_start.o: pp_start.cpp
	$(CXX) -o $@ -c $< $(CXXFLAGS)
pp_start: pp_start.o aes256.o
	$(CXX) -o $@ pp_start.o aes256.o $(LIBS)

all: pp_start pp_prove pp_unlock pp_secrets pp_check_addr

clean:
	rm -f pp_start pp_prove pp_unlock pp_secrets pp_check_addr 
	rm -f *.o

