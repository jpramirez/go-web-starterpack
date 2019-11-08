TIME=$(shell date +"%Y%m%d.%H%M%S")
VERSION=0.1.1-alpha-0.8
BINARY_NAME=go-webstarter-go.v1

BINARY_NAME_SERVER=go-webstarter-server.v1


BASE_FOLDER = $(shell pwd)
BUILD_FOLDER  = $(shell pwd)/build

FLAGS_LINUX   = CGO_LDFLAGS="-L./LIB -Wl,-rpath -Wl,\$ORIGIN/LIB" CGO_ENABLED=1 GOOS=linux GOARCH=amd64  
FLAGS_DARWIN  = OSXCROSS_NO_INCLUDE_PATH_WARNINGS=1 MACOSX_DEPLOYMENT_TARGET=10.6 CC=o64-clang CXX=o64-clang++ CGO_ENABLED=0
FLAGS_FREEBSD = GOOS=freebsd GOARCH=amd64 CGO_ENABLED=1
FLAGS_WINDOWS = GOOS=windows GOARCH=amd64 CC=i686-w64-mingw32-gcc CGO_ENABLED=1 

GOFLAGS_WINDOWS = -ldflags -H=windowsgui


init: 
	@mkdir -vp $(BASE_FOLDER)/assets
	@mkdir -vp $(BASE_FOLDER)/build
	@mkdir -vp $(BASE_FOLDER)/cmd
	@mkdir -vp $(BASE_FOLDER)/config
	@mkdir -vp $(BASE_FOLDER)/extras
	@mkdir -vp $(BASE_FOLDER)/pkg/constants
	@mkdir -vp $(BASE_FOLDER)/web
	@mkdir -vp $(BASE_FOLDER)/third-party
	@mkdir -vp $(BASE_FOLDER)/api
	@mkdir -vp $(BASE_FOLDER)/vendor
	@echo "Creating Base Files" 
	@touch $(BASE_FOLDER)/pkg/constants/version.go
	@touch $(BASE_FOLDER)/vendor/packages_windows.txt
	@touch $(BASE_FOLDER)/vendor/packages_linux.txt
	@echo "# README BASE " >> $(BASE_FOLDER)/Readme.md




	


check-env:
	@mkdir -p $(BUILD_FOLDER)/dist/linux/bin
	@mkdir -p $(BUILD_FOLDER)/dist/windows/bin
	@mkdir -p $(BUILD_FOLDER)/dist/arm/bin
	@mkdir -p $(BUILD_FOLDER)/dist/osx/bin
	cp -R config $(BUILD_FOLDER)/dist/linux/
	cp -R config $(BUILD_FOLDER)/dist/windows/
	cp -R config $(BUILD_FOLDER)/dist/arm/
	cp -R config $(BUILD_FOLDER)/dist/osx/
	cp -R extras $(BUILD_FOLDER)/dist/linux/
	cp -R assets $(BUILD_FOLDER)/dist/linux/


## Linting
lint:
	@echo "[lint] Running linter on codebase"
	@golint ./...


getdeps:
	./getDeps.sh


versioning:
	./version.sh ${VERSION} ${TIME}

build/weblayer-linux:
	cd cmd/WebServer && ${FLAGS_LINUX} go build -o ${BUILD_FOLDER}/dist/linux/bin/${BINARY_NAME_SERVER} .


run/dev:
	cd build/dist/linux && bin/${BINARY_NAME_SERVER} --config config/config.json

build/dev: check-env build/weblayer-linux run/dev

clean:
	rm -Rvf build/dist/

startover:
	@rm -fr $(BASE_FOLDER)/assets
	@rm -fr $(BASE_FOLDER)/build
	@rm -fr $(BASE_FOLDER)/cmd
	@rm -fr $(BASE_FOLDER)/config
	@rm -fr $(BASE_FOLDER)/extras
	@rm -fr $(BASE_FOLDER)/pkg
	@rm -fr $(BASE_FOLDER)/web
	@rm -fr $(BASE_FOLDER)/third-party
	@rm -fr $(BASE_FOLDER)/api
	@rm -fr $(BASE_FOLDER)/vendor
	@rm $(BASE_FOLDER)/Readme.md



