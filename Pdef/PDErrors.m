//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//

#import "PDErrors.h"
#import "PDMessage.h"


NSString * const PDefErrorDomain = @"PDefErrorDomain";
NSString * const PDRpcExceptionKey = @"PDRpcExceptionKey";

BOOL PDIsRpcError(NSError *error) {
    return [error.domain isEqualToString:PDefErrorDomain] && error.code == PDRpcException;
}

PDMessage *PDGetRpcException(NSError *error) {
    if ([error.domain isEqualToString:PDefErrorDomain] && error.code == PDRpcException) {
        return [error.userInfo objectForKey:PDRpcExceptionKey];
    }
    return nil;
}
