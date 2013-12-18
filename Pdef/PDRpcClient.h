//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>
#import "PDInvocationHandler.h"

@class PDInterfaceDescriptor;
@class PDRpcRequest;


@class AFHTTPRequestOperationManager;
@class PDDataTypeDescriptor;

@class AFHTTPRequestOperation;

@class AFHTTPResponseSerializer;
@class PDMessageDescriptor;

@interface PDRpcClient : NSObject <PDInvocationHandler>
@property (nonatomic, readonly) NSString *baseUrl;
@property (nonatomic, readonly) PDInterfaceDescriptor *descriptor;
@property (nonatomic, readonly) AFHTTPRequestOperationManager *manager;

- (id)initWithDescriptor:(PDInterfaceDescriptor *)descriptor baseUrl:(NSString *)baseUrl;

- (id)initWithDescriptor:(PDInterfaceDescriptor *)descriptor baseUrl:(NSString *)baseUrl
                 manager:(AFHTTPRequestOperationManager *)manager;

- (PDRpcRequest *)buildRpcRequest:(PDInvocation *)invocation error:(NSError **)error;

- (NSURLRequest *)buildUrlRequest:(PDRpcRequest *)rpcRequest;

- (NSString *)buildUrl:(PDRpcRequest *)request;

- (NSOperation *)sendRequest:(NSURLRequest *)request
                     success:(void (^)(AFHTTPRequestOperation *, id))success
                     failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

- (void)handleSuccess:(AFHTTPRequestOperation *)operation data:(NSData *)data
                datad:(PDDataTypeDescriptor *)datad errord:(PDMessageDescriptor *)errord
             callback:(void (^)(id, NSError *))callback;

- (void)handleError:(AFHTTPRequestOperation *)operation error:(NSError *)error
           callback:(void (^)(id, NSError *))callback;

- (void)executeCallback:(id)result error:(NSError *)error callback:(void (^)(id, NSError *))callback;

+ (AFHTTPRequestOperationManager *)httpManagerWithBaseUrl:(NSURL *)baseUrl;

+ (AFHTTPResponseSerializer *) responseSerializer;
@end
