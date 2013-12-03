//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//


#import <Foundation/Foundation.h>

@class PDInvocation;

@protocol PDInvocationHandler <NSObject>

@required
- (NSOperation *)handleInvocation:(PDInvocation *)invocation
                         callback:(void (^)(id result, NSError *error))response;

@end
