//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//


#import <Foundation/Foundation.h>

@class PDDataTypeDescriptor;

@interface PDJsonFormat : NSObject

/** Converts an object into a JSON string. */
+ (NSString *)writeString:(id)object descriptor:(PDDataTypeDescriptor *)descriptor error:(NSError **)error;

/** Reads an object from a JSON string. */
+ (id)readString:(NSString *)string descriptor:(PDDataTypeDescriptor *)descriptor error:(NSError **)error;


/** Converts an object into JSON data. */
+ (NSData *)writeData:(id)object descriptor:(PDDataTypeDescriptor *)descriptor error:(NSError **)error;

/** Reads an object from JSON data. */
+ (id)readData:(NSData *)data descriptor:(PDDataTypeDescriptor *)descriptor error:(NSError **)error;


/** Converts an object into a JSON-compatible object, or a JSON-fragment object. */
+ (id)writeObject:(id)object descriptor:(PDDataTypeDescriptor *)descriptor;

/** Reads an object from a JSON-compatible object or a JSON-fragment. */
+ (id)readObject:(id)object descriptor:(PDDataTypeDescriptor *)descriptor;

@end
