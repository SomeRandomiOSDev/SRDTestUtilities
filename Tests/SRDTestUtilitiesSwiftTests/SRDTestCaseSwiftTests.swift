//
//  SRDTestCaseSwiftTests.swift
//  SRDTestUtilitiesSwiftTests
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

import SRDTestUtilities
import XCTest

// MARK: - SRDTestCaseSwiftTests Definition

class SRDTestCaseSwiftTests: SRDTestCase {

    // MARK: SRDTestCaseTests.TestError

    private enum TestError: Error {

        // MARK: Cases

        case testError
    }

    // MARK: Private Constants

    private let testCollection = [
        "1", "2", "3", "4"
    ]
    private let testCombinations = [
        [],
        ["1"],
        ["2"], ["1", "2"],
        ["3"], ["1", "3"], ["2", "3"], ["1", "2", "3"],
        ["4"], ["1", "4"], ["2", "4"], ["1", "2", "4"], ["3", "4"], ["1", "3", "4"], ["2", "3", "4"], ["1", "2", "3", "4"]
    ]
    private let testPermutations = [
        ["1", "2", "3", "4"], ["1", "2", "4", "3"], ["1", "3", "2", "4"], ["1", "3", "4", "2"], ["1", "4", "2", "3"], ["1", "4", "3", "2"],
        ["2", "1", "3", "4"], ["2", "1", "4", "3"], ["2", "3", "1", "4"], ["2", "3", "4", "1"], ["2", "4", "1", "3"], ["2", "4", "3", "1"],
        ["3", "1", "2", "4"], ["3", "1", "4", "2"], ["3", "2", "1", "4"], ["3", "2", "4", "1"], ["3", "4", "1", "2"], ["3", "4", "2", "1"],
        ["4", "1", "2", "3"], ["4", "1", "3", "2"], ["4", "2", "1", "3"], ["4", "2", "3", "1"], ["4", "3", "1", "2"], ["4", "3", "2", "1"]
    ]

    // MARK: Test Methods

    func testAllCombinations() {
        let combinations = allCombinations(of: testCollection)

        XCTAssertEqual(Set(combinations), Set(testCombinations))
    }

    func testAllNSArrayCombinations() {
        let combinations = allCombinations(of: testCollection as NSArray)

        XCTAssertNotNil(combinations as? [[String]])
        XCTAssertEqual((combinations as? [[String]]).map { Set($0) }, Set(testCombinations))
    }

    func testAllPermutations() {
        let permutations = allPermutations(of: testCollection)

        XCTAssertEqual(Set(permutations), Set(testPermutations))
    }

    func testAllNSArrayPermutations() {
        let permutations = allPermutations(of: testCollection as NSArray)

        XCTAssertNotNil(permutations as? [[String]])
        XCTAssertEqual((permutations as? [[String]]).map { Set($0) }, Set(testPermutations))
    }

    //

    func testIterateAllCombinationsNoThrow() {
        let queue = DispatchQueue(label: "")

        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                var combinations: [[String]] = []

                iterateAllCombinations(of: testCollection, concurrent: concurrent) { combination in
                    if concurrent {
                        queue.sync { combinations.append(combination) }
                    } else {
                        combinations.append(combination)
                    }
                }

                if concurrent {
                    XCTAssertEqual(Set(combinations), Set(testCombinations))
                } else {
                    XCTAssertEqual(combinations, testCombinations)
                }
            }
        }
    }

    func testIterateAllCombinationsNoThrowWithMax() {
        let queue = DispatchQueue(label: "")
        let allCombinations = self.allCombinations(of: testCollection)

        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                for max in 0 ..< allCombinations.count {
                    XCTContext.runActivity(named: "Max: \(max)") { _  in
                        var combinations: [[String]] = []

                        iterateAllCombinations(of: testCollection, max: max, concurrent: concurrent) { combination in
                            if concurrent {
                                queue.sync { combinations.append(combination) }
                            } else {
                                combinations.append(combination)
                            }
                        }

                        if max == 0 || max == allCombinations.count {
                            XCTAssertEqual(Set(combinations), Set(testCombinations))
                        } else {
                            XCTAssertTrue(Set(combinations).isSubset(of: testCombinations))
                        }
                    }
                }
            }
        }
    }

    func testIterateAllCombinationsThrowError() {
        let combinations = allCombinations(of: testCollection)

        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                for i in 0 ..< combinations.count {
                    do {
                        try iterateAllCombinations(of: testCollection, concurrent: concurrent) { element in
                            if i == combinations.firstIndex(of: element) {
                                throw TestError.testError
                            }
                        }

                        XCTFail("Exepcted `SRDTestCase.iterateAllCombinations(of:max:concurrent:using:)` to throw an error")
                    } catch TestError.testError {
                        // Success!
                    } catch let error {
                        XCTFail("Unexpected error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func testIterateAllNSArrayCombinationsNoThrow() {
        let queue = DispatchQueue(label: "")

        for concurrentValue in [false, true, nil] {
            let concurrent = concurrentValue ?? true

            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                var combinations: [[String]] = []
                let block: (NSArray) -> Void = { combination in
                    if concurrent {
                        queue.sync { (combination as? [String]).map { combinations.append($0) } }
                    } else {
                        (combination as? [String]).map { combinations.append($0) }
                    }
                }

                if concurrentValue == nil {
                    iterateAllCombinations(of: testCollection as NSArray, using: block)
                } else {
                    iterateAllCombinations(of: testCollection as NSArray, max: .max, concurrent: concurrent, using: block)
                }

                if concurrent {
                    XCTAssertEqual(Set(combinations), Set(testCombinations))
                } else {
                    XCTAssertEqual(combinations, testCombinations)
                }
            }
        }
    }

    //

    func testIterateAllPermutationsNoThrow() {
        let queue = DispatchQueue(label: "")

        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                var permutations: [[String]] = []

                iterateAllPermutations(of: testCollection, concurrent: concurrent) { permutation in
                    if concurrent {
                        queue.sync { permutations.append(permutation) }
                    } else {
                        permutations.append(permutation)
                    }
                }

                if concurrent {
                    XCTAssertEqual(Set(permutations), Set(testPermutations))
                } else {
                    XCTAssertEqual(permutations, testPermutations)
                }
            }
        }
    }

    func testIterateAllPermutationsNoThrowWithMax() {
        let queue = DispatchQueue(label: "")
        let allPermutations = self.allPermutations(of: testCollection)

        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                for max in 0 ..< allPermutations.count {
                    XCTContext.runActivity(named: "Max: \(max)") { _  in
                        var permutations: [[String]] = []

                        iterateAllPermutations(of: testCollection, max: max, concurrent: concurrent) { permutation in
                            if concurrent {
                                queue.sync { permutations.append(permutation) }
                            } else {
                                permutations.append(permutation)
                            }
                        }

                        if max == 0 || max == allPermutations.count {
                            XCTAssertEqual(Set(permutations), Set(testPermutations))
                        } else {
                            XCTAssertTrue(Set(permutations).isSubset(of: testPermutations))
                        }
                    }
                }
            }
        }
    }

    func testIterateAllPermutationsThrowError() {
        let permutations = allPermutations(of: testCollection)

        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                for i in 0 ..< permutations.count {
                    do {
                        try iterateAllPermutations(of: testCollection, concurrent: concurrent) { element in
                            if i == permutations.firstIndex(of: element) {
                                throw TestError.testError
                            }
                        }

                        XCTFail("Exepcted `SRDTestCase.iterateAllPermutations(of:max:concurrent:using:)` to throw an error")
                    } catch TestError.testError {
                        // Success!
                    } catch let error {
                        XCTFail("Unexpected error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func testIterateAllNSArrayPermutations() {
        let queue = DispatchQueue(label: "")

        for concurrentValue in [false, true, nil] {
            let concurrent = concurrentValue ?? true

            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                var permutations: [[String]] = []
                let block: (NSArray) -> Void = { permutation in
                    if concurrent {
                        queue.sync { (permutation as? [String]).map { permutations.append($0) } }
                    } else {
                        (permutation as? [String]).map { permutations.append($0) }
                    }
                }

                if concurrentValue == nil {
                    iterateAllPermutations(of: testCollection as NSArray, using: block)
                } else {
                    iterateAllPermutations(of: testCollection as NSArray, max: .max, concurrent: concurrent, using: block)
                }

                if concurrent {
                    XCTAssertEqual(Set(permutations), Set(testPermutations))
                } else {
                    XCTAssertEqual(permutations, testPermutations)
                }
            }
        }
    }

    //

    func testIterateAllCombinationsOfTwoCollectionsNoThrow() {
        let collection1 = ["1", "2"]
        let collection2 = [1, 2]

        let allCombinations = generateTestElements(for: collection1, collection2)
        let queue = DispatchQueue(label: "")

        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                var combinations = allCombinations
                combinations.removeAll(keepingCapacity: true)

                iterateAllCombinations(of: collection1, collection2, concurrent: concurrent) { element1, element2 in
                    if concurrent {
                        queue.sync { combinations.append(.init(element1, element2)) }
                    } else {
                        combinations.append(.init(element1, element2))
                    }
                }

                if concurrent {
                    XCTAssertEqual(Set(combinations), Set(allCombinations))
                } else {
                    XCTAssertEqual(combinations, allCombinations)
                }
            }
        }
    }

    func testIterateAllCombinationsOfThreeCollectionsNoThrow() {
        let collection1 = ["1", "2"]
        let collection2 = [1, 2]
        let collection3 = [1.0, 2.0]

        let allCombinations = generateTestElements(for: collection1, collection2, collection3)
        let queue = DispatchQueue(label: "")

        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                var combinations = allCombinations
                combinations.removeAll(keepingCapacity: true)

                iterateAllCombinations(of: collection1, collection2, collection3, concurrent: concurrent) { element1, element2, element3 in
                    if concurrent {
                        queue.sync { combinations.append(.init(element1, element2, element3)) }
                    } else {
                        combinations.append(.init(element1, element2, element3))
                    }
                }

                if concurrent {
                    XCTAssertEqual(Set(combinations), Set(allCombinations))
                } else {
                    XCTAssertEqual(combinations, allCombinations)
                }
            }
        }
    }

    func testIterateAllCombinationsOfFourCollectionsNoThrow() {
        let collection1: [String] = ["1", "2"]
        let collection2: [Int] = [1, 2]
        let collection3: [Double] = [1.0, 2.0]
        let collection4: [Bool] = [false, true]

        let allCombinations = generateTestElements(for: collection1, collection2, collection3, collection4)
        let queue = DispatchQueue(label: "")

        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                var combinations = allCombinations
                combinations.removeAll(keepingCapacity: true)

                iterateAllCombinations(of: collection1, collection2, collection3, collection4, concurrent: concurrent) { element1, element2, element3, element4 in
                    if concurrent {
                        queue.sync { combinations.append(.init(element1, element2, element3, element4)) }
                    } else {
                        combinations.append(.init(element1, element2, element3, element4))
                    }
                }

                if concurrent {
                    XCTAssertEqual(Set(combinations), Set(allCombinations))
                } else {
                    XCTAssertEqual(combinations, allCombinations)
                }
            }
        }
    }

    func testIterateAllCombinationsOfFiveCollectionsNoThrow() {
        let collection1: [String] = ["1", "2"]
        let collection2: [Int] = [1, 2]
        let collection3: [Double] = [1.0, 2.0]
        let collection4: [Bool] = [false, true]
        let collection5: [Character] = ["a", "b"]

        let allCombinations = generateTestElements(for: collection1, collection2, collection3, collection4, collection5)
        let queue = DispatchQueue(label: "")

        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                var combinations = allCombinations
                combinations.removeAll(keepingCapacity: true)

                iterateAllCombinations(of: collection1, collection2, collection3, collection4, collection5, concurrent: concurrent) { element1, element2, element3, element4, element5 in
                    if concurrent {
                        queue.sync { combinations.append(.init(element1, element2, element3, element4, element5)) }
                    } else {
                        combinations.append(.init(element1, element2, element3, element4, element5))
                    }
                }

                if concurrent {
                    XCTAssertEqual(Set(combinations), Set(allCombinations))
                } else {
                    XCTAssertEqual(combinations, allCombinations)
                }
            }
        }
    }

    func testIterateAllCombinationsOfSixCollectionsNoThrow() {
        let collection1: [String] = ["1", "2"]
        let collection2: [Int] = [1, 2]
        let collection3: [Double] = [1.0, 2.0]
        let collection4: [Bool] = [false, true]
        let collection5: [Character] = ["a", "b"]
        let collection6: [String] = ["1", "2"]

        let allCombinations = generateTestElements(for: collection1, collection2, collection3, collection4, collection5, collection6)
        let queue = DispatchQueue(label: "")

        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                var combinations = allCombinations
                combinations.removeAll(keepingCapacity: true)

                iterateAllCombinations(of: collection1, collection2, collection3, collection4, collection5, collection6, concurrent: concurrent) { element1, element2, element3, element4, element5, element6 in
                    if concurrent {
                        queue.sync { combinations.append(.init(element1, element2, element3, element4, element5, element6)) }
                    } else {
                        combinations.append(.init(element1, element2, element3, element4, element5, element6))
                    }
                }

                if concurrent {
                    XCTAssertEqual(Set(combinations), Set(allCombinations))
                } else {
                    XCTAssertEqual(combinations, allCombinations)
                }
            }
        }
    }

    func testIterateAllCombinationsOfSevenCollectionsNoThrow() {
        let collection1: [String] = ["1", "2"]
        let collection2: [Int] = [1, 2]
        let collection3: [Double] = [1.0, 2.0]
        let collection4: [Bool] = [false, true]
        let collection5: [Character] = ["a", "b"]
        let collection6: [String] = ["1", "2"]
        let collection7: [Int] = [1, 2]

        let allCombinations = generateTestElements(for: collection1, collection2, collection3, collection4, collection5, collection6, collection7)
        let queue = DispatchQueue(label: "")

        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                var combinations = allCombinations
                combinations.removeAll(keepingCapacity: true)

                iterateAllCombinations(of: collection1, collection2, collection3, collection4, collection5, collection6, collection7, concurrent: concurrent) { element1, element2, element3, element4, element5, element6, element7 in
                    if concurrent {
                        queue.sync { combinations.append(.init(element1, element2, element3, element4, element5, element6, element7)) }
                    } else {
                        combinations.append(.init(element1, element2, element3, element4, element5, element6, element7))
                    }
                }

                if concurrent {
                    XCTAssertEqual(Set(combinations), Set(allCombinations))
                } else {
                    XCTAssertEqual(combinations, allCombinations)
                }
            }
        }
    }

    func testIterateAllCombinationsOfEightCollectionsNoThrow() {
        let collection1: [String] = ["1", "2"]
        let collection2: [Int] = [1, 2]
        let collection3: [Double] = [1.0, 2.0]
        let collection4: [Bool] = [false, true]
        let collection5: [Character] = ["a", "b"]
        let collection6: [String] = ["1", "2"]
        let collection7: [Int] = [1, 2]
        let collection8: [Double] = [1.0, 2.0]

        let allCombinations = generateTestElements(for: collection1, collection2, collection3, collection4, collection5, collection6, collection7, collection8)
        let queue = DispatchQueue(label: "")

        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                var combinations = allCombinations
                combinations.removeAll(keepingCapacity: true)

                iterateAllCombinations(of: collection1, collection2, collection3, collection4, collection5, collection6, collection7, collection8, concurrent: concurrent) { element1, element2, element3, element4, element5, element6, element7, element8 in
                    if concurrent {
                        queue.sync { combinations.append(.init(element1, element2, element3, element4, element5, element6, element7, element8)) }
                    } else {
                        combinations.append(.init(element1, element2, element3, element4, element5, element6, element7, element8))
                    }
                }

                if concurrent {
                    XCTAssertEqual(Set(combinations), Set(allCombinations))
                } else {
                    XCTAssertEqual(combinations, allCombinations)
                }
            }
        }
    }

    func testIterateAllCombinationsOfNineCollectionsNoThrow() {
        let collection1: [String] = ["1", "2"]
        let collection2: [Int] = [1, 2]
        let collection3: [Double] = [1.0, 2.0]
        let collection4: [Bool] = [false, true]
        let collection5: [Character] = ["a", "b"]
        let collection6: [String] = ["1", "2"]
        let collection7: [Int] = [1, 2]
        let collection8: [Double] = [1.0, 2.0]
        let collection9: [Bool] = [false, true]

        let allCombinations = generateTestElements(for: collection1, collection2, collection3, collection4, collection5, collection6, collection7, collection8, collection9)
        let queue = DispatchQueue(label: "")

        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                var combinations = allCombinations
                combinations.removeAll(keepingCapacity: true)

                iterateAllCombinations(of: collection1, collection2, collection3, collection4, collection5, collection6, collection7, collection8, collection9, concurrent: concurrent) { element1, element2, element3, element4, element5, element6, element7, element8, element9 in
                    if concurrent {
                        queue.sync { combinations.append(.init(element1, element2, element3, element4, element5, element6, element7, element8, element9)) }
                    } else {
                        combinations.append(.init(element1, element2, element3, element4, element5, element6, element7, element8, element9))
                    }
                }

                if concurrent {
                    XCTAssertEqual(Set(combinations), Set(allCombinations))
                } else {
                    XCTAssertEqual(combinations, allCombinations)
                }
            }
        }
    }

    func testIterateAllCombinationsOfTenCollectionsNoThrow() {
        let collection1: [String] = ["1", "2"]
        let collection2: [Int] = [1, 2]
        let collection3: [Double] = [1.0, 2.0]
        let collection4: [Bool] = [false, true]
        let collection5: [Character] = ["a", "b"]
        let collection6: [String] = ["1", "2"]
        let collection7: [Int] = [1, 2]
        let collection8: [Double] = [1.0, 2.0]
        let collection9: [Bool] = [false, true]
        let collection10: [Character] = ["a", "b"]

        let allCombinations = generateTestElements(for: collection1, collection2, collection3, collection4, collection5, collection6, collection7, collection8, collection9, collection10)
        let queue = DispatchQueue(label: "")

        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                var combinations = allCombinations
                combinations.removeAll(keepingCapacity: true)

                iterateAllCombinations(of: collection1, collection2, collection3, collection4, collection5, collection6, collection7, collection8, collection9, collection10, concurrent: concurrent) { element1, element2, element3, element4, element5, element6, element7, element8, element9, element10 in
                    if concurrent {
                        queue.sync { combinations.append(.init(element1, element2, element3, element4, element5, element6, element7, element8, element9, element10)) }
                    } else {
                        combinations.append(.init(element1, element2, element3, element4, element5, element6, element7, element8, element9, element10))
                    }
                }

                if concurrent {
                    XCTAssertEqual(Set(combinations), Set(allCombinations))
                } else {
                    XCTAssertEqual(combinations, allCombinations)
                }
            }
        }
    }

    //

    func testIterateAllCombinationsOfTwoCollectionsThrowError() {
        let collection1 = ["1", "2"]
        let collection2 = [1, 2]

        let allCombinations = generateTestElements(for: collection1, collection2)
        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                for i in 0 ..< allCombinations.count {
                    let element = allCombinations[i]

                    do {
                        try iterateAllCombinations(of: collection1, collection2, concurrent: concurrent) { element1, element2 in
                            if element == IteratedElements(element1, element2) {
                                throw TestError.testError
                            }
                        }

                        XCTFail("Exepcted `SRDTestCase.iterateAllPermutations(of:_:concurrent:using:)` to throw an error")
                    } catch TestError.testError {
                        // Success!
                    } catch let error {
                        XCTFail("Unexpected error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func testIterateAllCombinationsOfThreeCollectionsThrowError() {
        let collection1 = ["1", "2"]
        let collection2 = [1, 2]
        let collection3 = [1.0, 2.0]

        let allCombinations = generateTestElements(for: collection1, collection2, collection3)
        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                for i in 0 ..< allCombinations.count {
                    let element = allCombinations[i]

                    do {
                        try iterateAllCombinations(of: collection1, collection2, collection3, concurrent: concurrent) { element1, element2, element3 in
                            if element == IteratedElements(element1, element2, element3) {
                                throw TestError.testError
                            }
                        }

                        XCTFail("Exepcted `SRDTestCase.iterateAllPermutations(of:_:_:concurrent:using:)` to throw an error")
                    } catch TestError.testError {
                        // Success!
                    } catch let error {
                        XCTFail("Unexpected error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func testIterateAllCombinationsOfFourCollectionsThrowError() {
        let collection1: [String] = ["1", "2"]
        let collection2: [Int] = [1, 2]
        let collection3: [Double] = [1.0, 2.0]
        let collection4: [Bool] = [false, true]

        let allCombinations = generateTestElements(for: collection1, collection2, collection3, collection4)
        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                for i in 0 ..< allCombinations.count {
                    let element = allCombinations[i]

                    do {
                        try iterateAllCombinations(of: collection1, collection2, collection3, collection4, concurrent: concurrent) { element1, element2, element3, element4 in
                            if element == IteratedElements(element1, element2, element3, element4) {
                                throw TestError.testError
                            }
                        }

                        XCTFail("Exepcted `SRDTestCase.iterateAllPermutations(of:_:_:_:concurrent:using:)` to throw an error")
                    } catch TestError.testError {
                        // Success!
                    } catch let error {
                        XCTFail("Unexpected error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func testIterateAllCombinationsOfFiveCollectionsThrowError() {
        let collection1: [String] = ["1", "2"]
        let collection2: [Int] = [1, 2]
        let collection3: [Double] = [1.0, 2.0]
        let collection4: [Bool] = [false, true]
        let collection5: [Character] = ["a", "b"]

        let allCombinations = generateTestElements(for: collection1, collection2, collection3, collection4, collection5)
        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                for i in 0 ..< allCombinations.count {
                    let element = allCombinations[i]

                    do {
                        try iterateAllCombinations(of: collection1, collection2, collection3, collection4, collection5, concurrent: concurrent) { element1, element2, element3, element4, element5 in
                            if element == IteratedElements(element1, element2, element3, element4, element5) {
                                throw TestError.testError
                            }
                        }

                        XCTFail("Exepcted `SRDTestCase.iterateAllPermutations(of:_:_:_:_:concurrent:using:)` to throw an error")
                    } catch TestError.testError {
                        // Success!
                    } catch let error {
                        XCTFail("Unexpected error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func testIterateAllCombinationsOfSixCollectionsThrowError() {
        let collection1: [String] = ["1", "2"]
        let collection2: [Int] = [1, 2]
        let collection3: [Double] = [1.0, 2.0]
        let collection4: [Bool] = [false, true]
        let collection5: [Character] = ["a", "b"]
        let collection6: [String] = ["1", "2"]

        let allCombinations = generateTestElements(for: collection1, collection2, collection3, collection4, collection5, collection6)
        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                for i in 0 ..< allCombinations.count {
                    let element = allCombinations[i]

                    do {
                        try iterateAllCombinations(of: collection1, collection2, collection3, collection4, collection5, collection6, concurrent: concurrent) { element1, element2, element3, element4, element5, element6 in
                            if element == IteratedElements(element1, element2, element3, element4, element5, element6) {
                                throw TestError.testError
                            }
                        }

                        XCTFail("Exepcted `SRDTestCase.iterateAllPermutations(of:_:_:_:_:_:concurrent:using:)` to throw an error")
                    } catch TestError.testError {
                        // Success!
                    } catch let error {
                        XCTFail("Unexpected error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func testIterateAllCombinationsOfSevenCollectionsThrowError() {
        let collection1: [String] = ["1", "2"]
        let collection2: [Int] = [1, 2]
        let collection3: [Double] = [1.0, 2.0]
        let collection4: [Bool] = [false, true]
        let collection5: [Character] = ["a", "b"]
        let collection6: [String] = ["1", "2"]
        let collection7: [Int] = [1, 2]

        let allCombinations = generateTestElements(for: collection1, collection2, collection3, collection4, collection5, collection6, collection7)
        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                for i in 0 ..< allCombinations.count {
                    let element = allCombinations[i]

                    do {
                        try iterateAllCombinations(of: collection1, collection2, collection3, collection4, collection5, collection6, collection7, concurrent: concurrent) { element1, element2, element3, element4, element5, element6, element7 in
                            if element == IteratedElements(element1, element2, element3, element4, element5, element6, element7) {
                                throw TestError.testError
                            }
                        }

                        XCTFail("Exepcted `SRDTestCase.iterateAllPermutations(of:_:_:_:_:_:_:concurrent:using:)` to throw an error")
                    } catch TestError.testError {
                        // Success!
                    } catch let error {
                        XCTFail("Unexpected error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func testIterateAllCombinationsOfEightCollectionsThrowError() {
        let collection1: [String] = ["1", "2"]
        let collection2: [Int] = [1, 2]
        let collection3: [Double] = [1.0, 2.0]
        let collection4: [Bool] = [false, true]
        let collection5: [Character] = ["a", "b"]
        let collection6: [String] = ["1", "2"]
        let collection7: [Int] = [1, 2]
        let collection8: [Double] = [1.0, 2.0]

        let allCombinations = generateTestElements(for: collection1, collection2, collection3, collection4, collection5, collection6, collection7, collection8)
        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                for i in 0 ..< allCombinations.count {
                    let element = allCombinations[i]

                    do {
                        try iterateAllCombinations(of: collection1, collection2, collection3, collection4, collection5, collection6, collection7, collection8, concurrent: concurrent) { element1, element2, element3, element4, element5, element6, element7, element8 in
                            if element == IteratedElements(element1, element2, element3, element4, element5, element6, element7, element8) {
                                throw TestError.testError
                            }
                        }

                        XCTFail("Exepcted `SRDTestCase.iterateAllPermutations(of:_:_:_:_:_:_:_:concurrent:using:)` to throw an error")
                    } catch TestError.testError {
                        // Success!
                    } catch let error {
                        XCTFail("Unexpected error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func testIterateAllCombinationsOfNineCollectionsThrowError() {
        let collection1: [String] = ["1", "2"]
        let collection2: [Int] = [1, 2]
        let collection3: [Double] = [1.0, 2.0]
        let collection4: [Bool] = [false, true]
        let collection5: [Character] = ["a", "b"]
        let collection6: [String] = ["1", "2"]
        let collection7: [Int] = [1, 2]
        let collection8: [Double] = [1.0, 2.0]
        let collection9: [Bool] = [false, true]

        let allCombinations = generateTestElements(for: collection1, collection2, collection3, collection4, collection5, collection6, collection7, collection8, collection9)
        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                for i in 0 ..< allCombinations.count {
                    let element = allCombinations[i]

                    do {
                        try iterateAllCombinations(of: collection1, collection2, collection3, collection4, collection5, collection6, collection7, collection8, collection9, concurrent: concurrent) { element1, element2, element3, element4, element5, element6, element7, element8, element9 in
                            if element == IteratedElements(element1, element2, element3, element4, element5, element6, element7, element8, element9) {
                                throw TestError.testError
                            }
                        }

                        XCTFail("Exepcted `SRDTestCase.iterateAllPermutations(of:_:_:_:_:_:_:_:_:concurrent:using:)` to throw an error")
                    } catch TestError.testError {
                        // Success!
                    } catch let error {
                        XCTFail("Unexpected error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func testIterateAllCombinationsOfTenCollectionsThrowError() {
        let collection1: [String] = ["1", "2"]
        let collection2: [Int] = [1, 2]
        let collection3: [Double] = [1.0, 2.0]
        let collection4: [Bool] = [false, true]
        let collection5: [Character] = ["a", "b"]
        let collection6: [String] = ["1", "2"]
        let collection7: [Int] = [1, 2]
        let collection8: [Double] = [1.0, 2.0]
        let collection9: [Bool] = [false, true]
        let collection10: [Character] = ["a", "b"]

        let allCombinations = generateTestElements(for: collection1, collection2, collection3, collection4, collection5, collection6, collection7, collection8, collection9, collection10)
        for concurrent in [false, true] {
            XCTContext.runActivity(named: "Concurrent: \(concurrent ? "true" : "false")") { _ in
                for i in 0 ..< allCombinations.count {
                    let element = allCombinations[i]

                    do {
                        try iterateAllCombinations(of: collection1, collection2, collection3, collection4, collection5, collection6, collection7, collection8, collection9, collection10, concurrent: concurrent) { element1, element2, element3, element4, element5, element6, element7, element8, element9, element10 in
                            if element == IteratedElements(element1, element2, element3, element4, element5, element6, element7, element8, element9, element10) {
                                throw TestError.testError
                            }
                        }

                        XCTFail("Exepcted `SRDTestCase.iterateAllPermutations(of:_:_:_:_:_:_:_:_:_:concurrent:using:)` to throw an error")
                    } catch TestError.testError {
                        // Success!
                    } catch let error {
                        XCTFail("Unexpected error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    //

    func testSplitCamelCaseString() {
        let string = "thisIsACamelCaseString"
        let words = ["this", "Is", "A", "Camel", "Case", "String"]

        XCTAssertEqual(splitStringIntoWords(string), words)
    }

    func testSplitPascalCaseString() {
        let string = "ThisIsAPascalCaseString"
        let words = ["This", "Is", "A", "Pascal", "Case", "String"]

        XCTAssertEqual(splitStringIntoWords(string), words)
    }

    func testSplitSnakeCaseString() {
        let string = "this_is_a_snake_case_string"
        let words = ["this", "is", "a", "snake", "case", "string"]

        XCTAssertEqual(splitStringIntoWords(string), words)
    }

    func testSplitSnakeCaseStringWithDuplicateSepatators() {
        let string = "this_is__a_snake___case__string"
        let words = ["this", "is", "a", "snake", "case", "string"]

        XCTAssertEqual(splitStringIntoWords(string), words)
    }

    func testSplitKebabCaseString() {
        let string = "this-is-a-kebab-case-string"
        let words = ["this", "is", "a", "kebab", "case", "string"]

        XCTAssertEqual(splitStringIntoWords(string), words)
    }

    func testSplitKebabCaseStringWithDuplicateSeparators() {
        let string = "this--is-a----kebab--case---string"
        let words = ["this", "is", "a", "kebab", "case", "string"]

        XCTAssertEqual(splitStringIntoWords(string), words)
    }

    //

    func testSplitSnakeAndCamelCaseString() {
        let string = "thisIs_aSnake_andCamel_caseString"
        let words = ["this", "Is", "a", "Snake", "and", "Camel", "case", "String"]

        XCTAssertEqual(splitStringIntoWords(string), words)
    }

    func testSplitKebabAndCamelCaseString() {
        let string = "thisIs-aKebab-andCamel-caseString"
        let words = ["this", "Is", "a", "Kebab", "and", "Camel", "case", "String"]

        XCTAssertEqual(splitStringIntoWords(string), words)
    }

    func testSplitSnakeAndPascalCaseString() {
        let string = "ThisIs_ASnake_AndPascal_CaseString"
        let words = ["This", "Is", "A", "Snake", "And", "Pascal", "Case", "String"]

        XCTAssertEqual(splitStringIntoWords(string), words)
    }

    func testSplitKebabAndPascalCaseString() {
        let string = "ThisIs-AKebab-AndPascal-CaseString"
        let words = ["This", "Is", "A", "Kebab", "And", "Pascal", "Case", "String"]

        XCTAssertEqual(splitStringIntoWords(string), words)
    }

    //

    func testSplitEdgeCaseStrings() {
        XCTContext.runActivity(named: "\"URLEncoding\"") { _ in
            let string = "URLEncoding"
            let words = ["URL", "Encoding"]

            XCTAssertEqual(splitStringIntoWords(string), words)
        }
        XCTContext.runActivity(named: "\"NSURL\"") { _ in
            let string = "NSURL"
            let words = ["NSURL"]

            XCTAssertEqual(splitStringIntoWords(string), words)
        }
        XCTContext.runActivity(named: "\"lowercasestring\"") { _ in
            let string = "lowercasestring"
            let words = ["lowercasestring"]

            XCTAssertEqual(splitStringIntoWords(string), words)
        }
        XCTContext.runActivity(named: "\"\"") { _ in
            let string = ""

            XCTAssertTrue(splitStringIntoWords(string).isEmpty)
        }
    }

    func testSplitSnakeKebabStringsWithDuplicateSeparators() {
        for i in 2 ... 10 {
            let string = String(repeating: "-", count: i)

            XCTContext.runActivity(named: "\"\(string)\"") { _ in
                XCTAssertTrue(splitStringIntoWords(string).isEmpty)
            }
        }
        for i in 2 ... 10 {
            let string = String(repeating: "_", count: i)

            XCTContext.runActivity(named: "\"\(string)\"") { _ in
                XCTAssertTrue(splitStringIntoWords(string).isEmpty)
            }
        }
    }

    //

    func testConvertStringBetweenCases() {
        let camelCase = "thisIsAString"
        let pascalCase = "ThisIsAString"
        let snakeCase = "this_is_a_string"
        let kebabCase = "this-is-a-string"

        runConvertBetweenStringCaseTests(source: camelCase, sourceCase: .camel, camel: camelCase, pascal: pascalCase, snake: snakeCase, kebab: kebabCase)
        runConvertBetweenStringCaseTests(source: pascalCase, sourceCase: .pascal, camel: camelCase, pascal: pascalCase, snake: snakeCase, kebab: kebabCase)
        runConvertBetweenStringCaseTests(source: snakeCase, sourceCase: .snake, camel: camelCase, pascal: pascalCase, snake: snakeCase, kebab: kebabCase)
        runConvertBetweenStringCaseTests(source: kebabCase, sourceCase: .kebab, camel: camelCase, pascal: pascalCase, snake: snakeCase, kebab: kebabCase)
    }

    func testConvertEdgeCaseStrings() {
        XCTContext.runActivity(named: "\"URLEncoding\"") { _ in
            let source = "URLEncoding"
            let camelCase = "urlEncoding"
            let pascalCase = "URLEncoding"
            let snakeCase = "url_encoding"
            let kebabCase = "url-encoding"

            runConvertBetweenStringCaseTests(source: source, sourceCase: nil, camel: camelCase, pascal: pascalCase, snake: snakeCase, kebab: kebabCase)
        }
        XCTContext.runActivity(named: "\"NSURL\"") { _ in
            let source = "NSURL"
            let camelCase = "nsurl"
            let pascalCase = "NSURL"
            let snakeCase = "nsurl"
            let kebabCase = "nsurl"

            runConvertBetweenStringCaseTests(source: source, sourceCase: nil, camel: camelCase, pascal: pascalCase, snake: snakeCase, kebab: kebabCase)
        }
        XCTContext.runActivity(named: "\"lowercasestring\"") { _ in
            let source = "lowercasestring"
            let camelCase = "lowercasestring"
            let pascalCase = "Lowercasestring"
            let snakeCase = "lowercasestring"
            let kebabCase = "lowercasestring"

            runConvertBetweenStringCaseTests(source: source, sourceCase: nil, camel: camelCase, pascal: pascalCase, snake: snakeCase, kebab: kebabCase)
        }
        XCTContext.runActivity(named: "\"\"") { _ in
            let source = ""

            runConvertBetweenStringCaseTests(source: source, sourceCase: nil, camel: source, pascal: source, snake: source, kebab: source)
        }
    }

    func testConvertSnakeKebabStringsWithDuplicateSeparators() {
        for i in 2 ... 10 {
            let source = String(repeating: "-", count: i)

            XCTContext.runActivity(named: "\"\(source)\"") { _ in
                runConvertBetweenStringCaseTests(source: source, sourceCase: nil, camel: "", pascal: "", snake: "", kebab: "")
            }
        }
        for i in 2 ... 10 {
            let source = String(repeating: "_", count: i)

            XCTContext.runActivity(named: "\"\(source)\"") { _ in
                runConvertBetweenStringCaseTests(source: source, sourceCase: nil, camel: "", pascal: "", snake: "", kebab: "")
            }
        }
    }

    //

    func testFindAndReplace() {
        let count = 10
        var string = "[\((0 ..< count).map { "String\($0)" }.joined(separator: ","))]"

        for i in 0 ..< 10 {
            XCTAssertEqual(string, "[\(String(repeating: ",", count: i))\((i ..< count).map { "String\($0)" }.joined(separator: ","))]")
            XCTAssertTrue(findAndReplace("String\(i)", in: &string))
            XCTAssertEqual(string, "[\(String(repeating: ",", count: min(i + 1, count - 1)))\(((i + 1) ..< count).map { "String\($0)" }.joined(separator: ","))]")
        }

        XCTAssertEqual(string, "[\(String(repeating: ",", count: count - 1))]")
    }

    func testFindAndReplaceFailures() {
        let testString = "[\((0 ..< 10).map { "String\($0)" }.joined(separator: ","))]"
        var string = testString
        let searchString = UUID().uuidString
        var result = false

        // swiftlint:disable multiline_arguments
        XCTContext.runActivity(named: "Without Failing") { _ in
            XCTAssertFalse(findAndReplace(searchString, in: &string, recordIssueOnFail: false))
        }
        XCTContext.runActivity(named: "Fail Without String Description") { _ in
            XCTExpectFailure("This unit test tests to confirm that an issue is raised") {
                result = findAndReplace(searchString, in: &string, recordIssueOnFail: true)
            } issueMatcher: { issue in
                return issue.type == .assertionFailure &&
                       issue.compactDescription == "SRDTestCase.findAndReplace(_:in:options:locale:) failed: Expected to find \"\(searchString)\" in: \"\(testString)\"" &&
                       issue.detailedDescription == nil &&
                       issue.sourceCodeContext.location == XCTSourceCodeLocation(filePath: #file, lineNumber: #line - 5) &&
                       issue.associatedError == nil &&
                       issue.attachments.isEmpty
            }

            XCTAssertEqual(result, false)
        }
        XCTContext.runActivity(named: "Fail With String Description") { _ in
            XCTExpectFailure("This unit test tests to confirm that an issue is raised") {
                result = findAndReplace(searchString, in: &string, recordIssueOnFail: true, failureStringDescription: "JSON")
            } issueMatcher: { issue in
                return issue.type == .assertionFailure &&
                       issue.compactDescription == "SRDTestCase.findAndReplace(_:in:options:locale:) failed: Expected to find \"\(searchString)\" in JSON: \"\(testString)\"" &&
                       issue.detailedDescription == nil &&
                       issue.sourceCodeContext.location == XCTSourceCodeLocation(filePath: #file, lineNumber: #line - 5) &&
                       issue.associatedError == nil &&
                       issue.attachments.isEmpty
            }

            XCTAssertEqual(result, false)
        }
        // swiftlint:enable multiline_arguments multiple_closures_with_trailing_closure
    }

    // MARK: Private Methods

    private func runConvertBetweenStringCaseTests(source: String, sourceCase: SRDStringCase?, camel: String, pascal: String, snake: String, kebab: String) {
        let cases: [SRDStringCase: String] = [.camel: camel, .pascal: pascal, .snake: snake, .kebab: kebab]

        for `case` in SRDStringCase.allCases {
            XCTContext.runActivity(named: "\(sourceCase.map { String(describing: $0) } ?? "Mixed") -> \(String(describing: `case`))") { _ in
                XCTAssertEqual(convert(source, to: `case`), cases[`case`])
            }
        }
    }

    private func generateTestElements<S0, S1>(for sequence0: S0, _ sequence1: S1) -> [IteratedElements<S0.Element, S1.Element, _Void, _Void, _Void, _Void, _Void, _Void, _Void, _Void>] where S0: Sequence, S1: Sequence {
        var elements: [IteratedElements<S0.Element, S1.Element, _Void, _Void, _Void, _Void, _Void, _Void, _Void, _Void>] = []

        for value0 in sequence0 {
            for value1 in sequence1 {
                elements.append(IteratedElements(value0, value1))
            }
        }

        return elements
    }

    private func generateTestElements<S0, S1, S2>(for sequence0: S0, _ sequence1: S1, _ sequence2: S2) -> [IteratedElements<S0.Element, S1.Element, S2.Element, _Void, _Void, _Void, _Void, _Void, _Void, _Void>] where S0: Sequence, S1: Sequence, S2: Sequence {
        var elements: [IteratedElements<S0.Element, S1.Element, S2.Element, _Void, _Void, _Void, _Void, _Void, _Void, _Void>] = []

        for element in generateTestElements(for: sequence0, sequence1) {
            for value2 in sequence2 {
                elements.append(IteratedElements(element.value0, element.value1, value2))
            }
        }

        return elements
    }

    private func generateTestElements<S0, S1, S2, S3>(for sequence0: S0, _ sequence1: S1, _ sequence2: S2, _ sequence3: S3) -> [IteratedElements<S0.Element, S1.Element, S2.Element, S3.Element, _Void, _Void, _Void, _Void, _Void, _Void>] where S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence {
        var elements: [IteratedElements<S0.Element, S1.Element, S2.Element, S3.Element, _Void, _Void, _Void, _Void, _Void, _Void>] = []

        for element in generateTestElements(for: sequence0, sequence1, sequence2) {
            for value3 in sequence3 {
                elements.append(IteratedElements(element.value0, element.value1, element.value2, value3))
            }
        }

        return elements
    }

    private func generateTestElements<S0, S1, S2, S3, S4>(for sequence0: S0, _ sequence1: S1, _ sequence2: S2, _ sequence3: S3, _ sequence4: S4) -> [IteratedElements<S0.Element, S1.Element, S2.Element, S3.Element, S4.Element, _Void, _Void, _Void, _Void, _Void>] where S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence {
        var elements: [IteratedElements<S0.Element, S1.Element, S2.Element, S3.Element, S4.Element, _Void, _Void, _Void, _Void, _Void>] = []

        for element in generateTestElements(for: sequence0, sequence1, sequence2, sequence3) {
            for value4 in sequence4 {
                elements.append(IteratedElements(element.value0, element.value1, element.value2, element.value3, value4))
            }
        }

        return elements
    }

    private func generateTestElements<S0, S1, S2, S3, S4, S5>(for sequence0: S0, _ sequence1: S1, _ sequence2: S2, _ sequence3: S3, _ sequence4: S4, _ sequence5: S5) -> [IteratedElements<S0.Element, S1.Element, S2.Element, S3.Element, S4.Element, S5.Element, _Void, _Void, _Void, _Void>] where S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence, S5: Sequence {
        var elements: [IteratedElements<S0.Element, S1.Element, S2.Element, S3.Element, S4.Element, S5.Element, _Void, _Void, _Void, _Void>] = []

        for element in generateTestElements(for: sequence0, sequence1, sequence2, sequence3, sequence4) {
            for value5 in sequence5 {
                elements.append(IteratedElements(element.value0, element.value1, element.value2, element.value3, element.value4, value5))
            }
        }

        return elements
    }

    // swiftlint:disable function_parameter_count
    private func generateTestElements<S0, S1, S2, S3, S4, S5, S6>(for sequence0: S0, _ sequence1: S1, _ sequence2: S2, _ sequence3: S3, _ sequence4: S4, _ sequence5: S5, _ sequence6: S6) -> [IteratedElements<S0.Element, S1.Element, S2.Element, S3.Element, S4.Element, S5.Element, S6.Element, _Void, _Void, _Void>] where S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence, S5: Sequence, S6: Sequence {
        var elements: [IteratedElements<S0.Element, S1.Element, S2.Element, S3.Element, S4.Element, S5.Element, S6.Element, _Void, _Void, _Void>] = []

        for element in generateTestElements(for: sequence0, sequence1, sequence2, sequence3, sequence4, sequence5) {
            for value6 in sequence6 {
                elements.append(IteratedElements(element.value0, element.value1, element.value2, element.value3, element.value4, element.value5, value6))
            }
        }

        return elements
    }

    private func generateTestElements<S0, S1, S2, S3, S4, S5, S6, S7>(for sequence0: S0, _ sequence1: S1, _ sequence2: S2, _ sequence3: S3, _ sequence4: S4, _ sequence5: S5, _ sequence6: S6, _ sequence7: S7) -> [IteratedElements<S0.Element, S1.Element, S2.Element, S3.Element, S4.Element, S5.Element, S6.Element, S7.Element, _Void, _Void>] where S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence, S5: Sequence, S6: Sequence, S7: Sequence {
        var elements: [IteratedElements<S0.Element, S1.Element, S2.Element, S3.Element, S4.Element, S5.Element, S6.Element, S7.Element, _Void, _Void>] = []

        for element in generateTestElements(for: sequence0, sequence1, sequence2, sequence3, sequence4, sequence5, sequence6) {
            for value7 in sequence7 {
                elements.append(IteratedElements(element.value0, element.value1, element.value2, element.value3, element.value4, element.value5, element.value6, value7))
            }
        }

        return elements
    }

    private func generateTestElements<S0, S1, S2, S3, S4, S5, S6, S7, S8>(for sequence0: S0, _ sequence1: S1, _ sequence2: S2, _ sequence3: S3, _ sequence4: S4, _ sequence5: S5, _ sequence6: S6, _ sequence7: S7, _ sequence8: S8) -> [IteratedElements<S0.Element, S1.Element, S2.Element, S3.Element, S4.Element, S5.Element, S6.Element, S7.Element, S8.Element, _Void>] where S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence, S5: Sequence, S6: Sequence, S7: Sequence, S8: Sequence {
        var elements: [IteratedElements<S0.Element, S1.Element, S2.Element, S3.Element, S4.Element, S5.Element, S6.Element, S7.Element, S8.Element, _Void>] = []

        for element in generateTestElements(for: sequence0, sequence1, sequence2, sequence3, sequence4, sequence5, sequence6, sequence7) {
            for value8 in sequence8 {
                elements.append(IteratedElements(element.value0, element.value1, element.value2, element.value3, element.value4, element.value5, element.value6, element.value7, value8))
            }
        }

        return elements
    }

    private func generateTestElements<S0, S1, S2, S3, S4, S5, S6, S7, S8, S9>(for sequence0: S0, _ sequence1: S1, _ sequence2: S2, _ sequence3: S3, _ sequence4: S4, _ sequence5: S5, _ sequence6: S6, _ sequence7: S7, _ sequence8: S8, _ sequence9: S9) -> [IteratedElements<S0.Element, S1.Element, S2.Element, S3.Element, S4.Element, S5.Element, S6.Element, S7.Element, S8.Element, S9.Element>] where S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence, S5: Sequence, S6: Sequence, S7: Sequence, S8: Sequence, S9: Sequence {
        var elements: [IteratedElements<S0.Element, S1.Element, S2.Element, S3.Element, S4.Element, S5.Element, S6.Element, S7.Element, S8.Element, S9.Element>] = []

        for element in generateTestElements(for: sequence0, sequence1, sequence2, sequence3, sequence4, sequence5, sequence6, sequence7, sequence8) {
            for value9 in sequence9 {
                elements.append(IteratedElements(element.value0, element.value1, element.value2, element.value3, element.value4, element.value5, element.value6, element.value7, element.value8, value9))
            }
        }

        return elements
    }
    // swiftlint:enable function_parameter_count
}

// MARK: - _Void Definition

struct _Void: Equatable, Hashable {

    // MARK: Equatable Protocol Requirements

    static func == (lhs: _Void, rhs: _Void) -> Bool { true }

    // MARK: Hashable Protocol Requirements

    func hash(into: inout Hasher) { }
}

// MARK: - IteratedElements Definition

private struct IteratedElements<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> {

    // MARK: Properties

    let value0: T0
    let value1: T1
    let value2: T2
    let value3: T3
    let value4: T4
    let value5: T5
    let value6: T6
    let value7: T7
    let value8: T8
    let value9: T9

    // MARK: Initialization

    init(_ value0: T0, _ value1: T1, _ value2: T2, _ value3: T3, _ value4: T4, _ value5: T5, _ value6: T6, _ value7: T7, _ value8: T8, _ value9: T9) {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
        self.value4 = value4
        self.value5 = value5
        self.value6 = value6
        self.value7 = value7
        self.value8 = value8
        self.value9 = value9
    }
}

// MARK: - IteratedElements Extension

extension IteratedElements where T2 == _Void, T3 == _Void, T4 == _Void, T5 == _Void, T6 == _Void, T7 == _Void, T8 == _Void, T9 == _Void {

    // MARK: Initialization

    init(_ value0: T0, _ value1: T1) {
        self.init(value0, value1, _Void())
    }
}

// MARK: - IteratedElements Extension

extension IteratedElements where T3 == _Void, T4 == _Void, T5 == _Void, T6 == _Void, T7 == _Void, T8 == _Void, T9 == _Void {

    // MARK: Initialization

    init(_ value0: T0, _ value1: T1, _ value2: T2) {
        self.init(value0, value1, value2, _Void())
    }
}

// MARK: - IteratedElements Extension

extension IteratedElements where T4 == _Void, T5 == _Void, T6 == _Void, T7 == _Void, T8 == _Void, T9 == _Void {

    // MARK: Initialization

    init(_ value0: T0, _ value1: T1, _ value2: T2, _ value3: T3) {
        self.init(value0, value1, value2, value3, _Void())
    }
}

// MARK: - IteratedElements Extension

extension IteratedElements where T5 == _Void, T6 == _Void, T7 == _Void, T8 == _Void, T9 == _Void {

    // MARK: Initialization

    init(_ value0: T0, _ value1: T1, _ value2: T2, _ value3: T3, _ value4: T4) {
        self.init(value0, value1, value2, value3, value4, _Void())
    }
}

// MARK: - IteratedElements Extension

extension IteratedElements where T6 == _Void, T7 == _Void, T8 == _Void, T9 == _Void {

    // MARK: Initialization

    init(_ value0: T0, _ value1: T1, _ value2: T2, _ value3: T3, _ value4: T4, _ value5: T5) {
        self.init(value0, value1, value2, value3, value4, value5, _Void())
    }
}

// MARK: - IteratedElements Extension

extension IteratedElements where T7 == _Void, T8 == _Void, T9 == _Void {

    // MARK: Initialization

    init(_ value0: T0, _ value1: T1, _ value2: T2, _ value3: T3, _ value4: T4, _ value5: T5, _ value6: T6) {
        self.init(value0, value1, value2, value3, value4, value5, value6, _Void())
    }
}

// MARK: - IteratedElements Extension

extension IteratedElements where T8 == _Void, T9 == _Void {

    // MARK: Initialization

    init(_ value0: T0, _ value1: T1, _ value2: T2, _ value3: T3, _ value4: T4, _ value5: T5, _ value6: T6, _ value7: T7) {
        self.init(value0, value1, value2, value3, value4, value5, value6, value7, _Void())
    }
}

// MARK: - IteratedElements Extension

extension IteratedElements where T9 == _Void {

    // MARK: Initialization

    init(_ value0: T0, _ value1: T1, _ value2: T2, _ value3: T3, _ value4: T4, _ value5: T5, _ value6: T6, _ value7: T7, _ value8: T8) {
        self.init(value0, value1, value2, value3, value4, value5, value6, value7, value8, _Void())
    }
}

// MARK: - IteratedElements Extension

extension IteratedElements: Equatable where T0: Equatable, T1: Equatable, T2: Equatable, T3: Equatable, T4: Equatable, T5: Equatable, T6: Equatable, T7: Equatable, T8: Equatable, T9: Equatable {

    // MARK: Equatable Protocol Requirements

    static func == (lhs: IteratedElements<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>, rhs: IteratedElements<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>) -> Bool {
        return (lhs.value0 == rhs.value0) &&
               (lhs.value1 == rhs.value1) &&
               (lhs.value2 == rhs.value2) &&
               (lhs.value3 == rhs.value3) &&
               (lhs.value4 == rhs.value4) &&
               (lhs.value5 == rhs.value5) &&
               (lhs.value6 == rhs.value6) &&
               (lhs.value7 == rhs.value7) &&
               (lhs.value8 == rhs.value8) &&
               (lhs.value9 == rhs.value9)
    }
}

// MARK: - IteratedElements Extension

extension IteratedElements: Hashable where T0: Hashable, T1: Hashable, T2: Hashable, T3: Hashable, T4: Hashable, T5: Hashable, T6: Hashable, T7: Hashable, T8: Hashable, T9: Hashable {

    // MARK: Hashable Protocol Requirements

    func hash(into hasher: inout Hasher) {
        hasher.combine(value0)
        hasher.combine(value1)
        hasher.combine(value2)
        hasher.combine(value3)
        hasher.combine(value4)
        hasher.combine(value5)
        hasher.combine(value6)
        hasher.combine(value7)
        hasher.combine(value8)
        hasher.combine(value9)
    }
}
