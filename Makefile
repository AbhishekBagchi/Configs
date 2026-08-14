SOURCEHOME = home
DOTFILES := $(wildcard $(SOURCEHOME)/\.[^\.]*)
DOTFILES_NO_DIR := $(notdir $(DOTFILES))

all: config

.PHONY: all config dotfiles dryrun diff brew brew-install

config: dotfiles

dotfiles:
	@./sync.sh

dryrun:
	@DRYRUN=1 ./sync.sh

diff:
	@$(foreach X,$(DOTFILES_NO_DIR), \
		OUTPUT=$$(diff -ur --exclude='.git' home/${X} ~/${X} 2>&1); \
		if [ -n "$$OUTPUT" ]; then \
			echo "Diffing ${X}"; \
			echo "$$OUTPUT"; \
		fi;)

brew:
	@./brew-dump.sh

brew-install:
	@brew bundle install --file=Brewfile
