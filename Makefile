GO_SRC=$(shell find . -name \*.go)
COMMIT_HASH=$(shell git rev-parse HEAD)
COMMIT=$(if $(shell git status --porcelain --untracked-files=no),$(COMMIT_HASH)-dirty,$(COMMIT_HASH))
TEST?=$(patsubst test/%.bats,%,$(wildcard test/*.bats))
CRIO_REPO?=~/packages/cri-o
LXC_VERSION=3.1.0

crio-lxc: $(GO_SRC)
	go build -tags static_build -ldflags "-X main.version=$(COMMIT)" -o crio-lxc ./cmd

.PHONY: foreign
foreign: $(GO_SRC)
	stacker build --substitute PWD=$$PWD --substitute LXC_VERSION=${LXC_VERSION}

# make test TEST=basic will run only the basic test.
.PHONY: check
check: crio-lxc
	go fmt ./... && ([ -z $(TRAVIS) ] || git diff --quiet)
	go test ./...
	CRIO_REPO=$(CRIO_REPO) sudo -E "PATH=$$PATH" bats -t $(patsubst %,test/%.bats,$(TEST))

.PHONY: vendorup
vendorup:
	go get -u

.PHONY: clean
clean:
	-rm -f crio-lxc
	stacker clean --all
