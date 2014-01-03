SOURCES=$(wildcard ./*.coffee)
OBJECTS=$(SOURCES:%.coffee=%.js)

%.js: %.coffee
	# coffee -c $<
	coffee -c $<

all: $(OBJECTS)
	# $(SOURCES)
	# $(OBJECTS)
