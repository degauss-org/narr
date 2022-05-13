.PHONY: build test shell clean

build:
	docker build -t narr .

test:
	docker run --rm -v "${PWD}/test":/tmp narr my_address_file_geocoded.csv
	docker run --rm -v "${PWD}/test":/tmp narr my_address_file_geocoded.csv --all
	docker run --rm -v "${PWD}/test":/tmp narr my_address_file_geocoded.csv --none

shell:
	docker run --rm -it --entrypoint=/bin/bash -v "${PWD}/test":/tmp narr

clean:
	docker system prune -f
