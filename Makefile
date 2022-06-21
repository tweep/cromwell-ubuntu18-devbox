# Jans Makefile v1.0.2
# Dependenciees: 
# basic_build.env : APP_NAME 
# mk_version_default.env : VERSION 
# dkr_commandline_options.var for mounting code etc :
#   - DKR_CMD_LINE_OPTIONS_AWS
#   - DKR_CMD_LINE_OPTIONS_LOC
#   - DKR_CMD_LINE_OPTIONS_MAC

# Import variables to run docker test with live code mount.
# sets variable like DKR_CMD_LINE_OPTIONS_LOC DKR_CMD_LINE_OPTIONS_AWS etc
cnf ?= mk.conf/dkr_commandline_options.var
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

# import deploy config
# You can change the default deploy config with `make cnf="deploy_special.env" release`
dpl ?= mk.conf/basic_build.env
include $(dpl)
export $(shell sed 's/=.*//' $(dpl))

# grep the version from the mix file
#VERSION=$(shell ./mk_version.sh)
vr ?= mk.conf/mk_version_default.env
include $(vr)
export $(shell sed 's/=.*//' $(vr))


# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


# DOCKER TASKS 

## Build the container 
## docker build -f docker/Dockerfile -t ehive-sentieon-jg:develop 

build: ## Build the container with default version specified in mk_version_default.env. Build special version with make vr=mk_version.env build
	docker build -t $(APP_NAME):$(VERSION) -f docker/Dockerfile .

build-nc: ## Build default version of container without caching
	docker build --no-cache -t $(APP_NAME):$(VERSION) -f docker/Dockerfile .

run: ## Run container default version 
	docker run -i -t --rm --name="$(APP_NAME)" $(APP_NAME):$(VERSION)

test: build  ## Run container with live-mounting of code + envrionment variables in dkr_env_vars.env and mount stuff in mk.conf/dkr_commandline_options.var
	docker run --network=host -i -t --privileged --rm --name="$(APP_NAME)" --env-file=./mk.conf/dkr_environment_local.env $(DKR_CMD_LINE_OPTIONS_LOC)  $(APP_NAME):$(VERSION) /bin/bash

test-nc: build-nc  ## Run container with live-mounting of code + envrionment variables in dkr_env_vars.env and mount stuff in mk.conf/dkr_commandline_options.var
	docker run --network=host -i -t --privileged --rm --name="$(APP_NAME)" --env-file=./mk.conf/dkr_environment_local.env $(DKR_CMD_LINE_OPTIONS_LOC)  $(APP_NAME):$(VERSION) /bin/bash

helloWorld: ## Run HelloWorld wdl with Cromwell 
	java -jar /home/ubuntu/code/bin/cromwell-78.jar run /home/ubuntu/code/wdl/helloWorld.wdl

#release: build tag-version publish-version ## Build a version, tag and release it. Requires docker/ecr login


# Docker tagging
# docker tag ehive-sentieon-feb:develop 576714887429.dkr.ecr.us-west-2.amazonaws.com/ehive-sentieon-jg:develop

tag-version: ## Generate container `{version}` tag
	@echo 'create tag $(VERSION) using version from mk_version.env'
	docker tag $(APP_NAME):$(VERSION)  $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

public: repo-login build tag-version  ## Docker build, tag and push default container verison to ECR. Requires valid credentials via 'aws-azure-login'
	@echo 'publishing to ECR. $(APP_NAME):$(VERSION) to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION)



# HELPERS

version: ## Output the current version
	@echo $(VERSION)

CMD_REPOLOGIN := "aws ecr get-login-password  --region ${AWS_REGION} | docker login --username AWS --password-stdin $(DOCKER_REPO)" 

repo-login: ## Auto login to AWS-ECR unsing aws-cli
	@echo 'Getting ECR credentials for logging into docker repo. Requires valid credentials via aws-azure-login'
	@eval $(CMD_REPOLOGIN)


git: ## git add, commit and tag all changes 
	#$(eval VRSN=$(shell git describe --tags --abbrev=0 | awk -F. '{$$NF+=1; OFS="."; print $0}')) 
	$(eval VRSN=$(shell git tag | tail -n 1 | awk -F. '{$$NF+=1; OFS="."; print $0}')) 
	git add .
	git commit -m "Yet another commit"
	git push origin master
	git tag -a $(VRSN) -m "new release"
	git push origin $(VRSN)	


