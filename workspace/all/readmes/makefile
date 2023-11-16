readmes:
ifneq ($(wildcard ../readmes/EXTRAS-in.txt),)
	# formating readmes
	cd ../readmes && fmt -w 40 -s ./EXTRAS-in.txt > ./EXTRAS-out.txt
	cd ../readmes && rm ./*-in.txt
else
	# skipped readmes
endif