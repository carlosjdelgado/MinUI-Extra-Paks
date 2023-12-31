# MinUI

# NOTE: this runs on the host system (eg. macOS) not in a docker image
# it has to, otherwise we'd be running a docker in a docker and oof

ifeq (,$(PLATFORMS))
PLATFORMS = m17
endif

###########################################################

BUILD_HASH:=$(shell git rev-parse --short HEAD)
RELEASE_TIME:=$(shell date +%Y%m%d)
RELEASE_BETA=b
RELEASE_BASE=MinUI-$(RELEASE_TIME)$(RELEASE_BETA)
RELEASE_DOT:=$(shell find ./releases/. -regex ".*/${RELEASE_BASE}-[0-9]+-extras\.zip" | wc -l | sed 's/ //g')
RELEASE_NAME=$(RELEASE_BASE)-$(RELEASE_DOT)

###########################################################
.PHONY: build

export MAKEFLAGS=--no-print-directory

all: setup $(PLATFORMS) package
	
shell:
	make -f makefile.toolchain PLATFORM=$(PLATFORM)

name: 
	echo $(RELEASE_NAME)

build:
	# ----------------------------------------------------
	make build -f makefile.toolchain PLATFORM=$(PLATFORM)
	# ----------------------------------------------------

cores:
	make -C ./workspace/$(PLATFORM)

common: build cores
	
clean:
	rm -rf ./build

setup:
	# ----------------------------------------------------
	# ready fresh build
	rm -rf ./build
	mkdir -p ./releases
	cp -R ./skeleton ./build
	
	# remove authoring detritus
	cd ./build && find . -type f -name '.keep' -delete
	cd ./build && find . -type f -name '*.meta' -delete
	echo $(BUILD_HASH) > ./workspace/hash.txt

package:
	# ----------------------------------------------------
	# zip up build

	cd ./build/EXTRAS && zip -r ../../releases/$(RELEASE_NAME)-extras.zip Bios Emus Roms Saves
	echo "$(RELEASE_NAME)" > ./build/latest.txt
	

###########################################################

# TODO: make this a template like the cores makefile?

m17:
	# ----------------------------------------------------
	make common PLATFORM=$@
	# ----------------------------------------------------
