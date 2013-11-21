// Generated by Pdef Objective-C generator.

#import <Foundation/Foundation.h>
#import "PDef.h"
#import "TestMessage.h"
#import "TestEnum.h"
@class Base;


/** Message with fields of all data types. */
@interface TestComplexMessage : TestMessage
@property (nonatomic) NSNumber *short0;
@property (nonatomic) NSNumber *long0;
@property (nonatomic) NSNumber *float0;
@property (nonatomic) NSNumber *double0;
@property (nonatomic) NSDate *datetime0;
@property (nonatomic) NSArray *list0;
@property (nonatomic) NSSet *set0;
@property (nonatomic) NSDictionary *map0;
@property (nonatomic) TestEnum enum0;
@property (nonatomic) TestMessage *message0;
@property (nonatomic) Base *polymorphic;
@property (nonatomic) TestComplexMessage *datatypes;

+ (PDMessageDescriptor *)typeDescriptor;
@end

