//
// Created by Ivan Korobkov on 19.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import "PDMessage.h"
#import "PDDescriptors.h"
#import "PDDataFormat.h"


@implementation PDMessage
- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
        for (PDFieldDescriptor *field in self.descriptor.fields) {
            id value = [dictionary objectForKey:field.name];
            if (!value) {
                continue;
            }

            id parsed = [PDDataFormat readObjectFromData:value descriptor:field.type];
            [self setValue:parsed forKey:field.name];
        }
    }

    return self;
}

- (NSDictionary *)toDictionary {
    return [PDDataFormat writeObject:self descriptor:self.descriptor];
}

- (id)initWithJson:(NSData *)json error:(NSError **)error {
    id object = [NSJSONSerialization JSONObjectWithData:json options:0 error:error];
    if (!object) {
        return nil;
    }

    return [self initWithDictionary:object];
}

- (NSData *)toJsonWithError:(NSError **)error {
    return [self toJsonIndent:NO error:error];
}

- (NSData *)toJsonIndent:(BOOL)indent error:(NSError **)error {
    NSDictionary *dict = [self toDictionary];
    NSJSONWritingOptions options = 0;
    if (indent) {
        options = NSJSONWritingPrettyPrinted;
    }

    return [NSJSONSerialization dataWithJSONObject:dict options:options error:error];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToMessage:other];
}

- (BOOL)isEqualToMessage:(PDMessage *)message {
    if (self == message)
        return YES;
    if (message == nil)
        return NO;
    if (![[message class] isEqual:[self class]])
        return NO;

    for (PDFieldDescriptor *field in self.descriptor.fields) {
        NSString *name = field.name;

        if (![field isSetInMessage:self]) {
            if (![field isSetInMessage:message]) {
                continue;
            } else {
                return NO;
            }
        }

        id value = [self valueForKey:name];
        id otherValue = [message valueForKey:name];
        if (!value) {
            if (!otherValue) {
                continue;
            } else {
                return NO;
            }
        } else if (![value isEqual:otherValue]) {
            return NO;
        }
    }

    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;

    for (PDFieldDescriptor *field in self.descriptor.fields) {
        NSString *name = field.name;

        if ([field isSetInMessage:self]) {
            id value = [self valueForKey:name];
            hash = hash * 31u + [value hash];
        } else {
            hash = hash * 31u;
        }
    }

    return hash;
}

- (id)copyWithZone:(NSZone *)zone {
    PDMessage *copy = [[[self class] alloc] init];

    for (PDFieldDescriptor *field in self.descriptor.fields) {
        NSString *name = field.name;

        if ([field isSetInMessage:self]) {
            id value = [self valueForKey:name];
            id valueCopy = [value copyWithZone:zone];
            [copy setValue:valueCopy forKey:name];
        }
    }

    return copy;
}

/** Override this method in a subclass, and return a custom descriptor. */
+ (PDMessageDescriptor *)typeDescriptor {
    return nil;
}

/** Override this method in a subclass, and return the subclass typeDescriptor. */
- (PDMessageDescriptor *)descriptor {
    return nil;
}
@end
