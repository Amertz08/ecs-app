
init:
	@pip install \
	-r requirements.txt \
	-r requirements-dev.txt

compile:
	@rm -f requirements*.txt
	@pip-compile requirements.in
	@pip-compile requirements-dev.in

sync:
	@pip-sync requirements*.txt

sort:
	@sort requirements.in > sorted.in && mv sorted.in requirements.in
	@sort requirements-dev.in > sorted.in && mv sorted.in requirements-dev.in

start:
	@python src/main.py
