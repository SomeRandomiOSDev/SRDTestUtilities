//
//  SRDExceptionHandling.swift
//  SRDTestUtilities
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

import Foundation

#if SWIFT_PACKAGE
@_exported import SRDTestUtilitiesObjC
#endif

// MARK: Public Functions

/**
 A function for catching and handling Objective-C exceptions.

 - Parameters:
   - types: An array of exception classes to catch. This defaults to `[]` (any
     Objective-C exception).
   - work: The closure in which to catch any thrown Objective-C exceptions.

 - Throws: An ``SRDExceptionError`` if an Objective-C exception was thrown in the
   closure, or any error thrown from within the closure itself.
 */
public func catchingObjCException<T>(of types: [NSException.Type] = [], work: () throws -> T) throws -> T {
    var result: Result<T, Error> = .failure(NSError(domain: "", code: -1))
    let exception = __SRDCatchObjCException {
        do {
            result = try .success(work())
        } catch {
            result = .failure(error)
        }
    }

    if let exception = exception {
        if types.isEmpty {
            result = .failure(SRDExceptionError.exception(exception))
        } else {
            var match = false
            for type in types {
                if exception.isKind(of: type) {
                    result = .failure(SRDExceptionError.matchedException(exception, exceptionType: type))
                    match = true
                    break
                }
            }

            if !match {
                result = .failure(SRDExceptionError.unmatchedException(exception, exceptionTypes: types))
            }
        }
    }

    return try result.get()
}
