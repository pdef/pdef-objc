//
// Created by Ivan Korobkov on 21.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import <Foundation/Foundation.h>

@class PDInvocation;

@protocol PDInvocationHandler <NSObject>

@required
- (NSOperation *) handleInvocation:(PDInvocation *)invocation
                          response:(void (^)(id result, NSError *error))response;

@end
