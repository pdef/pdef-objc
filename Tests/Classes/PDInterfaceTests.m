//
//  Created by Ivan Korobkov on 21.11.13.
//  Copyright (c) 2013 pdef. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestInterface.h"


@interface PDTestInvocationHandler : NSObject<PDInvocationHandler>
@property (nonatomic) PDInvocation *invocation;
@property (nonatomic) NSOperation *operation;
@end


@implementation PDTestInvocationHandler
- (NSOperation *)handleInvocation:(PDInvocation *)invocation callback:(void (^)(id result, NSError *error))callback {
    self.invocation = invocation;
    return self.operation;
}
@end


@interface PDInterfaceTests : XCTestCase
@end

@implementation PDInterfaceTests

- (void) testHandleInvocation {
    PDTestInvocationHandler *handler = [[PDTestInvocationHandler alloc] init];
    id<TestInterface> client = [[TestInterfaceClient alloc] initWithHandler:handler];

    NSOperation *operation = [client methodArg0:1 arg1:2 callback:nil];
    XCTAssert(operation == handler.operation);
}

- (void) testCaptureInvocation {
    PDTestInvocationHandler *handler = [[PDTestInvocationHandler alloc] init];
    id<TestInterface> client = [[TestInterfaceClient alloc] initWithHandler:handler];

    [client methodArg0:1 arg1:2 callback:nil];
    PDInvocation * invocation = handler.invocation;

    PDMethodDescriptor *method = [TestInterfaceDescriptor() getMethodForName:@"method"];
    NSDictionary *expected = @{
            @"arg0": @(1),
            @"arg1": @(2)
    };
    XCTAssert(invocation.method == method);
    XCTAssertTrue([invocation.args isEqualToDictionary: expected]);
}

- (void) testInvocationChain {
    PDTestInvocationHandler *handler = [[PDTestInvocationHandler alloc] init];
    id<TestInterface> client = [[TestInterfaceClient alloc] initWithHandler:handler];

    [[client interface0Arg0:1 arg1:2] string0Text:@"hello" callback:nil];
    PDInvocation *invocation1 = handler.invocation;
    NSArray *chain = [invocation1 toChain];
    PDInvocation *invocation0 = [chain objectAtIndex:0];

    PDMethodDescriptor *method0 = [TestInterfaceDescriptor() getMethodForName:@"interface0"];
    PDMethodDescriptor *method1 = [TestInterfaceDescriptor() getMethodForName:@"string0"];
    XCTAssert(chain.count == 2);
    XCTAssert(invocation0.method == method0);
    XCTAssert(invocation1.method == method1);

    NSDictionary *expected = @{
            @"arg0": @(1),
            @"arg1": @(2)
    };
    XCTAssert([invocation0.args isEqualToDictionary:expected]);

    expected = @{@"text" : @"hello"};
    XCTAssert([invocation1.args isEqualToDictionary:expected]);
}
@end
