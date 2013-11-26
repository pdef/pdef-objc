//
// Created by Ivan Korobkov on 26.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import "PDObjectFormat.h"
#import "PDDescriptors.h"
#import "PDMessage.h"


@implementation PDObjectFormat {
    NSDateFormatter *_formatter;
}
static PDObjectFormat *_sharedInstance;
static dispatch_once_t _sharedOnce;

- (id)init {
    if (self = [super init]) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        _formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    }
    return self;
}

+ (PDObjectFormat *)sharedInstance {
    dispatch_once(&_sharedOnce, ^() {
        _sharedInstance = [[PDObjectFormat alloc] init];
    });

    return _sharedInstance;
}

#pragma mark toObject
- (id)toObject:(id)object descriptor:(PDDescriptor *)descriptor {
    if (!descriptor) {
        [NSException raise:NSInvalidArgumentException format:@"nil descriptor"];
    }
    if (!object) {
        return nil;
    }

    PDType type = descriptor.type;
    switch (type) {
        case PDTypeBool:
        case PDTypeInt16:
        case PDTypeInt32:
        case PDTypeInt64:
        case PDTypeFloat:
        case PDTypeDouble: return object;
        case PDTypeString:
        case PDTypeDatetime: return [object copy];
        case PDTypeList: return [self writeList:object descriptor:(PDListDescriptor *) descriptor];
        case PDTypeSet: return [self writeSet:object descriptor:(PDSetDescriptor *) descriptor];
        case PDTypeMap: return [self writeMap:object descriptor:(PDMapDescriptor *) descriptor];
        case PDTypeVoid: return nil;
        case PDTypeEnum: return [self writeEnum:object descriptor:(PDEnumDescriptor *)descriptor];
        case PDTypeMessage: return [self messageToDict:object descriptor:(PDMessageDescriptor *) descriptor];
        case PDTypeInterface: return nil;
    }

    return nil;
}

- (id)writeList:(NSArray *)list descriptor:(PDListDescriptor *)descriptor {
    PDDataTypeDescriptor *elementd = descriptor.elementDescriptor;

    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id element in list) {
        id serialized = [self toObject:element descriptor:elementd];
        if (!serialized) {
            continue;
        }

        [result addObject:serialized];
    }

    return result;
}

- (id)writeSet:(NSSet *)set descriptor:(PDSetDescriptor *)descriptor {
    PDDataTypeDescriptor *elementd = descriptor.elementDescriptor;

    NSMutableSet *result = [[NSMutableSet alloc] init];
    for (id element in set) {
        id serialized = [self toObject:element descriptor:elementd];
        if (!serialized) {
            continue;
        }

        [result addObject:serialized];
    }

    return result;
}

- (id)writeMap:(NSDictionary *)dict descriptor:(PDMapDescriptor *)descriptor {
    PDDataTypeDescriptor *keyd = descriptor.keyDescriptor;
    PDDataTypeDescriptor *valued = descriptor.valueDescriptor;

    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    for (id key in dict) {
        id value = [dict objectForKey:key];
        id serializedKey = [self toObject:key descriptor:keyd];
        id serializedValue = [self toObject:value descriptor:valued];
        if (!serializedKey || !serializedValue) {
            continue;
        }

        [result setObject:serializedValue forKey:serializedKey];
    }

    return result;
}

- (id)writeEnum:(NSNumber *)number descriptor:(PDEnumDescriptor *)descriptor {
    return [[descriptor.numbersToNames objectForKey:number] lowercaseString];
}


- (id)messageToDict:(PDMessage *)message descriptor:(PDMessageDescriptor *)descriptor {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

    // Mind polymorphic messages.
    descriptor = [message descriptor];
    for (PDFieldDescriptor *field in descriptor.fields) {
        if (![field isSetInMessage:message]) {
            continue;
        }

        id value = [message valueForKey:field.name];
        id serialized = [self toObject:value descriptor:field.type];
        [result setObject:serialized forKey:field.name];
    }

    return result;
}

#pragma mark fromObject
- (id)fromObject:(id)object descriptor:(PDDescriptor *)descriptor {
    id result = [self readObject:object descriptor:descriptor];
    return result;
}

- (id)readObject:(id)object descriptor:(PDDescriptor *)descriptor {
    if (!descriptor) {
        [NSException raise:NSInvalidArgumentException format:@"nil descriptor"];
    }

    if (!object) {
        return nil;
    }

    PDType type = descriptor.type;
    switch (type) {
        case PDTypeBool:
        case PDTypeInt16:
        case PDTypeInt32:
        case PDTypeInt64:
        case PDTypeFloat:
        case PDTypeDouble:return [self readNumber:object type:type];
        case PDTypeString:return [self readString:object];
        case PDTypeDatetime:return [self readDatetime:object];
        case PDTypeList:return [self readList:object descriptor:(PDListDescriptor *) descriptor];
        case PDTypeSet:return [self readSet:object descriptor:(PDSetDescriptor *) descriptor];
        case PDTypeMap:return [self readMap:object descriptor:(PDMapDescriptor *) descriptor];
        case PDTypeVoid:return nil;
        case PDTypeEnum:return [self readEnum:object descriptor:(PDEnumDescriptor *) descriptor];
        case PDTypeMessage:return [self readMessage:object descriptor:(PDMessageDescriptor *) descriptor];
        case PDTypeInterface:nil;
    }
    return nil;
}

- (id)readNumber:(id)object type:(PDType)type {
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

- (id)readString:(NSString *)string {
    return string;
}

- (id)readDatetime:(id)object {
    if ([object isKindOfClass:[NSDate class]]) {
        return [object copy];
    }

    NSString *string = object;
    return [_formatter dateFromString:string];
}

- (id)readList:(NSArray *)list descriptor:(PDListDescriptor *)descriptor {
    PDDataTypeDescriptor *elementd = descriptor.elementDescriptor;

    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id element in list) {
        id parsed = [self fromObject:element descriptor:elementd];
        [result addObject:parsed];
    }

    return result;
}

- (id)readSet:(id)object descriptor:(PDSetDescriptor *)descriptor {
    PDDataTypeDescriptor *elementd = descriptor.elementDescriptor;


    NSMutableSet *result = [[NSMutableSet alloc] init];
    for (id element in object) {
        id parsed = [self fromObject:element descriptor:elementd];
        [result addObject:parsed];
    }

    return result;
}

- (id)readMap:(NSDictionary *)dict descriptor:(PDMapDescriptor *)descriptor {
    PDDataTypeDescriptor *keyd = descriptor.keyDescriptor;
    PDDataTypeDescriptor *valued = descriptor.valueDescriptor;

    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    for (id key in dict) {
        id value = [dict objectForKey:key];
        id parsedKey = [self fromObject:key descriptor:keyd];
        id parsedValue = [self fromObject:value descriptor:valued];
        [result setObject:parsedValue forKey:parsedKey];
    }

    return result;
}

- (id)readEnum:(id)object descriptor:(PDEnumDescriptor *)descriptor {
    if ([object isKindOfClass:[NSNumber class]]) {
        NSNumber *number = object;
        if ([descriptor.numbersToNames doesContain:number]) {
            return number;
        } else {
            return @0;
        }
    }

    NSString *string = [((NSString *) object) uppercaseString];
    return [descriptor.namesToNumbers objectForKey:string];
}

- (id)readMessage:(NSDictionary *)dict descriptor:(PDMessageDescriptor *)descriptor {
    PDFieldDescriptor *discriminator = descriptor.discriminator;

    if (discriminator) {
        // Mind polymorphic messages.
        // Deserialize the discriminator value and get a subtype descriptor.
        id value = [dict objectForKey:discriminator.name];
        if (value) {
            NSNumber *dvalue = [self fromObject:value descriptor:discriminator.type];
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

        id parsed = [self fromObject:value descriptor:field.type];
        [message setValue:parsed forKey:field.name];
    }

    return message;
}

@end
