//
//  SRDExceptionHandling.h
//  SRDTestUtilities
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import <Foundation/Foundation.h>

// MARK: - Public Function Declarations

NS_ASSUME_NONNULL_BEGIN

/**
 A function that catches and returns any Objective-C exceptions thrown inside of
 the block parameter.

 @param block The block to run. Any Objective-C exceptions thrown within this
              block are caught and returned.

 @returns An Objective-C exception if one was thrown, @p nil otherwise.

 This is provided primarily as a way for Swift to catch and handle Objective-C
 exceptions.
 */
NSException * __nullable SRDCatchObjCException(void (^ NS_NOESCAPE block)(void)) NS_REFINED_FOR_SWIFT;

/**
 A function that catches and returns any Objective-C exceptions thrown inside of
 the block parameter that match a list of exception classes.

 @param exceptionTypes An array of exception classes to catch inside of @p block.
                       Any exceptions thrown not included in this array are not
                       handled.
 @param block The block to run. Any Objective-C exceptions thrown within this
              block that match the list of exception types are caught and
              returned.

 @returns An Objective-C exception if one was thrown and matched, @p nil
          otherwise.

 This is provided primarily as a way for Swift to catch and handle Objective-C
 exceptions.
 */
NSException * __nullable SRDCatchObjCExceptionOfTypes(NSArray<Class> *exceptionTypes, void (^ NS_NOESCAPE block)(void)) NS_REFINED_FOR_SWIFT;

NS_ASSUME_NONNULL_END
