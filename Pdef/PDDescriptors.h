//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//


#import <Foundation/Foundation.h>

@class PDFieldDescriptor;
@class PDMessageDescriptor;
@class PDMessage;


typedef NS_ENUM(NSInteger, PDType) {
    PDTypeBool,
    PDTypeInt16,
    PDTypeInt32,
    PDTypeInt64,
    PDTypeFloat,
    PDTypeDouble,
    PDTypeString,
    PDTypeDatetime,

    PDTypeList,
    PDTypeSet,
    PDTypeMap,

    PDTypeVoid,

    PDTypeEnum,
    PDTypeMessage,
    PDTypeInterface,
};


@interface PDDescriptor : NSObject
@property(readonly, nonatomic) PDType type;
@end


@interface PDDataTypeDescriptor : PDDescriptor
@end


@interface PDListDescriptor : PDDataTypeDescriptor
@property(readonly, nonatomic) PDDataTypeDescriptor *elementDescriptor;
@end


@interface PDSetDescriptor : PDDataTypeDescriptor
@property(readonly, nonatomic) PDDataTypeDescriptor *elementDescriptor;
@end


@interface PDMapDescriptor : PDDataTypeDescriptor
@property(readonly, nonatomic) PDDataTypeDescriptor *keyDescriptor;
@property(readonly, nonatomic) PDDataTypeDescriptor *valueDescriptor;
@end


@interface PDEnumDescriptor : PDDataTypeDescriptor
@property(readonly, nonatomic) NSDictionary *numbersToNames;
@property(readonly, nonatomic) NSDictionary *namesToNumbers;

- (id)initWithNumbersToNames:(NSDictionary *)numbersToNames;

- (NSNumber *)numberForName:(NSString *)name;

- (NSString *)nameForNumber:(NSNumber *)number;
@end


@interface PDMessageDescriptor : PDDataTypeDescriptor
@property(readonly, nonatomic) Class cls;
@property(readonly, nonatomic) PDMessageDescriptor *base;
@property(readonly, nonatomic) NSArray *fields;
@property(readonly, nonatomic) PDFieldDescriptor *discriminator;
@property(readonly, nonatomic) NSInteger discriminatorValue;
@property(readonly, nonatomic) NSSet *subtypes;

- (id)initWithClass:(Class)cls fields:(NSArray *)fields;

- (id)initWithClass:(Class)cls
               base:(PDMessageDescriptor *)base
 discriminatorValue:(NSInteger)discriminatorValue
   subtypeSuppliers:(NSArray *)subtypeSuppliers
             fields:(NSArray *)fields;

- (PDFieldDescriptor *)getFieldForName:(NSString *)name;

- (PDMessageDescriptor *)findSubtypeByDiscriminatorValue:(NSInteger)discriminatorValue;
@end


@interface PDFieldDescriptor : NSObject
@property(readonly, nonatomic) NSString *name;
@property(readonly, nonatomic) PDDataTypeDescriptor *type;
@property(readonly, nonatomic) BOOL discriminator;

- (id)initWithName:(NSString *)name
              type:(PDDataTypeDescriptor *)type
   isDiscriminator:(BOOL)isDiscriminator;

- (id)initWithName:(NSString *)name
      typeSupplier:(PDDataTypeDescriptor *(^)())typeSupplier
     discriminator:(BOOL)discriminator;

- (BOOL) isSetInMessage:(PDMessage *)message;
@end


@interface PDMethodDescriptor : NSObject
@property(readonly, nonatomic) NSString *name;
@property(readonly, nonatomic) PDDescriptor *result;
@property(readonly, nonatomic) NSArray *args;
@property(readonly, nonatomic, getter=isPost) BOOL post;
@property(readonly, nonatomic, getter=isTerminal) BOOL terminal;
@property(readonly, nonatomic, getter=isInterface) BOOL interface;

- (id)initWithName:(NSString *)name
    resultSupplier:(PDDescriptor *(^)())resultSupplier
              args:(NSArray *)args
              post:(BOOL)isPost;
@end


@interface PDArgumentDescriptor : NSObject
@property(readonly, nonatomic) NSString *name;
@property(readonly, nonatomic) PDDataTypeDescriptor *type;
@property(readonly, nonatomic) BOOL post __deprecated;
@property(readonly, nonatomic) BOOL query __deprecated;

- (id)initWithName:(NSString *)name
              type:(PDDataTypeDescriptor *)type;

- (id)initWithName:(NSString *)name
              type:(PDDataTypeDescriptor *)type
              post:(BOOL)isPost
             query:(BOOL)isQuery __deprecated;
@end


@interface PDInterfaceDescriptor : PDDescriptor
@property(readonly, nonatomic) Protocol *protocol;
@property(readonly, nonatomic) PDInterfaceDescriptor *base;
@property(readonly, nonatomic) PDMessageDescriptor *exc;
@property(readonly, nonatomic) NSArray *declaredMethods;
@property(readonly, nonatomic) NSArray *methods;

- (id)initWithProtocol:(Protocol *)protocol
                   exc:(PDMessageDescriptor *)exc
               methods:(NSArray *)methods;

- (id)initWithProtocol:(Protocol *)protocol
                  base:(PDInterfaceDescriptor *)base
                   exc:(PDMessageDescriptor *)exc
               methods:(NSArray *)methods;

- (PDMethodDescriptor *)getMethodForName:(NSString *)name;
@end



@interface PDDescriptors : NSObject
+ (PDDataTypeDescriptor *)bool0;

+ (PDDataTypeDescriptor *)int16;

+ (PDDataTypeDescriptor *)int32;

+ (PDDataTypeDescriptor *)int64;

+ (PDDataTypeDescriptor *)float0;

+ (PDDataTypeDescriptor *)double0;

+ (PDDataTypeDescriptor *)string;

+ (PDDataTypeDescriptor *)datetime;

+ (PDDataTypeDescriptor *)void0;

+ (PDListDescriptor *)listWithElement:(PDDataTypeDescriptor *)element;

+ (PDSetDescriptor *)setWithElement:(PDDataTypeDescriptor *)element;

+ (PDMapDescriptor *)mapWithKey:(PDDataTypeDescriptor *)key
                          value:(PDDataTypeDescriptor *)value;
@end
