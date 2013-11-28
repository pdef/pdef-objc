//
//  PDRpcProtocol.h
//  
//
//  Created by Ivan Korobkov on 28.11.13.
//
//

#import <Foundation/Foundation.h>

@class PDInterfaceDescriptor;
@class PDInvocation;
@class PDRpcRequest;


@interface PDRpcProtocol : NSObject
/** Creates an rpc request from an invocation chain. */
+ (PDRpcRequest *)requestWithInvocation:(PDInvocation *)invocation error:(NSError **)error;
@end

