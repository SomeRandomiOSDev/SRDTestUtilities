//
//  SRDTestCaseObjCTests.m
//  SRDTestUtilitiesObjCTests
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

@import SRDTestUtilities;
@import XCTest;

#undef pascal

// MARK: - SRDTestCaseObjCTests Interface

@interface SRDTestCaseObjCTests: SRDTestCase

@property (nonatomic, strong, readonly) NSArray<NSString *> *testArray;
@property (nonatomic, strong, readonly) NSArray<NSArray<NSString *> *> *testCombinations;
@property (nonatomic, strong, readonly) NSArray<NSArray<NSString *> *> *testPermutations;

@end

// MARK: - SRDTestCaseObjCTests Implementation

@implementation SRDTestCaseObjCTests {
    NSArray<NSString *> *_testArray;
    NSArray<NSArray<NSString *> *> *_testCombinations;
    NSArray<NSArray<NSString *> *> *_testPermutations;
    dispatch_once_t _onceToken;
}

// MARK: Property Synthesis

@dynamic testArray, testCombinations, testPermutations;

- (NSArray<NSString *> *)testArray {
    dispatch_once(&_onceToken, ^{ [self initializeTestData]; });
    return _testArray;
}

- (NSArray<NSArray<NSString *> *> *)testCombinations {
    dispatch_once(&_onceToken, ^{ [self initializeTestData]; });
    return _testCombinations;
}

- (NSArray<NSArray<NSString *> *> *)testPermutations {
    dispatch_once(&_onceToken, ^{ [self initializeTestData]; });
    return _testPermutations;
}

// MARK: Test Methods

- (void)testAllCombinations {
    NSArray * const combinations = [self allCombinationsOfObjects:self.testArray];

    XCTAssertTrue([[NSSet setWithArray:combinations] isEqualToSet:[NSSet setWithArray:self.testCombinations]]);
}

- (void)testAllPermutations {
    NSArray * const permutations = [self allPermutationsOfObjects:self.testArray];

    XCTAssertTrue([[NSSet setWithArray:permutations] isEqualToSet:[NSSet setWithArray:self.testPermutations]]);
}

//

- (void)testIterateAllCombinations {
    dispatch_queue_t const queue = dispatch_queue_create("", DISPATCH_QUEUE_SERIAL);

    for (NSNumber *concurrentValue in @[@0, @1, @2]) {
        const BOOL concurrent = concurrentValue.boolValue;

        [XCTContext runActivityNamed:[NSString stringWithFormat:@"Concurrent: %@", concurrent ? @"true" : @"false"] block:^(id _) {
            NSMutableArray * const combinations = [NSMutableArray array];
            void (^ const block)(NSArray *) = ^(NSArray *combination) {
                if (concurrent) {
                    dispatch_sync(queue, ^{ [combinations addObject:combination]; });
                } else {
                    [combinations addObject:combination];
                }
            };

            if (concurrentValue.integerValue == 2) {
                [self iterateAllCombinationsOfArray:self.testArray usingBlock:block];
            } else {
                [self iterateAllCombinationsOfArray:self.testArray maxIterations:NSIntegerMax concurrent:concurrent usingBlock:block];
            }

            if (concurrent) {
                XCTAssertTrue([[NSSet setWithArray:combinations] isEqualToSet:[NSSet setWithArray:self.testCombinations]]);
            } else {
                XCTAssertTrue([combinations isEqualToArray:self.testCombinations]);
            }
        }];
    }
}

- (void)testIterateAllCombinationsWithMax {
    NSArray * const allCombinations = [self allCombinationsOfObjects:self.testArray];
    dispatch_queue_t const queue = dispatch_queue_create("", DISPATCH_QUEUE_SERIAL);

    for (NSNumber *concurrentValue in @[@NO, @YES]) {
        const BOOL concurrent = concurrentValue.boolValue;

        [XCTContext runActivityNamed:[NSString stringWithFormat:@"Concurrent: %@", concurrent ? @"true" : @"false"] block:^(id _) {
            for (NSInteger max = 0; max < allCombinations.count; ++max) {
                [XCTContext runActivityNamed:[NSString stringWithFormat:@"Max: %lu", (unsigned long)max] block:^(id _) {
                    NSMutableArray * const combinations = [NSMutableArray array];

                    [self iterateAllCombinationsOfArray:self.testArray maxIterations:max concurrent:concurrent usingBlock:^(NSArray *combination) {
                        if (concurrent) {
                            dispatch_sync(queue, ^{ [combinations addObject:combination]; });
                        } else {
                            [combinations addObject:combination];
                        }
                    }];

                    if (max == 0 || max == allCombinations.count) {
                        XCTAssertTrue([[NSSet setWithArray:combinations] isEqualToSet:[NSSet setWithArray:self.testCombinations]]);
                    } else {
                        XCTAssertTrue([[NSSet setWithArray:combinations] isSubsetOfSet:[NSSet setWithArray:self.testCombinations]]);
                    }
                }];
            }
        }];
    }
}

//

- (void)testIterateAllPermutations {
    dispatch_queue_t const queue = dispatch_queue_create("", DISPATCH_QUEUE_SERIAL);

    for (NSNumber *concurrentValue in @[@0, @1, @2]) {
        const BOOL concurrent = concurrentValue.boolValue;

        [XCTContext runActivityNamed:[NSString stringWithFormat:@"Concurrent: %@", concurrent ? @"true" : @"false"] block:^(id _) {
            NSMutableArray * const permutations = [NSMutableArray array];
            void (^const block)(NSArray *) = ^(NSArray *permutation) {
                if (concurrent) {
                    dispatch_sync(queue, ^{ [permutations addObject:permutation]; });
                } else {
                    [permutations addObject:permutation];
                }
            };

            if (concurrentValue.integerValue == 2) {
                [self iterateAllPermutationsOfArray:self.testArray usingBlock:block];
            } else {
                [self iterateAllPermutationsOfArray:self.testArray maxIterations:NSIntegerMax concurrent:concurrent usingBlock:block];
            }

            if (concurrent) {
                XCTAssertTrue([[NSSet setWithArray:permutations] isEqualToSet:[NSSet setWithArray:self.testPermutations]]);
            } else {
                XCTAssertTrue([permutations isEqualToArray:self.testPermutations]);
            }
        }];
    }
}

- (void)testIterateAllPermutationsWithMax {
    NSArray * const allPermutations = [self allPermutationsOfObjects:self.testArray];
    dispatch_queue_t const queue = dispatch_queue_create("", DISPATCH_QUEUE_SERIAL);

    for (NSNumber *concurrentValue in @[@NO, @YES]) {
        const BOOL concurrent = concurrentValue.boolValue;

        [XCTContext runActivityNamed:[NSString stringWithFormat:@"Concurrent: %@", concurrent ? @"true" : @"false"] block:^(id _) {
            for (NSInteger max = 0; max < allPermutations.count; ++max) {
                [XCTContext runActivityNamed:[NSString stringWithFormat:@"Max: %lu", (unsigned long)max] block:^(id _) {
                    NSMutableArray * const permutations = [NSMutableArray array];

                    [self iterateAllPermutationsOfArray:self.testArray maxIterations:max concurrent:concurrent usingBlock:^(NSArray *permutation) {
                        if (concurrent) {
                            dispatch_sync(queue, ^{ [permutations addObject:permutation]; });
                        } else {
                            [permutations addObject:permutation];
                        }
                    }];

                    if (max == 0 || max == allPermutations.count) {
                        XCTAssertTrue([[NSSet setWithArray:permutations] isEqualToSet:[NSSet setWithArray:self.testPermutations]]);
                    } else {
                        XCTAssertTrue([[NSSet setWithArray:permutations] isSubsetOfSet:[NSSet setWithArray:self.testPermutations]]);
                    }
                }];
            }
        }];
    }
}

//

- (void)testSplitCamelCaseString {
    NSString * const string = @"thisIsACamelCaseString";
    NSArray<NSString *> * const words = @[@"this", @"Is", @"A", @"Camel", @"Case", @"String"];

    XCTAssertTrue([[self splitStringIntoWords:string] isEqualToArray:words]);
}

- (void)testSplitPascalCaseString {
    NSString * const string = @"ThisIsAPascalCaseString";
    NSArray<NSString *> * const words = @[@"This", @"Is", @"A", @"Pascal", @"Case", @"String"];

    XCTAssertTrue([[self splitStringIntoWords:string] isEqualToArray:words]);
}

- (void)testSplitSnakeCaseString {
    NSString * const string = @"this_is_a_snake_case_string";
    NSArray<NSString *> * const words = @[@"this", @"is", @"a", @"snake", @"case", @"string"];

    XCTAssertTrue([[self splitStringIntoWords:string] isEqualToArray:words]);
}

- (void)testSplitSnakeCaseStringWithDuplicateSepatators {
    NSString * const string = @"this_is__a_snake___case__string";
    NSArray<NSString *> * const words = @[@"this", @"is", @"a", @"snake", @"case", @"string"];

    XCTAssertTrue([[self splitStringIntoWords:string] isEqualToArray:words]);
}

- (void)testSplitKebabCaseString {
    NSString * const string = @"this-is-a-kebab-case-string";
    NSArray<NSString *> * const words = @[@"this", @"is", @"a", @"kebab", @"case", @"string"];

    XCTAssertTrue([[self splitStringIntoWords:string] isEqualToArray:words]);
}

- (void)testSplitKebabCaseStringWithDuplicateSepatators {
    NSString * const string = @"this--is-a----kebab--case---string";
    NSArray<NSString *> * const words = @[@"this", @"is", @"a", @"kebab", @"case", @"string"];

    XCTAssertTrue([[self splitStringIntoWords:string] isEqualToArray:words]);
}

//

- (void)testSplitSnakeAndCamelCaseString {
    NSString * const string = @"thisIs_aSnake_andCamel_caseString";
    NSArray<NSString *> * const words = @[@"this", @"Is", @"a", @"Snake", @"and", @"Camel", @"case", @"String"];

    XCTAssertTrue([[self splitStringIntoWords:string] isEqualToArray:words]);
}

- (void)testSplitKebabAndCamelCaseString {
    NSString * const string = @"thisIs-aKebab-andCamel-caseString";
    NSArray<NSString *> * const words = @[@"this", @"Is", @"a", @"Kebab", @"and", @"Camel", @"case", @"String"];

    XCTAssertTrue([[self splitStringIntoWords:string] isEqualToArray:words]);
}

- (void)testSplitSnakeAndPascalCaseString {
    NSString * const string = @"ThisIs_ASnake_AndPascal_CaseString";
    NSArray<NSString *> * const words = @[@"This", @"Is", @"A", @"Snake", @"And", @"Pascal", @"Case", @"String"];

    XCTAssertTrue([[self splitStringIntoWords:string] isEqualToArray:words]);
}

- (void)testSplitKebabAndPascalCaseString {
    NSString * const string = @"ThisIs-AKebab-AndPascal-CaseString";
    NSArray<NSString *> * const words = @[@"This", @"Is", @"A", @"Kebab", @"And", @"Pascal", @"Case", @"String"];

    XCTAssertTrue([[self splitStringIntoWords:string] isEqualToArray:words]);
}

//

- (void)testSplitEdgeCaseStrings {
    [XCTContext runActivityNamed:@"\"URLEncoding\"" block:^(id _) {
        NSString * const string = @"URLEncoding";
        NSArray<NSString *> * const words = @[@"URL", @"Encoding"];

        XCTAssertTrue([[self splitStringIntoWords:string] isEqualToArray:words]);
    }];
    [XCTContext runActivityNamed:@"\"NSURL\"" block:^(id _) {
        NSString * const string = @"NSURL";
        NSArray<NSString *> * const words = @[@"NSURL"];

        XCTAssertTrue([[self splitStringIntoWords:string] isEqualToArray:words]);
    }];
    [XCTContext runActivityNamed:@"\"lowercasestring\"" block:^(id _) {
        NSString * const string = @"lowercasestring";
        NSArray<NSString *> * const words = @[@"lowercasestring"];

        XCTAssertTrue([[self splitStringIntoWords:string] isEqualToArray:words]);
    }];
    [XCTContext runActivityNamed:@"\"\"" block:^(id _) {
        NSString * const string = @"";

        XCTAssertEqual([self splitStringIntoWords:string].count, 0);
    }];
}

- (void)testSplitSnakeKebabStringsWithDuplicateSeparators {
    for (NSUInteger i = 2; i <= 10; ++i) {
        NSString * const string = [@"" stringByPaddingToLength:i withString:@"-" startingAtIndex:0];

        [XCTContext runActivityNamed:[NSString stringWithFormat:@"\"%@\"", string] block:^(id _) {
            XCTAssertEqual([self splitStringIntoWords:string].count, 0);
        }];
    }

    for (NSUInteger i = 2; i <= 10; ++i) {
        NSString * const string = [@"" stringByPaddingToLength:i withString:@"_" startingAtIndex:0];

        [XCTContext runActivityNamed:[NSString stringWithFormat:@"\"%@\"", string] block:^(id _) {
            XCTAssertEqual([self splitStringIntoWords:string].count, 0);
        }];
    }
}

//

- (void)testConvertStringBetweenCases {
    NSString * const camelCase = @"thisIsAString";
    NSString * const pascalCase = @"ThisIsAString";
    NSString * const snakeCase = @"this_is_a_string";
    NSString * const kebabCase = @"this-is-a-string";

    [self runConvertBetweenStringCaseTestsWithSourceString:camelCase sourceCase:SRDStringCaseCamel camel:camelCase pascal:pascalCase snake:snakeCase kebab:kebabCase];
    [self runConvertBetweenStringCaseTestsWithSourceString:pascalCase sourceCase:SRDStringCasePascal camel:camelCase pascal:pascalCase snake:snakeCase kebab:kebabCase];
    [self runConvertBetweenStringCaseTestsWithSourceString:snakeCase sourceCase:SRDStringCaseSnake camel:camelCase pascal:pascalCase snake:snakeCase kebab:kebabCase];
    [self runConvertBetweenStringCaseTestsWithSourceString:kebabCase sourceCase:SRDStringCaseKebab camel:camelCase pascal:pascalCase snake:snakeCase kebab:kebabCase];
}

- (void)testConvertEdgeCaseStrings {
    [XCTContext runActivityNamed:@"\"URLEncoding\"" block:^(id _) {
        NSString * const source = @"URLEncoding";
        NSString * const camelCase = @"urlEncoding";
        NSString * const pascalCase = @"URLEncoding";
        NSString * const snakeCase = @"url_encoding";
        NSString * const kebabCase = @"url-encoding";

        [self runConvertBetweenStringCaseTestsWithSourceString:source sourceCase:(SRDStringCase)-1 camel:camelCase pascal:pascalCase snake:snakeCase kebab:kebabCase];
    }];
    [XCTContext runActivityNamed:@"\"NSURL\"" block:^(id _) {
        NSString * const source = @"NSURL";
        NSString * const camelCase = @"nsurl";
        NSString * const pascalCase = @"NSURL";
        NSString * const snakeCase = @"nsurl";
        NSString * const kebabCase = @"nsurl";

        [self runConvertBetweenStringCaseTestsWithSourceString:source sourceCase:(SRDStringCase)-1 camel:camelCase pascal:pascalCase snake:snakeCase kebab:kebabCase];
    }];
    [XCTContext runActivityNamed:@"\"lowercasestring\"" block:^(id _) {
        NSString * const source = @"lowercasestring";
        NSString * const camelCase = @"lowercasestring";
        NSString * const pascalCase = @"Lowercasestring";
        NSString * const snakeCase = @"lowercasestring";
        NSString * const kebabCase = @"lowercasestring";

        [self runConvertBetweenStringCaseTestsWithSourceString:source sourceCase:(SRDStringCase)-1 camel:camelCase pascal:pascalCase snake:snakeCase kebab:kebabCase];
    }];
    [XCTContext runActivityNamed:@"\"\"" block:^(id _) {
        NSString * const source = @"";

        [self runConvertBetweenStringCaseTestsWithSourceString:source sourceCase:(SRDStringCase)-1 camel:source pascal:source snake:source kebab:source];
    }];
}

- (void)testConvertSnakeKebabStringsWithDuplicateSeparators {
    for (NSUInteger i = 2; i <= 10; ++i) {
        NSString * const source = [@"" stringByPaddingToLength:i withString:@"-" startingAtIndex:0];

        [XCTContext runActivityNamed:[NSString stringWithFormat:@"\"%@\"", source] block:^(id _) {
            [self runConvertBetweenStringCaseTestsWithSourceString:source sourceCase:(SRDStringCase)-1 camel:@"" pascal:@"" snake:@"" kebab:@""];
        }];
    }

    for (NSUInteger i = 2; i <= 10; ++i) {
        NSString * const source = [@"" stringByPaddingToLength:i withString:@"_" startingAtIndex:0];

        [XCTContext runActivityNamed:[NSString stringWithFormat:@"\"%@\"", source] block:^(id _) {
            [self runConvertBetweenStringCaseTestsWithSourceString:source sourceCase:(SRDStringCase)-1 camel:@"" pascal:@"" snake:@"" kebab:@""];
        }];
    }
}

// MARK: Private Methods

- (void)runConvertBetweenStringCaseTestsWithSourceString:(NSString *)source sourceCase:(SRDStringCase)sourceCase camel:(NSString *)camel pascal:(NSString *)pascal snake:(NSString *)snake kebab:(NSString *)kebab {
    NSDictionary<NSNumber *, NSString *> * const caseDescriptions = @{
        @(SRDStringCaseCamel): @"Camel",
        @(SRDStringCasePascal): @"Pascal",
        @(SRDStringCaseSnake): @"Snake",
        @(SRDStringCaseKebab): @"Kebab"
    };
    NSDictionary<NSNumber *, NSString *> * const cases = @{
        @(SRDStringCaseCamel): camel,
        @(SRDStringCasePascal): pascal,
        @(SRDStringCaseSnake): snake,
        @(SRDStringCaseKebab): kebab
    };

    NSArray<NSNumber *> * const allStringCases = @[@(SRDStringCaseCamel), @(SRDStringCasePascal), @(SRDStringCaseSnake), @(SRDStringCaseKebab)];

    NSString *sourceCaseDescription = nil;
    if (![allStringCases containsObject:@(sourceCase)] || !((sourceCaseDescription = caseDescriptions[@(sourceCase)]))) {
        sourceCaseDescription = @"Mixed";
    }

    for (NSNumber *stringCase in allStringCases) {
        [XCTContext runActivityNamed:[NSString stringWithFormat:@"%@ -> %@", sourceCaseDescription, caseDescriptions[stringCase]] block:^(id _) {
            XCTAssertTrue([[self convertString:source stringCase:(SRDStringCase)stringCase.integerValue] isEqualToString:cases[stringCase]]);
        }];
    }
}

- (void)initializeTestData {
    _testArray = @[@"1", @"2", @"3", @"4"];

    _testCombinations = @[
        @[],
        @[@"1"],
        @[@"2"], @[@"1", @"2"],
        @[@"3"], @[@"1", @"3"], @[@"2", @"3"], @[@"1", @"2", @"3"],
        @[@"4"], @[@"1", @"4"], @[@"2", @"4"], @[@"1", @"2", @"4"], @[@"3", @"4"], @[@"1", @"3", @"4"], @[@"2", @"3", @"4"], @[@"1", @"2", @"3", @"4"]
    ];

    _testPermutations = @[
        @[@"1", @"2", @"3", @"4"], @[@"1", @"2", @"4", @"3"], @[@"1", @"3", @"2", @"4"], @[@"1", @"3", @"4", @"2"], @[@"1", @"4", @"2", @"3"], @[@"1", @"4", @"3", @"2"],
        @[@"2", @"1", @"3", @"4"], @[@"2", @"1", @"4", @"3"], @[@"2", @"3", @"1", @"4"], @[@"2", @"3", @"4", @"1"], @[@"2", @"4", @"1", @"3"], @[@"2", @"4", @"3", @"1"],
        @[@"3", @"1", @"2", @"4"], @[@"3", @"1", @"4", @"2"], @[@"3", @"2", @"1", @"4"], @[@"3", @"2", @"4", @"1"], @[@"3", @"4", @"1", @"2"], @[@"3", @"4", @"2", @"1"],
        @[@"4", @"1", @"2", @"3"], @[@"4", @"1", @"3", @"2"], @[@"4", @"2", @"1", @"3"], @[@"4", @"2", @"3", @"1"], @[@"4", @"3", @"1", @"2"], @[@"4", @"3", @"2", @"1"]
    ];
}

@end
