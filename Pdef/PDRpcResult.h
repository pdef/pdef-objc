//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>
#import "PDMessage.h"

@class PDDataTypeDescriptor;
@class PDMessageDescriptor;

@interface PDRpcResult : PDMessage
@property PDDataTypeDescriptor *dataDescriptor;
@property PDDataTypeDescriptor *errorDescriptor;
@property id data;
@property id error;

- (id)initWithDataDescriptor:(PDDataTypeDescriptor *)datad errorDescriptor:(PDDataTypeDescriptor *)errord;
@end
