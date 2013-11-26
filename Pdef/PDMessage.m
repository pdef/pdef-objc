//
// Created by Ivan Korobkov on 19.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import "PDMessage.h"
#import "PDDescriptors.h"


@implementation PDMessage
/** Override this method in a subclass, and return a custom descriptor. */
+ (PDMessageDescriptor *)typeDescriptor {
    return nil;
}

/** Override this method in a subclass, and return the subclass typeDescriptor. */
- (PDMessageDescriptor *)descriptor {
    return nil;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    return [self init];
}

- (id)initWithJson:(NSString *)json {
    return [self init];
}

- (NSDictionary *)toDictionary {
    return nil;
}

- (NSString *)toJson {
    return nil;
}

- (BOOL)isFieldSet:(NSString *)name {
    return YES;
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

        if (![self isFieldSet:name]) {
            if (![message isFieldSet:name]) {
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

        if ([self isFieldSet:name]) {
            id value = [self valueForKey:name];
            hash = hash * 31u + [value hash];
        }
    }

    return hash;
}

- (id)copyWithZone:(NSZone *)zone {
    PDMessage *copy = [[[self class] alloc] init];

    for (PDFieldDescriptor *field in self.descriptor.fields) {
        NSString *name = field.name;

        if ([self isFieldSet:name]) {
            id value = [self valueForKey:name];
            id valueCopy = [value copyWithZone:zone];
            [copy setValue:valueCopy forKey:name];
        }
    }

    return copy;
}
@end
