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
FROM swift:6.1.2-noble AS builder

##
## Conventional path.
##
WORKDIR /app

##
## Copy of essential files.
##

# Copy contract library source files.
COPY    ./VividKernelContract/Package.swift      ./VividKernelContract/Package.swift
COPY    ./VividKernelContract/Sources            ./VividKernelContract/Sources
COPY    ./VividKernelContract/Tests              ./VividKernelContract/Tests

# Copy impl library source files.
COPY    ./VividKernelImpl/Package.swift          ./VividKernelImpl/Package.swift
COPY    ./VividKernelImpl/Sources                ./VividKernelImpl/Sources
COPY    ./VividKernelImpl/Tests                  ./VividKernelImpl/Tests

# Copy webservice library source files.
COPY    ./VividKernelWebserviceLib/Package.swift ./VividKernelWebserviceLib/Package.swift
COPY    ./VividKernelWebserviceLib/Sources       ./VividKernelWebserviceLib/Sources
COPY    ./VividKernelWebserviceLib/Tests         ./VividKernelWebserviceLib/Tests

# Copy webservice executable source files.
COPY    ./VividKernelWebserviceExe/Package.swift ./VividKernelWebserviceExe/Package.swift
COPY    ./VividKernelWebserviceExe/Sources       ./VividKernelWebserviceExe/Sources

##
## Swift build.
##

# Build contract library package.
RUN     cd ./VividKernelContract/      && swift package resolve
RUN     cd ./VividKernelContract/      && swift build --configuration release

# Build impl library package.
RUN     cd ./VividKernelImpl/          && swift package resolve
RUN     cd ./VividKernelImpl/          && swift build --configuration  release

# Build webservice library package.
RUN     cd ./VividKernelWebserviceLib/ && swift package resolve
RUN     cd ./VividKernelWebserviceLib/ && swift build --configuration release

# Build webservice executable package.
RUN     cd ./VividKernelWebserviceExe/ && swift package resolve
RUN     cd ./VividKernelWebserviceExe/ && swift build --configuration release
RUN     ls -lah /app/VividKernelWebserviceExe/.build/

##
## Second stage (add binary to base image).
##

##
## "Slim" swift image to run the binary.
##
FROM swift:6.1.2-noble-slim

##
## Conventional path.
##
WORKDIR /app

##
## Copy the binary.
##
COPY --from=builder /app/VividKernelWebserviceExe/.build/aarch64-unknown-linux-gnu/release/VividKernelWebserviceExe .

##
## Run the binary.
##
CMD ["./VividKernelWebserviceExe"]
