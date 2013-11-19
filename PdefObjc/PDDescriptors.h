//
//  PDDescriptors.h
//  PdefObjc
//
//  Created by Ivan Korobkov on 18.11.13.
//  Copyright (c) 2013 pdef. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PDFieldDescriptor;
@class PDMessageDescriptor;


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
@property(readonly, nonatomic) PDDataTypeDescriptor *element;
@end


@interface PDSetDescriptor : PDDataTypeDescriptor
@property(readonly, nonatomic) PDDataTypeDescriptor *element;
@end


@interface PDMapDescriptor : PDDataTypeDescriptor
@property(readonly, nonatomic) PDDataTypeDescriptor *key;
@property(readonly, nonatomic) PDDataTypeDescriptor *value;
@end


@interface PDEnumDescriptor : PDDataTypeDescriptor
@property(readonly, nonatomic) NSDictionary *numbersToNames;
@property(readonly, nonatomic) NSDictionary *namesToNumbers;

- (id)initWithNumbersToNames:(NSDictionary *)numbersToNames;

- (NSNumber *) numberForName:(NSString *)name;

- (NSString *) nameForNumber:(NSNumber *)number;
@end


@interface PDMessageDescriptor : PDDataTypeDescriptor
@property(readonly, nonatomic) Class cls;
@property(readonly, nonatomic) PDMessageDescriptor *base;
@property(readonly, nonatomic) NSArray *fields;
@property(readonly, nonatomic) PDFieldDescriptor *discriminator;
@property(readonly, nonatomic) NSInteger discriminatorValue;
@property(readonly, nonatomic) NSArray *subtypes;

- (id)initWithClass:(Class)cls fields:(NSArray *)fields;

- (id)initWithClass:(Class)cls
               base:(PDMessageDescriptor *)base
 discriminatorValue:(NSInteger)discriminatorValue
   subtypeSuppliers:(NSArray *)subtypeSuppliers
             fields:(NSArray *)fields;

- (PDMessageDescriptor *)findSubtypeByDiscriminatorValue:(NSInteger)discriminatorValue;
@end


@interface PDFieldDescriptor : NSObject
@property(readonly, nonatomic) NSString *name;
@property(readonly, nonatomic) PDDataTypeDescriptor *type;
@property(readonly, nonatomic) BOOL isDiscriminator;

- (id)initWithName:(NSString *)name
              type:(PDDataTypeDescriptor *)type
   isDiscriminator:(BOOL)isDiscriminator;

- (id)initWithName:(NSString *)name
      typeSupplier:(PDDataTypeDescriptor *(^)())typeSupplier
   isDiscriminator:(BOOL)isDiscriminator;
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
