//
// Created by Ivan Korobkov on 03.12.13.
//


#import <XCTest/XCTest.h>
#import "PDTestComplexMessage.h"
#import "PDDeepCopying.h"
#import "PDMultiLevelSubtype.h"

@interface PDDeepCopyingTests : XCTestCase
@end

@implementation PDDeepCopyingTests

- (void)testCopyMessage {
    PDTestComplexMessage *message = [self fixtureComplexMessage];
    PDTestComplexMessage *copy = [PDDeepCopying copyObject:message descriptor:[PDTestComplexMessage typeDescriptor]];

    XCTAssertEqualObjects(message, copy);
    XCTAssert(message.message0 != copy.message0);
}

- (void)testCopyPolymorphic {
    PDMultiLevelSubtype *subtype = [[PDMultiLevelSubtype alloc] init];
    subtype.field = @"hello";
    subtype.mfield = @"world";
    PDMultiLevelSubtype *copy = [PDDeepCopying copyObject:subtype descriptor:[PDBase typeDescriptor]];

    XCTAssertEqualObjects(subtype, copy);
}

- (void)testCopyArray {
    PDListDescriptor *descriptor = [PDDescriptors listWithElement:[PDTestMessage typeDescriptor]];
    NSArray *array = @[[self fixtureMessage], [self fixtureMessage]];
    NSArray *copy = [PDDeepCopying copyObject:array descriptor:descriptor];

    XCTAssertEqualObjects(array, copy);
    XCTAssert(array[0] != copy[0]);
}

- (void)testCopySet {
    PDSetDescriptor *descriptor = [PDDescriptors setWithElement:[PDTestMessage typeDescriptor]];
    NSSet *set = [NSSet setWithObject: [self fixtureMessage]];
    NSSet *copy = [PDDeepCopying copyObject:set descriptor:descriptor];

    XCTAssertEqualObjects(set, copy);
    XCTAssert(set.anyObject != copy.anyObject);
}

- (void)testCopyDictionary {
    PDMapDescriptor *descriptor = [PDDescriptors mapWithKey:[PDDescriptors int32] value:[PDTestMessage typeDescriptor]];
    NSDictionary *dict = @{@1 : [self fixtureMessage], @2 : [self fixtureMessage]};
    NSDictionary *copy = [PDDeepCopying copyObject:dict descriptor:descriptor];

    XCTAssertEqualObjects(dict, copy);
    XCTAssert(dict[@1] != copy[@1]);
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
