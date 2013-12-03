//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//

#import "PDRpcRequest.h"


@implementation PDRpcRequest
- (id)init {
    if (self = [super init]) {
        self.method = @"GET";
    }
    return self;
}

- (id)initWithMethod:(NSString *)method {
    if (self = [super init]) {
        self.method = method;
    }
    return self;
}

+ (PDRpcRequest *)GET {
    return [[PDRpcRequest alloc] initWithMethod:@"GET"];
}

+ (PDRpcRequest *)POST {
    return [[PDRpcRequest alloc] initWithMethod:@"POST"];
}

- (BOOL)isPost {
    return [_method isEqualToString:@"POST"];
}
@end

