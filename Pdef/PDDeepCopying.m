//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//


#import <Pdef/PDDescriptors.h>
#import <Pdef/PDMessage.h>
#import "PDDeepCopying.h"

@implementation PDDeepCopying
+ (id)copyObject:(id)object descriptor:(PDDataTypeDescriptor *)descriptor {
    NSParameterAssert(descriptor);
    if (!object) {
        return nil;
    }

    PDType type = descriptor.type;
    switch (type) {
        case PDTypeList: return [self copyArray:object descriptor:(PDListDescriptor *) descriptor];
        case PDTypeSet: return [self copySet:object descriptor:(PDSetDescriptor *) descriptor];
        case PDTypeMap: return [self copyDictionary:object descriptor:(PDMapDescriptor *) descriptor];
        case PDTypeMessage: return [self copyMessage:object descriptor:(PDMessageDescriptor *) descriptor];
        default: break;
    }

    return [object copy];
}

+ (PDMessage *)copyMessage:(PDMessage *)message descriptor:(PDMessageDescriptor *)descriptor {
    NSParameterAssert(descriptor);
    if (!message) {
        return nil;
    }

    // Mind polymorphic messages.
    descriptor = message.descriptor;

    PDMessage *copy = [[[message class] alloc] init];
    for (PDFieldDescriptor *field in descriptor.fields) {
        NSString *name = field.name;

        if ([field isSetInMessage:message]) {
            id value = [message valueForKey:name];
            id valueCopy = [self copyObject:value descriptor:field.type];
            [copy setValue:valueCopy forKey:name];
        }
    }

    return copy;
}

+ (NSArray *)copyArray:(NSArray *)array descriptor:(PDListDescriptor *)descriptor {
    NSParameterAssert(descriptor);
    if (!array) {
        return nil;
    }

    NSMutableArray *copy = [NSMutableArray arrayWithCapacity:array.count];
    PDDataTypeDescriptor *elementd = descriptor.elementDescriptor;
    for (id element in array) {
        id elementCopy = [self copyObject:element descriptor:elementd];
        [copy addObject:elementCopy];
    }

    return copy;
}

+ (NSSet *)copySet:(NSSet *)set descriptor:(PDSetDescriptor *)descriptor {
    NSParameterAssert(descriptor);
    if (!set) {
        return nil;
    }

    NSMutableSet *copy = [NSMutableSet setWithCapacity:set.count];
    PDDataTypeDescriptor *elementd = descriptor.elementDescriptor;
    for (id element in set) {
        id elementCopy = [self copyObject:element descriptor:elementd];
        [copy addObject:elementCopy];
    }

    return copy;
}

+ (NSDictionary *)copyDictionary:(NSDictionary *)dictionary descriptor:(PDMapDescriptor *)descriptor {
    NSParameterAssert(descriptor);
    if (!dictionary) {
        return nil;
    }

    NSMutableDictionary *copy = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];
    PDDataTypeDescriptor *keyd = descriptor.keyDescriptor;
    PDDataTypeDescriptor *valued = descriptor.valueDescriptor;
    for (id key in dictionary) {
        id value = [dictionary objectForKey:key];
        id keyCopy = [self copyObject:key descriptor:keyd];
        id valueCopy = [self copyObject:value descriptor:valued];
        [copy setObject:valueCopy forKey:keyCopy];
    }

    return copy;
}
@end
