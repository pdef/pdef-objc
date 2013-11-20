// Generated by Pdef Objective-C generator.

#import <Foundation/Foundation.h>
#import "InterfacesDescriptors.h"

@class TestMessage;


/** Test exception.
Multi-line comment.
 */
@interface TestException : NSObject
@property (nonatomic) NSString *text;
@end


/** Test interface with method of all types.
Multi-line comment.
 */
@protocol TestInterface
/** Returns the sum of the numbers.
Multi-line comment.
 */
- (NSOperation *) methodArg0:(NSNumber *)arg0
        arg1:(NSNumber *)arg1
        response:(void (^)(id result, NSError *error))error;

/** Returns the sum of the numbers. */
- (NSOperation *) queryArg0:(NSNumber *)arg0
        arg1:(NSNumber *)arg1
        response:(void (^)(id result, NSError *error))error;

/** Returns the sum of the numbers. */
- (NSOperation *) postArg0:(NSNumber *)arg0
        arg1:(NSNumber *)arg1
        response:(void (^)(id result, NSError *error))error;

/** Returns the same string. */
- (NSOperation *) string0Text:(NSString *)text
        response:(void (^)(id result, NSError *error))error;

/** Return the same datetime. */
- (NSOperation *) datetime0Dt:(NSDate *)dt
        response:(void (^)(id result, NSError *error))error;

/** Returns the same message. */
- (NSOperation *) message0Msg:(TestMessage *)msg
        response:(void (^)(id result, NSError *error))error;

/** Returns the total number of items. */
- (NSOperation *) collectionsList0:(NSArray *)list0
        set0:(NSSet *)set0
        map0:(NSDictionary *)map0
        response:(void (^)(id result, NSError *error))error;

/** Returns the same interface (yes, it's endless). */
- (NSOperation *) interface0Arg0:(NSNumber *)arg0
        arg1:(NSNumber *)arg1
        response:(void (^)(id result, NSError *error))error;

/** Void method which returns null. */
- (NSOperation *) void0Response:(void (^)(id result, NSError *error))response;

/** Throws a TestException. */
- (NSOperation *) exc0Response:(void (^)(id result, NSError *error))response;

/** Throws any server error. */
- (NSOperation *) serverErrorResponse:(void (^)(id result, NSError *error))response;

@end


