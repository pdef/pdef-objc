//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//


#import <XCTest/XCTest.h>
#import <Pdef/PDRpcClient.h>
#import "PDTestInterface.h"
#import "AFHTTPRequestOperation.h"
#import "PDTestMessage.h"
#import "OCMockObject.h"
#import "OCMockRecorder.h"
#import "PDTestException.h"

@interface PDRpcClientTests : XCTestCase
@end

@implementation PDRpcClientTests {
    PDRpcClient *client;
}
- (void)setUp {
    client = [[PDRpcClient alloc] initWithDescriptor:PDTestInterfaceDescriptor() baseUrl:@"http://localhost:8080/app/"];
}

- (void)testBuildUrlRequest {
    PDRpcRequest *rpcRequest = [[PDRpcRequest alloc] initWithMethod:@"GET"];
    rpcRequest.path = @"/method/1/2";
    rpcRequest.query = @{@"a": @"1", @"b": @"2"};

    NSURLRequest *request = [client buildUrlRequest:rpcRequest];
    XCTAssertEqualObjects(request.HTTPMethod, @"GET");
    XCTAssertEqualObjects(request.URL.absoluteString, @"http://localhost:8080/app/method/1/2?a=1&b=2");
}

- (void)testBuildUrlRequest_post {
    PDRpcRequest *rpcRequest = [[PDRpcRequest alloc] initWithMethod:@"POST"];
    rpcRequest.path = @"/method";
    rpcRequest.query = @{@"a": @"1"};
    rpcRequest.post = @{@"b": @"2"};

    NSURLRequest *request = [client buildUrlRequest:rpcRequest];
    XCTAssertEqualObjects(request.HTTPMethod, @"POST");
    XCTAssertEqualObjects(request.URL.absoluteString, @"http://localhost:8080/app/method?a=1");
    XCTAssertEqualObjects(request.HTTPBody, [@"b=2" dataUsingEncoding:NSUTF8StringEncoding]);
}

- (void)testHandleSuccess_result {
    id operation = [self mockOperation:200];
    PDTestMessage *message= [self createMessage];
    PDRpcResult *rpcResult = [self createResultWithDatad:[message descriptor] errord:nil];
    rpcResult.data = message;

    NSData *data = [rpcResult toJsonError:nil];
    __block PDTestMessage *result = nil;
    [client handleSuccess:operation data:data datad:[PDTestMessage typeDescriptor] errord:nil
                 callback:^(id o, NSError *error) {
        result = o;
    }];
    XCTAssertEqualObjects(result, message);
}

- (void)testHandleSuccess_exception {
    id operation = [self mockOperation:422];
    PDTestException *exc = [self createException];
    PDRpcResult *rpcResult = [self createResultWithDatad:[PDDescriptors void0] errord:[exc descriptor]];
    rpcResult.error = exc;
    NSData *data = [rpcResult toJsonError:nil];

    __block NSString *domain = nil;
    __block NSInteger code = 0;
    __block PDTestException *result = nil;
    [client handleSuccess:operation data:data datad:[PDDescriptors void0] errord:[PDTestException typeDescriptor]
                 callback:^(id o, NSError *error) {
        domain = error.domain;
        code = error.code;
        result = error.userInfo[PDRpcExceptionKey];
    }];

    XCTAssertEqualObjects(domain, PDefErrorDomain);
    XCTAssert(code == PDRpcException);
    XCTAssertEqualObjects(result, exc);
}

- (id)mockOperation:(NSInteger)statusCode {
    id operation = [OCMockObject mockForClass:[AFHTTPRequestOperation class]];
    id response = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    [[[operation stub] andReturn:response] response];
    [[[response stub] andReturnValue:@(statusCode)] statusCode];
    return operation;
}

- (PDTestMessage *)createMessage {
    PDTestMessage *message = [[PDTestMessage alloc] init];
    message.string0 = @"hello";
    message.int0 = 123;
    message.bool0 = YES;
    return message;
}

- (PDTestException *)createException {
    PDTestException *exc = [[PDTestException alloc] init];
    exc.text = @"hello, world";
    return exc;
}

- (PDRpcResult *)createResultWithDatad:(PDDataTypeDescriptor *)datad errord:(PDDataTypeDescriptor *)errord {
    return [[PDRpcResult alloc] initWithDataDescriptor:datad errorDescriptor:errord];
}
@end
