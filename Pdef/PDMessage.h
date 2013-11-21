//
// Created by Ivan Korobkov on 19.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import <Foundation/Foundation.h>

@class PDMessageDescriptor;
@class PDEnumDescriptor;


@protocol PDMessage <NSObject>
/** Returns this class descriptor. */
+ (PDMessageDescriptor *)typeDescriptor;

/** Returns this instance descriptor. */
- (PDMessageDescriptor *)descriptor;

/** Initializes this instance with a dictionary using the PDObjectFormat. */
- (id)initWithDictionary:(NSDictionary *)dictionary;

/** Initialized this instance with a json string using the PDJsonFormat. */
- (id)initWithJson:(NSString *)json;

/** Converts this message to a dictionary using the PDObjectFormat. */
- (NSDictionary *)toDictionary;

/** Converts this message to a json string. */
- (NSString *)toJson;
@end


@interface PDGeneratedMessage : NSObject <PDMessage>
@end
