//
//  SRDExceptionErrorTests.swift
//  SRDTestUtilities
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

import SRDTestUtilities
import XCTest

// MARK: - SRDExceptionErrorTests Definition

class SRDExceptionErrorTests: XCTestCase {

    // MARK: Test Methods

    func testGenericExceptionCase() {
        let exception = NSException(name: .init(rawValue: NSStringFromClass(NSException.self)), reason: UUID().uuidString, userInfo: nil)
        let error = SRDExceptionError.exception(exception)

        //

        if case let .exception(testException) = error {
            XCTAssertEqual(exception, testException)
        } else {
            XCTFail("Expected `if case let .exception(...)` to succeed.")
        }

        //

        switch error {
        case let .exception(testException):
            XCTAssertEqual(exception, testException)
        default:
            XCTFail("Expected `case let .exception(...)` to succeed.")
        }

        //

        XCTAssertEqual(exception, error.exception)
    }

    func testThrowGenericExceptionError() {
        let exception = NSException(name: .init(rawValue: NSStringFromClass(NSException.self)), reason: UUID().uuidString, userInfo: nil)
        let error = SRDExceptionError.exception(exception)

        //

        do {
            throw error
        } catch let error {
            if case let .exception(testException) = error as? SRDExceptionError {
                XCTAssertEqual(exception, testException)
                XCTAssertEqual(exception, (error as? SRDExceptionError)?.exception)
            } else {
                XCTFail("Expected `if case let .exception(...)` to succeed.")
            }
        }

        //

        do {
            throw error
        } catch let error as SRDExceptionError {
            if case let .exception(testException) = error {
                XCTAssertEqual(exception, testException)
                XCTAssertEqual(exception, error.exception)
            } else {
                XCTFail("Expected `if case let .exception(...)` to succeed.")
            }
        } catch {
            XCTFail("Unexpected error thrown: \(error.localizedDescription)")
        }

        //

        do {
            throw error
        } catch let SRDExceptionError.exception(testException) {
            XCTAssertEqual(exception, testException)
        } catch {
            XCTFail("Unexpected error thrown: \(error.localizedDescription)")
        }
    }

    //

    func testMatchedExceptionCase() {
        let exception = CustomException(name: .init(rawValue: NSStringFromClass(CustomException.self)), reason: UUID().uuidString, userInfo: nil)
        let error = SRDExceptionError.matchedException(exception, exceptionType: CustomException.self)

        //

        if case let .matchedException(testException, exceptionType) = error {
            XCTAssertEqual(exception, testException)
            XCTAssertTrue(exceptionType is CustomException.Type)
        } else {
            XCTFail("Expected `if case let .matchedException(...)` to succeed.")
        }

        //

        switch error {
        case let .matchedException(testException, exceptionType):
            XCTAssertEqual(exception, testException)
            XCTAssertTrue(exceptionType is CustomException.Type)
        default:
            XCTFail("Expected `case let .matchedException(...)` to succeed.")
        }

        //

        XCTAssertEqual(exception, error.exception)
    }

    func testThrowMatchedExceptionError() {
        let exception = CustomException(name: .init(rawValue: NSStringFromClass(CustomException.self)), reason: UUID().uuidString, userInfo: nil)
        let error = SRDExceptionError.matchedException(exception, exceptionType: CustomException.self)

        //

        do {
            throw error
        } catch let error {
            if case let .matchedException(testException, exceptionType) = error as? SRDExceptionError {
                XCTAssertEqual(exception, testException)
                XCTAssertEqual(exception, (error as? SRDExceptionError)?.exception)

                XCTAssertTrue(exceptionType is CustomException.Type)
            } else {
                XCTFail("Expected `if case let .matchedException(...)` to succeed.")
            }
        }

        //

        do {
            throw error
        } catch let error as SRDExceptionError {
            if case let .matchedException(testException, exceptionType) = error {
                XCTAssertEqual(exception, testException)
                XCTAssertEqual(exception, error.exception)

                XCTAssertTrue(exceptionType is CustomException.Type)
            } else {
                XCTFail("Expected `if case let .matchedException(...)` to succeed.")
            }
        } catch {
            XCTFail("Unexpected error thrown: \(error.localizedDescription)")
        }

        //

        do {
            throw error
        } catch let SRDExceptionError.matchedException(testException, exceptionType) {
            XCTAssertEqual(exception, testException)
            XCTAssertTrue(exceptionType is CustomException.Type)
        } catch {
            XCTFail("Unexpected error thrown: \(error.localizedDescription)")
        }
    }

    //

    func testUnmatchedExceptionCase() {
        let exception = CustomException(name: .init(rawValue: NSStringFromClass(CustomException.self)), reason: UUID().uuidString, userInfo: nil)
        let error = SRDExceptionError.unmatchedException(exception, exceptionTypes: [CustomException.self, SubCustomException.self])

        //

        if case let .unmatchedException(testException, exceptionTypes) = error {
            XCTAssertEqual(exception, testException)

            XCTAssertEqual(exceptionTypes.count, 2)
            XCTAssertTrue(exceptionTypes.first is CustomException.Type)
            XCTAssertTrue(exceptionTypes.last is CustomException.Type)
        } else {
            XCTFail("Expected `if case let .matchedException(...)` to succeed.")
        }

        //

        switch error {
        case let .unmatchedException(testException, exceptionTypes):
            XCTAssertEqual(exception, testException)

            XCTAssertEqual(exceptionTypes.count, 2)
            XCTAssertTrue(exceptionTypes.first is CustomException.Type)
            XCTAssertTrue(exceptionTypes.last is CustomException.Type)
        default:
            XCTFail("Expected `case let .matchedException(...)` to succeed.")
        }

        //

        XCTAssertEqual(exception, error.exception)
    }

    func testThrowUnmatchedExceptionError() {
        let exception = CustomException(name: .init(rawValue: NSStringFromClass(CustomException.self)), reason: UUID().uuidString, userInfo: nil)
        let error = SRDExceptionError.unmatchedException(exception, exceptionTypes: [CustomException.self, SubCustomException.self])

        //

        do {
            throw error
        } catch let error {
            if case let .unmatchedException(testException, exceptionTypes) = error as? SRDExceptionError {
                XCTAssertEqual(exception, testException)
                XCTAssertEqual(exception, (error as? SRDExceptionError)?.exception)

                XCTAssertEqual(exceptionTypes.count, 2)
                XCTAssertTrue(exceptionTypes.first is CustomException.Type)
                XCTAssertTrue(exceptionTypes.last is CustomException.Type)
            } else {
                XCTFail("Expected `if case let .unmatchedException(...)` to succeed.")
            }
        }

        //

        do {
            throw error
        } catch let error as SRDExceptionError {
            if case let .unmatchedException(testException, exceptionTypes) = error {
                XCTAssertEqual(exception, testException)
                XCTAssertEqual(exception, error.exception)

                XCTAssertEqual(exceptionTypes.count, 2)
                XCTAssertTrue(exceptionTypes.first is CustomException.Type)
                XCTAssertTrue(exceptionTypes.last is CustomException.Type)
            } else {
                XCTFail("Expected `if case let .unmatchedException(...)` to succeed.")
            }
        } catch {
            XCTFail("Unexpected error thrown: \(error.localizedDescription)")
        }

        //

        do {
            throw error
        } catch let SRDExceptionError.unmatchedException(testException, exceptionTypes) {
            XCTAssertEqual(exception, testException)
            XCTAssertEqual(exceptionTypes.count, 2)
            XCTAssertTrue(exceptionTypes.first is CustomException.Type)
            XCTAssertTrue(exceptionTypes.last is CustomException.Type)
        } catch {
            XCTFail("Unexpected error thrown: \(error.localizedDescription)")
        }
    }
}
