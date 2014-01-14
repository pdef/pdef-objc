#import "PDInvocation.h"//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "PDJsonFormat.h"
#import "PDRpcClient.h"
#import "PDDescriptors.h"
#import "PDErrors.h"
#import "PDRpcRequest.h"
#import "PDRpcProtocol.h"
#import "PDRpcResult.h"


@implementation PDRpcClient

- (id)initWithDescriptor:(PDInterfaceDescriptor *)descriptor baseUrl:(NSString *)baseUrl {
    NSURL *url = [NSURL URLWithString:baseUrl];
    return [self initWithDescriptor:descriptor baseUrl:baseUrl manager:[PDRpcClient httpManagerWithBaseUrl:url]];
}

- (id)initWithDescriptor:(PDInterfaceDescriptor *)descriptor baseUrl:(NSString *)baseUrl
                 manager:(AFHTTPRequestOperationManager *)manager {
    NSParameterAssert(baseUrl);
    NSParameterAssert(descriptor);
    NSParameterAssert(manager);

    if (self = [super init]) {
        _baseUrl = baseUrl;
        _descriptor = descriptor;
        _manager = manager;
    }
    return self;
}

+ (AFHTTPRequestOperationManager *)httpManagerWithBaseUrl:(NSURL *)baseUrl {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    manager.responseSerializer = [self responseSerializer];
    return manager;
}

+ (AFHTTPResponseSerializer *)responseSerializer {
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableStatusCodes = [self responseStatusCodes];
    serializer.acceptableContentTypes = [self responseContentTypes];
    return serializer;
}

+ (NSIndexSet *)responseStatusCodes {
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndexesInRange:NSMakeRange(200, 100)];
    [set addIndex:422]; // Unprocessable entity.
    return set;
}

+ (NSSet *)responseContentTypes {
    return [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
}

- (NSOperation *)handleInvocation:(PDInvocation *)invocation callback:(PDInvocationCallback)callback {
    NSParameterAssert(invocation);
    NSParameterAssert(invocation.method.terminal);
    NSParameterAssert(callback);

    // Get the method and expected descriptors.
    PDMethodDescriptor *method = invocation.method;
    PDDataTypeDescriptor *datad = (PDDataTypeDescriptor *) method.result;
    PDMessageDescriptor *errord = _descriptor.exc;

    // Build and rpc request.
    NSError *error = nil;
    PDRpcRequest *rpcRequest = [self buildRpcRequest:invocation error:&error];
    if (!rpcRequest) {
        callback(nil, error);
        return nil;
    }

    // Build a url request.
    NSURLRequest *request = [self buildUrlRequest:rpcRequest];

    // Send the url request.
    return [self sendRequest:request success:^(AFHTTPRequestOperation *operation, id data) {
        [self handleSuccess:operation data:data datad:datad errord:errord callback:callback];
    } failure:^(AFHTTPRequestOperation *operation, NSError *e) {
        [self handleError:operation error:e callback:callback];
    }];
}

- (PDRpcRequest *)buildRpcRequest:(PDInvocation *)invocation error:(NSError **)error {
    return [PDRpcProtocol requestWithInvocation:invocation error:error];
}

- (NSURLRequest *)buildUrlRequest:(PDRpcRequest *)rpcRequest {
    NSString *url = [self buildUrl:rpcRequest];
    AFHTTPRequestSerializer *serializer = self.manager.requestSerializer;

    if (rpcRequest.isPost) {
        return [serializer requestWithMethod:@"POST" URLString:url parameters:rpcRequest.post];
    } else {
        return [serializer requestWithMethod:@"GET" URLString:url parameters:rpcRequest.query];
    }
}

- (NSString *)buildUrl:(PDRpcRequest *)request {
    NSMutableString *url = [[NSMutableString alloc] init];
    if ([self.baseUrl hasSuffix:@"/"]) {
        [url appendString:[_baseUrl substringToIndex:[_baseUrl length] - 1]];
    } else {
        [url appendString:_baseUrl];
    }

    [url appendString:request.path];
    return url;
}

- (NSOperation *)sendRequest:(NSURLRequest *)request
                     success:(void (^)(AFHTTPRequestOperation *, id))success
                     failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    AFHTTPRequestOperation *operation = [self.manager HTTPRequestOperationWithRequest:request
                                                                              success:success failure:failure];
    [self.manager.operationQueue addOperation:operation];
    return operation;
}

- (void)handleSuccess:(AFHTTPRequestOperation *)operation data:(NSData *)data
                datad:(PDDataTypeDescriptor *)datad errord:(PDMessageDescriptor *)errord
             callback:(void (^)(id, NSError *))callback {
    NSError *error = nil;
    id result = nil;

    // Read the rpc result.
    PDRpcResult *rpcResult = [[PDRpcResult alloc] initWithDataDescriptor:datad errorDescriptor:errord];
    [rpcResult mergeJson:data error:&error];

    NSInteger statusCode = operation.response.statusCode;
    if ((statusCode / 100) == 2) {
        // It is a successful result.
        result = rpcResult.data;

    } else if (statusCode == 422) {
        // It is an expected application exception.

        id exc = rpcResult.error;
        if (!exc) {
            exc = [NSNull null];
        }

        NSString *reason = NSLocalizedStringFromTable(@"RPC Exception", @"PDef", nil);
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey : reason, PDRpcExceptionKey : exc};
        error = [NSError errorWithDomain:PDefErrorDomain code:PDRpcException userInfo:userInfo];

    } else {
        // It is an unknown status code.

        NSString *reason = NSLocalizedStringFromTable(@"Unkown RPC status code", @"PDef", nil);
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey : reason};
        error = [NSError errorWithDomain:PDefErrorDomain code:PDRpcException userInfo:userInfo];
    }

    [self executeCallback:result error:error callback:callback];
}

- (void)handleError:(AFHTTPRequestOperation *)operation error:(NSError *)error
           callback:(void (^)(id, NSError *))callback {
    [self executeCallback:nil error:error callback:callback];
}

- (void)executeCallback:(id)result error:(NSError *)error callback:(void (^)(id, NSError *))callback {
    callback(result, error);
}
@end
