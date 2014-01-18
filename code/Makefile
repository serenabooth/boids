# This program

PROG = ocamlboids.exe

# Setup

LIBS = \
	graphics.cma

CAMLC = ocamlc -I +lablgl lablgl.cma lablglut.cma
CAMLDOC = ocamldoc
CAMLFLAGS = -g

%.cmo: %.ml
	$(CAMLC) $(CAMLFLAGS) -c $<

# Source and Object files
SOURCES = \
	Event.ml Helpers.ml GLObjectI.ml World.ml GLObject.ml\
	Boid.ml Obstacle.ml Food.ml PuppetBoid.ml Predator.ml\
        glUI.ml \

OBJECTS = $(SOURCES:.ml=.cmo)

# Final Program

$(PROG):clean $(OBJECTS)
	$(CAMLC) $(CAMLFLAGS) $(LIBS) $(OBJECTS) -o $(PROG)

# DocGen

doc: $(OBJECTS)
	$(CAMLDOC) -html $(SOURCES)

# Other

all:	$(PROG)

clean:
	rm -rf *.cmo *.cmi *.html *.css $(PROG)

.DEFAULT_GOAL := $(PROG)
.PHONY: doc build run clean
