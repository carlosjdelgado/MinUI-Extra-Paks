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
RELEASE_DOT:=$(shell find -E ./releases/. -regex ".*/${RELEASE_BASE}-[0-9]+-base\.zip" | wc -l | sed 's/ //g')
RELEASE_NAME=$(RELEASE_BASE)-$(RELEASE_DOT)

###########################################################
.PHONY: build

export MAKEFLAGS=--no-print-directory

all: setup $(PLATFORMS) package done
	
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

common: build cores
	
clean:
	rm -rf ./build

setup:
	# ----------------------------------------------------
	# make sure we're running in an input device
	tty -s 
	
	# ready fresh build
	rm -rf ./build
	mkdir -p ./releases
	cp -R ./skeleton ./build
	
	# remove authoring detritus
	cd ./build && find . -type f -name '.keep' -delete
	cd ./build && find . -type f -name '*.meta' -delete
	echo $(BUILD_HASH) > ./workspace/hash.txt
	
	# copy readmes to workspace so we can use Linux fmt instead of host's
	mkdir -p ./workspace/readmes
	cp ./skeleton/EXTRAS/README.txt ./workspace/readmes/EXTRAS-in.txt
	
done:
	say "done"


package:
	# ----------------------------------------------------
	# zip up build
		
	# move formatted readmes from workspace to build
	cp ./workspace/readmes/EXTRAS-out.txt ./build/EXTRAS/README.txt
	rm -rf ./workspace/readmes

	cd ./build/EXTRAS && zip -r ../../releases/$(RELEASE_NAME)-extras.zip Bios Emus Roms Saves Tools README.txt
	echo "$(RELEASE_NAME)" > ./build/latest.txt
	

###########################################################

# TODO: make this a template like the cores makefile?

m17:
	# ----------------------------------------------------
	make common PLATFORM=$@
	# ----------------------------------------------------