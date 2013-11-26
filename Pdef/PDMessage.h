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

/** Returns this instance descriptor. */
- (PDMessageDescriptor *)descriptor;

/** Initializes this instance from a dictionary with primitives and collections. */
- (id)initWithDictionary:(NSDictionary *)dictionary;

/** Initialized this instance with a JSON string. */
- (id)initWithJson:(NSData *)json error:(NSError **)error;

/** Converts this message to a dictionary with primitives and collections. */
- (NSDictionary *)toDictionary;

/** Converts this message to JSON data. */
- (NSData *)toJsonWithError:(NSError **)error;

/** Converts this message to JSON data, indents the JSON structures. */
- (NSData *)toJsonIndent:(BOOL)indent error:(NSError **)error;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToMessage:(PDMessage *)message;

- (NSUInteger)hash;
@end
