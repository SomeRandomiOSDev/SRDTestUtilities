# SRDTestUtilities

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/d30d31c29f17449481b97a04610ff5b9)](https://app.codacy.com/app/SomeRandomiOSDev/SRDTestUtilities?utm_source=github.com&utm_medium=referral&utm_content=SomeRandomiOSDev/SRDTestUtilities&utm_campaign=Badge_Grade_Dashboard)
[![License MIT](https://img.shields.io/cocoapods/l/SRDTestUtilities.svg)](https://cocoapods.org/pods/SRDTestUtilities)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SRDTestUtilities.svg)](https://cocoapods.org/pods/SRDTestUtilities) 
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 
[![Platform](https://img.shields.io/cocoapods/p/SRDTestUtilities.svg)](https://cocoapods.org/pods/SRDTestUtilities)
[![Code Coverage](https://codecov.io/gh/SomeRandomiOSDev/SRDTestUtilities/branch/master/graph/badge.svg)](https://codecov.io/gh/SomeRandomiOSDev/SRDTestUtilities)

![Carthage](https://github.com/SomeRandomiOSDev/SRDTestUtilities/workflows/Carthage/badge.svg)
![Cocoapods](https://github.com/SomeRandomiOSDev/SRDTestUtilities/workflows/Cocoapods/badge.svg)
![Swift Package](https://github.com/SomeRandomiOSDev/SRDTestUtilities/workflows/Swift%20Package/badge.svg)
![SwiftLint](https://github.com/SomeRandomiOSDev/SRDTestUtilities/actions/workflows/swiftlint.yml/badge.svg)
![XCFramework](https://github.com/SomeRandomiOSDev/SRDTestUtilities/actions/workflows/xcframework.yml/badge.svg)
![Xcode Project](https://github.com/SomeRandomiOSDev/SRDTestUtilities/workflows/Xcode%20Project/badge.svg)

A lightweight framework that provides a collection of APIs that are useful for unit testing.

## Purpose

In developing a number of different frameworks I've noticed that I've copied or duplicated various APIs for unit testing those frameworks. In lieu of continuing to duplicate or copy those APIs, I've decided to put them all in a single library that I can pull in as a dependency for testing, hence **SRDTestUtilities**.

## Installation

**SRDTestUtilities** is available through [CocoaPods](https://cocoapods.org), [Carthage](https://github.com/Carthage/Carthage) and the [Swift Package Manager](https://swift.org/package-manager/). 

To install via CocoaPods, simply add the following line to your Podfile:

```ruby
pod 'SRDTestUtilities'
```

> NOTE: Due to linkage issues with the XCTest framework, this pod in _incompatible_ with watchOS targets when using static libraries.

To install via Carthage, simply add the following line to your Cartfile:

```ruby
github "SomeRandomiOSDev/SRDTestUtilities"
```

To install via the Swift Package Manager add the following line to your `Package.swift` file's `dependencies`:

```swift
.package(url: "https://github.com/SomeRandomiOSDev/SRDTestUtilities.git", from: "0.1.0")
```

## Usage

First import **SRDTestUtilities** at the top of your Swift file:

```swift
import SRDTestUtilities
```

Or your Objective-C file:

```objc
@import SRDTestUtilities;
``` 

After that, the way to access the majority of the exposed APIs is by directly subclassing `SRDTestCase`:

```swift
class MyUnitTests: SRDTestCase {

    ...
}
```

Now in your unit testing class you can access any one of the provided APIs. Some of those APIs include:

```swift
// Generates a 2D array of elements that represent every possible combination of the input elements.
func allCombinations<S>(of elements: S) -> [[S.Element]] where S: Sequence

// Generates a 2D array of elements that represent every possible permutation of the input elements.
func allPermutations<S>(of elements: S) -> [[S.Element]] where S: Sequence

...

// Iterates over all possible combinations of the input sequences.
func iterateAllCombinations<S0, S1>(of sequence0: S0, _ sequence1: S1, concurrent: Bool = true, using block: (S0.Element, S1.Element) throws -> Void) rethrows where S0: Sequence, S1: Sequence

...

// Converts a given input string from its current case (or cases) to a given string case.
func convert(_ string: String, to stringCase: SRDStringCase) -> String

...

// Finds and removes a given search string in another string.
func findAndReplace(_ searchString: String, in string: inout String, options: String.CompareOptions, locale: Locale?, recordIssueOnFail: Bool, failureStringDescription: String) -> Bool
```

This framework also provides additional APIs separate from the `SRDTestCase` class. Some of those APIs include:

```swift
// A function for catching and handling Objective-C exceptions.
func catchingObjCException<T>(of types: [NSException.Type] = [], work: () throws -> T) throws -> T

...

// A function for asserting that a given NSAttributedString contains a particular attribute.
func SRDAssertAttributedStringContainsAttribute(_ attributedString: NSAttributedString, attribute: NSAttributedString.Key, in range: NSRange?)

// A function for asserting that a given NSAttributedString contains a particular value for a given attribute.
func SRDAssertAttributedStringContainsAttribute<T>(_ attributedString: NSAttributedString, attribute: (key: NSAttributedString.Key, value: T), in range: NSRange?) where T: Equatable
```

This is only a partial list of all of the APIs that are provided by this framework.

## Contributing

If you have need for a specific feature or you encounter a bug, please open an issue. If you extend the functionality of **SRDTestUtilities** yourself or you feel like fixing a bug yourself, please submit a pull request.

## Author

Joe Newton, somerandomiosdev@gmail.com

## License

**SRDTestUtilities** is available under the MIT license. See the `LICENSE` file for more info.
