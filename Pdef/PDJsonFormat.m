//
// Created by Ivan Korobkov on 19.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//

#import "PDJsonFormat.h"
#import "PDDescriptors.h"
#import "PDMessage.h"
#import "PDJsonSerialization.h"
#import "PDErrors.h"


@implementation PDJsonFormat
static NSDateFormatter *formatter;

+ (void)initialize {
    [super initialize];

    formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
}


#pragma mark string

+ (NSString *)writeString:(id)object descriptor:(PDDataTypeDescriptor *)descriptor error:(NSError **)error {
    NSParameterAssert(descriptor);
    if (!object || [object isEqual:[NSNull null]]) {
        return @"null";
    }

    // Convert an object into a JSON-compatible object.
    id jsonObject = [self writeObject:object descriptor:descriptor];

    // Serialize it into a JSON string;
    return [PDJsonSerialization stringWithJSONObject:jsonObject error:error];
}

+ (id)readString:(NSString *)string descriptor:(PDDataTypeDescriptor *)descriptor error:(NSError **)error {
    NSParameterAssert(string);
    NSParameterAssert(descriptor);

    id jsonObject = [PDJsonSerialization JSONObjectWithString:string error:error];
    if (!jsonObject) {
        return nil;
    }

    return [self readObject:jsonObject descriptor:descriptor];
}


#pragma mark data

+ (NSData *)writeData:(id)object descriptor:(PDDataTypeDescriptor *)descriptor error:(NSError **)error {
    NSParameterAssert(descriptor);
    if (!object || [object isEqual:[NSNull null]]) {
        return [@"null" dataUsingEncoding:NSUTF8StringEncoding];
    }

    // Convert an object into a JSON-compatible object.
    id jsonObject = [self writeObject:object descriptor:descriptor];

    // Serialize it into JSON-data.
    return [PDJsonSerialization dataWithJSONObject:jsonObject options:0 error:error];
}

+ (id)readData:(NSData *)data descriptor:(PDDataTypeDescriptor *)descriptor error:(NSError **)error {
    NSParameterAssert(data);
    NSParameterAssert(descriptor);

    id jsonObject = [PDJsonSerialization JSONObjectWithData:data error:error];
    if (!jsonObject) {
       return nil;
    }

    return [self readObject:jsonObject descriptor:descriptor];
}


#pragma mark object

+ (id)writeObject:(id)object descriptor:(PDDataTypeDescriptor *)descriptor {
    NSParameterAssert(descriptor);
    if (!object || [object isEqual:[NSNull null]]) {
        return [NSNull null];
    }

    PDType type = descriptor.type;
    switch (type) {
        case PDTypeBool:
        case PDTypeInt16:
        case PDTypeInt32:
        case PDTypeInt64:
        case PDTypeFloat:
        case PDTypeDouble: return object;
        case PDTypeString: return [object copy];
        case PDTypeDatetime: return [self writeDatetime:object];
        case PDTypeEnum: return [self writeEnum:object descriptor:(PDEnumDescriptor *) descriptor];
        case PDTypeVoid: return nil;

        case PDTypeList: return [self writeList:object descriptor:(PDListDescriptor *) descriptor];
        case PDTypeSet: return [self writeSet:object descriptor:(PDSetDescriptor *) descriptor];
        case PDTypeMap: return [self writeMap:object descriptor:(PDMapDescriptor *) descriptor];
        case PDTypeMessage: return [self writeMessage:object descriptor:(PDMessageDescriptor *) descriptor];

        case PDTypeInterface: return nil;
    }

    return nil;
}

+ (NSString *)writeDatetime:(NSDate *)date {
    return [formatter stringFromDate:date];
}

+ (NSString *)writeEnum:(NSNumber *)number descriptor:(PDEnumDescriptor *)descriptor {
    NSString *s = [[descriptor.numbersToNames objectForKey:number] lowercaseString];
    return s ? s : @"null";
}

+ (id)writeList:(NSArray *)list descriptor:(PDListDescriptor *)descriptor {
    PDDataTypeDescriptor *elementd = descriptor.elementDescriptor;

    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id element in list) {
        id serialized = [self writeObject:element descriptor:elementd];
        if (!serialized) {
            // Failed to serialize an element.
            return nil;
        }

        [result addObject:serialized];
    }

    return result;
}

+ (id)writeSet:(NSSet *)set descriptor:(PDSetDescriptor *)descriptor {
    PDDataTypeDescriptor *elementd = descriptor.elementDescriptor;

    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id element in set) {
        id serialized = [self writeObject:element descriptor:elementd];
        if (!serialized) {
            // Failed to serialize an element.
            return nil;
        }

        [result addObject:serialized];
    }

    return result;
}

+ (id)writeMap:(NSDictionary *)dict descriptor:(PDMapDescriptor *)descriptor {
    PDDataTypeDescriptor *keyd = descriptor.keyDescriptor;
    PDDataTypeDescriptor *valued = descriptor.valueDescriptor;
    BOOL keyIsString = keyd.type == PDTypeString;

    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    for (id key in dict) {
        if (!key || [key isEqual:[NSNull null]]) {
            // Ignore null keys.
            continue;
        }

        // Use strings as is, serialize primitives to json strings.
        NSString *skey;
        if (keyIsString) {
            skey = key;
        } else {
            NSError *error = nil;
            skey = [self writeString:key descriptor:keyd error:&error];
        }

        // Convert a value into a json object.
        id value = [dict objectForKey:key];
        id svalue = [self writeObject:value descriptor:valued];

        // Ignore failed keys/values.
        if (!skey || !svalue) {
            continue;
        }

        [result setObject:svalue forKey:skey];
    }

    return result;
}

+ (id)writeMessage:(PDMessage *)message descriptor:(PDMessageDescriptor *)descriptor {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

    // Mind polymorphic messages.
    descriptor = [message descriptor];
    for (PDFieldDescriptor *field in descriptor.fields) {
        if (![field isSetInMessage:message]) {
            continue;
        }

        id value = [message valueForKey:field.name];
        id serialized = [self writeObject:value descriptor:field.type];
        if (!serialized) {
            // Failed to serialize a field value.
            // Ignore it.
            continue;
        }

        [result setObject:serialized forKey:field.name];
    }

    return result;
}

+ (id)readObject:(id)object descriptor:(PDDataTypeDescriptor *)descriptor {
    NSParameterAssert(object);
    NSParameterAssert(descriptor);
    if (!object) {
        return nil;
    }
    if ([object isEqual:[NSNull null]]) {
        return [NSNull null];
    }

    PDType type = descriptor.type;
    switch (type) {
        case PDTypeBool:
        case PDTypeInt16:
        case PDTypeInt32:
        case PDTypeInt64:
        case PDTypeFloat:
        case PDTypeDouble:return [self readNumber:object type:type];
        case PDTypeString:return (NSString *) object;
        case PDTypeDatetime:return [self readDatetime:object];
        case PDTypeEnum:return [self readEnum:object descriptor:(PDEnumDescriptor *) descriptor];

        case PDTypeList:return [self readList:object descriptor:(PDListDescriptor *) descriptor];
        case PDTypeSet:return [self readSet:object descriptor:(PDSetDescriptor *) descriptor];
        case PDTypeMap:return [self readMap:object descriptor:(PDMapDescriptor *) descriptor];
        case PDTypeVoid:return nil;
        case PDTypeMessage:return [self readMessage:object descriptor:(PDMessageDescriptor *) descriptor];
        case PDTypeInterface:nil;
    }
    return nil;
}

+ (id)readNumber:(id)object type:(PDType)type {
    if ([object isKindOfClass:[NSNumber class]]) {
        return object;
    }

    NSString *string = object;
    switch(type) {
        case PDTypeBool: return @([string boolValue]);
        case PDTypeInt16: return @([string intValue]);
        case PDTypeInt32:return @([string intValue]);
        case PDTypeInt64:return @([string longLongValue]);
        case PDTypeFloat:return @([string floatValue]);
        case PDTypeDouble:return @([string doubleValue]);
        default: return nil;
    }
}

+ (id)readDatetime:(id)object {
    if ([object isKindOfClass:[NSDate class]]) {
        return [object copy];
    }

    NSString *string = object;
    return [formatter dateFromString:string];
}

+ (id)readList:(NSArray *)list descriptor:(PDListDescriptor *)descriptor {
    PDDataTypeDescriptor *elementd = descriptor.elementDescriptor;

    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id element in list) {
        id parsed = [self readObject:element descriptor:elementd];
        if (!parsed) {
            // Failed to parse an element, ignore it.
            continue;
        }

        [result addObject:parsed];
    }

    return result;
}

+ (id)readSet:(id)object descriptor:(PDSetDescriptor *)descriptor {
    PDDataTypeDescriptor *elementd = descriptor.elementDescriptor;


    NSMutableSet *result = [[NSMutableSet alloc] init];
    for (id element in object) {
        id parsed = [self readObject:element descriptor:elementd];
        if (!parsed) {
            // Failed to parse an element, ignore it.
            continue;
        }

        [result addObject:parsed];
    }

    return result;
}

+ (id)readMap:(NSDictionary *)dict descriptor:(PDMapDescriptor *)descriptor {
    PDDataTypeDescriptor *keyd = descriptor.keyDescriptor;
    PDDataTypeDescriptor *valued = descriptor.valueDescriptor;
    BOOL keyIsString = keyd.type == PDTypeString;

    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    for (id key in dict) {
        id value = [dict objectForKey:key];
        if (!key || [key isEqual:[NSNull null]]) {
            // Ignore null keys.
            continue;
        }

        id parsedKey;
        if (keyIsString) {
            parsedKey = key;
        } else {
            NSError *error = nil;
            parsedKey = [self readString:key descriptor:keyd error:&error];
        }

        id parsedValue = [self readObject:value descriptor:valued];
        if (!parsedKey || !parsedValue) {
            // Failed to parse a key or a value.
            // Ignore them.
            continue;
        }

        [result setObject:parsedValue forKey:parsedKey];
    }

    return result;
}

+ (id)readEnum:(id)object descriptor:(PDEnumDescriptor *)descriptor {
    if ([object isKindOfClass:[NSNumber class]]) {
        NSNumber *number = object;
        if ([descriptor.numbersToNames objectForKey:number]) {
            return number;
        } else {
            return @0;
        }
    }

    NSString *string = [((NSString *) object) uppercaseString];
    id value = [descriptor.namesToNumbers objectForKey:string];
    return value ? value : [NSNull null];
}

+ (id)readMessage:(NSDictionary *)dict descriptor:(PDMessageDescriptor *)descriptor {
    PDFieldDescriptor *discriminator = descriptor.discriminator;

    if (discriminator) {
        // Mind polymorphic messages.
        // Deserialize the discriminator value and get a subtype descriptor.
        id value = [dict objectForKey:discriminator.name];
        if (value) {
            NSNumber *dvalue = [self readObject:value descriptor:discriminator.type];
            NSInteger dint = [dvalue integerValue];

            PDMessageDescriptor *subtype = [descriptor findSubtypeByDiscriminatorValue:dint];
            descriptor = subtype ? subtype : descriptor;
        }
    }

    PDMessage *message = [[descriptor.cls alloc] init];
    for (PDFieldDescriptor *field in descriptor.fields) {
        id value = [dict objectForKey:field.name];
        if (!value) {
            continue;
        }

        id parsed = [self readObject:value descriptor:field.type];
        if (!parsed) {
            // Failed to parse a message field.
            continue;
        }

        [message setValue:parsed forKey:field.name];
    }
    return message;
}
@end
