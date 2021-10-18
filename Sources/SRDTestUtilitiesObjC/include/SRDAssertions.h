//
//  SRDAssertions.h
//  SRDTestUtilities
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: Function Declarations

/**
 A function for asserting that a given @p NSAttributedString contains a
 particular attribute.

 @param attributedString The attributed string over which the assertion is made.
 @param attribute The attribute that the @p attributedString is asserted to
                  contain.
 @param range The @a exact range in which the @p attribute is expected to appear
              in the @p attributedString. If @p range.location is @p NSNotFound
              or if @p range.length is @p 0, the @p attribute can appear anywhere
              in the @p attributedString to fulfill the assertion.

 This function should generally not be called directly. Instead, call the
 @p SRDAssertAttributedStringContainsAttribute macro which allows for the
 @p range parameter to be excluded and automatically sets the hidden
 @p filePath and @p lineNumber parameters.
 */
void _SRDAssertAttributedStringContainsAttribute(NSAttributedString *attributedString, NSAttributedStringKey attribute, NSRange range, const char *filePath, NSUInteger lineNumber) NS_REFINED_FOR_SWIFT;

/**
 A function for asserting that a given @p NSAttributedString contains a
 particular value for a given attribute.

 @param attributedString The attributed string over which the assertion is made.
 @param attributeKey The attribute that the @p attributedString is asserted to
                     contain.
 @param attributeValue The value that the @p attributedString is asserted to
                       contain for the given @p attributeKey. The values are
                       compared using the @p -isEqual: method.
 @param range The @a exact range in which the @p attributeKey & @p attributeValue
              is expected to appear in the @p attributedString. If
              @p range.location is @p NSNotFound or if @p range.length is @p 0,
              the @p attributeKey can appear anywhere in the @p attributedString
              to fulfill the assertion.

 This function should generally not be called directly. Instead, call the
 @p SRDAssertAttributedStringContainsAttributeAndValue macro which allows for the
 @p range parameter to be excluded and automatically sets the hidden
 @p filePath and @p lineNumber parameters.
 */
void _SRDAssertAttributedStringContainsAttributeAndValue(NSAttributedString *attributedString, NSAttributedStringKey attributeKey, id attributeValue, NSRange range, const char *filePath, NSUInteger lineNumber) NS_REFINED_FOR_SWIFT;

/**
 A function for asserting that a given @p NSAttributedString contains a
 particular value for a given attribute.

 @param attributedString The attributed string over which the assertion is made.
 @param attributeKey The attribute that the @p attributedString is asserted to
                     contain.
 @param attributeValue The value that the @p attributedString is asserted to
                       contain for the given @p attributeKey. The values are
                       compared using the @p -isEqual: method.
 @param alternateAttributeValue An alternate value to compare against the value
                                of @p attribute in @p attributedString if it was
                                already determined that the value was not equal
                                to @p attributeValue. Setting this parameter to
                                @p nil causes this function to behave identically
                                to @p _SRDAssertAttributedStringContainsAttributeAndValue
 @param range The @a exact range in which the @p attributeKey & @p attributeValue
              is expected to appear in the @p attributedString. If
              @p range.location is @p NSNotFound or if @p range.length is @p 0,
              the @p attributeKey can appear anywhere in the @p attributedString
              to fulfill the assertion.

 This function should generally not be called directly. Instead, call the
 @p SRDAssertAttributedStringContainsAttributeAndValues macro which allows for
 the @p range parameter to be excluded and automatically sets the hidden
 @p filePath and @p lineNumber parameters.
 */
void _SRDAssertAttributedStringContainsAttributeAndValues(NSAttributedString *attributedString, NSAttributedStringKey attributeKey, id attributeValue, id __nullable alternateAttributeValue, NSRange range, const char *filePath, NSUInteger lineNumber) NS_REFINED_FOR_SWIFT;

/**
 A function for asserting that a given @p NSAttributedString does not contain
 a particular attribute.

 @param attributedString The attributed string over which the assertion is made.
 @param attribute The attribute that the @p attributedString is asserted not to
                  contain.
 @param range The range in which the @p attribute is expected not to appear in
              the @p attributedString. If @p range.location is @p NSNotFound or
              if @p range.length is @p 0, the @p attribute must not appear
              anywhere in the @p attributedString to fulfill the assertion.

 This function should generally not be called directly. Instead, call the
 @p SRDAssertAttributedStringNotContainsAttribute macro which allows for the
 @p range parameter to be excluded and automatically sets the hidden
 @p filePath and @p lineNumber parameters.
 */
void _SRDAssertAttributedStringNotContainsAttribute(NSAttributedString *attributedString, NSAttributedStringKey attribute, NSRange range, const char *filePath, NSUInteger lineNumber) NS_REFINED_FOR_SWIFT;

/**
 An alias for the @p _XCTPreformattedFailureHandler function from @p XCTest. This
 exposed only for use within this module and should not be used directly.
 */
void _SRDRegisterUnexpectedFailure(const char *, NSUInteger, NSString *) NS_REFINED_FOR_SWIFT;

// MARK: Macro Definitions

#if !defined(SRDAssertAttributedStringContainsAttribute)

#define __SRD_FUNC_GET_MACRO(_1, _2, _3, _4, _5, NAME, ...) NAME

#define __SRD_CATCH_EXCEPTIONS(function, expression, ...)                                                                           \
({                                                                                                                                  \
    @try {                                                                                                                          \
        expression __VA_ARGS__;                                                                                                     \
    }                                                                                                                               \
    @catch (_XCTestCaseInterruptionException *interruption) { [interruption raise]; }                                               \
    @catch (NSException *exception) {                                                                                               \
        _SRDRegisterUnexpectedFailure(__FILE__, __LINE__, [NSString stringWithFormat:@"%s failed: throwing \\\"%@\\\"",             \
                                                           function, [exception reason]]);                                          \
    }                                                                                                                               \
    @catch (...) {                                                                                                                  \
        _SRDRegisterUnexpectedFailure(__FILE__, __LINE__, [NSString stringWithFormat:@"%s failed: throwing an unknown exception",   \
                                                           function]);                                                              \
    }                                                                                                                               \
})

//

// SRDAssertAttributedStringContainsAttribute(NSAttributedString *, NSAttributedStringKey)
// SRDAssertAttributedStringContainsAttribute(NSAttributedString *, NSAttributedStringKey, NSRange)
#define SRDAssertAttributedStringContainsAttribute(...) \
    __SRD_CATCH_EXCEPTIONS("SRDAssertAttributedStringContainsAttribute", __SRD_FUNC_GET_MACRO(0, 0, __VA_ARGS__, _SRDAssertAttributedStringContainsAttribute, _SRDAssertAttributedStringContainsAttributeNoRange)( __VA_ARGS__, __FILE__, __LINE__ ))

// SRDAssertAttributedStringContainsAttributeAndValue(NSAttributedString *, NSAttributedStringKey, id)
// SRDAssertAttributedStringContainsAttributeAndValue(NSAttributedString *, NSAttributedStringKey, id, NSRange)
#define SRDAssertAttributedStringContainsAttributeAndValue(...) \
    __SRD_CATCH_EXCEPTIONS("SRDAssertAttributedStringContainsAttributeAndValue", __SRD_FUNC_GET_MACRO(0, __VA_ARGS__, _SRDAssertAttributedStringContainsAttributeAndValue, _SRDAssertAttributedStringContainsAttributeAndValueNoRange)( __VA_ARGS__, __FILE__, __LINE__ ))

// SRDAssertAttributedStringContainsAttributeAndValues(NSAttributedString *, NSAttributedStringKey, id, id __nullable)
// SRDAssertAttributedStringContainsAttributeAndValues(NSAttributedString *, NSAttributedStringKey, id, id __nullable, NSRange)
#define SRDAssertAttributedStringContainsAttributeAndValues(...) \
    __SRD_CATCH_EXCEPTIONS("SRDAssertAttributedStringContainsAttributeAndValues", __SRD_FUNC_GET_MACRO(__VA_ARGS__, _SRDAssertAttributedStringContainsAttributeAndValues, _SRDAssertAttributedStringContainsAttributeAndValuesNoRange)( __VA_ARGS__, __FILE__, __LINE__ ))

// SRDAssertAttributedStringNotContainsAttribute(NSAttributedString *, NSAttributedStringKey)
// SRDAssertAttributedStringNotContainsAttribute(NSAttributedString *, NSAttributedStringKey, NSRange)
#define SRDAssertAttributedStringNotContainsAttribute(...) \
    __SRD_CATCH_EXCEPTIONS("SRDAssertAttributedStringNotContainsAttribute", __SRD_FUNC_GET_MACRO(0, 0, __VA_ARGS__, _SRDAssertAttributedStringNotContainsAttribute, _SRDAssertAttributedStringNotContainsAttributeNoRange)( __VA_ARGS__, __FILE__, __LINE__ ))

//

#define _SRDAssertAttributedStringContainsAttributeNoRange(attributedString, attribute, ...) \
    _SRDAssertAttributedStringContainsAttribute(attributedString, attribute, NSMakeRange(NSNotFound, 0), __VA_ARGS__)

#define _SRDAssertAttributedStringContainsAttributeAndValueNoRange(attributedString, attributeKey, attributeValue, ...) \
    _SRDAssertAttributedStringContainsAttributeAndValue(attributedString, attributeKey, attributeValue, NSMakeRange(NSNotFound, 0), __VA_ARGS__)

#define _SRDAssertAttributedStringContainsAttributeAndValuesNoRange(attributedString, attributeKey, attributeValue, alternateAttributeValue, ...) \
    _SRDAssertAttributedStringContainsAttributeAndValues(attributedString, attributeKey, attributeValue, alternateAttributeValue, NSMakeRange(NSNotFound, 0), __VA_ARGS__)

#define _SRDAssertAttributedStringNotContainsAttributeNoRange(attributedString, attribute, ...) \
    _SRDAssertAttributedStringNotContainsAttribute(attributedString, attribute, NSMakeRange(NSNotFound, 0), __VA_ARGS__)

#endif // !defined(SRDAssertAttributedStringContainsAttribute)

NS_ASSUME_NONNULL_END
