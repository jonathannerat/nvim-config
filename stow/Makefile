TARGET = $(HOME)
IGNORE = (Makefile|md)
OPTS = --dotfiles -v -t $(TARGET) --ignore="$(IGNORE)"

install:
	stow $(OPTS) .

uninstall: OPTS += -D
uninstall: install

.PHONY = install uninstall
