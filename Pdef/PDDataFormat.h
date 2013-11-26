//
// Created by Ivan Korobkov on 26.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import <Foundation/Foundation.h>

@class PDDescriptor;
@class PDMessage;
@class PDMessageDescriptor;


/**
* PDDataFormat converts between Foundation objects and Pdef objects (messages, enum, collections and primitives).
* The returned dictionaries and arrays are JSON-compatible and can be passed to NSJSONSerialization.
*/
@interface PDDataFormat : NSObject

/** Returns a foundation object from a pdef object. */
+ (id)writeObject:(id)object descriptor:(PDDescriptor *)descriptor;

/** Returns a pdef object from a foundation object. */
+ (id)readObjectFromData:(id)data descriptor:(PDDescriptor *)descriptor;
@end
