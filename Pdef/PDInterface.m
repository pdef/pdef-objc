//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//


#import "PDInterface.h"
#import "PDInvocationHandler.h"
#import "PDInvocation.h"
#import "PDDescriptors.h"


@implementation PDInterface {
    PDInvocation *_parent;
}

- (id)initWithHandler:(id <PDInvocationHandler>)handler {
    return [self initWithHandler:handler parentInvocation:nil];
}

- (id)initWithHandler:(id <PDInvocationHandler>)handler parentInvocation:(PDInvocation *)parent {
    if (self = [super init]) {
        if (!handler) {
            [NSException raise:NSInvalidArgumentException format:@"nil handler"];
        }
        _handler = handler;
        _parent = parent;
    }
    return self;
}

- (PDInvocation *)captureInvocation:(PDMethodDescriptor *)method args:(NSDictionary *)args {
    if (!_parent) {
        return [[PDInvocation alloc] initWithMethod:method args:args];
    }

    return [_parent nextWithMethod:method args:args];
}

@end
