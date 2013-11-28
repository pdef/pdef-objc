//
// Created by Ivan Korobkov on 19.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//

#import "PDJsonFormat.h"
#import "PDDescriptors.h"
#import "PDMessage.h"
#import "PDJsonSerialization.h"


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
    if (!object) {
        return @"null";
    }

    // Convert an object into a JSON-compatible object.
    id jsonObject = [self writeObject:object descriptor:descriptor error:error];
    if (!jsonObject) {
        return nil;
    }

    // Serialize it into a JSON string;
    return [PDJsonSerialization stringWithJSONObject:jsonObject error:error];
}

+ (id)readString:(NSString *)string descriptor:(PDDataTypeDescriptor *)descriptor error:(NSError **)error {
    NSParameterAssert(descriptor);

    id jsonObject = [PDJsonSerialization JSONObjectWithString:string error:error];
    if (!jsonObject) {
        return nil;
    }

    return [self readObject:jsonObject descriptor:descriptor error:error];
}


#pragma mark data

+ (NSData *)writeData:(id)object descriptor:(PDDataTypeDescriptor *)descriptor error:(NSError **)error {
    NSParameterAssert(descriptor);
    if (!object) {
        return nil;
    }

    // Convert an object into a JSON-compatible object.
    id jsonObject = [self writeObject:object descriptor:descriptor error:error];

    // Serialize it into JSON-data.
    return [PDJsonSerialization dataWithJSONObject:jsonObject options:0 error:error];
}

+ (id)readData:(NSData *)data descriptor:(PDDataTypeDescriptor *)descriptor error:(NSError **)error {
    NSParameterAssert(descriptor);
    if (!data) {
        return nil;
    }

    id jsonObject = [PDJsonSerialization JSONObjectWithData:data error:error];
    if (!jsonObject) {
       return nil;
    }
    return [self readObject:jsonObject descriptor:descriptor error:error];
}


#pragma mark object

+ (id)writeObject:(id)object descriptor:(PDDataTypeDescriptor *)descriptor error:(NSError **)error {
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
        case PDTypeDouble: return object;
        case PDTypeString: return [object copy];
        case PDTypeDatetime: return [self writeDatetime:object];
        case PDTypeEnum: return [self writeEnum:object descriptor:(PDEnumDescriptor *) descriptor];
        case PDTypeVoid: return nil;

        case PDTypeList: return [self writeList:object descriptor:(PDListDescriptor *) descriptor error:error];
        case PDTypeSet: return [self writeSet:object descriptor:(PDSetDescriptor *) descriptor error:error];
        case PDTypeMap: return [self writeMap:object descriptor:(PDMapDescriptor *) descriptor error:error];
        case PDTypeMessage: return [self writeMessage:object descriptor:(PDMessageDescriptor *) descriptor error:error];

        case PDTypeInterface: return nil;
    }

    return nil;
}

+ (NSString *)writeDatetime:(NSDate *)date {
    NSString *s = [formatter stringFromDate:date];
    return s ? s : @"null";
}

+ (NSString *)writeEnum:(NSNumber *)number descriptor:(PDEnumDescriptor *)descriptor {
    NSString *s = [[descriptor.numbersToNames objectForKey:number] lowercaseString];
    return s ? s : @"null";
}

+ (id)writeList:(NSArray *)list descriptor:(PDListDescriptor *)descriptor error:(NSError **)error {
    PDDataTypeDescriptor *elementd = descriptor.elementDescriptor;

    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id element in list) {
        id serialized = [self writeObject:element descriptor:elementd error:error];
        if (!serialized) {
            return nil;
        }

        [result addObject:serialized];
    }

    return result;
}

+ (id)writeSet:(NSSet *)set descriptor:(PDSetDescriptor *)descriptor error:(NSError **)error {
    PDDataTypeDescriptor *elementd = descriptor.elementDescriptor;

    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id element in set) {
        id serialized = [self writeObject:element descriptor:elementd error:error];
        if (!serialized) {
            return nil;
        }

        [result addObject:serialized];
    }

    return result;
}

+ (id)writeMap:(NSDictionary *)dict descriptor:(PDMapDescriptor *)descriptor error:(NSError **)error {
    PDDataTypeDescriptor *keyd = descriptor.keyDescriptor;
    PDDataTypeDescriptor *valued = descriptor.valueDescriptor;

    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    for (id key in dict) {
        id value = [dict objectForKey:key];

        NSString *skey = [self writeString:key descriptor:keyd error:error];
        if (!skey) {
            return nil;
        }

        id svalue = [self writeObject:value descriptor:valued error:error];
        if (!svalue) {
            return nil;
        }
        [result setObject:svalue forKey:skey];
    }

    return result;
}


+ (id)writeMessage:(PDMessage *)message descriptor:(PDMessageDescriptor *)descriptor error:(NSError **)error{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

    // Mind polymorphic messages.
    descriptor = [message descriptor];
    for (PDFieldDescriptor *field in descriptor.fields) {
        if (![field isSetInMessage:message]) {
            continue;
        }

        id value = [message valueForKey:field.name];
        id serialized = [self writeObject:value descriptor:field.type error:error];
        [result setObject:serialized forKey:field.name];
    }

    return result;
}



+ (id)readObject:(id)object descriptor:(PDDataTypeDescriptor *)descriptor error:(NSError **)error {
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

        case PDTypeList:return [self readList:object descriptor:(PDListDescriptor *) descriptor error:error];
        case PDTypeSet:return [self readSet:object descriptor:(PDSetDescriptor *) descriptor error:error];
        case PDTypeMap:return [self readMap:object descriptor:(PDMapDescriptor *) descriptor error:error];
        case PDTypeVoid:return nil;
        case PDTypeMessage:return [self readMessage:object descriptor:(PDMessageDescriptor *) descriptor error:error];
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

+ (id)readList:(NSArray *)list descriptor:(PDListDescriptor *)descriptor error:(NSError **)error {
    PDDataTypeDescriptor *elementd = descriptor.elementDescriptor;

    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id element in list) {
        id parsed = [self readObject:element descriptor:elementd error:error];
        if (!parsed) {
            return nil;
        }

        [result addObject:parsed];
    }

    return result;
}

+ (id)readSet:(id)object descriptor:(PDSetDescriptor *)descriptor error:(NSError **)error {
    PDDataTypeDescriptor *elementd = descriptor.elementDescriptor;


    NSMutableSet *result = [[NSMutableSet alloc] init];
    for (id element in object) {
        id parsed = [self readObject:element descriptor:elementd error:error];
        if (!parsed) {
            return nil;
        }

        [result addObject:parsed];
    }

    return result;
}

+ (id)readMap:(NSDictionary *)dict descriptor:(PDMapDescriptor *)descriptor error:(NSError **)error {
    PDDataTypeDescriptor *keyd = descriptor.keyDescriptor;
    PDDataTypeDescriptor *valued = descriptor.valueDescriptor;

    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    for (id key in dict) {
        id value = [dict objectForKey:key];
        id parsedKey = [self readObject:key descriptor:keyd error:error];
        id parsedValue = [self readObject:value descriptor:valued error:error];
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

+ (id)readMessage:(NSDictionary *)dict descriptor:(PDMessageDescriptor *)descriptor error:(NSError **)error {
    PDFieldDescriptor *discriminator = descriptor.discriminator;

    if (discriminator) {
        // Mind polymorphic messages.
        // Deserialize the discriminator value and get a subtype descriptor.
        id value = [dict objectForKey:discriminator.name];
        if (value) {
            NSNumber *dvalue = [self readObject:value descriptor:discriminator.type error:error];
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

        id parsed = [self readObject:value descriptor:field.type error:error];
        if (!parsed) {
            return nil;
        }

        [message setValue:parsed forKey:field.name];
    }
    return message;
}

@end
