.PHONY: build

build:
	rm -f build.pk3
	cd src; zip -r9 ../build.pk3 *