//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//


#import <XCTest/XCTest.h>
#import "PDef.h"
#import "PDTestMessage.h"
#import "PDTestComplexMessage.h"
#import "PDMultiLevelSubtype.h"


@interface PDMessageJsonTests : XCTestCase
@end

@implementation PDMessageJsonTests
- (void)testMessageWithJson {
    NSError *error = nil;

    PDTestComplexMessage *message = [self messageFixture];
    NSData *data = [message toJsonError:&error];
    XCTAssert(data != nil);
    XCTAssert(error == nil);

    PDTestComplexMessage *parsed = [PDTestComplexMessage messageWithJson:data error:&error];
    XCTAssert(parsed != nil);
    XCTAssert(error == nil);

    XCTAssert([parsed isEqual:message]);
}

- (void)testMessageWithJson_polymorphic {
    NSError *error = nil;

    PDMultiLevelSubtype *subtype = [[PDMultiLevelSubtype alloc] init];
    subtype.mfield = @"hello";
    NSData *json = [subtype toJsonError:&error];

    PDBase *base = [PDBase messageWithJson:json error:&error];
    XCTAssertEqualObjects(base, subtype);
    XCTAssert([base isKindOfClass:[PDMultiLevelSubtype class]]);
}

- (PDTestComplexMessage *)messageFixture {
    PDTestComplexMessage *message = [[PDTestComplexMessage alloc] init];
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

    PDTestMessage *submessage = [[PDTestMessage alloc] init];
    submessage.bool0 = YES;
    submessage.int0 = -32;
    submessage.string0 = @"hello";
    message.message0 = submessage;

    PDMultiLevelSubtype *polymorphic = [[PDMultiLevelSubtype alloc] init];
    polymorphic.field = @"field";
    polymorphic.subfield = @"subfield";
    polymorphic.mfield = @"mfield";
    message.polymorphic = polymorphic;

    return message;
}
@end
