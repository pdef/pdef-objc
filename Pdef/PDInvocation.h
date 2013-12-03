//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
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
