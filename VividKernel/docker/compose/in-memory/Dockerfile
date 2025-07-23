## GNU AFFERO GENERAL PUBLIC LICENSE
## Version 3, 19 November 2007
##
## Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
## Everyone is permitted to copy and distribute verbatim copies
## of this license document, but changing it is not allowed.

##
## Multi-stage Dockerfile.
## First stage actually build the binary.
## Second stage get the binary from first stage and add it to the base image.
##

##
## First stage (build binary).
##

##
## Full swift image to build swift binaries.
##

#FROM swift:6.1.2-noble AS builder
FROM swiftlang/swift:nightly-6.2-debian12 AS builder

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
## Copy of essential files.
##

# VividKernelService
COPY   ./VividKernelService/Package.swift      ./VividKernelService/Package.swift
COPY   ./VividKernelService/Sources            ./VividKernelService/Sources
COPY   ./VividKernelService/Tests              ./VividKernelService/Tests

# VividKernelDataAccessService
COPY   ./VividKernelDataAccessService/Package.swift      ./VividKernelDataAccessService/Package.swift
COPY   ./VividKernelDataAccessService/Sources            ./VividKernelDataAccessService/Sources

# VividKernelDataAccessServiceInMemory
COPY   ./VividKernelDataAccessServiceInMemory/Package.swift      ./VividKernelDataAccessServiceInMemory/Package.swift
COPY   ./VividKernelDataAccessServiceInMemory/Sources            ./VividKernelDataAccessServiceInMemory/Sources

##
## Swift build.
##

# VividKernelService
RUN     cd ./VividKernelService/      && swift package resolve
RUN     cd ./VividKernelService/      && swift build --configuration release

# VividKernelDataAccessService
RUN     cd ./VividKernelDataAccessService/      && swift package resolve
RUN     cd ./VividKernelDataAccessService/      && swift build --configuration release

# VividKernelDataAccessServiceInMemory
RUN     cd ./VividKernelDataAccessService/      && swift package resolve
RUN     cd ./VividKernelDataAccessService/      && swift build --configuration release

##
## Second stage (add binary to base image).
##

##
## "Slim" swift image to run the binary.
##
#FROM swift:6.1.2-noble-slim
FROM swiftlang/swift:nightly-6.2-debian12

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
