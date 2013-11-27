//
// Created by Ivan Korobkov on 20.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "PDDescriptors.h"
#import "TestMessage.h"
#import "TestComplexMessage.h"
#import "Base.h"
#import "Subtype.h"
#import "Subtype2.h"
#import "MultiLevelSubtype.h"
#import "TestInterface.h"
#import "TestException.h"

@interface PDGeneratedMessageDescriptorTests : XCTestCase
@end

@implementation PDGeneratedMessageDescriptorTests

- (void)test {
    PDMessageDescriptor *descriptor = [TestMessage typeDescriptor];
    XCTAssert(descriptor.cls == [TestMessage class]);
    XCTAssertNil(descriptor.base);
    XCTAssertNil(descriptor.discriminator);
    XCTAssert(descriptor.discriminatorValue == 0);
    XCTAssert(descriptor.subtypes.count == 0);
    XCTAssert(descriptor.fields.count == 3);
}

- (void)testNonpolymorphicInheritance {
    PDMessageDescriptor *base = [TestMessage typeDescriptor];
    PDMessageDescriptor *message = [TestComplexMessage typeDescriptor];

    XCTAssertNil(base.base);
    XCTAssert(message.base == base);
    XCTAssert(message.fields.count == 15);
}

- (void)testPolymorphicInheritance {
    PDMessageDescriptor *base = [Base typeDescriptor];
    PDMessageDescriptor *subtype = [Subtype typeDescriptor];
    PDMessageDescriptor *subtype2 = [Subtype2 typeDescriptor];
    PDMessageDescriptor *msubtype = [MultiLevelSubtype typeDescriptor];
    PDFieldDescriptor *discriminator = base.discriminator;

    XCTAssertNil(base.base);
    XCTAssert(subtype.base == base);
    XCTAssert(subtype2.base == base);
    XCTAssert(msubtype.base == subtype);

    XCTAssert(base.discriminator == discriminator);
    XCTAssert(subtype.discriminator == discriminator);
    XCTAssert(subtype2.discriminator == discriminator);
    XCTAssert(msubtype.discriminator == discriminator);

    XCTAssert(base.discriminatorValue == 0);
    XCTAssert(subtype.discriminatorValue == PolymorphicType_SUBTYPE);
    XCTAssert(subtype2.discriminatorValue == PolymorphicType_SUBTYPE2);
    XCTAssert(msubtype.discriminatorValue == PolymorphicType_MULTILEVEL_SUBTYPE);

    NSSet *expected = [[NSSet alloc] initWithArray:@[subtype, subtype2, msubtype]];
    XCTAssert([base.subtypes isEqualToSet:expected]);
    expected = [[NSSet alloc] initWithArray:@[msubtype]];
    XCTAssert([subtype.subtypes isEqualToSet:expected]);
    XCTAssert(subtype2.subtypes.count == 0);
    XCTAssert(msubtype.subtypes.count == 0);

    XCTAssertNil([base findSubtypeByDiscriminatorValue:0]);
    XCTAssert([base findSubtypeByDiscriminatorValue:PolymorphicType_SUBTYPE] == subtype);
    XCTAssert([base findSubtypeByDiscriminatorValue:PolymorphicType_SUBTYPE2] == subtype2);
    XCTAssert([base findSubtypeByDiscriminatorValue:PolymorphicType_MULTILEVEL_SUBTYPE] == msubtype);
    XCTAssert([subtype findSubtypeByDiscriminatorValue:PolymorphicType_MULTILEVEL_SUBTYPE] == msubtype);
}

@end


@interface PDGeneratedFieldDescriptorTests : XCTestCase
@end

@implementation PDGeneratedFieldDescriptorTests

- (void)test {
    PDFieldDescriptor *string0 = [[TestMessage typeDescriptor] getFieldForName:@"string0"];
    PDFieldDescriptor *bool0 = [[TestMessage typeDescriptor] getFieldForName:@"bool0"];

    XCTAssertEqual(string0.name, @"string0");
    XCTAssertEqual(bool0.name, @"bool0");

    XCTAssertEqual(string0.type, [PDDescriptors string]);
    XCTAssertEqual(bool0.type, [PDDescriptors bool0]);
}

- (void)testDiscriminator {
    PDFieldDescriptor *type = [[Base typeDescriptor] getFieldForName:@"type"];

    XCTAssertEqual(type.name, @"type");
    XCTAssertEqual(type.type, PolymorphicTypeDescriptor());
    XCTAssertTrue(type.discriminator);
}
@end


@interface PDGeneratedInterfaceDescriptorTests : XCTestCase
@end

@implementation PDGeneratedInterfaceDescriptorTests

- (void)test {
    PDInterfaceDescriptor *descriptor = TestInterfaceDescriptor();
    PDMethodDescriptor *method = [descriptor getMethodForName:@"method"];
    XCTAssertEqual(descriptor.protocol, @protocol(TestInterface));
    XCTAssertEqual(descriptor.exc, [TestException typeDescriptor]);
    XCTAssert(descriptor.methods.count == 11);
    XCTAssertNotNil(method);
}
@end


@interface PDGeneratedMethodDescriptorTests : XCTestCase
@end

@implementation PDGeneratedMethodDescriptorTests

- (void) test {
    PDMethodDescriptor *method = [TestInterfaceDescriptor() getMethodForName:@"message0"];

    XCTAssertEqual(method.name, @"message0");
    XCTAssertEqual(method.result, [TestMessage typeDescriptor]);
    XCTAssert(method.args.count == 1);

    PDArgumentDescriptor *arg = [method.args objectAtIndex:0];
    XCTAssertEqual(arg.type, [TestMessage typeDescriptor]);
    XCTAssertEqual(arg.name, @"msg");
}

- (void) testPostTerminal {
    PDInterfaceDescriptor *descriptor = TestInterfaceDescriptor();
    PDMethodDescriptor *method = [descriptor getMethodForName:@"method"];
    PDMethodDescriptor *post = [descriptor getMethodForName:@"post"];
    PDMethodDescriptor *iface = [descriptor getMethodForName:@"interface0"];

    XCTAssertTrue(method.terminal);
    XCTAssertFalse(method.post);

    XCTAssertTrue(post.terminal);
    XCTAssertTrue(post.post);

    XCTAssertFalse(iface.terminal);
    XCTAssertFalse(iface.post);
}
@end


@interface PDGeneratedEnumDescriptorTests : XCTestCase
@end

@implementation PDGeneratedEnumDescriptorTests

- (void) test {
    PDEnumDescriptor *descriptor = TestEnumDescriptor();
    NSDictionary *expected = @{
            @(1): @"ONE",
            @(2): @"TWO",
            @(3): @"THREE",
    };

    XCTAssert([descriptor.numbersToNames isEqualToDictionary:expected]);
}
@end


@interface PDGeneratedListDescriptor : XCTestCase
@end

@implementation PDGeneratedListDescriptor

-(void) test {
    PDListDescriptor *list = [PDDescriptors listWithElement:[TestMessage typeDescriptor]];
    XCTAssertEqual(list.elementDescriptor, [TestMessage typeDescriptor]);
}
@end


@interface PDGeneratedSetDescriptor : XCTestCase
@end

@implementation PDGeneratedSetDescriptor

-(void) test {
    PDSetDescriptor *set = [PDDescriptors setWithElement:[TestMessage typeDescriptor]];
    XCTAssertEqual(set.elementDescriptor, [TestMessage typeDescriptor]);
}
@end


@interface PDGeneratedMapDescriptor : XCTestCase
@end

@implementation PDGeneratedMapDescriptor

- (void) test {
    PDMapDescriptor *map = [PDDescriptors mapWithKey:[PDDescriptors int32] value:[TestMessage typeDescriptor]];
    XCTAssertEqual(map.keyDescriptor, [PDDescriptors int32]);
    XCTAssertEqual(map.valueDescriptor, [TestMessage typeDescriptor]);
}
@end