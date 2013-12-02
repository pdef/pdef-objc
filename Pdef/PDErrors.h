//
//  PDErrors.h
//  
//
//  Created by Ivan Korobkov on 28.11.13.
//
//

#import <Foundation/Foundation.h>
@class PDMessage;

enum {
    PDRpcException = 1,           // Expected RPC application exception.
};


extern NSString * const PDefErrorDomain;
extern NSString * const PDRpcExceptionKey;


/** Returns true if the error domain matches PDefErrorDomain and the code is PDRpcException. */
BOOL PDIsRpcError(NSError *error);

/** Returns a remote pdef exception from an error user dict. */
PDMessage *PDGetRpcException(NSError *error);
