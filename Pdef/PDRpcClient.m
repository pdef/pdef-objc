//
//  PDRpcClient.m
//  
//
//  Created by Ivan Korobkov on 28.11.13.
//
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "PDJsonFormat.h"
#import "PDRpcClient.h"
#import "PDDescriptors.h"
#import "PDErrors.h"
#import "PDRpcRequest.h"
#import "PDRpcProtocol.h"


@implementation PDRpcClient

- (id)initWithDescriptor:(PDInterfaceDescriptor *)descriptor baseUrl:(NSString *)baseUrl {
    return [self initWithDescriptor:descriptor baseUrl:baseUrl manager:nil];
}

- (id)initWithDescriptor:(PDInterfaceDescriptor *)descriptor baseUrl:(NSString *)baseUrl
                 manager:(AFHTTPRequestOperationManager *)manager {
    NSParameterAssert(descriptor);
    NSParameterAssert(baseUrl);

    if (self = [super init]) {
        _descriptor = descriptor;
        _baseUrl = baseUrl;
        _manager = manager ? manager : [PDRpcClient httpManager];
    }
    return self;
}

+ (AFHTTPRequestOperationManager *)httpManager {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [self responseSerializer];
    return manager;
}

+ (AFHTTPResponseSerializer *) responseSerializer {
    NSMutableIndexSet *statucCodes = [[NSMutableIndexSet alloc] initWithIndexesInRange:NSMakeRange(200, 100)];
    [statucCodes addIndex:422]; // Unprocessable entity.

    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableStatusCodes = statucCodes;
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
    return serializer;
}

- (NSOperation *)handleInvocation:(PDInvocation *)invocation callback:(void (^)(id result, NSError *error))callback {
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
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
            requestWithMethod:@"GET" URLString:[self buildUrl:rpcRequest] parameters:rpcRequest.query];
    if (!rpcRequest.isPost) {
        return request;
    }

    NSString *url = [[request URL] absoluteString];
    return [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:rpcRequest.post];
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
    AFHTTPRequestOperation *operation = [_manager HTTPRequestOperationWithRequest:request success:success failure:failure];
    [_manager.operationQueue addOperation:operation];
    return operation;
}

- (void)handleSuccess:(AFHTTPRequestOperation *)operation data:(NSData *)data
                datad:(PDDataTypeDescriptor *)datad errord:(PDMessageDescriptor *)errord
             callback:(void (^)(id, NSError *))callback {
    NSError *error = nil;
    id result = nil;

    if (operation.response.statusCode == 422) {
        // It's an expected application exception.

        id exc = nil;
        if (errord) {
            exc = [PDJsonFormat readData:data descriptor:errord error:&error];
        }
        if (!exc) {
            exc = [NSNull null];
        }

        NSString *reason = NSLocalizedStringFromTable(@"RPC Exception", @"PDef", nil);
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey : reason, PDRpcExceptionKey : exc};
        error = [NSError errorWithDomain:PDefErrorDomain code:PDRpcException userInfo:userInfo];

    } else {
        // It's a successful result.
        result = [PDJsonFormat readData:data descriptor:datad error:&error];
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
