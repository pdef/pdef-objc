//
// Created by Ivan Korobkov on 21.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import <Foundation/Foundation.h>

@class PDMethodDescriptor;
@class PDDescriptor;
@class PDMessageDescriptor;


@interface PDInvocation : NSObject
@property PDMethodDescriptor *method;
@property NSDictionary *args;

- (id) initWithMethod:(PDMethodDescriptor *)method
                 args:(NSDictionary *)args;

- (NSArray *)toChain;

- (PDInvocation *)nextWithMethod:(PDMethodDescriptor *)method
                            args:(NSDictionary *)args;
@end
