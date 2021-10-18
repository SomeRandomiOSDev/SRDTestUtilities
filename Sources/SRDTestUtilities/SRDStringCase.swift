//
//  SRDStringCase.swift
//  SRDTestUtilities
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

import Foundation

// MARK: - SRDStringCase Definition

/// An enumeration representing various string cases.
@objc public enum SRDStringCase: Int, CaseIterable, CustomStringConvertible {

    // MARK: Cases

    /**
     An enumeration case representing the 'Camel' string case.

     This string case is defined as a group of words combined without any spaces
     where the first letter of each word is capitalized with the remaining letters
     lowercase with the exception of the first word using all lowercase letters. The
     only exception of the captilization rule is that any acronyms (e.g. URL) that
     are _not_ the first word which should generally use all uppercase letters.

     ```swift
     let strings = [
        "camelCaseString", // "Camel case string"
        "someRandomStringOfWords", // "Some random string of words"
        "endpointURLOfService" // "Endpoint URL of service"
     ]
     ```
     */
    case camel

    /**
     An enumeration case representing the 'Pascal' string case.

     This string case is defined as a group of words combined without any spaces
     where the first letter of each word, including the first word, is capitalized
     with the remaining letters lowercase. The only exception of the captilization
     rule is that any acronyms (e.g. URL) which should generally use all uppercase
     letters.

     ```swift
     let strings = [
        "PascalCaseString", // "Pascal case string"
        "SomeRandomStringOfWords", // "Some random string of words"
        "EndpointURLOfService" // "Endpoint URL of service"
     ]
     ```
     */
    case pascal

    /**
     An enumeration case representing the 'Snake' string case.

     This string case is defined as a group of words separated by the "\_" character
     with all letters being lowercase.

     ```swift
     let strings = [
        "snake_case_string", // "Snake case string"
        "some_random_string_of_words", // "Some random string of words"
        "endpoint_url_of_service" // "Endpoint URL of service"
     ]
     ```
     */
    case snake

    /**
     An enumeration case representing the 'Kebab' string case.

     This string case is defined as a group of words separated by the "-" character
     with all letters being lowercase.

     ```swift
     let strings = [
        "kebab-case-string", // "Kebab case string"
        "some-random-string-of-words", // "Some random string of words"
        "endpoint-url-of-service" // "Endpoint URL of service"
     ]
     ```
     */
    case kebab

    // MARK: CustomStringConvertible Protocol Requirements

    public var description: String {
        let description: String
        switch self {
        case .camel: description = "Camel"
        case .pascal: description = "Pascal"
        case .snake: description = "Snake"
        case .kebab: description = "Kebab"
        }

        return description
    }
}
