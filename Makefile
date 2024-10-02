.PHONY: build runlinux buildrunlinux

build:
	node PaK3/main.js src/ build/build.pk3

runlinux:
	cd ~/.srb2/; ./lsdl2srb2 $(SRB2OPT) -file $(CURDIR)/build/build.pk3

buildrunlinux: build runlinux