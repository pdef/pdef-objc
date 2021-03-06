//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//


#import <Foundation/Foundation.h>

/** PDJsonSerialization extends NSJSONSerialization to support primitives and nils as root objects. */
@interface PDJsonSerialization : NSObject

/** Generate JSON string from a Foundation object or a primitive. */
+ (NSString *)stringWithJSONObject:(id)object error:(NSError **)error;

/* Generate JSON data from a Foundation object or a primitive. */
+ (NSData *)dataWithJSONObject:(id)object options:(NSJSONWritingOptions)opt error:(NSError **)error;

/* Create a Foundation object or a primitive from JSON data. */
+ (id)JSONObjectWithData:(NSData *)data error:(NSError **)error;

/** Create a Foundation object or a primitive from JSON data. */
+ (id)JSONObjectWithString:(NSString *)string error:(NSError **)error;

@end
