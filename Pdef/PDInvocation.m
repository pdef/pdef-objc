//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//


#import "PDInvocation.h"
#import "PDDescriptors.h"


@implementation PDInvocation {
    PDInvocation *_parent;
}

- (id)initWithMethod:(PDMethodDescriptor *)method args:(NSDictionary *)args {
    return [self initWithParent:nil method:method args:args];
}

- (id)initWithParent:(PDInvocation *)parent
              method:(PDMethodDescriptor *)method
                args:(NSDictionary *)args {
    NSParameterAssert(method);

    if (self = [super init]) {
        _parent = parent;
        _method = method;
        _args = args ? [args copy] : [[NSDictionary alloc] init];
    }
    return self;
}

- (NSArray *)toChain {
    if (!_parent) {
        return [[NSMutableArray alloc] initWithObjects:self, nil];
    }

    NSMutableArray *chain = (NSMutableArray *) [_parent toChain];
    [chain addObject:self];
    return chain;
}

- (PDInvocation *)nextWithMethod:(PDMethodDescriptor *)method args:(NSDictionary *)args {
    return [[PDInvocation alloc] initWithParent:self method:method args:args];
}

@end
