
init:
	@pip install \
	-r src/requirements.txt \
	-r src/requirements-dev.txt

compile:
	@rm -f src/requirements*.txt
	@pip-compile src/requirements.in
	@pip-compile src/requirements-dev.in

sync:
	@pip-sync src/requirements*.txt

sort:
	@sort src/requirements.in > sorted.in && mv sorted.in src/requirements.in
	@sort src/requirements-dev.in > sorted.in && mv sorted.in src/requirements-dev.in

start:
	@python src/main.py
