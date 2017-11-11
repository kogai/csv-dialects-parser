NAME := csv_dialect
TEST_NAME := $(NAME)_test
PKGS := core,menhirlib,ppx_deriving,ppx_deriving.show,yojson
SRC_FILES := $(shell find ./src -type f -name '*.m*')
SRC_DIRS := "src"

OCB_FLAGS := -use-ocamlfind -use-menhir -Is $(SRC_DIRS) -pkgs $(PKGS)
OCB := ocamlbuild $(OCB_FLAGS)
OPAM_VER := 4.03.0
ARGS := "fixture/rfc4180-escaped.csv"

all:$(NAME).native $(NAME).byte

$(NAME).native: $(SRC_FILES)
	eval `opam config env` && \
	$(OCB) $(NAME).native

$(NAME).byte: $(SRC_FILES)
	eval `opam config env` && \
	$(OCB) -tag debug $(NAME).byte

.PHONY: native
native: $(NAME).native
	@./$(NAME).native $(ARGS)

.PHONY: byte
byte: $(NAME).byte
	@./$(NAME).byte $(ARGS)

.PHONY: interpret
interpret:
	menhir --interpret --interpret-show-cst --interpret-error src/parser.mly

.PHONY: run
run:
	docker-compose run $(NAME) $(ARGS)

.PHONY: install
install:
	opam init -ya --comp=$(OPAM_VER) && \
	opam switch $(OPAM_VER) && \
	eval `opam config env` && \
	opam update && \
	opam install -y \
		ocamlfind \
		ppx_deriving \
		merlin \
		yojson \
		core

.PHONY: setup
setup:
	opam user-setup install

.PHONY: clean
clean:
	$(OCB) -clean
