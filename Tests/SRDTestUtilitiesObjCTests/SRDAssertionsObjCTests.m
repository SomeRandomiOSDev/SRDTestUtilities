//
//  SRDAssertionsObjCTests.m
//  SRDTestUtilities
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

@import SRDTestUtilities;
@import XCTest;

#if defined(SWIFT_PACKAGE)
@import SRDTestUtilitiesObjC;
#endif // #if defined(SWIFT_PACKAGE)

#if __has_include(<UIKit/UIKit.h>)
#   import <UIKit/UIKit.h>
#elif __has_include(<AppKit/AppKit.h>)
#   import <AppKit/AppKit.h>
#endif // #if __canImport(<UIKit/UIKit.h>)

// MARK: - SRDAssertionsObjCTests Interface

@interface SRDAssertionsObjCTests: XCTestCase

@property (nonatomic, strong, readonly) NSArray<NSAttributedStringKey> *attributes;
@property (nonatomic, strong, readonly) XCTExpectedFailureOptions *defaultOptions;
@property (nonatomic, strong, readonly) XCTExpectedFailureOptions *exceptionOptions;

@end

// MARK: - SRDAssertionsObjCTests Implementations

@implementation SRDAssertionsObjCTests {
    NSArray<NSAttributedStringKey> *_attributes;
    XCTExpectedFailureOptions *_defaultOptions;
    XCTExpectedFailureOptions *_exceptionOptions;
    dispatch_once_t _onceToken;
}

// MARK: Property Synthesis

@dynamic attributes, defaultOptions, exceptionOptions;

- (NSArray<NSAttributedStringKey> *)attributes {
    dispatch_once(&_onceToken, ^{ [self initializeTestData]; });
    return _attributes;
}

- (XCTExpectedFailureOptions *)defaultOptions {
    dispatch_once(&_onceToken, ^{ [self initializeTestData]; });
    return _defaultOptions;
}

- (XCTExpectedFailureOptions *)exceptionOptions {
    dispatch_once(&_onceToken, ^{ [self initializeTestData]; });
    return _exceptionOptions;
}

// MARK: Test Methods

- (void)testAttributedStringContainsAttribute {
    id const attributeValue = @0;

    for (NSAttributedStringKey attributeKey in self.attributes) {
        [XCTContext runActivityNamed:[NSString stringWithFormat:@"Attribute: %@", attributeKey] block:^(id _) {
            NSMutableAttributedString * const attributedString = [[NSMutableAttributedString alloc] initWithString:@"The quick brown fox jumps over the lazy dog"];
            const NSRange attributeRange = [self randomRangeForAttributedString:attributedString];

            [attributedString addAttribute:attributeKey value:attributeValue range:attributeRange];

            //

            [XCTContext runActivityNamed:@"No Range" block:^(id _) {
                SRDAssertAttributedStringContainsAttribute(attributedString, attributeKey);
            }];

            [XCTContext runActivityNamed:@"Specific Range" block:^(id _) {
                SRDAssertAttributedStringContainsAttribute(attributedString, attributeKey, attributeRange);
            }];
        }];
    }
}

- (void)testAttributedStringContainsAttributeFailureCases {
    id const attributeValue = @0;

    for (NSAttributedStringKey attributeKey in self.attributes) {
        [XCTContext runActivityNamed:[NSString stringWithFormat:@"Attribute: %@", attributeKey] block:^(id _) {
            NSMutableAttributedString * const attributedString = [[NSMutableAttributedString alloc] initWithString:@"The quick brown fox jumps over the lazy dog"];
            const NSRange attributeRange = [self randomRangeForAttributedString:attributedString];

            [attributedString addAttribute:attributeKey value:attributeValue range:attributeRange];

            //

            NSAttributedStringKey const otherAttribute = [self randomAttributeAsideFromAttribute:attributeKey];
            const NSRange otherRange = [self randomRangeDisjointFromRange:attributeRange upperBound:attributedString.length];

            [XCTContext runActivityNamed:@"No Range" block:^(id _) {
                XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.defaultOptions, ^{
                    SRDAssertAttributedStringContainsAttribute(attributedString, otherAttribute);
                });
            }];

            [XCTContext runActivityNamed:@"Specific Range" block:^(id _) {
                [XCTContext runActivityNamed:@"Different Range" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.defaultOptions, ^{
                        SRDAssertAttributedStringContainsAttribute(attributedString, attributeKey, otherRange);
                    });
                }];

                [XCTContext runActivityNamed:@"Different Attribute Key" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.defaultOptions, ^{
                        SRDAssertAttributedStringContainsAttribute(attributedString, otherAttribute, attributeRange);
                    });
                }];
            }];

            [XCTContext runActivityNamed:@"Thrown Exception" block:^(id _) {
                [XCTContext runActivityNamed:@"Attributed String Expression Throws" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.exceptionOptions, ^{
                        SRDAssertAttributedStringContainsAttribute([self throwingAttributedStringExpression], attributeKey);
                        SRDAssertAttributedStringContainsAttribute([self throwingAttributedStringExpression], attributeKey, attributeRange);
                    });
                }];

                [XCTContext runActivityNamed:@"Attribute Key Expression Throws" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.exceptionOptions, ^{
                        SRDAssertAttributedStringContainsAttribute(attributedString, [self throwingAttributeKeyExpression]);
                        SRDAssertAttributedStringContainsAttribute(attributedString, [self throwingAttributeKeyExpression], attributeRange);
                    });
                }];

                [XCTContext runActivityNamed:@"Range Expression Throws" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.exceptionOptions, ^{
                        SRDAssertAttributedStringContainsAttribute(attributedString, attributeKey, [self throwingRangeExpression]);
                    });
                }];
            }];
        }];
    }
}

//

- (void)testAttributedStringContainsAttributeAndValue {
    id const attributeValue = @0;

    for (NSAttributedStringKey attributeKey in self.attributes) {
        [XCTContext runActivityNamed:[NSString stringWithFormat:@"Attribute: %@", attributeKey] block:^(id _) {
            NSMutableAttributedString * const attributedString = [[NSMutableAttributedString alloc] initWithString:@"The quick brown fox jumps over the lazy dog"];
            const NSRange attributeRange = [self randomRangeForAttributedString:attributedString];

            [attributedString addAttribute:attributeKey value:attributeValue range:attributeRange];

            //

            [XCTContext runActivityNamed:@"No Range" block:^(id _) {
                SRDAssertAttributedStringContainsAttributeAndValue(attributedString, attributeKey, attributeValue);
            }];

            [XCTContext runActivityNamed:@"Specific Range" block:^(id _) {
                SRDAssertAttributedStringContainsAttributeAndValue(attributedString, attributeKey, attributeValue, attributeRange);
            }];
        }];
    }
}

- (void)testAttributedStringContainsAttributeAndValueFailureCases {
    id const attributeValue = @0;
    id const otherAttributeValue = @1;

    for (NSAttributedStringKey attributeKey in self.attributes) {
        [XCTContext runActivityNamed:[NSString stringWithFormat:@"Attribute: %@", attributeKey] block:^(id _) {
            NSMutableAttributedString * const attributedString = [[NSMutableAttributedString alloc] initWithString:@"The quick brown fox jumps over the lazy dog"];
            const NSRange attributeRange = [self randomRangeForAttributedString:attributedString];

            [attributedString addAttribute:attributeKey value:attributeValue range:attributeRange];

            //

            NSAttributedStringKey const otherAttribute = [self randomAttributeAsideFromAttribute:attributeKey];
            const NSRange otherRange = [self randomRangeDisjointFromRange:attributeRange upperBound:attributedString.length];

            [XCTContext runActivityNamed:@"No Range" block:^(id _) {
                [XCTContext runActivityNamed:@"Different Attribute Key" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.defaultOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValue(attributedString, otherAttribute, attributeValue);
                    });
                }];

                [XCTContext runActivityNamed:@"Different Attribute Value" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.defaultOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValue(attributedString, attributeKey, otherAttributeValue);
                    });
                }];
            }];

            [XCTContext runActivityNamed:@"Specific Range" block:^(id _) {
                [XCTContext runActivityNamed:@"Different Range" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.defaultOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValue(attributedString, attributeKey, attributeValue, otherRange);
                    });
                }];

                [XCTContext runActivityNamed:@"Different Attribute Key" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.defaultOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValue(attributedString, otherAttribute, attributeValue, attributeRange);
                    });
                }];

                [XCTContext runActivityNamed:@"Different Attribute Value" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.defaultOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValue(attributedString, attributeKey, otherAttributeValue, attributeRange);
                    });
                }];
            }];

            [XCTContext runActivityNamed:@"Thrown Exception" block:^(id _) {
                [XCTContext runActivityNamed:@"Attributed String Expression Throws" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.exceptionOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValue([self throwingAttributedStringExpression], attributeKey, attributeValue);
                        SRDAssertAttributedStringContainsAttributeAndValue([self throwingAttributedStringExpression], attributeKey, attributeValue, attributeRange);
                    });
                }];

                [XCTContext runActivityNamed:@"Attribute Key Expression Throws" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.exceptionOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValue(attributedString, [self throwingAttributeKeyExpression], attributeValue);
                        SRDAssertAttributedStringContainsAttributeAndValue(attributedString, [self throwingAttributeKeyExpression], attributeValue, attributeRange);
                    });
                }];

                [XCTContext runActivityNamed:@"Attribute Value Expression Throws" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.exceptionOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValue(attributedString, attributeKey, [self throwingAttributeValueExpression]);
                        SRDAssertAttributedStringContainsAttributeAndValue(attributedString, attributeKey, [self throwingAttributeValueExpression], attributeRange);
                    });
                }];

                [XCTContext runActivityNamed:@"Range Expression Throws" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.exceptionOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValue(attributedString, attributeKey, attributeValue, [self throwingRangeExpression]);
                    });
                }];
            }];
        }];
    }
}

//

- (void)testAttributedStringContainsAttributeAndValues {
    id const attributeValue = @0;
    id const otherAttributeValue = @1;

    for (NSAttributedStringKey attributeKey in self.attributes) {
        [XCTContext runActivityNamed:[NSString stringWithFormat:@"Attribute: %@", attributeKey] block:^(id _) {
            NSMutableAttributedString * const attributedString = [[NSMutableAttributedString alloc] initWithString:@"The quick brown fox jumps over the lazy dog"];
            const NSRange attributeRange = [self randomRangeForAttributedString:attributedString];

            [attributedString addAttribute:attributeKey value:attributeValue range:attributeRange];

            //

            [XCTContext runActivityNamed:@"No Range" block:^(id _) {
                SRDAssertAttributedStringContainsAttributeAndValues(attributedString, attributeKey, attributeValue, nil);
                SRDAssertAttributedStringContainsAttributeAndValues(attributedString, attributeKey, attributeValue, otherAttributeValue);
                SRDAssertAttributedStringContainsAttributeAndValues(attributedString, attributeKey, otherAttributeValue, attributeValue);
            }];

            [XCTContext runActivityNamed:@"Specific Range" block:^(id _) {
                SRDAssertAttributedStringContainsAttributeAndValues(attributedString, attributeKey, attributeValue, nil, attributeRange);
                SRDAssertAttributedStringContainsAttributeAndValues(attributedString, attributeKey, attributeValue, otherAttributeValue, attributeRange);
                SRDAssertAttributedStringContainsAttributeAndValues(attributedString, attributeKey, otherAttributeValue, attributeValue, attributeRange);
            }];
        }];
    }
}

- (void)testAttributedStringContainsAttributeAndValuesFailureCasess {
    id const attributeValue = @0;
    id const otherAttributeValue = @1;

    for (NSAttributedStringKey attributeKey in self.attributes) {
        [XCTContext runActivityNamed:[NSString stringWithFormat:@"Attribute: %@", attributeKey] block:^(id _) {
            NSMutableAttributedString * const attributedString = [[NSMutableAttributedString alloc] initWithString:@"The quick brown fox jumps over the lazy dog"];
            const NSRange attributeRange = [self randomRangeForAttributedString:attributedString];

            [attributedString addAttribute:attributeKey value:attributeValue range:attributeRange];

            //

            NSAttributedStringKey const otherAttribute = [self randomAttributeAsideFromAttribute:attributeKey];
            const NSRange otherRange = [self randomRangeDisjointFromRange:attributeRange upperBound:attributedString.length];

            [XCTContext runActivityNamed:@"No Range" block:^(id _) {
                [XCTContext runActivityNamed:@"Different Attribute Key" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.defaultOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValues(attributedString, otherAttribute, attributeValue, otherAttributeValue);
                        SRDAssertAttributedStringContainsAttributeAndValues(attributedString, otherAttribute, otherAttributeValue, attributeValue);
                    });
                }];

                [XCTContext runActivityNamed:@"Different Attribute Value" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.defaultOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValues(attributedString, attributeKey, otherAttributeValue, otherAttributeValue);
                    });
                }];
            }];

            [XCTContext runActivityNamed:@"Specific Range" block:^(id _) {
                [XCTContext runActivityNamed:@"Different Range" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.defaultOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValues(attributedString, attributeKey, attributeValue, otherAttributeValue, otherRange);
                        SRDAssertAttributedStringContainsAttributeAndValues(attributedString, attributeKey, otherAttributeValue, attributeValue, otherRange);
                    });
                }];

                [XCTContext runActivityNamed:@"Different Attribute Key" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.defaultOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValues(attributedString, otherAttribute, attributeValue, otherAttributeValue, attributeRange);
                        SRDAssertAttributedStringContainsAttributeAndValues(attributedString, otherAttribute, otherAttributeValue, attributeValue, attributeRange);
                    });
                }];

                [XCTContext runActivityNamed:@"Different Attribute Value" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.defaultOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValues(attributedString, attributeKey, otherAttributeValue, otherAttributeValue, attributeRange);
                    });
                }];
            }];

            [XCTContext runActivityNamed:@"Thrown Exception" block:^(id _) {
                [XCTContext runActivityNamed:@"Attributed String Expression Throws" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.exceptionOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValues([self throwingAttributedStringExpression], attributeKey, attributeValue, otherAttributeValue);
                        SRDAssertAttributedStringContainsAttributeAndValues([self throwingAttributedStringExpression], attributeKey, attributeValue, otherAttributeValue, attributeRange);
                    });
                }];

                [XCTContext runActivityNamed:@"Attribute Key Expression Throws" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.exceptionOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValues(attributedString, [self throwingAttributeKeyExpression], attributeValue, otherAttributeValue);
                        SRDAssertAttributedStringContainsAttributeAndValues(attributedString, [self throwingAttributeKeyExpression], attributeValue, otherAttributeValue, attributeRange);
                    });
                }];

                [XCTContext runActivityNamed:@"Attribute Value Expression Throws" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.exceptionOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValues(attributedString, attributeKey, [self throwingAttributeValueExpression], otherAttributeValue);
                        SRDAssertAttributedStringContainsAttributeAndValues(attributedString, attributeKey, [self throwingAttributeValueExpression], otherAttributeValue, attributeRange);
                    });
                }];

                [XCTContext runActivityNamed:@"Alternate Attribute Value Expression Throws" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.exceptionOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValues(attributedString, attributeKey, attributeValue, [self throwingAttributeValueExpression]);
                        SRDAssertAttributedStringContainsAttributeAndValues(attributedString, attributeKey, attributeValue, [self throwingAttributeValueExpression], attributeRange);
                    });
                }];

                [XCTContext runActivityNamed:@"Range Expression Throws" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.exceptionOptions, ^{
                        SRDAssertAttributedStringContainsAttributeAndValues(attributedString, attributeKey, attributeValue, otherAttributeValue, [self throwingRangeExpression]);
                    });
                }];
            }];
        }];
    }
}

//

- (void)testAttributedStringNotContainsAttribute {
    id const attributeValue = @0;

    for (NSAttributedStringKey attributeKey in self.attributes) {
        [XCTContext runActivityNamed:[NSString stringWithFormat:@"Attribute: %@", attributeKey] block:^(id _) {
            NSMutableAttributedString * const attributedString = [[NSMutableAttributedString alloc] initWithString:@"The quick brown fox jumps over the lazy dog"];
            const NSRange attributeRange = [self randomRangeForAttributedString:attributedString];

            [attributedString addAttribute:attributeKey value:attributeValue range:attributeRange];

            //

            NSAttributedStringKey const otherAttribute = [self randomAttributeAsideFromAttribute:attributeKey];
            const NSRange otherRange = [self randomRangeDisjointFromRange:attributeRange upperBound:attributedString.length];

            [XCTContext runActivityNamed:@"No Range" block:^(id _) {
                SRDAssertAttributedStringNotContainsAttribute(attributedString, otherAttribute);
            }];

            [XCTContext runActivityNamed:@"Specific Range" block:^(id _) {
                SRDAssertAttributedStringNotContainsAttribute(attributedString, attributeKey, otherRange);
            }];
        }];
    }
}

- (void)testAttributedStringNotContainsAttributeFailureCases {
    id const attributeValue = @0;

    for (NSAttributedStringKey attributeKey in self.attributes) {
        [XCTContext runActivityNamed:[NSString stringWithFormat:@"Attribute: %@", attributeKey] block:^(id _) {
            NSMutableAttributedString * const attributedString = [[NSMutableAttributedString alloc] initWithString:@"The quick brown fox jumps over the lazy dog"];
            const NSRange attributeRange = [self randomRangeForAttributedString:attributedString];

            [attributedString addAttribute:attributeKey value:attributeValue range:attributeRange];

            //

            [XCTContext runActivityNamed:@"No Range" block:^(id _) {
                XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.defaultOptions, ^{
                    SRDAssertAttributedStringNotContainsAttribute(attributedString, attributeKey);
                });
            }];

            [XCTContext runActivityNamed:@"Specific Range" block:^(id _) {
                XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.defaultOptions, ^{
                    SRDAssertAttributedStringNotContainsAttribute(attributedString, attributeKey, attributeRange);
                });
            }];

            [XCTContext runActivityNamed:@"Thrown Exception" block:^(id _) {
                [XCTContext runActivityNamed:@"Attributed String Expression Throws" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.exceptionOptions, ^{
                        SRDAssertAttributedStringNotContainsAttribute([self throwingAttributedStringExpression], attributeKey);
                        SRDAssertAttributedStringNotContainsAttribute([self throwingAttributedStringExpression], attributeKey, attributeRange);
                    });
                }];

                [XCTContext runActivityNamed:@"Attribute Key Expression Throws" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.exceptionOptions, ^{
                        SRDAssertAttributedStringNotContainsAttribute(attributedString, [self throwingAttributeKeyExpression]);
                        SRDAssertAttributedStringNotContainsAttribute(attributedString, [self throwingAttributeKeyExpression], attributeRange);
                    });
                }];

                [XCTContext runActivityNamed:@"Range Expression Throws" block:^(id _) {
                    XCTExpectFailureWithOptionsInBlock(@"This unit test tests to confirm that an issue is raised", self.exceptionOptions, ^{
                        SRDAssertAttributedStringNotContainsAttribute(attributedString, attributeKey, [self throwingRangeExpression]);
                    });
                }];
            }];
        }];
    }
}

// MARK: - Private Methods

- (NSRange)randomRangeForAttributedString:(NSAttributedString *)attributedString {
    const uint32_t stringLength = (uint32_t)attributedString.length;
    const uint32_t location = arc4random_uniform(stringLength >> 1) + (stringLength >> 2) - 1;
    const uint32_t length = arc4random_uniform((stringLength >> 2) - 1) + 1;

    return NSMakeRange(location, length);
}

- (NSRange)randomRangeDisjointFromRange:(NSRange)range upperBound:(NSUInteger)upperBound {
    BOOL above = (arc4random() % 2) ? YES : NO;
    NSUInteger location, length;

    if (above && NSMaxRange(range) >= (upperBound - 1))
        above = !above;

    if (above) {
        location = arc4random_uniform((uint32_t)(upperBound - NSMaxRange(range) - 1)) + NSMaxRange(range);
        length = arc4random_uniform((uint32_t)(upperBound - location - 1)) + 1;
    } else {
        location = arc4random_uniform((uint32_t)(range.location - 1));
        length = arc4random_uniform((uint32_t)(range.location - location - 1)) + 1;
    }

    return NSMakeRange(location, length);
}

- (NSAttributedStringKey)randomAttributeAsideFromAttribute:(NSAttributedStringKey)attr {
    NSAttributedStringKey attribute = nil;

    do {
        attribute = self.attributes[arc4random_uniform((uint32_t)self.attributes.count - 1)];
    } while (attribute == attr);

    return attribute;
}

//

- (NSAttributedString *)throwingAttributedStringExpression {
    @throw [NSException exceptionWithName:(NSExceptionName)NSStringFromClass(NSException.class) reason:[NSUUID UUID].UUIDString userInfo:nil];
}

- (NSAttributedStringKey)throwingAttributeKeyExpression {
    @throw [NSException exceptionWithName:(NSExceptionName)NSStringFromClass(NSException.class) reason:[NSUUID UUID].UUIDString userInfo:nil];
}

- (id)throwingAttributeValueExpression {
    @throw [NSException exceptionWithName:(NSExceptionName)NSStringFromClass(NSException.class) reason:[NSUUID UUID].UUIDString userInfo:nil];
}

- (NSRange)throwingRangeExpression {
    @throw [NSException exceptionWithName:(NSExceptionName)NSStringFromClass(NSException.class) reason:[NSUUID UUID].UUIDString userInfo:nil];
}

//

- (void)initializeTestData {
    _attributes = @[
        NSAttachmentAttributeName, NSBackgroundColorAttributeName, NSBaselineOffsetAttributeName,
        NSExpansionAttributeName, NSFontAttributeName, NSForegroundColorAttributeName,
        NSKernAttributeName, NSLigatureAttributeName, NSLinkAttributeName,
        NSObliquenessAttributeName, NSParagraphStyleAttributeName, NSShadowAttributeName,
        NSStrikethroughColorAttributeName, NSStrikethroughStyleAttributeName, NSStrokeColorAttributeName,
        NSStrokeWidthAttributeName, NSTextEffectAttributeName, NSUnderlineColorAttributeName,
        NSUnderlineStyleAttributeName, NSVerticalGlyphFormAttributeName
    ];

    _defaultOptions = [[XCTExpectedFailureOptions alloc] init];
    _defaultOptions.issueMatcher = ^BOOL (XCTIssue *issue) {
        return issue.type == XCTIssueTypeAssertionFailure;
    };

    _exceptionOptions = [[XCTExpectedFailureOptions alloc] init];
    _exceptionOptions.issueMatcher = ^BOOL (XCTIssue *issue) {
        return issue.type == XCTIssueTypeUncaughtException;
    };
}

@end
