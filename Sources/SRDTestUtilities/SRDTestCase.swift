//
//  SRDTestCase.swift
//  SRDTestUtilities
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

import ReadWriteLock
import XCTest

#if SWIFT_PACKAGE
@_exported import SRDTestUtilitiesObjC
#endif // #if SWIFT_PACKAGE

// MARK: - SRDTestCase Extension

extension SRDTestCase {

    // MARK: Public Methods

    /**
     Generates a 2D array of elements that represent every possible combination of
     the input elements.

     - Parameters:
       - elements: A sequence of elements in which to combine.

     - Returns: All possible combinations of the input elements.

     As an example, here is what a sample output would look like given the following
     input:

     ```swift
     let input = [1, 2, 3]
     let output = self.allCombinations(of: input)

     // output = [[], [1], [2], [3], [1, 2], [1, 3], [2, 3]]
     ```
     */
    @nonobjc open func allCombinations<S>(of elements: S) -> [[S.Element]] where S: Sequence {
        func recursiveCombine(current: [[S.Element]], remaining: [S.Element]) -> [[S.Element]] {
            guard !remaining.isEmpty else { return current }
            var remaining = remaining

            let element = remaining.removeFirst()
            let combinations = current + current.map { $0 + [element] }

            return recursiveCombine(current: combinations, remaining: remaining)
        }

        return recursiveCombine(current: [[]], remaining: array(for: elements))
    }

    /**
     Generates a 2D array of elements that represent every possible permutation of
     the input elements.

     - Parameters:
       - elements: A sequence of elements in which to permuate.

     - Returns: All possible permutations of the input elements.

     As an example, here is what a sample output would look like given the following
     input:

     ```swift
     let input = [1, 2, 3]
     let output = self.allPermutations(of: input)

     // output = [[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]
     ```
     */
    @nonobjc open func allPermutations<S>(of elements: S) -> [[S.Element]] where S: Sequence {
        func recursivePermute(current: [S.Element], remaining: [S.Element]) -> [[S.Element]] {
            guard !remaining.isEmpty else { return [current] }
            var permutations: [[S.Element]] = []

            for i in 0 ..< remaining.count {
                var remaining = remaining
                let element = remaining.remove(at: i)

                permutations.append(contentsOf: recursivePermute(current: (current + [element]), remaining: remaining))
            }

            return permutations
        }

        return recursivePermute(current: [], remaining: array(for: elements))
    }

    //

    /**
     Generates a 2D array of elements that represent every possible combination of
     the input elements.

     - Parameters:
       - array: An array of elements in which to combine.

     - Returns: All possible combinations of the input elements.

     As an example, here is what a sample output would look like given the following
     input:

     ```objc
     NSArray<NSNumber *> *input = @[@1, @2, @3];
     NSArray<NSNumber *> *output = [self allCombinationsOfObjects:input];

     // output = @[@[], @[@1], @[@2], @[@3], @[@1, @2], @[@1, @3], @[@2, @3]]
     ```
     */
    @objc(allCombinationsOfObjects:)
    open func allCombinations(of array: NSArray) -> NSArray {
        let allCombinations = self.allCombinations(of: array as [AnyObject])
        return allCombinations as NSArray
    }

    /**
     Generates a 2D array of elements that represent every possible permutation of
     the input elements.

     - Parameters:
       - array: An array of elements in which to permuate.

     - Returns: All possible permutations of the input elements.

     As an example, here is what a sample output would look like given the following
     input:

     ```swift
     NSArray<NSNumber *> *input = @[@1, @2, @3];
     NSArray<NSNumber *> *output = [self allCombinationsOfObjects:input];

     // output = @[@[@1, @2, @3], @[@1, @3, @2], @[@2, @1, @3], @[@2, @3, @1], @[@3, @1, @2], @[@3, @2, @1]]
     ```
     */
    @objc(allPermutationsOfObjects:)
    open func allPermutations(of array: NSArray) -> NSArray {
        let allPermutations = self.allPermutations(of: array as [AnyObject])
        return allPermutations as NSArray
    }

    //

    /**
     Iterates over all possible combinations of the input elements.

     - Parameters:
       - elements: A sequence of elements whose combinations will be iterated over.
       - max: An optional maximum number of elements to iterate over. If supplied the
         combinations that are iterated over are selected at random.
       - concurrent: A boolean indicating whether or not to iterate over the
         combinations concurrently. If `true`,
         `DispatchQueue.concurrentPerform(iterations:execute:)` is used for iterating.
       - block: The block used to process each combination. If iterating concurrently
         and an error is thrown, due to the concurrent nature of the iteration this block
         may be subsequently called on other threads prior to the iteration stopping and
         the error being re-thrown.

     - Throws: Any exception thrown from within the `block` parameter.
     */
    @nonobjc open func iterateAllCombinations<S>(of elements: S, max: Int = .max, concurrent: Bool = true, using block: ([S.Element]) throws -> Void) rethrows where S: Sequence {
        let allCombinations = process(self.allCombinations(of: elements), withMax: max)
        try iterate(allCombinations, concurrent: concurrent, using: block)
    }

    /**
     Iterates over all possible permutations of the input elements.

     - Parameters:
       - elements: A sequence of elements whose permutations will be iterated over.
       - max: An optional maximum number of elements to iterate over. If supplied the
         permutations that are iterated over are selected at random.
       - concurrent: A boolean indicating whether or not to iterate over the
         permutations concurrently. If `true`,
         `DispatchQueue.concurrentPerform(iterations:execute:)` is used for iterating.
       - block: The block used to process each permutation. If iterating concurrently
         and an error is thrown, due to the concurrent nature of the iteration this block
         may be subsequently called on other threads prior to the iteration stopping and
         the error being re-thrown.

     - Throws: Any exception thrown from within the `block` parameter.
     */
    @nonobjc open func iterateAllPermutations<S>(of elements: S, max: Int = .max, concurrent: Bool = true, using block: ([S.Element]) throws -> Void) rethrows where S: Sequence {
        let allPermutations = process(self.allPermutations(of: elements), withMax: max)
        try iterate(allPermutations, concurrent: concurrent, using: block)
    }

    //

    /**
     Iterates over all possible combinations of the input elements.

     - Parameters:
       - array: An array of elements whose combinations will be iterated over.
       - max: An optional maximum number of elements to iterate over. If supplied the
         combinations that are iterated over are selected at random.
       - concurrent: A boolean indicating whether or not to iterate over the
         combinations concurrently. If `true`,
         `DispatchQueue.concurrentPerform(iterations:execute:)` is used for iterating.
       - block: The block used to process each combination.
     */
    @objc(iterateAllCombinationsOfArray:maxIterations:concurrent:usingBlock:)
    open func iterateAllCombinations(of array: NSArray, max: Int, concurrent: Bool, using block: (NSArray) -> Void) {
        let allCombinations = process(self.allCombinations(of: array as [AnyObject]), withMax: max)
        self.iterate(allCombinations, concurrent: concurrent) { array in
            block(array as NSArray)
        }
    }

    /**
     Concurrently iterates over all possible combinations of the input elements.

     - Parameters:
       - array: An array of elements whose combinations will be iterated over.
       - block: The block used to process each combination.
     */
    @objc(iterateAllCombinationsOfArray:usingBlock:)
    open func iterateAllCombinations(of array: NSArray, using block: (NSArray) -> Void) {
        self.iterateAllCombinations(of: array, max: .max, concurrent: true, using: block)
    }

    //

    /**
     Iterates over all possible permutations of the input elements.

     - Parameters:
       - array: A sequence of elements whose permutations will be iterated over.
       - max: An optional maximum number of elements to iterate over. If supplied the
         permutations that are iterated over are selected at random.
       - concurrent: A boolean indicating whether or not to iterate over the
         permutations concurrently. If `true`,
         `DispatchQueue.concurrentPerform(iterations:execute:)` is used for iterating.
       - block: The block used to process each permutation.
     */
    @objc(iterateAllPermutationsOfArray:maxIterations:concurrent:usingBlock:)
    open func iterateAllPermutations(of array: NSArray, max: Int, concurrent: Bool, using block: (NSArray) -> Void) {
        let allPermutations = process(self.allPermutations(of: array as [AnyObject]), withMax: max)
        self.iterate(allPermutations, concurrent: concurrent) { array in
            block(array as NSArray)
        }
    }

    /**
     Concurrently iterates over all possible permutations of the input elements.

     - Parameters:
       - array: A sequence of elements whose permutations will be iterated over.
       - block: The block used to process each permutation.
     */
    @objc(iterateAllPermutationsOfArray:usingBlock:)
    open func iterateAllPermutations(of array: NSArray, using block: (NSArray) -> Void) {
        self.iterateAllPermutations(of: array, max: .max, concurrent: true, using: block)
    }

    //

    // swiftlint:disable function_parameter_count
    /**
     Iterates over all possible combinations of two input sequences.

     - Parameters:
       - sequence0: The first sequence of elements to iterate.
       - sequence1: The second sequence of elements to iterate.
       - concurrent: A boolean indicating whether or not to iterate over the
         combinations concurrently. If `true`,
         `DispatchQueue.concurrentPerform(iterations:execute:)` is used for iterating.
       - block: The block used to process each combination. If iterating concurrently
         and an error is thrown, due to the concurrent nature of the iteration this block
         may be subsequently called on other threads prior to the iteration stopping and
         the error being re-thrown.

     - Throws: Any exception thrown from within the `block` parameter.

     As an example, here is what a sample output would look like given the following
     input:

     ```swift
     let input0 = [1, 2, 3]
     let input1 = [4, 5, 6]
     var output: [(Int, Int)] = []

     self.iterateAllCombinations(of: input0, input1, concurrent: false) { element0, element1 in
         output.append((element0, element1))
     }

     // output = [(1, 4), (1, 5), (1, 6), (2, 4), (2, 5), (2, 6), (3, 4), (3, 5), (3, 6)]
     */
    @nonobjc open func iterateAllCombinations<S0, S1>(of sequence0: S0, _ sequence1: S1, concurrent: Bool = true, using block: (S0.Element, S1.Element) throws -> Void) rethrows where S0: Sequence, S1: Sequence {
        try iterate(sequence0, concurrent: concurrent) { element0 in
            try iterate(sequence1, concurrent: concurrent) { element1 in
                try block(element0, element1)
            }
        }
    }

    /**
     Iterates over all possible combinations of three input sequences.

     - Parameters:
       - sequence0: The first sequence of elements to iterate.
       - sequence1: The second sequence of elements to iterate.
       - sequence2: The third sequence of elements to iterate.
       - concurrent: A boolean indicating whether or not to iterate over the
         combinations concurrently. If `true`,
         `DispatchQueue.concurrentPerform(iterations:execute:)` is used for iterating.
       - block: The block used to process each combination. If iterating concurrently
         and an error is thrown, due to the concurrent nature of the iteration this block
         may be subsequently called on other threads prior to the iteration stopping and
         the error being re-thrown.

     - Throws: Any exception thrown from within the `block` parameter.

     See ``iterateAllCombinations(of:_:concurrent:using:)`` for example usage.
     */
    @nonobjc open func iterateAllCombinations<S0, S1, S2>(of sequence0: S0, _ sequence1: S1, _ sequence2: S2, concurrent: Bool = true, using block: (S0.Element, S1.Element, S2.Element) throws -> Void) rethrows where S0: Sequence, S1: Sequence, S2: Sequence {
        try iterateAllCombinations(of: sequence0, sequence1, concurrent: concurrent) { element0, element1 in
            try iterate(sequence2, concurrent: concurrent) { element2 in
                try block(element0, element1, element2)
            }
        }
    }

    /**
     Iterates over all possible combinations of four input sequences.

     - Parameters:
       - sequence0: The first sequence of elements to iterate.
       - sequence1: The second sequence of elements to iterate.
       - sequence2: The third sequence of elements to iterate.
       - sequence3: The fourth sequence of elements to iterate.
       - concurrent: A boolean indicating whether or not to iterate over the
         combinations concurrently. If `true`,
         `DispatchQueue.concurrentPerform(iterations:execute:)` is used for iterating.
       - block: The block used to process each combination. If iterating concurrently
         and an error is thrown, due to the concurrent nature of the iteration this block
         may be subsequently called on other threads prior to the iteration stopping and
         the error being re-thrown.

     - Throws: Any exception thrown from within the `block` parameter.

     See ``iterateAllCombinations(of:_:concurrent:using:)`` for example usage.
     */
    @nonobjc open func iterateAllCombinations<S0, S1, S2, S3>(of sequence0: S0, _ sequence1: S1, _ sequence2: S2, _ sequence3: S3, concurrent: Bool = true, using block: (S0.Element, S1.Element, S2.Element, S3.Element) throws -> Void) rethrows where S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence {
        try iterateAllCombinations(of: sequence0, sequence1, sequence2, concurrent: concurrent) { element0, element1, element2 in
            try iterate(sequence3, concurrent: concurrent) { element3 in
                try block(element0, element1, element2, element3)
            }
        }
    }

    /**
     Iterates over all possible combinations of five input sequences.

     - Parameters:
       - sequence0: The first sequence of elements to iterate.
       - sequence1: The second sequence of elements to iterate.
       - sequence2: The third sequence of elements to iterate.
       - sequence3: The fourth sequence of elements to iterate.
       - sequence4: The fifth sequence of elements to iterate.
       - concurrent: A boolean indicating whether or not to iterate over the
         combinations concurrently. If `true`,
         `DispatchQueue.concurrentPerform(iterations:execute:)` is used for iterating.
       - block: The block used to process each combination. If iterating concurrently
         and an error is thrown, due to the concurrent nature of the iteration this block
         may be subsequently called on other threads prior to the iteration stopping and
         the error being re-thrown.

     - Throws: Any exception thrown from within the `block` parameter.

     See ``iterateAllCombinations(of:_:concurrent:using:)`` for example usage.
     */
    @nonobjc open func iterateAllCombinations<S0, S1, S2, S3, S4>(of sequence0: S0, _ sequence1: S1, _ sequence2: S2, _ sequence3: S3, _ sequence4: S4, concurrent: Bool = true, using block: (S0.Element, S1.Element, S2.Element, S3.Element, S4.Element) throws -> Void) rethrows where S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence {
        try iterateAllCombinations(of: sequence0, sequence1, sequence2, sequence3, concurrent: concurrent) { element0, element1, element2, element3 in
            try iterate(sequence4, concurrent: concurrent) { element4 in
                try block(element0, element1, element2, element3, element4)
            }
        }
    }

    /**
     Iterates over all possible combinations of six input sequences.

     - Parameters:
       - sequence0: The first sequence of elements to iterate.
       - sequence1: The second sequence of elements to iterate.
       - sequence2: The third sequence of elements to iterate.
       - sequence3: The fourth sequence of elements to iterate.
       - sequence4: The fifth sequence of elements to iterate.
       - sequence5: The sixth sequence of elements to iterate.
       - concurrent: A boolean indicating whether or not to iterate over the
         combinations concurrently. If `true`,
         `DispatchQueue.concurrentPerform(iterations:execute:)` is used for iterating.
       - block: The block used to process each combination. If iterating concurrently
         and an error is thrown, due to the concurrent nature of the iteration this block
         may be subsequently called on other threads prior to the iteration stopping and
         the error being re-thrown.

     - Throws: Any exception thrown from within the `block` parameter.

     See ``iterateAllCombinations(of:_:concurrent:using:)`` for example usage.
     */
    @nonobjc open func iterateAllCombinations<S0, S1, S2, S3, S4, S5>(of sequence0: S0, _ sequence1: S1, _ sequence2: S2, _ sequence3: S3, _ sequence4: S4, _ sequence5: S5, concurrent: Bool = true, using block: (S0.Element, S1.Element, S2.Element, S3.Element, S4.Element, S5.Element) throws -> Void) rethrows where S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence, S5: Sequence {
        try iterateAllCombinations(of: sequence0, sequence1, sequence2, sequence3, sequence4, concurrent: concurrent) { element0, element1, element2, element3, element4 in
            try iterate(sequence5, concurrent: concurrent) { element5 in
                try block(element0, element1, element2, element3, element4, element5)
            }
        }
    }

    /**
     Iterates over all possible combinations of seven input sequences.

     - Parameters:
       - sequence0: The first sequence of elements to iterate.
       - sequence1: The second sequence of elements to iterate.
       - sequence2: The third sequence of elements to iterate.
       - sequence3: The fourth sequence of elements to iterate.
       - sequence4: The fifth sequence of elements to iterate.
       - sequence5: The sixth sequence of elements to iterate.
       - sequence6: The seventh sequence of elements to iterate.
       - concurrent: A boolean indicating whether or not to iterate over the
         combinations concurrently. If `true`,
         `DispatchQueue.concurrentPerform(iterations:execute:)` is used for iterating.
       - block: The block used to process each combination. If iterating concurrently
         and an error is thrown, due to the concurrent nature of the iteration this block
         may be subsequently called on other threads prior to the iteration stopping and
         the error being re-thrown.

     - Throws: Any exception thrown from within the `block` parameter.

     See ``iterateAllCombinations(of:_:concurrent:using:)`` for example usage.
     */
    @nonobjc open func iterateAllCombinations<S0, S1, S2, S3, S4, S5, S6>(of sequence0: S0, _ sequence1: S1, _ sequence2: S2, _ sequence3: S3, _ sequence4: S4, _ sequence5: S5, _ sequence6: S6, concurrent: Bool = true, using block: (S0.Element, S1.Element, S2.Element, S3.Element, S4.Element, S5.Element, S6.Element) throws -> Void) rethrows where S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence, S5: Sequence, S6: Sequence {
        try iterateAllCombinations(of: sequence0, sequence1, sequence2, sequence3, sequence4, sequence5, concurrent: concurrent) { element0, element1, element2, element3, element4, element5 in
            try iterate(sequence6, concurrent: concurrent) { element6 in
                try block(element0, element1, element2, element3, element4, element5, element6)
            }
        }
    }

    /**
     Iterates over all possible combinations of eight input sequences.

     - Parameters:
       - sequence0: The first sequence of elements to iterate.
       - sequence1: The second sequence of elements to iterate.
       - sequence2: The third sequence of elements to iterate.
       - sequence3: The fourth sequence of elements to iterate.
       - sequence4: The fifth sequence of elements to iterate.
       - sequence5: The sixth sequence of elements to iterate.
       - sequence6: The seventh sequence of elements to iterate.
       - sequence7: The eighth sequence of elements to iterate.
       - concurrent: A boolean indicating whether or not to iterate over the
         combinations concurrently. If `true`,
         `DispatchQueue.concurrentPerform(iterations:execute:)` is used for iterating.
       - block: The block used to process each combination. If iterating concurrently
         and an error is thrown, due to the concurrent nature of the iteration this block
         may be subsequently called on other threads prior to the iteration stopping and
         the error being re-thrown.

     - Throws: Any exception thrown from within the `block` parameter.

     See ``iterateAllCombinations(of:_:concurrent:using:)`` for example usage.
     */
    @nonobjc open func iterateAllCombinations<S0, S1, S2, S3, S4, S5, S6, S7>(of sequence0: S0, _ sequence1: S1, _ sequence2: S2, _ sequence3: S3, _ sequence4: S4, _ sequence5: S5, _ sequence6: S6, _ sequence7: S7, concurrent: Bool = true, using block: (S0.Element, S1.Element, S2.Element, S3.Element, S4.Element, S5.Element, S6.Element, S7.Element) throws -> Void) rethrows where S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence, S5: Sequence, S6: Sequence, S7: Sequence {
        try iterateAllCombinations(of: sequence0, sequence1, sequence2, sequence3, sequence4, sequence5, sequence6, concurrent: concurrent) { element0, element1, element2, element3, element4, element5, element6 in
            try iterate(sequence7, concurrent: concurrent) { element7 in
                try block(element0, element1, element2, element3, element4, element5, element6, element7)
            }
        }
    }

    /**
     Iterates over all possible combinations of nine input sequences.

     - Parameters:
       - sequence0: The first sequence of elements to iterate.
       - sequence1: The second sequence of elements to iterate.
       - sequence2: The third sequence of elements to iterate.
       - sequence3: The fourth sequence of elements to iterate.
       - sequence4: The fifth sequence of elements to iterate.
       - sequence5: The sixth sequence of elements to iterate.
       - sequence6: The seventh sequence of elements to iterate.
       - sequence7: The eighth sequence of elements to iterate.
       - sequence8: The ninth sequence of elements to iterate.
       - concurrent: A boolean indicating whether or not to iterate over the
         combinations concurrently. If `true`,
         `DispatchQueue.concurrentPerform(iterations:execute:)` is used for iterating.
       - block: The block used to process each combination. If iterating concurrently
         and an error is thrown, due to the concurrent nature of the iteration this block
         may be subsequently called on other threads prior to the iteration stopping and
         the error being re-thrown.

     - Throws: Any exception thrown from within the `block` parameter.

     See ``iterateAllCombinations(of:_:concurrent:using:)`` for example usage.
     */
    @nonobjc open func iterateAllCombinations<S0, S1, S2, S3, S4, S5, S6, S7, S8>(of sequence0: S0, _ sequence1: S1, _ sequence2: S2, _ sequence3: S3, _ sequence4: S4, _ sequence5: S5, _ sequence6: S6, _ sequence7: S7, _ sequence8: S8, concurrent: Bool = true, using block: (S0.Element, S1.Element, S2.Element, S3.Element, S4.Element, S5.Element, S6.Element, S7.Element, S8.Element) throws -> Void) rethrows where S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence, S5: Sequence, S6: Sequence, S7: Sequence, S8: Sequence {
        try iterateAllCombinations(of: sequence0, sequence1, sequence2, sequence3, sequence4, sequence5, sequence6, sequence7, concurrent: concurrent) { element0, element1, element2, element3, element4, element5, element6, element7 in
            try iterate(sequence8, concurrent: concurrent) { element8 in
                try block(element0, element1, element2, element3, element4, element5, element6, element7, element8)
            }
        }
    }

    /**
     Iterates over all possible combinations of ten input sequences.

     - Parameters:
       - sequence0: The first sequence of elements to iterate.
       - sequence1: The second sequence of elements to iterate.
       - sequence2: The third sequence of elements to iterate.
       - sequence3: The fourth sequence of elements to iterate.
       - sequence4: The fifth sequence of elements to iterate.
       - sequence5: The sixth sequence of elements to iterate.
       - sequence6: The seventh sequence of elements to iterate.
       - sequence7: The eighth sequence of elements to iterate.
       - sequence8: The ninth sequence of elements to iterate.
       - sequence9: The tenth sequence of elements to iterate.
       - concurrent: A boolean indicating whether or not to iterate over the
         combinations concurrently. If `true`,
         `DispatchQueue.concurrentPerform(iterations:execute:)` is used for iterating.
       - block: The block used to process each combination. If iterating concurrently
         and an error is thrown, due to the concurrent nature of the iteration this block
         may be subsequently called on other threads prior to the iteration stopping and
         the error being re-thrown.

     - Throws: Any exception thrown from within the `block` parameter.

     See ``iterateAllCombinations(of:_:concurrent:using:)`` for example usage.
     */
    @nonobjc open func iterateAllCombinations<S0, S1, S2, S3, S4, S5, S6, S7, S8, S9>(of sequence0: S0, _ sequence1: S1, _ sequence2: S2, _ sequence3: S3, _ sequence4: S4, _ sequence5: S5, _ sequence6: S6, _ sequence7: S7, _ sequence8: S8, _ sequence9: S9, concurrent: Bool = true, using block: (S0.Element, S1.Element, S2.Element, S3.Element, S4.Element, S5.Element, S6.Element, S7.Element, S8.Element, S9.Element) throws -> Void) rethrows where S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence, S5: Sequence, S6: Sequence, S7: Sequence, S8: Sequence, S9: Sequence {
        try iterateAllCombinations(of: sequence0, sequence1, sequence2, sequence3, sequence4, sequence5, sequence6, sequence7, sequence8, concurrent: concurrent) { element0, element1, element2, element3, element4, element5, element6, element7, element8 in
            try iterate(sequence9, concurrent: concurrent) { element9 in
                try block(element0, element1, element2, element3, element4, element5, element6, element7, element8, element9)
            }
        }
    }
    // swiftlint:enable function_parameter_count

    //

    /**
     Splits a given input string into an array of words. The input is split on
     logical boundaries using the rules for strings formatted in
     ``SRDStringCase/camel``, ``SRDStringCase/pascal``, ``SRDStringCase/snake``, or
     ``SRDStringCase/kebab`` case, or any combination thereof.

     - Parameters:
       - string: The input string to split up.

     - Returns: An array of words split from the input string.

     Words are formed by first splitting the string using "\_" and "-" as separators.
     The words are then divided further using the capitalization rules laid out in
     the ``SRDStringCase/camel``, ``SRDStringCase/pascal`` string cases. The case of
     the words is unchanged from the input string.
     */
    @objc open func splitStringIntoWords(_ string: String) -> [String] {
        let words = string.components(separatedBy: CharacterSet(charactersIn: "_- ")).filter { !$0.isEmpty }

        return words.reduce(into: []) { words, word in
            var word = word
            while !word.isEmpty {
                if let index = word.firstIndex(where: { $0.isLowercase }) {
                    let numberOfLeadingUppercaseCharacters = max(0, word.distance(from: word.startIndex, to: index) - 1)

                    if numberOfLeadingUppercaseCharacters > 0 {
                        words.append(String(word[word.startIndex ..< word.index(word.startIndex, offsetBy: numberOfLeadingUppercaseCharacters)]))
                        word = String(word.dropFirst(numberOfLeadingUppercaseCharacters))
                    } else {
                        if let indexOfNextUppercaseCharacter = word.indices.first(where: { $0 != word.startIndex && word[$0].isUppercase }) {
                            words.append(String(word[word.startIndex ..< indexOfNextUppercaseCharacter]))
                            word = String(word[indexOfNextUppercaseCharacter...])
                        } else {
                            words.append(word)
                            word = ""
                        }
                    }
                } else {
                    words.append(word)
                    word = ""
                }
            }
        }
    }

    /**
     Converts a given input string from its current case (or cases) to a given
     ``SRDStringCase``.

     - Parameters:
       - string: The string whose case is to be converted.
       - stringCase: The case to convert the input string to.

     - Returns: The input string converted to the new string case.

     This method converts the input string by first splitting the string into an
     array of words using the ``splitStringIntoWords(_:)`` method, and then
     recombines those words using the rules of the specified string case.
     */
    @objc(convertString:stringCase:)
    open func convert(_ string: String, to stringCase: SRDStringCase) -> String {
        let words = splitStringIntoWords(string)
        let result: String

        switch stringCase {
        case .camel: result = (words.first ?? "").lowercased() + words.dropFirst().map { uppercaseFirstCharacter(of: $0) }.joined()
        case .pascal: result = words.map { uppercaseFirstCharacter(of: $0) }.joined()
        case .snake: result = words.map { $0.lowercased() }.joined(separator: "_")
        case .kebab: result = words.map { $0.lowercased() }.joined(separator: "-")
        }

        return result
     }

    //

    /**
     Finds and removes a given search string in another string.

     - Parameters:
       - searchString: The string to search for and remove.
       - string: The string in which to search for the search string.
       - options: Options to use when searching the input string. This defaults to
         `[]`.
       - locale: An optional locale to use when searching the input string. This
         defaults to `nil`.
       - recordIssueOnFail: A flag that determines whether or not an `XCTIssue` will be
         recorded if the search string is not found within the input string. This
         defaults to `true`.
       - failureStringDescription: An optional string to include in the description of
         the `XCTIssue` if one is raised. This will only be included if it is non-empty.
         This defaults to an empty string.

     - Returns: `true` if the search string was found and removed from the input
       string, `false` otherwise.
     */
    @discardableResult
    @nonobjc open func findAndReplace(_ searchString: String, in string: inout String, options: String.CompareOptions = [], locale: Locale? = nil, recordIssueOnFail: Bool = true, failureStringDescription: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Bool {
        guard let range = string.range(of: searchString, options: options, locale: locale) else {
            if recordIssueOnFail {
                let failureStringDescription = failureStringDescription()
                let message = "Expected to find \"\(searchString)\" in\(failureStringDescription.isEmpty ? "" : " \(failureStringDescription)"): \"\(string)\""
                let issue = XCTIssue(type: .assertionFailure,
                                     compactDescription: "SRDTestCase.findAndReplace(_:in:options:locale:) failed: \(message)",
                                     sourceCodeContext: XCTSourceCodeContext(location: XCTSourceCodeLocation(filePath: file, lineNumber: line)))

                self.record(issue)
            }
            return false
        }

        string.replaceSubrange(range, with: "")
        return true
    }

    // MARK: Private Methods

    @inline(__always)
    private func array<S>(for elements: S) -> [S.Element] where S: Sequence {
        return (elements as? [S.Element]) ?? Array(elements)
    }

    //

    private func uppercaseFirstCharacter(of string: String) -> String {
        let result: String

        if (string.count == 1) || string.allSatisfy({ $0.isUppercase }) {
            result = string.uppercased()
        } else {
            result = string[string.startIndex].uppercased() + string[string.index(after: string.startIndex)...].lowercased()
        }

        return result
    }

    //

    private func process<C>(_ collection: C, withMax max: Int) -> [C.Element] where C: Collection {
        let max = (max >= 1) ? max : .max
        let result: [C.Element]

        if max < collection.count {
            result = collection.shuffled()
                               .enumerated()
                               .filter { $0.offset < max }
                               .map { $0.element }
        } else {
            result = array(for: collection)
        }

        return result
    }

    private func iterate<S>(_ elements: S, concurrent: Bool = true, using block: (S.Element) throws -> Void) rethrows where S: Sequence {
        if concurrent {
            func rethrowing(_ error: Error?) throws {
                guard let error = error else { return }
                throw error
            }

            var thrownError: Error?
            let lock = ReadWriteLock()

            withoutActuallyEscaping(block) { block in
                let elements = array(for: elements)

                DispatchQueue.concurrentPerform(iterations: elements.count) { i in
                    guard lock.acquireReadLock({ thrownError == nil }) else { return }

                    do {
                        try block(elements[i])
                    } catch let error {
                        lock.acquireWriteLock {
                            if thrownError == nil {
                                thrownError = error
                            }
                        }
                    }
                }
            }

            try rethrowing(thrownError)
        } else {
            for element in elements {
                try block(element)
            }
        }
    }
}
