.PHONY: test

test:
	perevir test/perevirky

README.md: $(wildcard test/perevirky/*)
	pandoc -d docs.yaml --output=$@
