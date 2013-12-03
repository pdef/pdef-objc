//
// Created by Ivan Korobkov on 21.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "PDTestInterface.h"
#import "PDInvocation.h"

@interface PDInvocationTests : XCTestCase
@end

@implementation PDInvocationTests
- (void)testToChain {
    PDInterfaceDescriptor *iface = PDTestInterfaceDescriptor();
    PDMethodDescriptor *method0 = [iface getMethodForName:@"interface0"];
    PDMethodDescriptor *method1 = [iface getMethodForName:@"method"];

    PDInvocation *root = [[PDInvocation alloc] initWithMethod:method0 args:@{}];
    PDInvocation *next = [root nextWithMethod:method1 args:@{}];

    NSArray *chain = [next toChain];
    NSArray *expected = @[root, next];
    XCTAssert([chain isEqualToArray:expected]);
}
@end
