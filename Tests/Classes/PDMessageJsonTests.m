//
// Created by Ivan Korobkov on 26.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//



#import <XCTest/XCTest.h>
#import "PDef.h"
#import "TestMessage.h"
#import "TestComplexMessage.h"
#import "MultiLevelSubtype.h"


@interface PDMessageJsonTests : XCTestCase
@end

@implementation PDMessageJsonTests
- (void)testMessage {
    NSError *error = nil;

    TestComplexMessage *message = [self messageFixture];
    NSData *data = [message toJsonError:&error];
    XCTAssert(data != nil);
    XCTAssert(error == nil);

    TestComplexMessage *parsed = [[TestComplexMessage alloc] initWithJson:data error:&error];
    XCTAssert(parsed != nil);
    XCTAssert(error == nil);

    XCTAssert([parsed isEqual:message]);
}

- (TestComplexMessage *)messageFixture {
    TestComplexMessage *message = [[TestComplexMessage alloc] init];
    message.bool0 = YES;
    message.short0 = 16;
    message.int0 = 32;
    message.long0 = 64L;
    message.float0 = 1.5f;
    message.double0 = 2.5;
    message.string0 = @"привет";
    message.list0 = @[@1, @2];
    message.set0 = [NSSet setWithObjects:@1, @2, nil];
    message.map0 = @{@1: @1.5};
    message.datetime0 = [NSDate dateWithTimeIntervalSince1970:0];

    TestMessage *submessage = [[TestMessage alloc] init];
    submessage.bool0 = YES;
    submessage.int0 = -32;
    submessage.string0 = @"hello";
    message.message0 = submessage;

    MultiLevelSubtype *polymorphic = [[MultiLevelSubtype alloc] init];
    polymorphic.field = @"field";
    polymorphic.subfield = @"subfield";
    polymorphic.mfield = @"mfield";
    message.polymorphic = polymorphic;

    return message;
}
@end
