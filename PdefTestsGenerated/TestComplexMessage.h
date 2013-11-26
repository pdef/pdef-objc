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

- (BOOL) hasShort0;
- (void) clearShort0;

- (BOOL) hasLong0;
- (void) clearLong0;

- (BOOL) hasFloat0;
- (void) clearFloat0;

- (BOOL) hasDouble0;
- (void) clearDouble0;

- (BOOL) hasDatetime0;
- (void) clearDatetime0;

- (BOOL) hasList0;
- (void) clearList0;

- (BOOL) hasSet0;
- (void) clearSet0;

- (BOOL) hasMap0;
- (void) clearMap0;

- (BOOL) hasEnum0;
- (void) clearEnum0;

- (BOOL) hasMessage0;
- (void) clearMessage0;

- (BOOL) hasPolymorphic;
- (void) clearPolymorphic;

- (BOOL) hasDatatypes;
- (void) clearDatatypes;


+ (PDMessageDescriptor *)typeDescriptor;
@end


