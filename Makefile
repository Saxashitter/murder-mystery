.PHONY: windows linux test-windows

windows:
	node PaK3/main.js src/ build/build.pk3

linux:
	rm -f build.pk3
	cd src; zip -r9 ../build.pk3 *