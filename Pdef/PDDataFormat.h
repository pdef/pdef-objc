//
// Created by Ivan Korobkov on 26.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import <Foundation/Foundation.h>

@class PDDescriptor;
@class PDMessage;
@class PDMessageDescriptor;


/**
* PDJsonFormat converts between Foundation objects and Pdef objects (messages, enum, collections and primitives).
*
* A foundation data can be passed as a JSON object to NSJsonSerializetion.
*/
@interface PDDataFormat : NSObject

/** Returns a foundation object from a pdef object (a message, an enum, a collection or a primitive). */
+ (id)dataWithPdefObject:(id)object descriptor:(PDDescriptor *)descriptor;

/** Returns a pdef object (a message, an enum, a collection or a primitive) from a foundation object. */
+ (id)pdefObjectFromData:(id)data descriptor:(PDDescriptor *)descriptor;
@end
