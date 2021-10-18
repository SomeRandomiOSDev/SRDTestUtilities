//
//  SRDExceptionError.swift
//  SRDTestUtilities
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

import Foundation

// MARK: - SRDExceptionError Definition

/// An error type for representing thrown Objective-C exceptions.
public enum SRDExceptionError: Error {

    // MARK: Cases

    /**
     An error case that represents a generalized thrown Objective-C exception.
     */
    case exception(NSException)

    /**
     An error case that represents a thrown Objective-C exception that matches a
     particular exception class.
     */
    case matchedException(NSException, exceptionType: NSException.Type)

    /**
     An error case that represents a thrown Objective-C exception that doesn't match
     any class in a particular list of exception classes.
     */
    case unmatchedException(NSException, exceptionTypes: [NSException.Type])

    // MARK: Public Properties

    /**
     The Objective-C exception of the receiver.
     */
    public var exception: NSException {
        let exception: NSException

        switch self {
        case let .exception(exc): exception = exc
        case let .matchedException(exc, _): exception = exc
        case let .unmatchedException(exc, _): exception = exc
        }

        return exception
    }

    // MARK: Error Protocol Requirements

    public var localizedDescription: String {
        return "SRDExceptionError: \(String(describing: exception))"
    }
}
