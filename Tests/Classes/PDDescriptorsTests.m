//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//

#import <XCTest/XCTest.h>
#import "PDDescriptors.h"

@interface PDFixtureMessage : NSObject
@end

@implementation PDFixtureMessage
@end


@interface PDDescriptorsTests : XCTestCase
@end

@implementation PDDescriptorsTests

- (void)testPrimitives {
    XCTAssert([PDDescriptors bool0].type == PDTypeBool);
    XCTAssert([PDDescriptors int16].type == PDTypeInt16);
    XCTAssert([PDDescriptors int32].type == PDTypeInt32);
    XCTAssert([PDDescriptors int64].type == PDTypeInt64);
    XCTAssert([PDDescriptors float0].type == PDTypeFloat);
    XCTAssert([PDDescriptors double0].type == PDTypeDouble);

    XCTAssert([PDDescriptors string].type == PDTypeString);
    XCTAssert([PDDescriptors datetime].type == PDTypeDatetime);
    XCTAssert([PDDescriptors void0].type == PDTypeVoid);
}

- (void)testList {
    PDListDescriptor *list = [PDDescriptors listWithElement:[PDDescriptors int32]];
    XCTAssert(list.type == PDTypeList);
    XCTAssert(list.elementDescriptor.type == PDTypeInt32);
}

- (void)testSet {
    PDSetDescriptor *set = [PDDescriptors setWithElement:[PDDescriptors int32]];
    XCTAssert(set.type == PDTypeSet);
    XCTAssert(set.elementDescriptor.type == PDTypeInt32);
}

- (void)testMap {
    PDMapDescriptor *map = [PDDescriptors mapWithKey:[PDDescriptors int32] value:[PDDescriptors float0]];
    XCTAssert(map.type == PDTypeMap);
    XCTAssert(map.keyDescriptor.type == PDTypeInt32);
    XCTAssert(map.valueDescriptor.type == PDTypeFloat);
}

@end


@interface PDEnumDescriptorTests : XCTestCase
@end

@implementation PDEnumDescriptorTests
- (void)testValues {
    PDEnumDescriptor *descriptor = [[PDEnumDescriptor alloc] initWithNumbersToNames:@{
            @1 : @"one",
            @2 : @"two",
            @3 : @"three"
    }];

    XCTAssertEqual([descriptor numberForName:@"one"], @1);
    XCTAssertEqual([descriptor numberForName:@"two"], @2);
    XCTAssertEqual([descriptor numberForName:@"three"], @3);
    XCTAssertNil([descriptor numberForName:@"four"]);

    XCTAssertEqual([descriptor nameForNumber:@1], @"one");
    XCTAssertEqual([descriptor nameForNumber:@2], @"two");
    XCTAssertEqual([descriptor nameForNumber:@3], @"three");
    XCTAssertNil([descriptor nameForNumber:@4]);
}
@end


@interface PDFieldDescriptorTests : XCTestCase
@end

@implementation PDFieldDescriptorTests
- (void)testType {
    PDFieldDescriptor *field = [[PDFieldDescriptor alloc] initWithName:@"field"
                                                                  type:[PDDescriptors int32]
                                                       isDiscriminator:NO];

    XCTAssertTrue([field.name isEqualToString:@"field"]);
    XCTAssert(field.type == [PDDescriptors int32]);
}

- (void)testTypeSupplier {
    PDFieldDescriptor *field = [[PDFieldDescriptor alloc] initWithName:@"field"
                                                          typeSupplier:^PDDataTypeDescriptor *() {
                                                              return [PDDescriptors int32];
                                                          }
                                                         discriminator:NO];

    XCTAssertTrue([field.name isEqualToString:@"field"]);
    XCTAssert(field.type == [PDDescriptors int32]);
}
@end


@interface PDMessageDescriptorTests : XCTestCase
@end

@implementation PDMessageDescriptorTests
- (void)testFields {
    PDMessageDescriptor *message = [[PDMessageDescriptor alloc] initWithClass:[PDFixtureMessage class] fields:@[
            [[PDFieldDescriptor alloc] initWithName:@"int32" type:[PDDescriptors int32] isDiscriminator:NO],
            [[PDFieldDescriptor alloc] initWithName:@"string" type:[PDDescriptors string] isDiscriminator:NO]
    ]];

    XCTAssertNil(message.base);
    XCTAssert([message.fields count] == 2);

    PDFieldDescriptor *field = [message.fields objectAtIndex:0];
    XCTAssert(field.type == [PDDescriptors int32]);
    XCTAssert([field.name isEqualToString:@"int32"]);

    field = [message.fields objectAtIndex:1];
    XCTAssert(field.type == [PDDescriptors string]);
    XCTAssert([field.name isEqualToString:@"string"]);
}

- (void)testDiscriminator {
    PDFieldDescriptor *field0 = [[PDFieldDescriptor alloc] initWithName:@"field" type:[PDDescriptors string]
                                                        isDiscriminator:NO];
    PDFieldDescriptor *field1 = [[PDFieldDescriptor alloc] initWithName:@"type" type:[PDDescriptors int32]
                                                        isDiscriminator:YES];

    PDMessageDescriptor *message = [[PDMessageDescriptor alloc] initWithClass:[PDFixtureMessage class]
                                                                       fields:@[field0, field1]];
    XCTAssert(message.discriminator == field1);
}

- (void)testSubtypes {
    PDMessageDescriptor __block *subtype0;
    PDMessageDescriptor __block *subtype1;
    PDMessageDescriptor *base = [[PDMessageDescriptor alloc]
            initWithClass:[PDFixtureMessage class]
                     base:nil
       discriminatorValue:0
         subtypeSuppliers:@[
                 ^PDMessageDescriptor *() {
                     return subtype0;
                 },
                 ^PDMessageDescriptor *() {
                     return subtype1;
                 }]
                   fields:nil];
    subtype0 = [[PDMessageDescriptor alloc] initWithClass:[PDFixtureMessage class]
                                                     base:nil
                                       discriminatorValue:1
                                         subtypeSuppliers:nil
                                                   fields:nil];
    subtype1 = [[PDMessageDescriptor alloc] initWithClass:[PDFixtureMessage class]
                                                     base:nil
                                       discriminatorValue:2
                                         subtypeSuppliers:nil
                                                   fields:nil];

    XCTAssert([base findSubtypeByDiscriminatorValue:1] == subtype0);
    XCTAssert([base findSubtypeByDiscriminatorValue:2] == subtype1);
    XCTAssert([base findSubtypeByDiscriminatorValue:3] == nil);
}
@end
