NUMBERS := $(shell seq 1 10)

all: clean create_database compile execute_loop create_report

clean:
	@echo "Deleting previous outputs"
	rm outputs/*

	@echo "Deleting previous result"
	rm result/*

	@echo "Deleting database"
	rm db/*

	@echo "Deleting binaries"
	rm bin/*

create_database:
	@echo "Creating database"
	ruby resources/create_database.rb

compile:
	@echo "Compiling"
	crystal build -o bin/crystal_a src/crystal_a.cr
	gcc -o bin/c_a src/c_a.c
	javac -d bin src/java_a.java
	cp src/java_a.java bin
	go build -o bin/go_a src/go_a.go
	cobc -x -o bin/cobol_a  src/cobol_a.cbl

execute_loop:
	@echo "Executing programs"
	$(foreach var,$(NUMBERS), make execute_block ;)

create_report:
	Rscript resources/result.r

execute_block:
	$(shell ./run.sh ruby src/ruby_a.rb ruby_a 1 )
	$(shell ./run.sh python3 src/python_a.py python_a 1 )
	$(shell ./run.sh php src/php_a.php php_a 1 )
	$(shell ./run.sh Rscript src/r_a.r r_a 1 )
	$(shell ./run.sh node src/node_a.js node_a 1 )

	$(shell ./run.sh cmd bin/crystal_a crystal_a 1 )
	$(shell ./run.sh cmd bin/c_a c_a 1 )
	$(shell ./run.sh cmd "java -cp bin java_a" java_a 1 )
	$(shell ./run.sh cmd bin/go_a go_a 1 )
	$(shell ./run.sh cmd bin/cobol_a cobol_a 1 )

docker: clean
	docker build -t nu12/language-performance-benchmark .
	docker run -d --name lpb nu12/language-performance-benchmark
	docker cp lpb:/app/outputs/ .
	docker rm lpb -f

setup:
	# Crystal
	curl -sSL https://dist.crystal-lang.org/apt/setup.sh | sudo bash
	curl -sL "https://keybase.io/crystal/pgp_keys.asc" | sudo apt-key add -
	echo "deb https://dist.crystal-lang.org/apt crystal main" | sudo tee /etc/apt/sources.list.d/crystal.list

	# Go
	wget https://golang.org/dl/go1.15.linux-amd64.tar.gz
	sudo tar -C /usr/local -xzf go1.15.linux-amd64.tar.gz
	rm *.tar.gz
	sudo ln -s /usr/local/go/bin/go /bin/go

	# Node
	curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

	sudo apt-get update
	sudo apt-get install -y \
	ruby2.7 ruby2.7-dev \
	crystal \
	python3.6 \
	php7.4-cli \
	r-base \
	default-jdk \
	nodejs \
	gnucobol \
	pandoc

	sudo R -e "install.packages(c('data.table', 'dplyr', 'ggplot2', 'agricolae', 'DT', 'rmarkdown', 'bit64'))"
