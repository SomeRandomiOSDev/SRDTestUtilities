//
//  SRDAssertionsSwiftTests.swift
//  SRDTestUtilities
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

import SRDTestUtilities
import XCTest

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - SRDAssertionsSwiftTests Definition

class SRDAssertionsSwiftTests: XCTestCase {

    // MARK: Private Constants

    private let attributes: [NSAttributedString.Key] = [
        .attachment, .backgroundColor, .baselineOffset,
        .expansion, .font, .foregroundColor,
        .kern, .ligature, .link,
        .obliqueness, .paragraphStyle, .shadow,
        .strikethroughColor, .strikethroughStyle, .strokeColor,
        .strokeWidth, .textEffect, .underlineColor,
        .underlineStyle, .verticalGlyphForm
    ]

    private let defaultOptions: XCTExpectedFailure.Options = {
        let options = XCTExpectedFailure.Options()
        options.issueMatcher = { $0.type == .assertionFailure }

        return options
    }()

    private let exceptionOptions: XCTExpectedFailure.Options = {
        let options = XCTExpectedFailure.Options()
        options.issueMatcher = { $0.type == .uncaughtException }

        return options
    }()

    // MARK: Test Methods

    func testAttributedStringContainsAttribute() {
        let attributeValue = 0

        for attributeKey in attributes {
            XCTContext.runActivity(named: "Attribute: \(attributeKey.rawValue)") { _ in
                let attributedString = NSMutableAttributedString(string: "The quick brown fox jumps over the lazy dog")
                let attributeRange = randomRange(for: attributedString)

                attributedString.addAttribute(attributeKey, value: attributeValue, range: attributeRange)

                //

                XCTContext.runActivity(named: "No Range") { _ in
                    SRDAssertAttributedStringContainsAttribute(attributedString, attribute: attributeKey)
                }

                XCTContext.runActivity(named: "Specific Range") { _ in
                    SRDAssertAttributedStringContainsAttribute(attributedString, attribute: attributeKey, in: attributeRange)
                }
            }
        }
    }

    func testAttributedStringContainsAttributeFailureCases() {
        let attributeValue = 0

        for attributeKey in attributes {
            XCTContext.runActivity(named: "Attribute: \(attributeKey.rawValue)") { _ in
                let attributedString = NSMutableAttributedString(string: "The quick brown fox jumps over the lazy dog")
                let attributeRange = randomRange(for: attributedString)

                attributedString.addAttribute(attributeKey, value: attributeValue, range: attributeRange)

                //

                let otherAttribute = randomAttribute(asideFrom: attributeKey)
                let otherRange = randomRange(disjointFrom: attributeRange, upperBound: attributedString.length)

                XCTContext.runActivity(named: "No Range") { _ in
                    XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: defaultOptions) {
                        SRDAssertAttributedStringContainsAttribute(attributedString, attribute: otherAttribute)
                    }
                }

                XCTContext.runActivity(named: "Specific Range") { _ in
                    XCTContext.runActivity(named: "Different Range") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: defaultOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: attributeKey, in: otherRange)
                        }
                    }

                    XCTContext.runActivity(named: "Different Attribute Key") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: defaultOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: otherAttribute, in: attributeRange)
                        }
                    }
                }

                XCTContext.runActivity(named: "Thrown Exception") { _ in
                    XCTContext.runActivity(named: "Attributed String Expression Throws") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: exceptionOptions) {
                            SRDAssertAttributedStringContainsAttribute(throwingAttributedStringExpression(), attribute: attributeKey)
                            SRDAssertAttributedStringContainsAttribute(throwingAttributedStringExpression(), attribute: attributeKey, in: attributeRange)
                        }
                    }

                    XCTContext.runActivity(named: "Attribute Key Expression Throws") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: exceptionOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: throwingAttributeKeyExpression())
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: throwingAttributeKeyExpression(), in: attributeRange)
                        }
                    }

                    XCTContext.runActivity(named: "Range Expression Throws") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: exceptionOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: attributeKey, in: throwingRangeExpression())
                        }
                    }
                }
            }
        }
    }

    //

    func testAttributedStringContainsAttributeAndValue() {
        let attributeValue = 0

        for attributeKey in attributes {
            XCTContext.runActivity(named: "Attribute: \(attributeKey.rawValue)") { _ in
                let attributedString = NSMutableAttributedString(string: "The quick brown fox jumps over the lazy dog")
                let attributeRange = randomRange(for: attributedString)

                attributedString.addAttribute(attributeKey, value: attributeValue, range: attributeRange)

                //

                XCTContext.runActivity(named: "No Range") { _ in
                    SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, attributeValue))
                }

                XCTContext.runActivity(named: "Specific Range") { _ in
                    SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, attributeValue), in: attributeRange)
                }
            }
        }
    }

    func testAttributedStringContainsAttributeAndValueFailureCases() {
        let attributeValue = 0
        let otherAttributeValue = 1

        for attributeKey in attributes {
            XCTContext.runActivity(named: "Attribute: \(attributeKey.rawValue)") { _ in
                let attributedString = NSMutableAttributedString(string: "The quick brown fox jumps over the lazy dog")
                let attributeRange = randomRange(for: attributedString)

                attributedString.addAttribute(attributeKey, value: attributeValue, range: attributeRange)

                //

                let otherAttribute = randomAttribute(asideFrom: attributeKey)
                let otherRange = randomRange(disjointFrom: attributeRange, upperBound: attributedString.length)

                XCTContext.runActivity(named: "No Range") { _ in
                    XCTContext.runActivity(named: "Different Attribute Key") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: defaultOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (otherAttribute, attributeValue))
                        }
                    }

                    XCTContext.runActivity(named: "Different Attribute Value") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: defaultOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, otherAttributeValue))
                        }
                    }
                }

                XCTContext.runActivity(named: "Specific Range") { _ in
                    XCTContext.runActivity(named: "Different Range") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: defaultOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, attributeValue), in: otherRange)
                        }
                    }

                    XCTContext.runActivity(named: "Different Attribute Key") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: defaultOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (otherAttribute, attributeValue), in: attributeRange)
                        }
                    }

                    XCTContext.runActivity(named: "Different Attribute Value") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: defaultOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, otherAttributeValue), in: attributeRange)
                        }
                    }
                }

                XCTContext.runActivity(named: "Thrown Exception") { _ in
                    XCTContext.runActivity(named: "Attributed String Expression Throws") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: exceptionOptions) {
                            SRDAssertAttributedStringContainsAttribute(throwingAttributedStringExpression(), attribute: (attributeKey, attributeValue))
                            SRDAssertAttributedStringContainsAttribute(throwingAttributedStringExpression(), attribute: (attributeKey, attributeValue), in: attributeRange)
                        }
                    }

                    XCTContext.runActivity(named: "Attribute Key Expression Throws") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: exceptionOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (throwingAttributeKeyExpression(), attributeValue))
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (throwingAttributeKeyExpression(), attributeValue), in: attributeRange)
                        }
                    }

                    XCTContext.runActivity(named: "Attribute Value Expression Throws") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: exceptionOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, throwingAttributeValueExpression()))
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, throwingAttributeValueExpression()), in: attributeRange)
                        }
                    }

                    XCTContext.runActivity(named: "Range Expression Throws") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: exceptionOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, attributeValue), in: throwingRangeExpression())
                        }
                    }
                }
            }
        }
    }

    //

    func testAttributedStringContainsAttributeAndValues() {
        let attributeValue = 0
        let otherAttributeValue = 1

        for attributeKey in attributes {
            XCTContext.runActivity(named: "Attribute: \(attributeKey.rawValue)") { _ in
                let attributedString = NSMutableAttributedString(string: "The quick brown fox jumps over the lazy dog")
                let attributeRange = randomRange(for: attributedString)

                attributedString.addAttribute(attributeKey, value: attributeValue, range: attributeRange)

                //

                XCTContext.runActivity(named: "No Range") { _ in
                    SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, attributeValue, nil))
                    SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, attributeValue, otherAttributeValue))
                    SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, otherAttributeValue, attributeValue))
                }

                XCTContext.runActivity(named: "Specific Range") { _ in
                    SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, attributeValue, nil), in: attributeRange)
                    SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, attributeValue, otherAttributeValue), in: attributeRange)
                    SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, otherAttributeValue, attributeValue), in: attributeRange)
                }
            }
        }
    }

    func testAttributedStringContainsAttributeAndValuesFailureCases() {
        let attributeValue = 0
        let otherAttributeValue = 1

        for attributeKey in attributes {
            XCTContext.runActivity(named: "Attribute: \(attributeKey.rawValue)") { _ in
                let attributedString = NSMutableAttributedString(string: "The quick brown fox jumps over the lazy dog")
                let attributeRange = randomRange(for: attributedString)

                attributedString.addAttribute(attributeKey, value: attributeValue, range: attributeRange)

                //

                let otherAttribute = randomAttribute(asideFrom: attributeKey)
                let otherRange = randomRange(disjointFrom: attributeRange, upperBound: attributedString.length)

                XCTContext.runActivity(named: "No Range") { _ in
                    XCTContext.runActivity(named: "Different Attribute Key") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: defaultOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (otherAttribute, attributeValue, otherAttributeValue))
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (otherAttribute, otherAttributeValue, attributeValue))
                        }
                    }

                    XCTContext.runActivity(named: "Different Attribute Value") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: defaultOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, otherAttributeValue, otherAttributeValue))
                        }
                    }
                }

                XCTContext.runActivity(named: "Specific Range") { _ in
                    XCTContext.runActivity(named: "Different Range") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: defaultOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, attributeValue, otherAttributeValue), in: otherRange)
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, otherAttributeValue, attributeValue), in: otherRange)
                        }
                    }

                    XCTContext.runActivity(named: "Different Attribute Key") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: defaultOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (otherAttribute, attributeValue, otherAttributeValue), in: attributeRange)
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (otherAttribute, otherAttributeValue, attributeValue), in: attributeRange)
                        }
                    }

                    XCTContext.runActivity(named: "Different Attribute Value") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised") {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, otherAttributeValue, otherAttributeValue), in: attributeRange)
                        }
                    }
                }

                XCTContext.runActivity(named: "Thrown Exception") { _ in
                    XCTContext.runActivity(named: "Attributed String Expression Throws") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: exceptionOptions) {
                            SRDAssertAttributedStringContainsAttribute(throwingAttributedStringExpression(), attribute: (attributeKey, attributeValue, nil))
                            SRDAssertAttributedStringContainsAttribute(throwingAttributedStringExpression(), attribute: (attributeKey, attributeValue, nil), in: attributeRange)
                            SRDAssertAttributedStringContainsAttribute(throwingAttributedStringExpression(), attribute: (attributeKey, attributeValue, otherAttributeValue))
                            SRDAssertAttributedStringContainsAttribute(throwingAttributedStringExpression(), attribute: (attributeKey, attributeValue, otherAttributeValue), in: attributeRange)
                        }
                    }

                    XCTContext.runActivity(named: "Attribute Key Expression Throws") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: exceptionOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (throwingAttributeKeyExpression(), attributeValue, nil))
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (throwingAttributeKeyExpression(), attributeValue, nil), in: attributeRange)
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (throwingAttributeKeyExpression(), attributeValue, otherAttributeValue))
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (throwingAttributeKeyExpression(), attributeValue, otherAttributeValue), in: attributeRange)
                        }
                    }

                    XCTContext.runActivity(named: "Attribute Value Expression Throws") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: exceptionOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, throwingAttributeValueExpression(), nil))
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, throwingAttributeValueExpression(), nil), in: attributeRange)
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, throwingAttributeValueExpression(), otherAttributeValue))
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, throwingAttributeValueExpression(), otherAttributeValue), in: attributeRange)
                        }
                    }

                    XCTContext.runActivity(named: "Range Expression Throws") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: exceptionOptions) {
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, attributeValue, nil), in: throwingRangeExpression())
                            SRDAssertAttributedStringContainsAttribute(attributedString, attribute: (attributeKey, attributeValue, otherAttributeValue), in: throwingRangeExpression())
                        }
                    }
                }
            }
        }
    }

    //

    func testAttributedStringNotContainsAttribute() {
        let attributeValue = 0

        for attributeKey in attributes {
            XCTContext.runActivity(named: "Attribute: \(attributeKey.rawValue)") { _ in
                let attributedString = NSMutableAttributedString(string: "The quick brown fox jumps over the lazy dog")
                let attributeRange = randomRange(for: attributedString)

                attributedString.addAttribute(attributeKey, value: attributeValue, range: attributeRange)

                //

                let otherAttribute = randomAttribute(asideFrom: attributeKey)
                let otherRange = randomRange(disjointFrom: attributeRange, upperBound: attributedString.length)

                XCTContext.runActivity(named: "No Range") { _ in
                    SRDAssertAttributedStringNotContainsAttribute(attributedString, attribute: otherAttribute)
                }

                XCTContext.runActivity(named: "Specific Range") { _ in
                    SRDAssertAttributedStringNotContainsAttribute(attributedString, attribute: attributeKey, in: otherRange)
                }
            }
        }
    }

    func testAttributedStringNotContainsAttributeFailureCases() {
        let attributeValue = 0

        for attributeKey in attributes {
            XCTContext.runActivity(named: "Attribute: \(attributeKey.rawValue)") { _ in
                let attributedString = NSMutableAttributedString(string: "The quick brown fox jumps over the lazy dog")
                let attributeRange = randomRange(for: attributedString)

                attributedString.addAttribute(attributeKey, value: attributeValue, range: attributeRange)

                //

                XCTContext.runActivity(named: "No Range") { _ in
                    XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: defaultOptions) {
                        SRDAssertAttributedStringNotContainsAttribute(attributedString, attribute: attributeKey)
                    }
                }

                XCTContext.runActivity(named: "Specific Range") { _ in
                    XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: defaultOptions) {
                        SRDAssertAttributedStringNotContainsAttribute(attributedString, attribute: attributeKey, in: attributeRange)
                    }
                }

                XCTContext.runActivity(named: "Thrown Exception") { _ in
                    XCTContext.runActivity(named: "Attributed String Expression Throws") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: exceptionOptions) {
                            SRDAssertAttributedStringNotContainsAttribute(throwingAttributedStringExpression(), attribute: attributeKey)
                            SRDAssertAttributedStringNotContainsAttribute(throwingAttributedStringExpression(), attribute: attributeKey, in: attributeRange)
                        }
                    }

                    XCTContext.runActivity(named: "Attribute Key Expression Throws") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: exceptionOptions) {
                            SRDAssertAttributedStringNotContainsAttribute(attributedString, attribute: throwingAttributeKeyExpression())
                            SRDAssertAttributedStringNotContainsAttribute(attributedString, attribute: throwingAttributeKeyExpression(), in: attributeRange)
                        }
                    }

                    XCTContext.runActivity(named: "Range Expression Throws") { _ in
                        XCTExpectFailure("This unit test tests to confirm that an issue is raised", options: exceptionOptions) {
                            SRDAssertAttributedStringNotContainsAttribute(attributedString, attribute: attributeKey, in: throwingRangeExpression())
                        }
                    }
                }
            }
        }
    }

    // MARK: - Private Methods

    private func randomRange(for attributedString: NSAttributedString) -> NSRange {
        let stringLength = attributedString.length
        let location = Int.random(in: (stringLength / 4) ... (stringLength * 3 / 4)) - 1
        let length = Int.random(in: 0 ..< (stringLength / 4)) + 1

        return NSRange(location: location, length: length)
    }

    private func randomRange(disjointFrom range: NSRange, upperBound: Int) -> NSRange {
        var above = Bool.random()
        let location: Int, length: Int

        if above && range.upperBound >= (upperBound - 1) {
            above.toggle()
        }

        if above {
            location = Int.random(in: range.upperBound ..< (upperBound - 1))
            length = Int.random(in: 0 ..< (upperBound - location - 1)) + 1
        } else {
            location = Int.random(in: 0 ..< range.location - 1)
            length = Int.random(in: 0 ..< (range.location - location - 1)) + 1
        }

        return NSRange(location: location, length: length)
    }

    private func randomAttribute(asideFrom attribute: NSAttributedString.Key) -> NSAttributedString.Key {
        return self.attributes.filter { $0 != attribute }
                              .shuffled()[0]
    }

    //

    private func throwingAttributedStringExpression() -> NSAttributedString {
        NSException(name: .init(rawValue: NSStringFromClass(NSException.self)), reason: UUID().uuidString).raise()
        return NSAttributedString(string: "")
    }

    private func throwingAttributeKeyExpression() -> NSAttributedString.Key {
        NSException(name: .init(rawValue: NSStringFromClass(NSException.self)), reason: UUID().uuidString).raise()
        return .backgroundColor
    }

    private func throwingAttributeValueExpression() -> Int {
        NSException(name: .init(rawValue: NSStringFromClass(NSException.self)), reason: UUID().uuidString).raise()
        return -1
    }

    private func throwingRangeExpression() -> NSRange {
        NSException(name: .init(rawValue: NSStringFromClass(NSException.self)), reason: UUID().uuidString).raise()
        return NSRange(location: 0, length: 0)
    }
}
