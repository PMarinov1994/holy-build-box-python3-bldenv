PYENV_VERSION = 1.0.0
PY_VERSION = 1.0.0
IMG_REPO = docker.io
OWNER = pmarinov944
DISABLE_OPTIMIZATIONS = 0
PYENV_IMAGE = $(IMG_REPO)/$(OWNER)/holy-build-box-pyenv
PY_IMAGE = $(IMG_REPO)/$(OWNER)/holy-build-box-py

.PHONY: build_pyenv_amd64 build_pyenv_arm64 build_py_amd64 build_py_arm64 tag_pyenv_amd64 tag_pyenv_arm64 tag_py_amd64 tag_py_arm64 push_pyenv_amd64 push_pyenv_arm64 push_py_amd64 push_py_arm64 release_pyenv release_py all

#####
##### BUILDS
#####

# TODO '--provenance false' is a hack but I CBA fixing it
build_pyenv_amd64:
	docker buildx build --load --platform "linux/amd64" --provenance false --rm -t $(PYENV_IMAGE):$(PYENV_VERSION)-amd64 --pull --build-arg DISABLE_OPTIMIZATIONS=$(DISABLE_OPTIMIZATIONS) --file Dockerfile-pyenv.dockerfile .

build_pyenv_arm64:
	docker buildx build --load --platform "linux/arm64" --provenance false --rm -t $(PYENV_IMAGE):$(PYENV_VERSION)-arm64 --pull --build-arg DISABLE_OPTIMIZATIONS=$(DISABLE_OPTIMIZATIONS) --file Dockerfile-pyenv.dockerfile .

build_py_amd64:
	docker buildx build --load --platform "linux/amd64" --provenance false --rm -t $(PY_IMAGE):$(PY_VERSION)-amd64 --pull --build-arg DISABLE_OPTIMIZATIONS=$(DISABLE_OPTIMIZATIONS) --file Dockerfile-py.dockerfile .

build_py_arm64:
	docker buildx build --load --platform "linux/arm64" --provenance false --rm -t $(PY_IMAGE):$(PY_VERSION)-arm64 --pull --build-arg DISABLE_OPTIMIZATIONS=$(DISABLE_OPTIMIZATIONS) --file Dockerfile-py.dockerfile .

#####
##### TAGS
#####

tag_pyenv_amd64: build_pyenv_amd64
	docker tag $(PYENV_IMAGE):$(PYENV_VERSION)-amd64 $(PYENV_IMAGE):latest-amd64

tag_pyenv_arm64: build_pyenv_arm64
	docker tag $(PYENV_IMAGE):$(PYENV_VERSION)-arm64 $(PYENV_IMAGE):latest-arm64

tag_py_amd64: build_py_amd64
	docker tag $(PY_IMAGE):$(PY_VERSION)-amd64 $(PY_IMAGE):latest-amd64

tag_py_arm64: build_py_arm64
	docker tag $(PY_IMAGE):$(PY_VERSION)-arm64 $(PY_IMAGE):latest-arm64


#####
##### PUBLISH
#####

push_pyenv_amd64: tag_pyenv_amd64
	docker push $(PYENV_IMAGE):$(PYENV_VERSION)-amd64
	docker push $(PYENV_IMAGE):latest-amd64

push_pyenv_arm64: tag_pyenv_arm64
	docker push $(PYENV_IMAGE):$(PYENV_VERSION)-arm64
	docker push $(PYENV_IMAGE):latest-arm64

push_py_amd64: tag_py_amd64
	docker push $(PY_IMAGE):$(PY_VERSION)-amd64
	docker push $(PY_IMAGE):latest-amd64

push_py_arm64: tag_py_arm64
	docker push $(PY_IMAGE):$(PY_VERSION)-arm64
	docker push $(PY_IMAGE):latest-arm64

release_pyenv: push_pyenv_amd64 push_pyenv_arm64
	docker manifest create $(PYENV_IMAGE):$(PYENV_VERSION) $(PYENV_IMAGE):$(PYENV_VERSION)-amd64 $(PYENV_IMAGE):$(PYENV_VERSION)-arm64
	docker manifest push $(PYENV_IMAGE):$(PYENV_VERSION)
	docker manifest create $(PYENV_IMAGE):latest $(PYENV_IMAGE):latest-amd64 $(PYENV_IMAGE):latest-arm64
	docker manifest push $(PYENV_IMAGE):latest

release_py: push_py_amd64 push_py_arm64
	docker manifest create $(PY_IMAGE):$(PY_VERSION) $(PY_IMAGE):$(PY_VERSION)-amd64 $(PY_IMAGE):$(PY_VERSION)-arm64
	docker manifest push $(PY_IMAGE):$(PY_VERSION)
	docker manifest create $(PY_IMAGE):latest $(PY_IMAGE):latest-amd64 $(PY_IMAGE):latest-arm64
	docker manifest push $(PY_IMAGE):latest

all: release_pyenv release_py
