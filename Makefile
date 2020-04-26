SOURCEHOME = home
DOTFILES := $(wildcard $(SOURCEHOME)/\.[^\.]*)

all: config

config: dotfiles

dotfiles:
	cp -vru $(DOTFILES) $(HOME)/
