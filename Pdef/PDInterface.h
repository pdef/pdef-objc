//
// Created by Ivan Korobkov on 21.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
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
