//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>
@class PDMessage;

enum {
    PDRpcException = 1,         // Expected RPC application exception.
    PDRpcNillPathArg = 2,       // Nill method path arguments are forbidden.
};


extern NSString * const PDefErrorDomain;
extern NSString * const PDRpcExceptionKey;


/** Returns true if the error domain matches PDefErrorDomain and the code is PDRpcException. */
BOOL PDIsRpcError(NSError *error);

/** Returns a remote pdef exception from an error user dict. */
PDMessage *PDGetRpcException(NSError *error);
