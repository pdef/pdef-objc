//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//


#import "PDJsonSerialization.h"

@implementation PDJsonSerialization

+ (NSString *)stringWithJSONObject:(id)object error:(NSError **)error {
    if (!object || [object isEqual:[NSNull null]]){
       return @"null";
    }

    else if ([object isKindOfClass:[NSNumber class]]) {
        return [self stringWithNumber:(NSNumber *) object];
    }

    else if ([object isKindOfClass:[NSString class]]) {
        return [self stringWithString:(NSString *) object error:error];
    }

    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:error];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString *)stringWithNumber:(NSNumber *)number {
    char const *type = [number objCType];
    char const *boolType = @encode(BOOL);
    // There must be only two boxed boolean instances.
    if (strcmp(type, boolType) == 0 || number == [NSNumber numberWithBool:YES] || number == [NSNumber numberWithBool:NO]) {
        return [number boolValue] ? @"true" : @"false";
    }

    return [number stringValue];
}

+ (NSString *)stringWithString:(NSString *)string error:(NSError **)error {
    // Wrap a string into an array, convert it into JSON data, and strip the array start/end.

    NSArray *array = @[string];
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:0 error:error];
    if (!data) {
        return nil;
    }

    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [s substringWithRange:(NSRange) {1, s.length - 2}];
}

+ (NSData *)dataWithJSONObject:(id)object options:(NSJSONWritingOptions)opt error:(NSError **)error {
    if (!object || [object isEqual:[NSNull null]]) {
        return [@"null" dataUsingEncoding:NSUTF8StringEncoding];
    }

    if (![NSJSONSerialization isValidJSONObject:object]) {
        NSString *s = [self stringWithJSONObject:object error:error];
        if (!s) {
            return nil;
        }

        return [s dataUsingEncoding:NSUTF8StringEncoding];
    }

    return [NSJSONSerialization dataWithJSONObject:object options:0 error:error];
}

+ (id)JSONObjectWithData:(NSData *)data error:(NSError **)error {
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
}

+ (id)JSONObjectWithString:(NSString *)string error:(NSError **)error {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self JSONObjectWithData:data error:error];
}

@end
