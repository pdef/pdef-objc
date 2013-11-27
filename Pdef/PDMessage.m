//
// Created by Ivan Korobkov on 19.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import "PDMessage.h"
#import "PDDescriptors.h"
#import "PDJsonFormat.h"
#import "PDJsonSerialization.h"


@implementation PDMessage
- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
        NSError *error = nil;
        for (PDFieldDescriptor *field in self.descriptor.fields) {
            id value = [dictionary objectForKey:field.name];
            if (!value) {
                continue;
            }

            id parsed = [PDJsonFormat readObject:value descriptor:field.type error:&error];
            if (!parsed) {
                return nil;
            }
            [self setValue:parsed forKey:field.name];
        }
    }

    return self;
}

- (id)initWithJson:(NSData *)json error:(NSError **)error {
    id object = [PDJsonSerialization JSONObjectWithData:json error:error];
    return [self initWithDictionary:object];
}

- (id)mergeMessage:(PDMessage *)message {
    if (!message || message == self) {
        return self;
    }

    PDMessageDescriptor *descriptor = self.descriptor;
    if (![message isKindOfClass:self.class]) {
        if (![self isKindOfClass:message.class]) {
            return self;
        }
        descriptor = message.descriptor;
    }

    for (PDFieldDescriptor *field in descriptor.fields) {
        if (field.discriminator) {
            continue;
        }

        if (![field isSetInMessage:message]) {
            continue;
        }

        id value = [message valueForKey:field.name];
        id valueCopy = [value copy];
        [self setValue:valueCopy forKey:field.name];
    }

    return self;
}

- (id)mergeDictionary:(NSDictionary *)dictionary {
    PDMessage *message = [[[self class] alloc] initWithDictionary:dictionary];
    return [self mergeMessage:message];
}

- (id)mergeJson:(NSData *)json error:(NSError **)error {
    PDMessage *message = [[[self class] alloc] initWithJson:json error:error];
    if (!message) {
        return self;
    }

    return [self mergeMessage:message];
}

- (NSDictionary *)toDictionary {
    NSError *error = nil;
    return [PDJsonFormat writeObject:self descriptor:[self descriptor] error:&error];
}

- (NSData *)toJsonWithError:(NSError **)error {
    return [self toJsonIndent:NO error:error];
}

- (NSData *)toJsonIndent:(BOOL)indent error:(NSError **)error {
    return [PDJsonFormat writeData:self descriptor:[self descriptor] error:error];
}

- (NSJSONWritingOptions)getJsonWritingOptions:(BOOL)indent {
    NSJSONWritingOptions options = 0;
    if (indent) {
        options = NSJSONWritingPrettyPrinted;
    }
    return options;
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
