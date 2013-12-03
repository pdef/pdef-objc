//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//


#import <Foundation/Foundation.h>
@class PDInvocation;
@class PDMethodDescriptor;
@protocol PDInvocationHandler;


@interface PDInterface : NSObject
@property (readonly, nonatomic) id <PDInvocationHandler> handler;
- (id)initWithHandler:(id<PDInvocationHandler>)handler;

- (id)initWithHandler:(id<PDInvocationHandler>)handler parentInvocation:(PDInvocation *)parent;

- (PDInvocation *)captureInvocation:(PDMethodDescriptor *)method
                               args:(NSDictionary *)args;
@end
