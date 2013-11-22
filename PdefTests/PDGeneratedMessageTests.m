//
// Created by Ivan Korobkov on 22.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "Base.h"
#import "Subtype.h"
#import "Subtype2.h"
#import "MultiLevelSubtype.h"

@interface PDGeneratedMessageTests : XCTestCase
@end

@implementation PDGeneratedMessageTests

- (void)testDiscriminatorValue {
    Base *base = [[Base alloc] init];
    Subtype *subtype = [[Subtype alloc] init];
    Subtype2 *subtype2 = [[Subtype2 alloc] init];
    MultiLevelSubtype *msubtype = [[MultiLevelSubtype alloc] init];

    XCTAssert(base.type == nil);
    XCTAssert(subtype.type == PolymorphicType_SUBTYPE);
    XCTAssert(subtype2.type == PolymorphicType_SUBTYPE2);
    XCTAssert(msubtype.type == PolymorphicType_MULTILEVEL_SUBTYPE);
}
@end