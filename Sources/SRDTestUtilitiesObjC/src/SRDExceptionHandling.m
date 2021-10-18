//
//  SRDExceptionHandling.m
//  SRDTestUtilities
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRDExceptionHandling.h"

// MARK: - Public Function Definitions

NSException * __nullable SRDCatchObjCException(void (^ NS_NOESCAPE block)(void)) {
    return SRDCatchObjCExceptionOfTypes(@[], block);
}

NSException * __nullable SRDCatchObjCExceptionOfTypes(NSArray<Class> *exceptionTypes, void (^ NS_NOESCAPE block)(void)) {
    NSException * __nullable caughtException = nil;

    @try {
        block();
    } @catch (NSException *exception) {
        if (exceptionTypes.count > 0) {
            BOOL match = NO;
            for (Class cls in exceptionTypes) {
                if ([exception isKindOfClass:cls]) {
                    match = YES;
                    break;
                }
            }

            if (!match)
                @throw;
        }

        caughtException = exception;
    }

    return caughtException;
}
