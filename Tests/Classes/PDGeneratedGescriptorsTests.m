//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//


#import <XCTest/XCTest.h>
#import "PDDescriptors.h"
#import "PDTestMessage.h"
#import "PDTestComplexMessage.h"
#import "PDBase.h"
#import "PDSubtype.h"
#import "PDSubtype2.h"
#import "PDMultiLevelSubtype.h"
#import "PDTestInterface.h"
#import "PDTestSubInterface.h"
#import "PDTestException.h"
#import "PDTestSubException.h"

@interface PDGeneratedMessageDescriptorTests : XCTestCase
@end

@implementation PDGeneratedMessageDescriptorTests

- (void)test {
    PDMessageDescriptor *descriptor = [PDTestMessage typeDescriptor];
    XCTAssert(descriptor.cls == [PDTestMessage class]);
    XCTAssertNil(descriptor.base);
    XCTAssertNil(descriptor.discriminator);
    XCTAssert(descriptor.discriminatorValue == 0);
    XCTAssert(descriptor.subtypes.count == 0);
    XCTAssert(descriptor.fields.count == 3);
}

- (void)testNonpolymorphicInheritance {
    PDMessageDescriptor *base = [PDTestMessage typeDescriptor];
    PDMessageDescriptor *message = [PDTestComplexMessage typeDescriptor];

    XCTAssertNil(base.base);
    XCTAssert(message.base == base);
    XCTAssert(message.fields.count == 15);
}

- (void)testPolymorphicInheritance {
    PDMessageDescriptor *base = [PDBase typeDescriptor];
    PDMessageDescriptor *subtype = [PDSubtype typeDescriptor];
    PDMessageDescriptor *subtype2 = [PDSubtype2 typeDescriptor];
    PDMessageDescriptor *msubtype = [PDMultiLevelSubtype typeDescriptor];
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
    XCTAssert(subtype.discriminatorValue == PDPolymorphicType_SUBTYPE);
    XCTAssert(subtype2.discriminatorValue == PDPolymorphicType_SUBTYPE2);
    XCTAssert(msubtype.discriminatorValue == PDPolymorphicType_MULTILEVEL_SUBTYPE);

    NSSet *expected = [[NSSet alloc] initWithArray:@[subtype, subtype2, msubtype]];
    XCTAssert([base.subtypes isEqualToSet:expected]);
    expected = [[NSSet alloc] initWithArray:@[msubtype]];
    XCTAssert([subtype.subtypes isEqualToSet:expected]);
    XCTAssert(subtype2.subtypes.count == 0);
    XCTAssert(msubtype.subtypes.count == 0);

    XCTAssertNil([base findSubtypeByDiscriminatorValue:0]);
    XCTAssert([base findSubtypeByDiscriminatorValue:PDPolymorphicType_SUBTYPE] == subtype);
    XCTAssert([base findSubtypeByDiscriminatorValue:PDPolymorphicType_SUBTYPE2] == subtype2);
    XCTAssert([base findSubtypeByDiscriminatorValue:PDPolymorphicType_MULTILEVEL_SUBTYPE] == msubtype);
    XCTAssert([subtype findSubtypeByDiscriminatorValue:PDPolymorphicType_MULTILEVEL_SUBTYPE] == msubtype);
}

@end


@interface PDGeneratedFieldDescriptorTests : XCTestCase
@end

@implementation PDGeneratedFieldDescriptorTests

- (void)test {
    PDFieldDescriptor *string0 = [[PDTestMessage typeDescriptor] getFieldForName:@"string0"];
    PDFieldDescriptor *bool0 = [[PDTestMessage typeDescriptor] getFieldForName:@"bool0"];

    XCTAssertEqual(string0.name, @"string0");
    XCTAssertEqual(bool0.name, @"bool0");

    XCTAssertEqual(string0.type, [PDDescriptors string]);
    XCTAssertEqual(bool0.type, [PDDescriptors bool0]);
}

- (void)testDiscriminator {
    PDFieldDescriptor *type = [[PDBase typeDescriptor] getFieldForName:@"type"];

    XCTAssertEqual(type.name, @"type");
    XCTAssertEqual(type.type, PDPolymorphicTypeDescriptor());
    XCTAssertTrue(type.discriminator);
}
@end


@interface PDGeneratedInterfaceDescriptorTests : XCTestCase
@end

@implementation PDGeneratedInterfaceDescriptorTests

- (void)test {
    PDInterfaceDescriptor *descriptor = PDTestInterfaceDescriptor();
    PDMethodDescriptor *method = [descriptor getMethodForName:@"method"];
    XCTAssertEqual(descriptor.protocol, @protocol(PDTestInterface));
    XCTAssertEqual(descriptor.exc, [PDTestException typeDescriptor]);
    XCTAssert(descriptor.methods.count == 13);
    XCTAssertNotNil(method);
}

- (void)testInheritance {
    PDInterfaceDescriptor *descriptor = PDTestSubInterfaceDescriptor();
    PDMethodDescriptor *subMethod = [descriptor getMethodForName:@"subMethod"];

    XCTAssertEqual(descriptor.protocol, @protocol(PDTestSubInterface));
    XCTAssertEqual(descriptor.exc, [PDTestException typeDescriptor]);
    XCTAssert(descriptor.declaredMethods.count == 1);
    XCTAssert(descriptor.methods.count == 14);
    XCTAssertNotNil(subMethod);
}
@end


@interface PDGeneratedMethodDescriptorTests : XCTestCase
@end

@implementation PDGeneratedMethodDescriptorTests

- (void) test {
    PDMethodDescriptor *method = [PDTestInterfaceDescriptor() getMethodForName:@"message0"];

    XCTAssertEqual(method.name, @"message0");
    XCTAssertEqual(method.result, [PDTestMessage typeDescriptor]);
    XCTAssert(method.args.count == 1);

    PDArgumentDescriptor *arg = [method.args objectAtIndex:0];
    XCTAssertEqual(arg.type, [PDTestMessage typeDescriptor]);
    XCTAssertEqual(arg.name, @"msg");
}

- (void) testPostTerminal {
    PDInterfaceDescriptor *descriptor = PDTestInterfaceDescriptor();
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
    PDEnumDescriptor *descriptor = PDTestEnumDescriptor();
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
    PDListDescriptor *list = [PDDescriptors listWithElement:[PDTestMessage typeDescriptor]];
    XCTAssertEqual(list.elementDescriptor, [PDTestMessage typeDescriptor]);
}
@end


@interface PDGeneratedSetDescriptor : XCTestCase
@end

@implementation PDGeneratedSetDescriptor

-(void) test {
    PDSetDescriptor *set = [PDDescriptors setWithElement:[PDTestMessage typeDescriptor]];
    XCTAssertEqual(set.elementDescriptor, [PDTestMessage typeDescriptor]);
}
@end


@interface PDGeneratedMapDescriptor : XCTestCase
@end

@implementation PDGeneratedMapDescriptor

- (void) test {
    PDMapDescriptor *map = [PDDescriptors mapWithKey:[PDDescriptors int32] value:[PDTestMessage typeDescriptor]];
    XCTAssertEqual(map.keyDescriptor, [PDDescriptors int32]);
    XCTAssertEqual(map.valueDescriptor, [PDTestMessage typeDescriptor]);
}
@end