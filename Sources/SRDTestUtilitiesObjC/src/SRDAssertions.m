//
//  SRDAssertions.m
//  SRDTestUtilities
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SRDAssertions.h"

// MARK: - Private Function Declarations

static void __SRDAssertAttributedStringContainsAttributeAndValues(NSAttributedString *attributedString, NSAttributedStringKey attributeKey, id attributeValue, id __nullable alternateAttributeValue, NSRange range, const char *filePath, NSUInteger lineNumber, const char *function);

// MARK: - Public Function Definitions

void _SRDAssertAttributedStringContainsAttribute(NSAttributedString *attributedString, NSAttributedStringKey attribute, NSRange range, const char *filePath, NSUInteger lineNumber) {
    if (range.location != NSNotFound && range.length > 0) {
        NSRange attributeRange;
        id value = [attributedString attribute:attribute atIndex:range.location longestEffectiveRange:&attributeRange inRange:NSMakeRange(0, attributedString.length)];

        if (value == nil || !NSEqualRanges(range, attributeRange)) {
            _XCTPreformattedFailureHandler(nil, YES, [NSString stringWithUTF8String:filePath], lineNumber, [NSString stringWithFormat:@"SRDAssertAttributedStringContainsAttribute failed: Expected to find attribute (%@) in range: \"%@\" of attributed string: \"%@\"", attribute, NSStringFromRange(range), attributedString], @"");
        }
    } else {
        __block id value = nil;

        [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSAttributedStringKey, id> *attributes, NSRange _, BOOL *stop) {
            value = attributes[attribute];
            *stop = (value != nil);
        }];

        if (value == nil) {
            _XCTPreformattedFailureHandler(nil, YES, [NSString stringWithUTF8String:filePath], lineNumber, [NSString stringWithFormat:@"SRDAssertAttributedStringContainsAttribute failed: Expected to find attribute (%@) in attributed string: \"%@\"", attribute, attributedString.debugDescription], @"");
        }
    }
}

void _SRDAssertAttributedStringContainsAttributeAndValue(NSAttributedString *attributedString, NSAttributedStringKey attributeKey, id attributeValue, NSRange range, const char *filePath, NSUInteger lineNumber) {
    __SRDAssertAttributedStringContainsAttributeAndValues(attributedString, attributeKey, attributeValue, nil, range, filePath, lineNumber, "SRDAssertAttributedStringContainsAttributeAndValue");
}

void _SRDAssertAttributedStringContainsAttributeAndValues(NSAttributedString *attributedString, NSAttributedStringKey attributeKey, id attributeValue, id __nullable alternateAttributeValue, NSRange range, const char *filePath, NSUInteger lineNumber) {
    __SRDAssertAttributedStringContainsAttributeAndValues(attributedString, attributeKey, attributeValue, alternateAttributeValue, range, filePath, lineNumber, "SRDAssertAttributedStringContainsAttributeAndValues");
}

void _SRDAssertAttributedStringNotContainsAttribute(NSAttributedString *attributedString, NSAttributedStringKey attribute, NSRange range, const char *filePath, NSUInteger lineNumber) {
    __block id value = nil;

    [attributedString enumerateAttributesInRange:(range.location != NSNotFound && range.length > 0) ? range : NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSAttributedStringKey, id> *attributes, NSRange _, BOOL *stop) {
        value = attributes[attribute];
        *stop = (value != nil);
    }];

    if (value != nil) {
        NSString *description;
        if (range.location != NSNotFound && range.length > 0) {
            description = [NSString stringWithFormat:@"Expected to not find attribute (%@) in range: \"%@\" of attributed string: \"%@\"", attribute, NSStringFromRange(range), attributedString.debugDescription];
        } else {
            description = [NSString stringWithFormat:@"Expected to not find attribute (%@) in attributed string: \"%@\"", attribute, attributedString.debugDescription];
        }

        _XCTPreformattedFailureHandler(nil, YES, [NSString stringWithUTF8String:filePath], lineNumber, [NSString stringWithFormat:@"SRDAssertAttributedStringNotContainsAttribute failed: %@", description], @"");
    }
}

//

void _SRDRegisterUnexpectedFailure(const char *filePath, NSUInteger lineNumber, NSString *message) {
    _XCTPreformattedFailureHandler(nil, NO, [NSString stringWithUTF8String:filePath], lineNumber, message, @"");
}

// MARK: Private Function Definitions

static void __SRDAssertAttributedStringContainsAttributeAndValues(NSAttributedString *attributedString, NSAttributedStringKey attributeKey, id attributeValue, id __nullable alternateAttributeValue, NSRange range, const char *filePath, NSUInteger lineNumber, const char *function) {
    if (range.location != NSNotFound && range.length > 0) {
        NSRange attributeRange;
        id value = [attributedString attribute:attributeKey atIndex:range.location longestEffectiveRange:&attributeRange inRange:NSMakeRange(0, attributedString.length)];

        if (value == nil || !NSEqualRanges(range, attributeRange) || !([value isEqual:attributeValue] || (alternateAttributeValue != nil && [value isEqual:alternateAttributeValue]))) {
            _XCTPreformattedFailureHandler(nil, YES, [NSString stringWithUTF8String:filePath], lineNumber, [NSString stringWithFormat:@"%s failed: Expected to find attribute (%@, \"%@\" or \"%@\") in range: \"%@\" of attributed string: \"%@\"", function, attributeKey, [attributeValue description], [alternateAttributeValue description], NSStringFromRange(range), attributedString], @"");
        }
    } else {
        __block id value = nil;

        [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSAttributedStringKey, id> *attributes, NSRange _, BOOL *stop) {
            value = attributes[attributeKey];
            *stop = (value != nil);
        }];

        if (value == nil || !([value isEqual:attributeValue] || (alternateAttributeValue != nil && [value isEqual:alternateAttributeValue]))) {
            _XCTPreformattedFailureHandler(nil, YES, [NSString stringWithUTF8String:filePath], lineNumber, [NSString stringWithFormat:@"%s failed: Expected to find attribute (%@, \"%@\" or \"%@\") in attributed string: \"%@\"", function, attributeKey, [attributeValue description], [alternateAttributeValue description], attributedString], @"");
        }
    }
}
