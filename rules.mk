.PHONY      += check-builder
BUILD_FILES += module.mk rules.mk

check-latest: check-builder
check-builder:
	$(DOCKER) $(DOCKER_OPTS) images | grep $(NAME)-builder | grep latest &>/dev/null || ( [ -d target ] && rm -rf target || true )

.dockerbuilder:
	$(DOCKER) $(DOCKER_OPTS) build --force-rm -t $(NAME)-builder:latest -f Dockerfile.build .
	touch $@;

.dockerbuild: .dockerbuilder | target
target: $(shell find src -type f) module.mk rules.mk
	$(DOCKER) $(DOCKER_OPTS) run -a stdout -a stderr --rm $(NAME)-builder:latest build 1.2.0 | tar xzf -
