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

cores: # TODO: can't assume every platform will have the same stock cores (platform should be responsible for copy too)
	# extras
	cp ./workspace/$(PLATFORM)/cores/output/fbalpha2012_neogeo_libretro.so ./build/EXTRAS/Emus/$(PLATFORM)/NG.pak
	cp ./workspace/$(PLATFORM)/cores/output/mame2003_libretro.so ./build/EXTRAS/Emus/$(PLATFORM)/MAME.pak
	cp ./workspace/$(PLATFORM)/cores/output/handy_libretro.so ./build/EXTRAS/Emus/$(PLATFORM)/LYNX.pak
	cp ./workspace/$(PLATFORM)/cores/output/stella2014_libretro.so ./build/EXTRAS/Emus/$(PLATFORM)/A2600.pak
	cp ./workspace/$(PLATFORM)/cores/output/a5200_libretro.so ./build/EXTRAS/Emus/$(PLATFORM)/A5200.pak
	cp ./workspace/$(PLATFORM)/cores/output/prosystem_libretro.so ./build/EXTRAS/Emus/$(PLATFORM)/A7800.pak
	cp ./workspace/$(PLATFORM)/cores/output/gw_libretro.so ./build/EXTRAS/Emus/$(PLATFORM)/GW.pak
	cp ./workspace/$(PLATFORM)/cores/output/fuse_libretro.so ./build/EXTRAS/Emus/$(PLATFORM)/ZXS.pak
	cp ./workspace/$(PLATFORM)/cores/output/crocods_libretro.so ./build/EXTRAS/Emus/$(PLATFORM)/ACPC.pak

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
