//
//  SRDAssertions.swift
//  SRDTestUtilities
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

import Foundation
import XCTest

#if SWIFT_PACKAGE
@_exported import SRDTestUtilitiesObjC
#endif // #if SWIFT_PACKAGE

// MARK: Public Functions

/**
 A function for asserting that a given `NSAttributedString` contains a particular
 attribute.

 - Parameters:
   - attributedString: The attributed string over which the assertion is made.
   - attribute: The attribute that the `attributedString` is asserted to contain.
   - range: An optional range in which to specify the _exact_ range in which the
     `attribute` is expected to appear in the `attributedString`. If this parameter
     is `nil`, the `attribute` can appear anywhere in the `attributedString` to
     fulfill the assertion.
 */
public func SRDAssertAttributedStringContainsAttribute(_ attributedString: @autoclosure () -> NSAttributedString, attribute: @autoclosure () -> NSAttributedString.Key, in range: @autoclosure () -> NSRange? = nil, file: StaticString = #file, line: UInt = #line) {
    do {
        try catchingObjCException {
            ___SRDAssertAttributedStringContainsAttribute(attributedString(), attribute(), range() ?? NSRange(location: NSNotFound, length: 0), file.description, line)
        }
    } catch let error as SRDExceptionError {
        ___SRDRegisterUnexpectedFailure(file.description, line, "SRDAssertAttributedStringContainsAttribute failed: throwing \\\"\(error.exception.reason ?? "nil")\\\"")
    } catch {
        ___SRDRegisterUnexpectedFailure(file.description, line, "SRDAssertAttributedStringContainsAttribute failed: throwing an unknown exception")
    }
}

/**
 A function for asserting that a given `NSAttributedString` contains a particular
 value for a given attribute.

 - Parameters:
   - attributedString: The attributed string over which the assertion is made.
   - attribute: The attribute key and value that the `attributedString` is asserted
     to contain.
   - range: An optional range in which to specify the _exact_ range in which the
     `attributeKey` is expected to appear in the `attributedString`. If this
     parameter is `nil`, the `attributeKey` can appear anywhere in the
     `attributedString` to fulfill the assertion.
 */
public func SRDAssertAttributedStringContainsAttribute<T>(_ attributedString: @autoclosure () -> NSAttributedString, attribute: @autoclosure () -> (key: NSAttributedString.Key, value: T), in range: @autoclosure () -> NSRange? = nil, file: StaticString = #file, line: UInt = #line) where T: Equatable {
    do {
        try catchingObjCException {
            let attribute = attribute()

            ___SRDAssertAttributedStringContainsAttributeAndValue(attributedString(), attribute.key, attribute.value, range() ?? NSRange(location: NSNotFound, length: 0), file.description, line)
        }
    } catch let error as SRDExceptionError {
        ___SRDRegisterUnexpectedFailure(file.description, line, "SRDAssertAttributedStringContainsAttributeAndValue failed: throwing \\\"\(error.exception.reason ?? "nil")\\\"")
    } catch {
        ___SRDRegisterUnexpectedFailure(file.description, line, "SRDAssertAttributedStringContainsAttributeAndValue failed: throwing an unknown exception")
    }
}

// swiftlint:disable large_tuple
/**
 A function for asserting that a given `NSAttributedString` contains a particular
 value for a given attribute.

 - Parameters:
   - attributedString: The attributed string over which the assertion is made.
   - attribute: The attribute key, value, and optional alternate value that the
     `attributedString` is asserted to contain.
   - range: An optional range in which to specify the _exact_ range in which the
     `attributeKey` is expected to appear in the `attributedString`. If this
     parameter is `nil`, the `attributeKey` can appear anywhere in the
     `attributedString` to fulfill the assertion.

 If the given attribute is found within the `attributedString` (in a given range
 if specified), this function first compares the value for the attribute against
 `attribute.value`. If those are not equal and an alternate value is provided,
 the value is then compared against `attribute.alternateValue`. If both values
 are not equal to the value found in the `attributedString` then a `XCTest`
 assertion is raised.
 */
public func SRDAssertAttributedStringContainsAttribute<T>(_ attributedString: @autoclosure () -> NSAttributedString, attribute: @autoclosure () -> (key: NSAttributedString.Key, value: T, alternateValue: T?), in range: @autoclosure () -> NSRange? = nil, file: StaticString = #file, line: UInt = #line) where T: Equatable {
    do {
        try catchingObjCException {
            let attribute = attribute()

            ___SRDAssertAttributedStringContainsAttributeAndValues(attributedString(), attribute.key, attribute.value, attribute.alternateValue, range() ?? NSRange(location: NSNotFound, length: 0), file.description, line)
        }
    } catch let error as SRDExceptionError {
        ___SRDRegisterUnexpectedFailure(file.description, line, "SRDAssertAttributedStringContainsAttributeAndValues failed: throwing \\\"\(error.exception.reason ?? "nil")\\\"")
    } catch {
        ___SRDRegisterUnexpectedFailure(file.description, line, "SRDAssertAttributedStringContainsAttributeAndValues failed: throwing an unknown exception")
    }
}
// swiftlint:enable large_tuple

/**
 A function for asserting that a given `NSAttributedString` does not contain a
 particular attribute.

 - Parameters:
   - attributedString: The attributed string over which the assertion is made.
   - attribute: The attribute that the `attributedString` is asserted not to
     contain.
   - range: An optional range in which to specify the _exact_ range in which the
     `attribute` is expected not to appear in the `attributedString`. If this
     parameter   is `nil`, the `attribute` must not appear anywhere in the
     `attributedString` to   fulfill the assertion.
 */
public func SRDAssertAttributedStringNotContainsAttribute(_ attributedString: @autoclosure () -> NSAttributedString, attribute: @autoclosure () -> NSAttributedString.Key, in range: @autoclosure () -> NSRange? = nil, file: StaticString = #file, line: UInt = #line) {
    do {
        try catchingObjCException {
            ___SRDAssertAttributedStringNotContainsAttribute(attributedString(), attribute(), range() ?? NSRange(location: NSNotFound, length: 0), file.description, line)
        }
    } catch let error as SRDExceptionError {
        ___SRDRegisterUnexpectedFailure(file.description, line, "SRDAssertAttributedStringNotContainsAttribute failed: throwing \\\"\(error.exception.reason ?? "nil")\\\"")
    } catch {
        ___SRDRegisterUnexpectedFailure(file.description, line, "SRDAssertAttributedStringNotContainsAttribute failed: throwing an unknown exception")
    }
}
