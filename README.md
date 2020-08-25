# Language Performance Benchmark

This project is a simple performance benchmark between some popular programming languages:

* Ruby
* Crystal
* Python
* PHP
* R
* C
* Java
* Cobol
* Go
* Javascript (nodejs)

## Objectives

The main objective is to find out if there is one language that is considerably "faster" than the other ones when performing the same programming logic.

Second, to find out if compiled languages are "faster" than interpreted languages.

Finally, if Docker affects languages' performance.

## Methods

In the scope of this project the velocity measure will take into consideration the amount of time used by a program/script to be executed. Therefore a "faster" program/script is the one that takes less time to complete the task.

The letter appended in the end of each script name references the methods described below.

### Method A

To reduce the amount of variables of the experiment, all programs/scripts are required to run the same "logic":

```
# This is pseudo-code

var current-value = 0
var highest = 0
var sum = 0
var count = 0
var input-file = File.open("data/input.cvs", read)
var output-file = File.open("outputs/language-method", write+)

for line = input-file.read-next-line():
    current-value = line.to_float()
    if current-value > highest:
        highest = current-value
    sum = sum + current-value
    count = count + 1
input-file.close()

output-file.write(highest , sum, count )
output-file.close()
```

The code encompasses opening two files (one for reading, one for writing), creating four more variables, looping through a dataset, performing one conditional statement and its block (when evaluated as true), performing one cumulative sum, adding 1 to the counter each record, writing the output and closing the files.

### Method B

Not all programming languages are good at everything, and some may have different (more performant) approaches for the same task. A second program/script may be added and it is free to execute the task regardless the code, but external packages are not allowed. It should create an output with highest, sum, count, starting time and ending time.

### Method C

It's time to go wild! Packages are allowed in this method. As before, it should create an output with highest, sum, count, starting time and ending time.

## Executing 

Prerequisites: install `docker`, `docker-compose` and `make`.

### Docker (compose)

Warning: this will download a massive amount of data for several different images.

Run:

```bash
$ docker-compose up -d --build
```

Wait the service to be available and open `localhost` or the IP machine in the browser.

To run the test again, remove the created container and intermediate images:

```bash
$ docker-compose down
$ docker image prune --filter dangling=true
```

### Local

Warning: this will download and install a massive amount of data for several different compilers and interpreters.

Install compilers and interpreters:

```bash
$ make setup -i -s
```
Run:

```bash
$ make -i -s
```

Open `result/index.html`.

## Development

Prerequisites: install `docker`, `docker-compose` and `make`.

Install compilers and interpreters:

```shell
$ make setup -i -s
```

Execute scripts:

```shell
$ make -i -s
```

To add a new script, include it in the Makefile and Dockerfile to be executed.