//
// Created by Ivan Korobkov on 20.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "PDDescriptors.h"
#import "Messages.h"

@interface PDGeneratedMessageDescriptorTests : XCTestCase
@end

@implementation PDGeneratedMessageDescriptorTests

- (void)test {
    PDMessageDescriptor *descriptor = TestMessageDescriptor();
    XCTAssert(descriptor.cls == [TestMessage class]);
    XCTAssertNil(descriptor.base);
    XCTAssertNil(descriptor.discriminator);
    XCTAssert(descriptor.discriminatorValue == 0);
    XCTAssert(descriptor.subtypes.count == 0);
    XCTAssert(descriptor.fields.count == 3);
}

@end
