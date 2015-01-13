# Server Addresses
EXPRESS_URL=http://127.0.0.1:3000/
RESTIFY_URL=http://127.0.0.1:8080/hello/world

# Apache Bench params
ifndef verbosity
	verbosity=0
endif
ifndef concurrency
	concurrency=10
endif

ifndef requests
	requests=1000
endif

# Output Directories
resultsDir=results
dataDir=data
pidDir=run

# PIDs used to kill servers
expressPid=$(pidDir)/express.pid
restifyPid=$(pidDir)/restify.pid

date := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

all: start plot-express plot-restify stop

preamble:
	$(info -> Date: $(date))
	$(info -> Concurrency: $(concurrency))
	$(info -> Total Requests: $(requests))

start: preamble
	$(info -> Starting Express Server)
	@node express.js > /dev/null 2>&1 &
	$(info -> Starting Restify Server)
	@node restify.js > /dev/null 2>&1 &
	@sleep 1

stop:
	$(info -> Killing Express Server)
	@kill $(shell cat $(expressPid))
	@rm $(expressPid)
	$(info -> Killing Restify Server)
	@kill $(shell cat $(restifyPid))
	@rm $(restifyPid)

bench-express:
	$(info -> Running Apache Bench on Express Server on $(EXPRESS_URL))
	@ab -r -l -k -g "$(dataDir)/$(date)-$(requests)-requests-$(concurrency)-concurrent-express.tsv" -v $(verbosity) -n $(requests) -c $(concurrency) $(EXPRESS_URL) > $(resultsDir)/$(date)-$(requests)-requests-$(concurrency)-concurrent-express.txt

plot-express: bench-express
	$(info -> Plotting Results of Apache Bench on Express Server)
	@./bin/plot "$(dataDir)/$(date)-$(requests)-requests-$(concurrency)-concurrent-express.tsv" $(date)-$(requests)-requests-$(concurrency)-concurrent-express

bench-restify:
	$(info -> Running Apache Bench on Restify Server on $(RESTIFY_URL))
	@ab -r -l -k -g "$(dataDir)/$(date)-$(requests)-requests-$(concurrency)-concurrent-restify.tsv" -v $(verbosity) -n $(requests) -c $(concurrency) $(RESTIFY_URL) > $(resultsDir)/$(date)-$(requests)-requests-$(concurrency)-concurrent-restify.txt

plot-restify: bench-restify
	$(info -> Plotting Results of Apache Bench on Restify Server)
	@./bin/plot "$(dataDir)/$(date)-$(requests)-requests-$(concurrency)-concurrent-restify.tsv" $(date)-$(requests)-requests-$(concurrency)-concurrent-restify

clean:
	rm -f graphs/*.png
	rm -f data/*.tsv
	rm -f results/*.txt
	rm -f run/*.pid

.PHONY: start clean stop