# vivid-swift

A swift project to have fun with a familiar project.

# Usage

TODO

# Dev notes

Please install latest Swift release (6.1.2) using [https://www.swift.org/install](Swiftly) toolchain.

Older 6.1.0 version [https://github.com/realm/SwiftLint/issues/6042](has issue) with SwiftLint when 
using ```swift``` cli.

Also install vapor using brew :

```brew install vapor```

Documentation about vapor : https://www.swift.org/getting-started/vapor-web-server/

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

## Apple Container

### Install Apple Container Tool.

#### Install

Install [https://github.com/apple/container/tree/main](Apple Container).

#### Configure

```bash
container system start
container builder stop && container builder delete && container builder start --cpus 1 --memory 2g
```
### Build images

#### Kernel

```bash
cd VividKernel/
container build --progress plain --tag vivid-kernel-webservice .
```

### Run images

```bash
container run --rm --tty --interactive --name kernel vivid-kernel-webservice
```

### Test images

#### Create a new customer (random values)

```bash
curl --request POST http://localhost:8080/customer/auto
```

#### Create a new customer (specific values)

```bash
curl --request POST --header "Content-Type: application/json" \
    --data '{"id":"my-new-id","secret":"my-new-secret"}' http://localhost:8080/customer/
```
#### Get a specific customer

```bash
curl --request GET  http://localhost:8080/customer/my-new-id
```

#### Get all customers

```bash
curl --request GET  http://localhost:8080/customer
```
