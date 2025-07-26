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
COPY ./VividKernel/VividKernelService/Package.swift ./VividKernelService/Package.swift
COPY ./VividKernel/VividKernelService/Sources       ./VividKernelService/Sources
COPY ./VividKernel/VividKernelService/Tests         ./VividKernelService/Tests

# VividKernelDataAccessService
COPY ./VividKernel/VividKernelDataAccessService/Package.swift ./VividKernelDataAccessService/Package.swift
COPY ./VividKernel/VividKernelDataAccessService/Sources       ./VividKernelDataAccessService/Sources

# VividKernelDataAccessServiceInMemory
COPY ./VividKernel/VividKernelDataAccessServiceInMemory/Package.swift ./VividKernelDataAccessServiceInMemory/Package.swift
COPY ./VividKernel/VividKernelDataAccessServiceInMemory/Sources       ./VividKernelDataAccessServiceInMemory/Sources
COPY ./VividKernel/VividKernelDataAccessServiceInMemory/Tests         ./VividKernelDataAccessServiceInMemory/Tests

# VividKernelServiceImpl
COPY ./VividKernel/VividKernelServiceImpl/Package.swift ./VividKernelServiceImpl/Package.swift
COPY ./VividKernel/VividKernelServiceImpl/Sources       ./VividKernelServiceImpl/Sources
COPY ./VividKernel/VividKernelServiceImpl/Tests         ./VividKernelServiceImpl/Tests

# VividKernelWebserviceLib
COPY ./VividKernel/VividKernelWebserviceLib/Package.swift ./VividKernelWebserviceLib/Package.swift
COPY ./VividKernel/VividKernelWebserviceLib/Sources       ./VividKernelWebserviceLib/Sources

# VividKernelWebserviceLibInMemory
COPY ./VividKernel/VividKernelWebserviceLibInMemory/Package.swift ./VividKernelWebserviceLibInMemory/Package.swift
COPY ./VividKernel/VividKernelWebserviceLibInMemory/Sources       ./VividKernelWebserviceLibInMemory/Sources

# VividKernelWebserviceLibInMemoryExe
COPY ./VividKernel/VividKernelWebserviceLibInMemoryExe/Package.swift ./VividKernelWebserviceLibInMemoryExe/Package.swift
COPY ./VividKernel/VividKernelWebserviceLibInMemoryExe/Sources       ./VividKernelWebserviceLibInMemoryExe/Sources
RUN  cd ./VividKernelWebserviceLibInMemoryExe/ && swift package resolve
RUN  cd ./VividKernelWebserviceLibInMemoryExe/ && swift build --configuration release --static-swift-stdlib

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
COPY --from=builder /app/VividKernelWebserviceLibInMemoryExe/.build/aarch64-unknown-linux-gnu/release/VividKernelWebserviceLibInMemoryExe .

##
## Run the binary.
##
CMD ["./VividKernelWebserviceLibInMemoryExe"]
