//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//


#import <XCTest/XCTest.h>
#import "PDInvocation.h"
#import "PDDescriptors.h"
#import "PDTestInterface.h"
#import "PDRpcRequest.h"
#import "PDRpcProtocol.h"

@interface PDRpcProtocolTests : XCTestCase
@end

@implementation PDRpcProtocolTests {
    PDInterfaceDescriptor *interface;
}

- (void)setUp {
    interface = PDTestInterfaceDescriptor();
}

- (void)testRequestGet {
    PDMethodDescriptor *method = [interface getMethodForName:@"method"];
    PDInvocation *invocation = [[PDInvocation alloc] initWithMethod:method args:@{@"arg0" : @1, @"arg1" : @2}];

    PDRpcRequest *request = [PDRpcProtocol requestWithInvocation:invocation error:nil ];
    XCTAssert([request.method isEqualToString:@"GET"]);
    XCTAssert([request.path isEqualToString:@"/method/1/2"]);
    XCTAssert(request.query.count == 0);
    XCTAssert(request.post.count == 0);
}

- (void)testRequestQuery {
    PDMethodDescriptor *method = [interface getMethodForName:@"query"];
    PDInvocation *invocation = [[PDInvocation alloc] initWithMethod:method args:@{@"arg0" : @1, @"arg1" : @2}];

    PDRpcRequest *request = [PDRpcProtocol requestWithInvocation:invocation error:nil ];
    NSDictionary *query = @{@"arg0": @"1", @"arg1": @"2"};
    XCTAssert([request.method isEqualToString:@"GET"]);
    XCTAssert([request.path isEqualToString:@"/query"]);
    XCTAssert([request.query isEqualToDictionary:query]);
    XCTAssert(request.post.count == 0);
}

- (void)testRequestPost {
    PDMethodDescriptor *method = [interface getMethodForName:@"post"];
    PDInvocation *invocation = [[PDInvocation alloc] initWithMethod:method args:@{@"arg0" : @1, @"arg1" : @2}];

    PDRpcRequest *request = [PDRpcProtocol requestWithInvocation:invocation error:nil ];
    NSDictionary *post = @{@"arg0": @"1", @"arg1": @"2"};
    XCTAssert([request.method isEqualToString:@"POST"]);
    XCTAssert([request.path isEqualToString:@"/post"]);
    XCTAssert(request.query.count == 0);
    XCTAssert([request.post isEqualToDictionary:post]);
}

- (void)testRequestChainedMethods {
    PDMethodDescriptor *method0 = [interface getMethodForName:@"interface0"];
    PDMethodDescriptor *method1 = [interface getMethodForName:@"method"];

    PDInvocation *invocation = [[[PDInvocation alloc]
            initWithMethod:method0 args:@{@"arg0" : @1, @"arg1" : @2}]
            nextWithMethod:method1 args:@{@"arg0" : @3, @"arg1" : @4}];

    PDRpcRequest *request = [PDRpcProtocol requestWithInvocation:invocation error:nil ];
    XCTAssert([request.method isEqualToString:@"GET"]);
    XCTAssert([request.path isEqualToString:@"/interface0/1/2/method/3/4"]);
    XCTAssert(request.query.count == 0);
    XCTAssert(request.post.count == 0);
}

- (void)testRequestUrlencodePathArguments {
    PDMethodDescriptor *method = [interface getMethodForName:@"string0"];
    PDInvocation *invocation = [[PDInvocation alloc] initWithMethod:method args:@{@"text" : @"привет"}];

    PDRpcRequest *request = [PDRpcProtocol requestWithInvocation:invocation error:nil ];
    XCTAssert([request.path isEqualToString:@"/string0/%D0%BF%D1%80%D0%B8%D0%B2%D0%B5%D1%82"]);
}

- (void)testRequestUrlencodePathArgumentsWithSlashes {
    PDMethodDescriptor *method = [interface getMethodForName:@"string0"];
    PDInvocation *invocation = [[PDInvocation alloc] initWithMethod:method args:@{@"text" : @"Привет/мир"}];

    PDRpcRequest *request = [PDRpcProtocol requestWithInvocation:invocation error:nil ];
    XCTAssert([request.path isEqualToString:@"/string0/%D0%9F%D1%80%D0%B8%D0%B2%D0%B5%D1%82%5C%2F%D0%BC%D0%B8%D1%80"]);
}
@end
