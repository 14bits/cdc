


.DEFAULT_GOAL:=help
SHELL:=/bin/bash
GO111MODULE=off

# https://github.com/xo/usql
USQL_LIB_NAME=usql
USQL_LIB=github.com/xo/$(USQL_LIB_NAME)
USQL_LIB_FSPATH=$(GOPATH)/src/$(USQL_LIB)

# https://github.com/wal-g/wal-g
WAL_LIB_NAME=wal-g
WAL_LIB_BRANCH=master
WAL_LIB_TAG=v1.0.0
WAL_LIB=github.com/wal-g/$(WAL_LIB_NAME)
WAL_LIB_UPSTREAM=github.com/wal-g/$(WAL_LIB_NAME)
WAL_LIB_FSPATH=$(GOPATH)/src/$(WAL_LIB)

# https://github.com/moiot/gravity
GRA_LIB_NAME=gravity
GRA_LIB_BRANCH=master
GRA_LIB_TAG=v1.0.0
GRA_LIB=github.com/moiot/$(GRA_LIB_NAME)
GRA_LIB_UPSTREAM=github.com/moiot/$(GRA_LIB_NAME)
GRA_LIB_FSPATH=$(GOPATH)/src/$(GRA_LIB)




help:  ## Display this help
	# from: https://suva.sh/posts/well-documented-makefiles/
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

print: ### print

	@echo 	
	@echo USQL_LIB_NAME :      $(USQL_LIB_NAME)
	@echo USQL_LIB_BRANCH :    $(USQL_LIB_BRANCH)
	@echo USQL_LIB_TAG :       $(USQL_LIB_TAG)
	@echo USQL_LIB :           $(USQL_LIB)
	@echo USQL_LIB_FSPATH  :   $(USQL_LIB_FSPATH)
	@echo 

	@echo 	
	@echo WAL_LIB_NAME :      $(WAL_LIB_NAME)
	@echo WAL_LIB_BRANCH :    $(WAL_LIB_BRANCH)
	@echo WAL_LIB_TAG :       $(WAL_LIB_TAG)
	@echo WAL_LIB :           $(WAL_LIB)
	@echo WAL_LIB_FSPATH  :   $(WAL_LIB_FSPATH)
	@echo 


	@echo 	
	@echo GRA_LIB_NAME :      $(GRA_LIB_NAME)
	@echo GRA_LIB_BRANCH :    $(GRA_LIB_BRANCH)
	@echo GRA_LIB_TAG :       $(GRA_LIB_TAG)
	@echo GRA_LIB :           $(GRA_LIB)
	@echo GRA_LIB_FSPATH  :   $(GRA_LIB_FSPATH)
	@echo 


	@echo 

git-clone: ### git-clone

	# usql
	mkdir -p $(USQL_LIB_FSPATH)
	cd $(USQL_LIB_FSPATH) && cd .. && rm -rf $(USQL_LIB_NAME) && git clone ssh://git@$(USQL_LIB).git
	cd $(USQL_LIB_FSPATH) && git fetch --all --tags --prune
	#cd $(USQL_LIB_FSPATH) && git checkout tags/$(USQL_LIB_TAG)

	# walg
	mkdir -p $(WAL_LIB_FSPATH)
	cd $(WAL_LIB_FSPATH) && cd .. && rm -rf $(WAL_LIB_NAME) && git clone ssh://git@$(WAL_LIB).git
	cd $(WAL_LIB_FSPATH) && git fetch --all --tags --prune
	#cd $(WAL_LIB_FSPATH) && git checkout tags/$(WAL_LIB_TAG)

	# gravity
	mkdir -p $(GRA_LIB_FSPATH)
	cd $(GRA_LIB_FSPATH) && cd .. && rm -rf $(GRA_LIB_NAME) && git clone ssh://git@$(GRA_LIB).git
	cd $(GRA_LIB_FSPATH) && git fetch --all --tags --prune
	#cd $(GRA_LIB_FSPATH) && git checkout tags/$(GRA_LIB_TAG)
	

git-clean: ### git-clean
	rm -rf $(WAL_LIB_FSPATH)
	rm -rf $(GRA_LIB_FSPATH)

dep-os: ### dep-os

	# THis installed the databases we need quickyly. Dont want to sue Docker because want to support Desktops too.
	# Mac for now because life is too short. Will get multi OS later.
	# All of these have equivalents in Scoop, so easy to do later.
	# E.G: https://github.com/xo/usql#installing-via-scoop-windows


	# postgresql
	brew install postgresql
	brew services start postgresql
	brew services stop postgresql

	# mysql
	brew install mysql
	brew services start mysql
	brew services stop mysql

	# oracle
	# Must be manually downloaded first. Freaking Oracle !!
	# https://vanwollingen.nl/install-oracle-instant-client-and-sqlplus-using-homebrew-a233ce224bf
	# This includes the Data Pump tools needed for CDC :)
	brew tap InstantClientTap/instantclient
	brew install instantclient-basic
	brew install instantclient-sqlplus


dep-os-list: ### deo-os-list
	# whats running ? works great
	brew services list


dep-modules:
	

	# https://github.com/elves
	# Looks like its made to do Pipelines from the Terminal in a Cross platform way.
	# Miht be a nice match for Benthos.
	#go get github.com/elves/elvish

code-open: ### code-open
	code code.code-workspace

### Gateway

gate-dep: ### gate-dep
	# see https://ngrok.com/download
	
	mkdir -p $(PWD)/temp
	curl -o $(PWD)/temp/ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-darwin-amd64.zip
	unzip $(PWD)/temp/ngrok.zip -d $(PWD)/bin

gate-open: ### gate-open
	# login using gedw99 google accont
	open https://dashboard.ngrok.com/status

gate-run: ### gate-run
	# get laptops ip.
	ifconfig | grep "inet " | grep -v 127.0.0.1

	$(PWD)/bin/ngrok authtoken 
	#$(PWD)/bin/ngrok http 8000
	$(PWD)/bin/ngrok http -subdomain=gedw99 $(GATE_PORT)

### USQL

usql-build:
	cd $(USQL_LIB_FSPATH) && GO111MODULE=on go build .
	cp $(GOPATH)/src/github.com/xo/usql/usql $(GOPATH)/bin
	
run:
	usql -h

### GRA 

GRA_BIN=grabs

gra-dep:	
	# grabs dep
	cd $(GRA_LIB_FSPATH) && make install

	# gets all deps.
	cd $(GRA_LIB_FSPATH) && make deps
	


### WAL

WAL_BIN=wal

wal-dep:	
	# grabs dep
	cd $(WAL_LIB_FSPATH) && make install

	# gets all deps.
	cd $(WAL_LIB_FSPATH) && make deps
	

wal-build: ### wal-build
	# pg
	cd $(WAL_LIB_FSPATH) && GOBIN=$(GOPATH)/bin make pg_install
	mkdir -p $(PWD)/bin
	cp $(GOPATH)/bin/wal-g $(PWD)/bin/$(WAL_BIN)-pg

	# mysql
	cd $(WAL_LIB_FSPATH) && GOBIN=$(GOPATH)/bin make mysql_install
	mkdir -p $(PWD)/bin
	cp $(GOPATH)/bin/wal-g $(PWD)/bin/$(WAL_BIN)-my
	
wal-run: ### wal-run
	$(PWD)/bin/$(WAL_BIN) 






	
	
