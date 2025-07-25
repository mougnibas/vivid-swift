## GNU AFFERO GENERAL PUBLIC LICENSE
## Version 3, 19 November 2007
##
## Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
## Everyone is permitted to copy and distribute verbatim copies
## of this license document, but changing it is not allowed.

##
## Multi-stage Dockerfile.
## First stage actually build the binary.
## Second stage get the binary from first stage and add it to a slim base image.
##

##
## First stage (build binary).
##

##
## Full swift image to build swift binaries.
##

FROM swift:6.1.0-noble AS builder

##
## Default user.
##
USER root

##
## Conventional path.
##
WORKDIR /app

##
## Build requirements
##
RUN apt-get update && apt-get install -y unzip

##
## Copy sources then build packges
##

# VividKernelService
COPY      ./VividKernel/VividKernelService/Package.swift      ./VividKernelService/Package.swift
COPY      ./VividKernel/VividKernelService/Sources            ./VividKernelService/Sources
COPY      ./VividKernel/VividKernelService/Tests              ./VividKernelService/Tests
RUN    cd ./VividKernelService/      && swift package resolve
RUN    cd ./VividKernelService/      && swift build --configuration release

# VividKernelDataAccessService
COPY      ./VividKernel/VividKernelDataAccessService/Package.swift      ./VividKernelDataAccessService/Package.swift
COPY      ./VividKernel/VividKernelDataAccessService/Sources            ./VividKernelDataAccessService/Sources
RUN    cd ./VividKernelDataAccessService/      && swift package resolve
RUN    cd ./VividKernelDataAccessService/      && swift build --configuration release

# VividKernelDataAccessServiceInMemory
COPY      ./VividKernel/VividKernelDataAccessServiceInMemory/Package.swift ./VividKernelDataAccessServiceInMemory/Package.swift
COPY      ./VividKernel/VividKernelDataAccessServiceInMemory/Sources       ./VividKernelDataAccessServiceInMemory/Sources
COPY      ./VividKernel/VividKernelDataAccessServiceInMemory/Tests         ./VividKernelDataAccessServiceInMemory/Tests
RUN    cd ./VividKernelDataAccessServiceInMemory/              && swift package resolve
RUN    cd ./VividKernelDataAccessServiceInMemory/              && swift build --configuration release

# VividKernelDataAccessServiceFluent
COPY      ./VividKernel/VividKernelDataAccessServiceFluent/Package.swift ./VividKernelDataAccessServiceFluent/Package.swift
COPY      ./VividKernel/VividKernelDataAccessServiceFluent/Sources       ./VividKernelDataAccessServiceFluent/Sources
COPY      ./VividKernel/VividKernelDataAccessServiceFluent/Tests         ./VividKernelDataAccessServiceFluent/Tests
RUN    cd ./VividKernelDataAccessServiceFluent/              && swift package resolve
RUN    cd ./VividKernelDataAccessServiceFluent/              && swift build --configuration release

# VividKernelServiceImpl
COPY      ./VividKernel/VividKernelServiceImpl/Package.swift ./VividKernelServiceImpl/Package.swift
COPY      ./VividKernel/VividKernelServiceImpl/Sources       ./VividKernelServiceImpl/Sources
COPY      ./VividKernel/VividKernelServiceImpl/Tests         ./VividKernelServiceImpl/Tests
RUN    cd ./VividKernelServiceImpl/              && swift package resolve
RUN    cd ./VividKernelServiceImpl/              && swift build --configuration release

# VividKernelWebserviceLib
COPY      ./VividKernel/VividKernelWebserviceLib/Package.swift ./VividKernelWebserviceLib/Package.swift
COPY      ./VividKernel/VividKernelWebserviceLib/Sources       ./VividKernelWebserviceLib/Sources
COPY      ./VividKernel/VividKernelWebserviceLib/Tests         ./VividKernelWebserviceLib/Tests
RUN    cd ./VividKernelWebserviceLib/              && swift package resolve
RUN    cd ./VividKernelWebserviceLib/              && swift build --configuration release

# VividKernelWebserviceExeInMemory
COPY      ./VividKernel/VividKernelWebserviceExeInMemory/Package.swift ./VividKernelWebserviceExeInMemory/Package.swift
COPY      ./VividKernel/VividKernelWebserviceExeInMemory/Sources       ./VividKernelWebserviceExeInMemory/Sources
RUN    cd ./VividKernelWebserviceExeInMemory/              && swift package resolve
RUN    cd ./VividKernelWebserviceExeInMemory/              && swift build --configuration release --static-swift-stdlib

# VividKernelWebserviceExeFluent
COPY      ./VividKernel/VividKernelWebserviceExeFluent/Package.swift ./VividKernelWebserviceExeFluent/Package.swift
COPY      ./VividKernel/VividKernelWebserviceExeFluent/Sources       ./VividKernelWebserviceExeFluent/Sources
RUN    cd ./VividKernelWebserviceExeFluent/              && swift package resolve
RUN    cd ./VividKernelWebserviceExeFluent/              && swift build --configuration release

# VividKernelServiceConnector
COPY      ./VividKernel/VividKernelServiceConnector/Package.swift ./VividKernelServiceConnector/Package.swift
COPY      ./VividKernel/VividKernelServiceConnector/Sources       ./VividKernelServiceConnector/Sources
COPY      ./VividKernel/VividKernelServiceConnector/Tests         ./VividKernelServiceConnector/Tests
RUN    cd ./VividKernelServiceConnector/              && swift package resolve
RUN    cd ./VividKernelServiceConnector/              && swift build --configuration release

##
## Second stage (add binary to base image).
##

##
## Regular ubuntu image to run the binary.
##
FROM ubuntu:noble

##
## Port exposed
##
EXPOSE 50000

##
## Conventional path.
##
WORKDIR /app

##
## Copy the binary.
##
COPY --from=builder /app/VividKernelWebserviceExeInMemory/.build/aarch64-unknown-linux-gnu/release/VividKernelWebserviceExeInMemory .

##
## Run the binary.
##
CMD ["./VividKernelWebserviceExeInMemory"]
