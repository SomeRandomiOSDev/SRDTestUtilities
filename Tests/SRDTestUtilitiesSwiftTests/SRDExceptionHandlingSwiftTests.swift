//
//  SRDExceptionHandlingSwiftTests.swift
//  SRDTestUtilities
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

import SRDTestUtilities
import XCTest

// MARK: - SRDExceptionHandlingSwiftTests Definition

class SRDExceptionHandlingSwiftTests: XCTestCase {

    // MARK: Test Methods

    func testCatchingObjCExceptions() {
        let genericException = NSException(name: .init(rawValue: UUID().uuidString), reason: UUID().uuidString, userInfo: nil)
        let customException = CustomException(name: .init(rawValue: UUID().uuidString), reason: UUID().uuidString, userInfo: nil)

        XCTContext.runActivity(named: "No Throw") { _ in
            do {
                let value = try catchingObjCException {
                    return 1
                }

                XCTAssertEqual(value, 1)
            } catch let error as SRDExceptionError {
                XCTFail("Unexpected exception thrown from `catchingObjCException()`: \(error.exception)")
            } catch {
                XCTFail("Unexpected error thrown from `catchingObjCException()`: \(error.localizedDescription)")
            }
        }
        XCTContext.runActivity(named: "Throws NSException") { _ in
            do {
                try catchingObjCException {
                    genericException.raise()
                }

                XCTFail("Unexpected `catchingObjCException()` to throw an exception")
            } catch let SRDExceptionError.exception(exception) {
                XCTAssertEqual(exception, genericException)
            } catch {
                XCTFail("Unexpected error thrown from `catchingObjCException()`: \(error.localizedDescription)")
            }
        }
        XCTContext.runActivity(named: "Throws CustomException") { _ in
            do {
                try catchingObjCException {
                    customException.raise()
                }

                XCTFail("Unexpected `catchingObjCException()` to throw an exception")
            } catch let SRDExceptionError.exception(exception) {
                XCTAssertEqual(exception, customException)
            } catch {
                XCTFail("Unexpected error thrown from `catchingObjCException()`: \(error.localizedDescription)")
            }
        }
    }

    func testCatchingNonSpecificObjCExceptionsWithTypes() {
        let genericException = NSException(name: .init(rawValue: NSStringFromClass(NSException.self)), reason: UUID().uuidString, userInfo: nil)

        XCTContext.runActivity(named: "No Throw") { _ in
            do {
                let value = try catchingObjCException(of: [CustomException.self]) {
                    return 1
                }

                XCTAssertEqual(value, 1)
            } catch let error as SRDExceptionError {
                XCTFail("Unexpected exception thrown from `catchingObjCException()`: \(error.exception)")
            } catch {
                XCTFail("Unexpected error thrown from `catchingObjCException()`: \(error.localizedDescription)")
            }
        }
        XCTContext.runActivity(named: "Throws NSException") { _ in
            for exceptionTypes in [[CustomException.self], []] {
                XCTContext.runActivity(named: "Match Types: \(String(describing: exceptionTypes))") { _ in
                    do {
                        try catchingObjCException(of: exceptionTypes) {
                            genericException.raise()
                        }

                        XCTFail("Unexpected `catchingObjCException()` to throw an exception")
                    } catch let SRDExceptionError.exception(exception) {
                        if exceptionTypes.isEmpty {
                            XCTAssertEqual(exception, genericException)
                        } else {
                            XCTFail("Unexpected exception thrown from `catchingObjCException()`: \(exception)")
                        }
                    } catch let SRDExceptionError.unmatchedException(exception, types) {
                        if exceptionTypes.isEmpty {
                            XCTFail("Unexpected exception thrown from `catchingObjCException()`: \(exception)")
                        } else {
                            XCTAssertEqual(exception, genericException)
                            XCTAssertEqual(types.count, 1)
                            XCTAssertTrue(types.first is CustomException.Type)
                        }
                    } catch {
                        XCTFail("Unexpected error thrown from `catchingObjCException()`: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func testCatchingSpecificObjCExceptions() {
        let customException = CustomException(name: .init(rawValue: NSStringFromClass(CustomException.self)), reason: UUID().uuidString, userInfo: nil)
        let subCustomException = SubCustomException(name: .init(rawValue: NSStringFromClass(SubCustomException.self)), reason: UUID().uuidString, userInfo: nil)

        XCTContext.runActivity(named: "Throws CustomException") { _ in
            do {
                try catchingObjCException(of: [CustomException.self]) {
                    customException.raise()
                }

                XCTFail("Unexpected `catchingObjCException()` to throw an exception")
            } catch let SRDExceptionError.matchedException(exception, type) {
                XCTAssertEqual(exception, customException)
                XCTAssertTrue(type is CustomException.Type)
            } catch {
                XCTFail("Unexpected error thrown from `catchingObjCException()`: \(error.localizedDescription)")
            }
        }
        XCTContext.runActivity(named: "Throws SubCustomException") { _ in
            do {
                try catchingObjCException(of: [CustomException.self]) {
                    subCustomException.raise()
                }

                XCTFail("Unexpected `catchingObjCException()` to throw an exception")
            } catch let SRDExceptionError.matchedException(exception, type) {
                XCTAssertEqual(exception, subCustomException)
                XCTAssertTrue(type is CustomException.Type)
            } catch {
                XCTFail("Unexpected error thrown from `catchingObjCException()`: \(error.localizedDescription)")
            }
        }
    }

    func testCatchingObjCExceptionsThrowingErrors() {
        let nserror = NSError(domain: UUID().uuidString, code: -1, userInfo: nil)

        XCTContext.runActivity(named: "No Match Types") { _ in
            do {
                try catchingObjCException {
                    throw nserror
                }

                XCTFail("Expected `catchingObjCException()` to throw an error")
            } catch let error as SRDExceptionError {
                XCTFail("Unexpected exception thrown from `catchingObjCException()`: \(error.exception)")
            } catch let error {
                XCTAssertEqual(error as NSError, nserror)
            }
        }
        XCTContext.runActivity(named: "Match Types: [CustomException]") { _ in
            do {
                try catchingObjCException(of: [CustomException.self]) {
                    throw nserror
                }

                XCTFail("Expected `catchingObjCException()` to throw an error")
            } catch let error as SRDExceptionError {
                XCTFail("Unexpected exception thrown from `catchingObjCException()`: \(error.exception)")
            } catch let error {
                XCTAssertEqual(error as NSError, nserror)
            }
        }
    }
}

// MARK: - CustomException Definition

internal class CustomException: NSException { }

// MARK: - SubCustomException Definition

internal class SubCustomException: CustomException { }
