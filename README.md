# vivid-swift

A swift project to have fun with a familiar project.

# Usage

TODO

# Dev notes

## Requirements

### Latest Swift Release (Swiftly)

Please install latest Swift release (6.2) using [https://www.swift.org/install](Swiftly) toolchain.

Also change Xcode toolchains to match the previously installed one (```Xcode / Toolchains / Swift 6.2```).

### Vapor

Also install vapor using brew :

```brew install vapor```

Documentation about vapor : https://www.swift.org/getting-started/vapor-web-server/

### Docker Desktop

I face to many issues with Apple Container at current time.
I guess it will be usable and better than Docker Desktop at a time, but until it reach this state, Docker Desktop will
be favored.

Install [https://www.docker.com](Docker Desktop).

## Xcode

Open `Vivid.xcworspace```.

### Scheme

Xcode should be able to autocreate the default scheme at startup.

In case it fail to do so, just run :

```Product / Scheme / Manage schemes... / Autocreate Scheme Now / Close```

### Build

```Product / Build```

### Test

```Product / Test```

### SwiftLint

SwiftLint is integrated with SwiftPackage plugin.

Just run "Build" or "Test", then open "Show the issue navigator" on the left panel.

### Coverage

After running tests, code coverage result is available on "Show the Report navigator" on the left panel.

## Docker Desktop

### Build images

#### Kernel

```bash
cd VividKernel/
docker image build --progress plain --tag vivid-kernel-webservice .
```

### Run images

```bash
docker run --rm --tty --interactive --name pgsql  --hostname pgsql                                                    \
           --env POSTGRES_PASSWORD=mysecretpassword --publish 5432:5432                                               \
           postgres:17.5-bookworm
docker run --rm --tty --interactive --name kernel --hostname kernel vivid-kernel-webservice
```

### Test images

#### Create a new customer (random values)

```bash
curl --request POST http://localhost:50000/customer/auto
```

#### Create a new customer (specific values)

```bash
curl --request POST --header "Content-Type: application/json" \
    --data '{"id":"my-new-id","secret":"my-new-secret"}' http://localhost:50000/customer/
```
#### Get a specific customer

```bash
curl --request GET  http://localhost:50000/customer/my-new-id
```

#### Get all customers

```bash
curl --request GET  http://localhost:50000/customer
```
