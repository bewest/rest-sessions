SOURCES=$(wildcard ./*.coffee)
OBJECTS=$(SOURCES:%.coffee=%.js)

%.js: %.coffee
	coffee -c $<

all: $(OBJECTS)

