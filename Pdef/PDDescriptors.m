//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//


#import "PDDescriptors.h"
#import "PDMessage.h"

@implementation PDDescriptor : NSObject
- (id)initWithType:(PDType)type {
    _type = type;
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"Descriptor: type=%d", _type];
}
@end


@implementation PDDataTypeDescriptor
@end


@implementation PDListDescriptor
- (id)initWithElementDescriptor:(PDDataTypeDescriptor *)elementDescriptor {
    if (self = [super initWithType:PDTypeList]) {
        if (!elementDescriptor) {
            [NSException raise:NSInvalidArgumentException format:@"nil elementDescriptor"];
        }
        _elementDescriptor = elementDescriptor;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"List: element=%@", _elementDescriptor];
}
@end


@implementation PDSetDescriptor
- (id)initWithElementDescriptor:(PDDataTypeDescriptor *)elementDescriptor {
    if (self = [super initWithType:PDTypeSet]) {
        if (!elementDescriptor) {
            [NSException raise:NSInvalidArgumentException format:@"nil elementDescriptor"];
        }
        _elementDescriptor = elementDescriptor;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"Set: element=%@", _elementDescriptor];
}
@end


@implementation PDMapDescriptor
- (id)initWithKeyDescriptor:(PDDataTypeDescriptor *)keyDescriptor
            valueDescriptor:(PDDataTypeDescriptor *)valueDescriptor {
    if (self = [super initWithType:PDTypeMap]) {
        if (!keyDescriptor) {
            [NSException raise:NSInvalidArgumentException format:@"nil keyDescriptor"];
        }
        if (!valueDescriptor) {
            [NSException raise:NSInvalidArgumentException format:@"nil valueDescriptor"];
        }
        _keyDescriptor = keyDescriptor;
        _valueDescriptor = valueDescriptor;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"Map: key=%@, value=%@", _keyDescriptor, _valueDescriptor];
}
@end


@implementation PDEnumDescriptor
- (id)initWithNumbersToNames:(NSDictionary *)numbersToNames {
    if (self = [super initWithType:PDTypeEnum]) {
        _numbersToNames = [[NSDictionary alloc] initWithDictionary:numbersToNames];

        NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
        for (NSNumber *number in numbersToNames) {
            NSString *name = [numbersToNames objectForKey:number];
            [temp setObject:number forKey:name];
        }
        _namesToNumbers = [[NSDictionary alloc] initWithDictionary:temp];
    }
    return self;
}

- (NSNumber *)numberForName:(NSString *)name {
    return [_namesToNumbers objectForKey:name];
}

- (NSString *)nameForNumber:(NSNumber *)number {
    return [_numbersToNames objectForKey:number];
}
@end


@implementation PDMessageDescriptor {
    NSArray *_subtypeSuppliers;
    NSSet *_subtypes;
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
        _fields = [PDMessageDescriptor mergeFields:fields base:base];
        _discriminatorValue = discriminatorValue;
        _discriminator = [PDMessageDescriptor findDiscriminatorInFields:_fields];
        _subtypeSuppliers = (subtypeSuppliers) ? subtypeSuppliers : @[];
    }

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"Message: class=%@", _cls];
}

- (NSSet *)subtypes {
    if (_subtypes != nil) {
        return _subtypes;
    }

    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (PDMessageDescriptor *(^supplier)() in _subtypeSuppliers) {
        [temp addObject:supplier()];
    }

    _subtypes = [[NSSet alloc] initWithArray:temp];
    return _subtypes;
}

- (PDFieldDescriptor *)getFieldForName:(NSString *)name {
    for (PDFieldDescriptor *field in _fields) {
        if ([field.name isEqualToString:name]) {
            return field;
        }
    }
    return nil;
}


- (PDMessageDescriptor *)findSubtypeByDiscriminatorValue:(NSInteger)discriminatorValue {
    for (PDMessageDescriptor *subtype in [self subtypes]) {
        if (subtype.discriminatorValue == discriminatorValue) {
            return subtype;
        }
    }
    return nil;
}

+ (NSArray *)mergeFields:(NSArray *)declaredFields
                    base:(PDMessageDescriptor *)base {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    if (base) {
        [temp addObjectsFromArray:base.fields];
    }
    if (declaredFields) {
        [temp addObjectsFromArray:declaredFields];
    }
    
    return [[NSArray alloc] initWithArray:temp];
}

+ (PDFieldDescriptor *)findDiscriminatorInFields:(NSArray *)fields {
    if (!fields) {
        return nil;
    }

    for (PDFieldDescriptor *field in fields) {
        if (field.discriminator) {
            return field;
        }
    }

    return nil;
}

@end


@implementation PDFieldDescriptor {
    PDDataTypeDescriptor *_type;
    PDDataTypeDescriptor *(^_typeSupplier)();
    SEL _isSetSelector;
}

- (id)initWithName:(NSString *)name type:(PDDataTypeDescriptor *)type isDiscriminator:(BOOL)isDiscriminator {
    if (!type) {
        [NSException raise:NSInvalidArgumentException format:@"nil type"];
    }
    return [self initWithName:name
                 typeSupplier:^PDDataTypeDescriptor *() {
                     return type;
                 }
                discriminator:isDiscriminator];
}

- (id)initWithName:(NSString *)name typeSupplier:(PDDataTypeDescriptor *(^)())typeSupplier
                                   discriminator:(BOOL)discriminator {
    if (self = [super init]) {
        if (!name) {
            [NSException raise:NSInvalidArgumentException format:@"nil name"];
        }
        if (!typeSupplier) {
            [NSException raise:NSInvalidArgumentException format:@"nil typeSupplier"];
        }
        _name = name;
        _typeSupplier = typeSupplier;
        _discriminator = discriminator;

        // Uppercase the first letter of the field name and prepent to "has" to get "hasField".
        NSString *sel = [NSString stringWithFormat:@"has%@%@",
                        [[name substringToIndex:1] uppercaseString],
                        [name substringFromIndex:1] ];
        _isSetSelector = NSSelectorFromString(sel);
    }
    return self;
}

- (BOOL)isSetInMessage:(PDMessage *)message {
    return (BOOL) [message performSelector:_isSetSelector];
}


- (NSString *)description {
    return [NSString stringWithFormat: @"Field: name=%@ type=%@", _name, self.type];
}

- (PDDataTypeDescriptor *)type {
    if (!_type) {
        _type = _typeSupplier();
    }

    return _type;
}
@end


@implementation PDInterfaceDescriptor {
    PDMessageDescriptor *_exc;
}

- (id)initWithProtocol:(Protocol *)protocol exc:(PDMessageDescriptor *)exc methods:(NSArray *)methods {
    return [self initWithProtocol:protocol base:nil exc:exc methods:methods];
}

- (id)initWithProtocol:(Protocol *)protocol
                  base:(PDInterfaceDescriptor *)base
                   exc:(PDMessageDescriptor *)exc
               methods:(NSArray *)methods {
    NSParameterAssert(protocol);

    if (self = [super initWithType:PDTypeInterface]) {
        _protocol = protocol;
        _base = base;
        _exc = exc;
        _declaredMethods = (methods) ? [[NSArray alloc] initWithArray:methods] : @[];
        _methods = [self joinMethodsFromBase:base withDeclaredMethods:methods];
    }
    return self;
}

- (PDMessageDescriptor *)exc {
    return _exc ? _exc : (_base ? _base.exc : nil);
}

- (PDMethodDescriptor *)getMethodForName:(NSString *)name {
    for (PDMethodDescriptor *method in _methods) {
        if ([method.name isEqualToString:name]) {
            return method;
        }
    }
    return nil;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"Interface: protocol=%@", _protocol];
}

- (NSArray *)joinMethodsFromBase:(PDInterfaceDescriptor *)base withDeclaredMethods:(NSArray *)declaredMethods {
    if (!base) {
        return declaredMethods;
    }

    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObjectsFromArray:base.methods];
    [result addObjectsFromArray:declaredMethods];

    return [[NSArray alloc] initWithArray:result];
}
@end


@implementation PDMethodDescriptor {
    PDDescriptor *_result;
    PDDescriptor *(^_resultSupplier)();
}

- (id)initWithName:(NSString *)name
    resultSupplier:(PDDescriptor *(^)())resultSupplier
              args:(NSArray *)args
              post:(BOOL)isPost {
    if (self = [super init]) {
        if (!name) {
            [NSException raise:NSInvalidArgumentException format:@"nil name"];
        }
        if (!resultSupplier) {
            [NSException raise:NSInvalidArgumentException format:@"nil resultSupplier"];
        }
        _name = name;
        _resultSupplier = resultSupplier;
        _args = (args) ? [[NSArray alloc] initWithArray:args] : @[];
        _post = isPost;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"Method: name=%@", _name];
}

- (PDDescriptor *)result {
    if (!_result) {
        _result = _resultSupplier();
    }
    return _result;
}

- (BOOL)isTerminal {
    return self.result.type != PDTypeInterface;
}

- (BOOL)isInterface {
    return !self.isTerminal;
}
@end


@implementation PDArgumentDescriptor
- (id)initWithName:(NSString *)name type:(PDDataTypeDescriptor *)type {
    if (self = [super init]) {
        NSParameterAssert(name);
        NSParameterAssert(type);

        _name = name;
        _type = type;
    }

    return self;
}

- (id)initWithName:(NSString *)name type:(PDDataTypeDescriptor *)type post:(BOOL)isPost query:(BOOL)isQuery {
    if (self = [super init]) {
        NSParameterAssert(name != nil);
        NSParameterAssert(type != nil);

        _name = name;
        _type = type;
        _post = isPost;
        _query = isQuery;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"Argument: name=%@ type=%@", _name, _type];
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
    return [[PDListDescriptor alloc] initWithElementDescriptor:element];
}

+ (PDSetDescriptor *)setWithElement:(PDDataTypeDescriptor *)element {
    return [[PDSetDescriptor alloc] initWithElementDescriptor:element];
}

+ (PDMapDescriptor *)mapWithKey:(PDDataTypeDescriptor *)key
                          value:(PDDataTypeDescriptor *)value {
    return [[PDMapDescriptor alloc] initWithKeyDescriptor:key valueDescriptor:value];
}

@end