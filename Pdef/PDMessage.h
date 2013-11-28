//
// Created by Ivan Korobkov on 19.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import <Foundation/Foundation.h>

@class PDMessageDescriptor;
@class PDEnumDescriptor;


@interface PDMessage : NSObject<NSCopying>
/** Returns this class descriptor. */
+ (PDMessageDescriptor *)typeDescriptor;

/** Returns this message descriptor. */
- (PDMessageDescriptor *)descriptor;

/** Initializes this message with a JSON dictionary. */
- (id)initWithDictionary:(NSDictionary *)dictionary;

/** Initializes this message with a JSON string. */
- (id)initWithJson:(NSData *)json error:(NSError **)error;

/** Deeply copies present fields from another message into this message. */
- (id)mergeMessage:(PDMessage *)message;

/** Parses another message from a dictionary and merges it into this message. */
- (id)mergeDictionary:(NSDictionary *)dictionary;

/** Parses another message from JSON data and merges it into this message. */
- (id)mergeJson:(NSData *)json error:(NSError **)error;

/** Converts this message to a dictionary with primitives and collections. */
- (NSDictionary *)toDictionary;

/** Converts this message to JSON data. */
- (NSData *)toJsonError:(NSError **)error;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToMessage:(PDMessage *)message;

- (NSUInteger)hash;
@end
