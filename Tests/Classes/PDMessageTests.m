//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//


#import <XCTest/XCTest.h>
#import "PDTestMessage.h"
#import "PDTestComplexMessage.h"
#import "PDMultiLevelSubtype.h"
#import "PDSubtype2.h"


@interface PDMessageTests : XCTestCase
@end

@implementation PDMessageTests
- (void)testSetDiscriminatorValueInConstructor {
    PDBase *base = [[PDBase alloc] init];
    PDSubtype *subtype = [[PDSubtype alloc] init];
    PDSubtype2 *subtype2 = [[PDSubtype2 alloc] init];
    PDMultiLevelSubtype *msubtype = [[PDMultiLevelSubtype alloc] init];

    XCTAssert(base.type == 0);
    XCTAssert(subtype.type == PDPolymorphicType_SUBTYPE);
    XCTAssert(subtype2.type == PDPolymorphicType_SUBTYPE2);
    XCTAssert(msubtype.type == PDPolymorphicType_MULTILEVEL_SUBTYPE);
}

- (void)testInitWithDictionary {
    PDTestMessage *expected = [self fixtureMessage];
    PDTestMessage *message = [PDTestMessage messageWithDictionary:[self fixtureDictionary]];

    XCTAssert([message isEqual:expected]);
}

- (void)testInitWithJson {
    NSError *error = nil;
    NSData *json = [[self fixtureComplexMessage] toJsonError:&error];
    XCTAssert(!error);

    PDTestComplexMessage *message = [[[PDTestComplexMessage alloc] init] mergeJson:json error:&error];
    XCTAssert(message);
    XCTAssert(!error);
    XCTAssert([message isEqual:[self fixtureComplexMessage]]);
}

- (void)testNSCoding {
    PDTestComplexMessage *message = [self fixtureComplexMessage];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:message];
    PDTestComplexMessage *message1 = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    XCTAssertEqualObjects(message, message1);
}

- (void)testMergeMessage {
    PDTestComplexMessage *message = [[[PDTestComplexMessage alloc] init] mergeMessage:[self fixtureComplexMessage]];

    XCTAssert([message isEqual:[self fixtureComplexMessage]]);
}

- (void)testMergeMessage_mergeSuperType {
    PDBase *base = [[PDBase alloc] init];
    base.field = @"hello";

    PDMultiLevelSubtype *subtype = [[[PDMultiLevelSubtype alloc] init] mergeMessage:base];
    XCTAssert([subtype.field isEqualToString:@"hello"]);
}

- (void)testMergeMessage_mergeSubtype {
    PDMultiLevelSubtype *subtype = [[PDMultiLevelSubtype alloc] init];
    subtype.field = @"hello";

    PDBase *base = [[[PDBase alloc] init] mergeMessage:subtype];
    XCTAssert([base.field isEqualToString:@"hello"]);
}

- (void)testMergeMessage_skipDiscriminatorFields {
    PDSubtype *subtype = [[PDSubtype alloc] init];
    XCTAssert(subtype.type == PDPolymorphicType_SUBTYPE);

    PDMultiLevelSubtype *msubtype = [[PDMultiLevelSubtype alloc] init];
    XCTAssert(msubtype.type == PDPolymorphicType_MULTILEVEL_SUBTYPE);

    [msubtype mergeMessage:subtype];
    XCTAssert(msubtype.type == PDPolymorphicType_MULTILEVEL_SUBTYPE);
}

- (void)testMergeDictionary {
    PDTestMessage *message = [[[PDTestMessage alloc] init] mergeDictionary:[self fixtureDictionary]];
    XCTAssert([message isEqual:[self fixtureMessage]]);
}

- (void)testMergeJson {
    NSError *error = nil;
    NSData *json = [[self fixtureComplexMessage] toJsonError:&error];
    XCTAssert(!error);

    PDTestComplexMessage *message = [[[PDTestComplexMessage alloc] init] mergeJson:json error:&error];
    XCTAssert(!error);
    XCTAssert([message isEqual:[self fixtureComplexMessage]]);
}

- (void)testToDictionary {
    PDTestMessage *message = [[PDTestMessage alloc] init];
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
    PDTestMessage *message0 = [[PDTestMessage alloc] init];
    message0.int0 = 123;
    message0.bool0 = YES;
    message0.string0 = @"hello, world";

    PDTestMessage *message1 = [[PDTestMessage alloc] init];
    message1.int0 = 123;
    message1.bool0 = YES;
    message1.string0 = @"hello, world";

    XCTAssertEqualObjects(message0, message1);
    message1.string0 = @"goodbye, world";
    XCTAssertNotEqualObjects(message0, message1);
}

- (void)testIsEqualSubclass {
    PDTestComplexMessage *message0 = [self fixtureComplexMessage];
    PDTestComplexMessage *message1 = [self fixtureComplexMessage];

    XCTAssertEqualObjects(message0, message1);
}

- (void)testIsEqualPolymorphic {
    PDMultiLevelSubtype *subtype = [[PDMultiLevelSubtype alloc] init];
    subtype.field = @"hello";
    subtype.subfield = @"world";

    PDMultiLevelSubtype *subtype1 = [[PDMultiLevelSubtype alloc] init];
    subtype1.field = @"hello";
    subtype1.subfield = @"world";

    [subtype isEqual:subtype1];

    XCTAssertEqualObjects(subtype, subtype1);
}

- (void)testCopy {
    PDTestMessage *message0 = [[PDTestMessage alloc] init];
    message0.int0 = 123;
    message0.bool0 = YES;
    message0.string0 = @"hello, world";

    PDTestMessage *message1 = [message0 copy];
    XCTAssertEqualObjects(message0, message1);
}

- (void)testCopySubclass {
    PDTestComplexMessage *message0 = [self fixtureComplexMessage];
    message0.int0 = 123;
    message0.list0 = @[@1, @2, @3];

    PDTestComplexMessage *message1 = [message0 copy];
    XCTAssertEqualObjects(message0, message1);
}

- (void)testCopyPolymorphic {
    PDMultiLevelSubtype *subtype = [[PDMultiLevelSubtype alloc] init];
    subtype.field = @"hello";
    subtype.subfield = @"world";

    PDMultiLevelSubtype *subtype1 = [subtype copy];
    XCTAssertEqualObjects(subtype, subtype1);
}

- (void)testCopy_deepCopy {
    PDTestComplexMessage *message = [[PDTestComplexMessage alloc] init];
    message.int0 = 10;
    message.message0 = [[PDTestMessage alloc] init];
    message.message0.string0 = @"hello, world";

    PDTestComplexMessage *copy = [message copy];
    XCTAssertEqualObjects(copy, message);
    XCTAssert(copy.message0 != message.message0);
}

- (NSDictionary *)fixtureDictionary {
    return @{
            @"bool0": @YES,
            @"int0": @"123",
            @"string0": @"hello"};
}

- (PDTestMessage *)fixtureMessage {
    PDTestMessage *expected = [[PDTestMessage alloc] init];
    expected.bool0 = YES;
    expected.int0 = 123;
    expected.string0 = @"hello";
    return expected;
}

- (PDTestComplexMessage *)fixtureComplexMessage {
    PDTestComplexMessage *m = [[PDTestComplexMessage alloc] init];
    m.string0 = @"hello";
    m.enum0 = PDTestEnum_THREE;
    m.bool0 = YES;
    m.short0 = INT16_MIN;
    m.int0 = INT32_MIN;
    m.long0 = INT64_MIN;
    m.float0 = -1.5;
    m.double0 = -2.5;
    m.datetime0 = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    m.list0 = @[@-1, @0, @1, @2];
    m.set0 = [[NSSet alloc] initWithObjects:@-1, @0, @1, nil];
    m.map0 = @{@1: @-1.5, @2: @-2.5};
    m.message0 = [self fixtureMessage];
    return m;
}
@end
