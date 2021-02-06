SOURCEHOME = home
DOTFILES := $(wildcard $(SOURCEHOME)/\.[^\.]*)
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Darwin)
	CP_FLAGS := -vr
else
	CP_FLAGS := -uvr
endif

all: config

config: dotfiles

dotfiles:
	cp $(CP_FLAGS) $(DOTFILES) $(HOME)/
