//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//


#import "PDMessage.h"
#import "PDDescriptors.h"
#import "PDJsonFormat.h"
#import "PDJsonSerialization.h"
#import "PDDeepCopying.h"


@implementation PDMessage
- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
        for (PDFieldDescriptor *field in self.descriptor.fields) {
            id value = [dictionary objectForKey:field.name];
            if (!value) {
                continue;
            }

            id parsed = [PDJsonFormat readObject:value descriptor:field.type];
            if (!parsed) {
                // Failed to parse a field value.
                continue;
            }
            if (parsed == [NSNull null]) {
                // Unbox the value.
                parsed = nil;
            }

            [self setValue:parsed forKey:field.name];
        }
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [self init]) {
        for (PDFieldDescriptor *field in self.descriptor.fields) {
            NSString *name = field.name;
            PDDataTypeDescriptor *type = field.type;
            if (![coder containsValueForKey:name]) {
                continue;
            }

            id object = nil;
            switch(type.type) {
                case PDTypeBool: object = @([coder decodeBoolForKey:name]); break;
                case PDTypeInt16: object = @([coder decodeInt32ForKey:name]); break;
                case PDTypeInt32: object = @([coder decodeInt32ForKey:name]); break;
                case PDTypeInt64: object = @([coder decodeInt64ForKey:name]); break;
                case PDTypeFloat: object = @([coder decodeFloatForKey:name]); break;
                case PDTypeDouble: object = @([coder decodeDoubleForKey:name]); break;
                case PDTypeEnum: object = @([coder decodeInt64ForKey:name]); break;
                case PDTypeVoid:break;
                case PDTypeInterface:break;
                default: object = [coder decodeObjectForKey:name]; break;
            }

            if (object) {
                [self setValue:object forKey:name];
            }
        }
    }
    return self;
}

- (id)initWithJson:(NSData *)json error:(NSError **)error {
    id object = [PDJsonSerialization JSONObjectWithData:json error:error];
    return [self initWithDictionary:object];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    for (PDFieldDescriptor *field in self.descriptor.fields) {
        NSString *name = field.name;
        PDDataTypeDescriptor *type = field.type;
        id object = [self valueForKey:name];

        switch(type.type) {
            case PDTypeBool: [coder encodeBool:[((NSNumber *)object) boolValue] forKey:name];break;
            case PDTypeInt16: [coder encodeInt32:[((NSNumber *)object) shortValue] forKey:name];break;
            case PDTypeInt32: [coder encodeInt32:[((NSNumber *)object) integerValue] forKey:name];break;
            case PDTypeInt64: [coder encodeInt64:[((NSNumber *)object) longLongValue] forKey:name];break;
            case PDTypeFloat: [coder encodeFloat:[((NSNumber *)object) floatValue] forKey:name];break;;
            case PDTypeDouble: [coder encodeDouble:[((NSNumber *)object) doubleValue] forKey:name];break;
            case PDTypeEnum: [coder encodeInt64:[((NSNumber *)object) longLongValue] forKey:name];break;
            case PDTypeVoid:break;
            case PDTypeInterface:break;
            default: [coder encodeObject:object forKey:name];
        }
    }
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
    PDMessage *message = [PDJsonFormat readObject:dictionary descriptor:self.descriptor];
    return [self mergeMessage:message];
}

- (id)mergeJson:(NSData *)json error:(NSError **)error {
    PDMessage *message = [PDJsonFormat readData:json descriptor:self.descriptor error:error];
    if (!message) {
        return self;
    }

    return [self mergeMessage:message];
}

- (NSDictionary *)toDictionary {
    return [PDJsonFormat writeObject:self descriptor:[self descriptor]];
}

- (NSData *)toJsonError:(NSError **)error {
    return [PDJsonFormat writeData:self descriptor:[self descriptor] error:error];
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
    return [PDDeepCopying copyMessage:self descriptor:[self descriptor]];
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
