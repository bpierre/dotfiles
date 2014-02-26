all: js css

js: dist/main.js
css: dist/main.css

dist/main.js: index.js
	mkdir -p dist
	browserify -t brfs $^ -o $@

dist/main.css: index.styl
	mkdir -p dist
	stylus < $^ > $@

.PHONY: all js css
