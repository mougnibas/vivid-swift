# vivid-swift

A swift project to have fun with a familiar project.

# Usage

TODO

# Dev notes

Please install latest Swift release (6.1.2) using [https://www.swift.org/install](Swiftly) toolchain.

Older 6.1.0 version [https://github.com/realm/SwiftLint/issues/6042](has issue) with SwiftLint.

Also set Xcode to use this toolchain (```Xcode / Toolchains / Swift x.y.z release```).

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
