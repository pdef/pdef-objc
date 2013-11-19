//
//  PDDescriptors.m
//  PdefObjc
//
//  Created by Ivan Korobkov on 18.11.13.
//  Copyright (c) 2013 pdef. All rights reserved.
//

#import "PDDescriptors.h"

@implementation PDDescriptor : NSObject
- (id)initWithType:(PDType)type {
    _type = type;
    return self;
}
@end


@implementation PDDataTypeDescriptor
@end


@implementation PDListDescriptor
- (id)initWithElement:(PDDataTypeDescriptor *)element {
    if (self = [super initWithType:PDTypeList]) {
        if (!element) {
            [NSException raise:NSInvalidArgumentException format:@"nil element"];
        }
        _element = element;
    }
    return self;
}
@end


@implementation PDSetDescriptor
- (id)initWithElement:(PDDataTypeDescriptor *)element {
    if (self = [super initWithType:PDTypeSet]) {
        if (!element) {
            [NSException raise:NSInvalidArgumentException format:@"nil element"];
        }
        _element = element;
    }
    return self;
}
@end


@implementation PDMapDescriptor
- (id)initWithKey:(PDDataTypeDescriptor *)key
            value:(PDDataTypeDescriptor *)value {
    if (self = [super initWithType:PDTypeMap]) {
        if (!key) {
            [NSException raise:NSInvalidArgumentException format:@"nil key"];
        }
        if (!value) {
            [NSException raise:NSInvalidArgumentException format:@"nil value"];
        }
        _key = key;
        _value = value;
    }
    return self;
}
@end


@implementation PDMessageDescriptor {
    NSArray *_subtypeSuppliers;
    NSArray *_subtypes;
}
- (id)initWithClass:(Class)cls fields:(NSArray *)fields {
    return [self initWithClass:cls base:nil discriminatorValue:0 subtypeSuppliers:nil fields:fields];
}

- (id)initWithClass:(Class) cls
               base:(PDMessageDescriptor *)base
discriminatorValue:(NSInteger)discriminatorValue
  subtypeSuppliers:(NSArray *)subtypeSuppliers
            fields:(NSArray *)fields {
    if (self = [super initWithType:PDTypeMessage]) {
        if (!cls) {
            [NSException raise:NSInvalidArgumentException format:@"nil cls"];
        }

        _cls = cls;
        _base = base;
        _fields = (fields) ? fields : @[];
        _discriminatorValue = discriminatorValue;
        _discriminator = [PDMessageDescriptor findDiscriminatorInFields:_fields];
        _subtypeSuppliers = (subtypeSuppliers) ? subtypeSuppliers : @[];
    }
    return self;
}

- (NSArray *)subtypes {
    if (_subtypes != nil) {
        return _subtypes;
    }

    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (PDMessageDescriptor *(^supplier)() in _subtypeSuppliers) {
        [temp addObject:supplier()];
    }

    _subtypes = [[NSArray alloc] initWithArray:temp];
    return _subtypes;
}


- (PDMessageDescriptor *)findSubtypeByDiscriminatorValue:(NSInteger)discriminatorValue {
    for (PDMessageDescriptor *subtype in [self subtypes]) {
        if (subtype.discriminatorValue == discriminatorValue) {
            return subtype;
        }
    }
    return nil;
}

+ (PDFieldDescriptor *)findDiscriminatorInFields:(NSArray *)fields {
    if (!fields) {
        return nil;
    }

    for (PDFieldDescriptor *field in fields) {
        if (field.isDiscriminator) {
            return field;
        }
    }

    return nil;
}

@end


@implementation PDFieldDescriptor {
    PDDataTypeDescriptor *_type;
    PDDataTypeDescriptor *(^_typeSupplier)();
}

- (id)initWithName:(NSString *)name type:(PDDataTypeDescriptor *)type isDiscriminator:(BOOL)isDiscriminator {
    if (self = [super init]) {
        _name = name;
        _type = type;
        _isDiscriminator = isDiscriminator;
    }
    return self;
}

- (id)initWithName:(NSString *)name typeSupplier:(PDDataTypeDescriptor *(^)())typeSupplier
                                 isDiscriminator:(BOOL)isDiscriminator {
    if (self = [super init]) {
        _name = name;
        _typeSupplier = typeSupplier;
        _isDiscriminator = isDiscriminator;
    }
    return self;
}

- (PDDataTypeDescriptor *)type {
    if (!_type) {
        _type = _typeSupplier();
    }

    return _type;
}

@end


@implementation PDDescriptors
static PDDataTypeDescriptor *bool0;
static PDDataTypeDescriptor *int16;
static PDDataTypeDescriptor *int32;
static PDDataTypeDescriptor *int64;
static PDDataTypeDescriptor *float0;
static PDDataTypeDescriptor *double0;

static PDDataTypeDescriptor *string;
static PDDataTypeDescriptor *datetime;
static PDDataTypeDescriptor *void0;

+ (void)initialize {
    bool0 = [[PDDataTypeDescriptor alloc] initWithType:PDTypeBool];
    int16 = [[PDDataTypeDescriptor alloc] initWithType:PDTypeInt16];
    int32 = [[PDDataTypeDescriptor alloc] initWithType:PDTypeInt32];
    int64 = [[PDDataTypeDescriptor alloc] initWithType:PDTypeInt64];
    float0 = [[PDDataTypeDescriptor alloc] initWithType:PDTypeFloat];
    double0 = [[PDDataTypeDescriptor alloc] initWithType:PDTypeDouble];

    string = [[PDDataTypeDescriptor alloc] initWithType:PDTypeString];
    datetime = [[PDDataTypeDescriptor alloc] initWithType:PDTypeDatetime];
    void0 = [[PDDataTypeDescriptor alloc] initWithType:PDTypeVoid];
}

+ (PDDataTypeDescriptor *)bool0 {
    return bool0;
}

+ (PDDataTypeDescriptor *)int16 {
    return int16;
}

+ (PDDataTypeDescriptor *)int32 {
    return int32;
}

+ (PDDataTypeDescriptor *)int64 {
    return int64;
}

+ (PDDataTypeDescriptor *)float0 {
    return float0;
}

+ (PDDataTypeDescriptor *)double0 {
    return double0;
}

+ (PDDataTypeDescriptor *)string {
    return string;
}

+ (PDDataTypeDescriptor *)datetime {
    return datetime;
}

+ (PDDataTypeDescriptor *)void0 {
    return void0;
}

+ (PDListDescriptor *)listWithElement:(PDDataTypeDescriptor *)element {
    return [[PDListDescriptor alloc] initWithElement:element];
}

+ (PDSetDescriptor *)setWithElement:(PDDataTypeDescriptor *)element {
    return [[PDSetDescriptor alloc] initWithElement:element];
}

+ (PDMapDescriptor *)mapWithKey:(PDDataTypeDescriptor *)key
                          value:(PDDataTypeDescriptor *)value {
    return [[PDMapDescriptor alloc] initWithKey:key value:value];
}

@end
