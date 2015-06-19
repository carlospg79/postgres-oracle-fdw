NAME               := visualphoenix/postgres-oracle-fdw
VERSION            := 9.4.4-1.2.0
PACKAGE_VERSION    := 1
REPOSITORY         := index.docker.io
BUILD_FILES        += $(filter-out $(wildcard target/*) $(wildcard target/**/*), $(wildcard **/*))
#$(info pkg: $$BUILD_FILES is [${BUILD_FILES}])
