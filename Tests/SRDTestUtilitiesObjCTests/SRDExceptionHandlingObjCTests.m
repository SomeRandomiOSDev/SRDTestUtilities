//
//  SRDExceptionHandlingObjCTests.m
//  SRDTestUtilities
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

@import SRDTestUtilities;
@import XCTest;

// MARK: - CustomException Interface

@interface CustomException: NSException
@end

// MARK: - SubCustomException Interface

@interface SubCustomException: CustomException
@end

// MARK: - SRDExceptionHandlingObjCTests Interface

@interface SRDExceptionHandlingObjCTests: XCTestCase
@end

// MARK: - SRDExceptionHandlingObjCTests Implementation

@implementation SRDExceptionHandlingObjCTests

// MARK: Test Methods

- (void)testCatchingNonSpecificObjCExceptions {
    NSException * const genericException = [[NSException alloc] initWithName:[[NSUUID UUID] UUIDString] reason:[[NSUUID UUID] UUIDString] userInfo:nil];
    CustomException * const customException = [[CustomException alloc] initWithName:[[NSUUID UUID] UUIDString] reason:[[NSUUID UUID] UUIDString] userInfo:nil];

    [XCTContext runActivityNamed:@"No Throw" block:^(id _) {
        NSException * __nullable exception = nil;
        __block id value = nil;

        exception = SRDCatchObjCException(^{
            value = [[NSObject alloc] init];
        });

        XCTAssertNotNil(value);
        XCTAssertNil(exception);
    }];
    [XCTContext runActivityNamed:@"Throws NSException" block:^(id _) {
        NSException * __nullable exception = nil;
        __block id value = nil;

        exception = SRDCatchObjCException(^{
            [genericException raise];
            value = [[NSObject alloc] init];
        });

        XCTAssertNil(value);
        XCTAssertNotNil(exception);
        XCTAssertTrue([exception isEqual:genericException]);
    }];
    [XCTContext runActivityNamed:@"Throws CustomException" block:^(id _) {
        NSException * __nullable exception = nil;
        __block id value = nil;

        exception = SRDCatchObjCException(^{
            [customException raise];
            value = [[NSObject alloc] init];
        });

        XCTAssertNil(value);
        XCTAssertNotNil(exception);
        XCTAssertTrue([exception isEqual:customException]);
    }];
}

- (void)testCatchingSpecificObjCExceptions {
    NSException * const genericException = [[NSException alloc] initWithName:[[NSUUID UUID] UUIDString] reason:[[NSUUID UUID] UUIDString] userInfo:nil];
    CustomException * const customException = [[CustomException alloc] initWithName:[[NSUUID UUID] UUIDString] reason:[[NSUUID UUID] UUIDString] userInfo:nil];
    SubCustomException * const subCustomException = [[SubCustomException alloc] initWithName:[[NSUUID UUID] UUIDString] reason:[[NSUUID UUID] UUIDString] userInfo:nil];

    [XCTContext runActivityNamed:@"No Throw" block:^(id _) {
        NSException * __nullable exception = nil;
        __block id value = nil;

        exception = SRDCatchObjCExceptionOfTypes(@[CustomException.class], ^{
            value = [[NSObject alloc] init];
        });

        XCTAssertNotNil(value);
        XCTAssertNil(exception);
    }];
    [XCTContext runActivityNamed:@"Throws NSException" block:^(id _) {
        [XCTContext runActivityNamed:@"Match Types: [CustomException]" block:^(id _) {
            NSException * __nullable exception = nil;
            __block id value = nil;

            @try {
                // Generic exception is raised which won't match `CustomException`, therefore the
                // exception should be re-thrown.
                exception = SRDCatchObjCExceptionOfTypes(@[CustomException.class], ^{
                    [genericException raise];
                    value = [[NSObject alloc] init];
                });

                XCTFail(@"Expected `-catchingObjCExceptionOfTypes:block:` to re-throw uncaught exception.");
            } @catch (NSException *exception) {
                // Nothing to do.
            }

            XCTAssertNil(value);
            XCTAssertNil(exception);
        }];

        for (NSArray<Class> *types in @[@[], NSNull.null]) {
            [XCTContext runActivityNamed:[NSString stringWithFormat:@"Match Types: %@", [types isKindOfClass:NSNull.class] ? @"nil" : @"[]"] block:^(id _) {
                NSException * __nullable exception = nil;
                __block id value = nil;

                exception = SRDCatchObjCExceptionOfTypes(([types isKindOfClass:NSNull.class] ? nil : types), ^{
                    [genericException raise];
                    value = [[NSObject alloc] init];
                });

                XCTAssertNil(value);
                XCTAssertNotNil(exception);
                XCTAssertTrue([exception isEqual:genericException]);
            }];
        }
    }];
    [XCTContext runActivityNamed:@"Throws CustomException" block:^(id _) {
        NSException * __nullable exception = nil;
        __block id value = nil;

        exception = SRDCatchObjCExceptionOfTypes(@[CustomException.class], ^{
            [customException raise];
            value = [[NSObject alloc] init];
        });

        XCTAssertNil(value);
        XCTAssertNotNil(exception);
        XCTAssertTrue([exception isEqual:customException]);
    }];
    [XCTContext runActivityNamed:@"Throws SubCustomException" block:^(id _) {
        NSException * __nullable exception = nil;
        __block id value = nil;

        exception = SRDCatchObjCExceptionOfTypes(@[CustomException.class], ^{
            [subCustomException raise];
            value = [[NSObject alloc] init];
        });

        XCTAssertNil(value);
        XCTAssertNotNil(exception);
        XCTAssertTrue([exception isEqual:subCustomException]);
    }];
}

@end

// MARK: - CustomException Implementation

@implementation CustomException
@end

// MARK: - SubCustomException Implementation

@implementation SubCustomException
@end
