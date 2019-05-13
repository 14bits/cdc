


.DEFAULT_GOAL:=help
SHELL:=/bin/bash
GO111MODULE=off

# https://github.com/wal-g/wal-g
WAL_LIB_NAME=wal-g
WAL_LIB_BRANCH=master
WAL_LIB_TAG=v1.0.0
WAL_LIB=github.com/wal-g/$(WAL_LIB_NAME)
WAL_LIB_UPSTREAM=github.com/wal-g/$(WAL_LIB_NAME)
WAL_LIB_FSPATH=$(GOPATH)/src/$(WAL_LIB)



help:  ## Display this help
	# from: https://suva.sh/posts/well-documented-makefiles/
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

print: ### print

	@echo 	
	@echo WAL_LIB_NAME :      $(WAL_LIB_NAME)
	@echo WAL_LIB_BRANCH :    $(WAL_LIB_BRANCH)
	@echo WAL_LIB_TAG :       $(WAL_LIB_TAG)
	@echo WAL_LIB :           $(WAL_LIB)
	@echo WAL_LIB_FSPATH  :   $(WAL_LIB_FSPATH)
	@echo 


	@echo 

git-clone: ### git-clone

	# benthos
	mkdir -p $(WAL_LIB_FSPATH)
	cd $(WAL_LIB_FSPATH) && cd .. && rm -rf $(WAL_LIB_NAME) && git clone ssh://git@$(WAL_LIB).git
	cd $(WAL_LIB_FSPATH) && git fetch --all --tags --prune
	#cd $(WAL_LIB_FSPATH) && git checkout tags/$(WAL_LIB_TAG)

	

git-clean: ### git-clean
	#rm -rf $(BEP_LIB_FSPATH)



code-open: ### code-open
	code $(WAL_LIB_FSPATH)

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


### WAL

WAL_BIN=wal


wal-dep-os:
	# postgresql
	brew install postgresql
	brew services start postgresql
	brew services stop postgresql

	# mysql
	brew install mysql
	brew services start mysql
	brew services stop mysql

wal-dep-os-list:
	# whats running ? works great
	brew services list

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






	
	
