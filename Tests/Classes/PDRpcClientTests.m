//
// Created by Ivan Korobkov on 28.11.13.
//


#import <XCTest/XCTest.h>
#import <Pdef/PDRpcClient.h>
#import "TestInterface.h"
#import "AFHTTPRequestOperation.h"
#import "TestMessage.h"
#import "OCMockObject.h"
#import "OCMockRecorder.h"
#import "TestException.h"

@interface PDRpcClientTests : XCTestCase
@end

@implementation PDRpcClientTests {
    PDRpcClient *client;
}
- (void)setUp {
    client = [[PDRpcClient alloc] initWithDescriptor:TestInterfaceDescriptor() baseUrl:@"http://localhost:8080/app/"];
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
    TestMessage *message= [self createMessage];
    NSData *data = [message toJsonWithError:nil];

    __block TestMessage *result = nil;
    [client handleSuccess:operation data:data datad:[TestMessage typeDescriptor] errord:nil
                 callback:^(id o, NSError *error) {
        result = o;
    }];
    XCTAssertEqualObjects(result, message);
}

- (void)testHandleSuccess_exception {
    id operation = [self mockOperation:422];
    TestException *exc = [self createException];
    NSData *data = [exc toJsonWithError:nil];

    __block NSString *domain = nil;
    __block int code = 0;
    __block TestException *result = nil;
    [client handleSuccess:operation data:data datad:nil errord:[TestException typeDescriptor]
                 callback:^(id o, NSError *error) {
        domain = error.domain;
        code = error.code;
        result = error.userInfo[PDRpcExceptionKey];
    }];

    XCTAssertEqualObjects(domain, PDefErrorDomain);
    XCTAssertEqual(code, PDRpcException);
    XCTAssertEqualObjects(result, exc);
}

- (id)mockOperation:(NSInteger)statusCode {
    id operation = [OCMockObject mockForClass:[AFHTTPRequestOperation class]];
    id response = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    [[[operation stub] andReturn:response] response];
    [[[response stub] andReturnValue:@(statusCode)] statusCode];
    return operation;
}

- (TestMessage *)createMessage {
    TestMessage *message = [[TestMessage alloc] init];
    message.string0 = @"hello";
    message.int0 = 123;
    message.bool0 = YES;
    return message;
}

- (TestException *)createException {
    TestException *exc = [[TestException alloc] init];
    exc.text = @"hello, world";
    return exc;
}
@end
