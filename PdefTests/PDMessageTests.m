//
// Created by Ivan Korobkov on 26.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "TestMessage.h"
#import "TestComplexMessage.h"
#import "MultiLevelSubtype.h"
#import "Subtype2.h"


@interface PDMessageTests : XCTestCase
@end

@implementation PDMessageTests

- (void)testSetDiscriminatorValueInConstructor {
    Base *base = [[Base alloc] init];
    Subtype *subtype = [[Subtype alloc] init];
    Subtype2 *subtype2 = [[Subtype2 alloc] init];
    MultiLevelSubtype *msubtype = [[MultiLevelSubtype alloc] init];

    XCTAssert(base.type == 0);
    XCTAssert(subtype.type == PolymorphicType_SUBTYPE);
    XCTAssert(subtype2.type == PolymorphicType_SUBTYPE2);
    XCTAssert(msubtype.type == PolymorphicType_MULTILEVEL_SUBTYPE);
}

- (void)testInitWithDictionary {
    TestMessage *expected = [[TestMessage alloc] init];
    expected.bool0 = YES;
    expected.int0 = 123;
    expected.string0 = @"hello";

    TestMessage *message = [[TestMessage alloc] initWithDictionary:@{
            @"bool0": @YES,
            @"int0": @"123",
            @"string0": @"hello"}];

    XCTAssert([message isEqual:expected]);
}

- (void)testToDictionary {
    TestMessage *message = [[TestMessage alloc] init];
    message.bool0 = YES;
    message.int0 = 123;
    message.string0 = @"hello";

    NSDictionary *expected = @{
            @"bool0": @YES,
            @"int0": @123,
            @"string0": @"hello"};

    XCTAssert([[message toDictionary] isEqual:expected]);
}

- (void)testIsEqual {
    TestMessage *message0 = [[TestMessage alloc] init];
    message0.int0 = 123;
    message0.bool0 = YES;
    message0.string0 = @"hello, world";

    TestMessage *message1 = [[TestMessage alloc] init];
    message1.int0 = 123;
    message1.bool0 = YES;
    message1.string0 = @"hello, world";

    XCTAssertEqualObjects(message0, message1);
    message1.string0 = @"goodbye, world";
    XCTAssertNotEqualObjects(message0, message1);
}

- (void)testIsEqualSubclass {
    TestComplexMessage *message0 = [[TestComplexMessage alloc] init];
    message0.int0 = 123;
    message0.list0 = @[@1, @2, @3];
    message0.map0 = @{@1: @1.5, @2: @2.5};

    TestComplexMessage *message1 = [[TestComplexMessage alloc] init];
    message1.int0 = 123;
    message1.list0 = @[@1, @2, @3];
    message1.map0 = @{@1: @1.5, @2: @2.5};

    XCTAssertEqualObjects(message0, message1);
}

- (void)testIsEqualPolymorphic {
    MultiLevelSubtype *subtype = [[MultiLevelSubtype alloc] init];
    subtype.field = @"hello";
    subtype.subfield = @"world";

    MultiLevelSubtype *subtype1 = [[MultiLevelSubtype alloc] init];
    subtype1.field = @"hello";
    subtype1.subfield = @"world";

    [subtype isEqual:subtype1];

    XCTAssertEqualObjects(subtype, subtype1);
}

- (void)testCopy {
    TestMessage *message0 = [[TestMessage alloc] init];
    message0.int0 = 123;
    message0.bool0 = YES;
    message0.string0 = @"hello, world";

    TestMessage *message1 = [message0 copy];
    XCTAssertEqualObjects(message0, message1);
}

- (void)testCopySubclass {
    TestComplexMessage *message0 = [[TestComplexMessage alloc] init];
    message0.int0 = 123;
    message0.list0 = @[@1, @2, @3];

    TestComplexMessage *message1 = [message0 copy];
    XCTAssertEqualObjects(message0, message1);
}

- (void)testCopyPolymorphic {
    MultiLevelSubtype *subtype = [[MultiLevelSubtype alloc] init];
    subtype.field = @"hello";
    subtype.subfield = @"world";

    MultiLevelSubtype *subtype1 = [subtype copy];
    XCTAssertEqualObjects(subtype, subtype1);
}

- (void)testCopy_deepCopy {
    TestComplexMessage *message = [[TestComplexMessage alloc] init];
    message.int0 = 10;
    message.message0 = [[TestMessage alloc] init];
    message.message0.string0 = @"hello, world";

    TestComplexMessage *copy = [message copy];
    XCTAssertEqualObjects(copy, message);
    XCTAssert(copy.message0 != message.message0);
}
@end