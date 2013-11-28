//
//  PDRpcRequest.m
//  
//
//  Created by Ivan Korobkov on 28.11.13.
//
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

