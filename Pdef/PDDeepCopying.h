//
//  PDCopying.h
//  
//
//  Created by Ivan Korobkov on 03.12.13.
//
//

#import <Foundation/Foundation.h>

@class PDDataTypeDescriptor;
@class PDListDescriptor;
@class PDSetDescriptor;
@class PDMapDescriptor;
@class PDMessage;
@class PDMessageDescriptor;

@interface PDDeepCopying : NSObject
+ (id) copyObject:(id)object descriptor:(PDDataTypeDescriptor *)descriptor;

+ (PDMessage *) copyMessage:(PDMessage *)message descriptor:(PDMessageDescriptor *)descriptor;

+ (NSArray *) copyArray:(NSArray *)array descriptor:(PDListDescriptor *)descriptor;

+ (NSSet *)copySet:(NSSet *)set descriptor:(PDSetDescriptor *)descriptor;

+ (NSDictionary *)copyDictionary:(NSDictionary *)dictionary descriptor:(PDMapDescriptor *)descriptor;
@end
