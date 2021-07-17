
init:
	@pip install \
	-r requirements-dev.txt

compile:
	@rm -f requirements*.txt
	@pip-compile requirements-dev.in

sync:
	@pip-sync requirements*.txt

sort:
	@sort requirements-dev.in > sorted.in && mv sorted.in requirements-dev.in
