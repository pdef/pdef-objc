//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@class PDInterfaceDescriptor;
@class PDInvocation;
@class PDRpcRequest;


@interface PDRpcProtocol : NSObject
/** Creates an rpc request from an invocation chain. */
+ (PDRpcRequest *)requestWithInvocation:(PDInvocation *)invocation error:(NSError **)error;
@end

