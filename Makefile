.PHONY: build runlinux buildrunlinux

SRB2RUN = flatpak run org.srb2.SRB2

build:
	node PaK3/main.js src/ build/build.pk3

runlinux:
	$(SRB2RUN) -file $(CURDIR)/build/build.pk3

buildrunlinux: build runlinux
