SOURCEHOME = home
DOTFILES := $(wildcard $(SOURCEHOME)/\.[^\.]*)
DOTFILES_NO_DIR := $(notdir $(DOTFILES))
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Darwin)
	CP_FLAGS := -vr
else
	CP_FLAGS := -uvr
endif

all: config

config: dotfiles

dotfiles:
	cp $(CP_FLAGS) $(DOTFILES) $(HOME)/;

diff:
	$(foreach X,$(DOTFILES_NO_DIR), \
		echo Diffing ${X}; diff -ur home/${X} ~/${X};)
