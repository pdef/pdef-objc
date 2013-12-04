//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//

#import "PDRpcResult.h"
#import "PDDescriptors.h"


@implementation PDRpcResult {
    PDMessageDescriptor *_descriptor;
}

- (id)initWithDataDescriptor:(PDDataTypeDescriptor *)datad errorDescriptor:(PDDataTypeDescriptor *)errord {
    NSParameterAssert(datad);
    if (!errord) {
        errord = [PDDescriptors void0];
    }

    if (self = [super init]) {
        _dataDescriptor = datad;
        _errorDescriptor = errord;
        _descriptor = [[PDMessageDescriptor alloc]
                initWithClass:[self class]
                         base:nil
           discriminatorValue:0
             subtypeSuppliers:@[]
                       fields:@[
                               [[PDFieldDescriptor alloc] initWithName:@"data" type:datad isDiscriminator:NO],
                               [[PDFieldDescriptor alloc] initWithName:@"error" type:errord isDiscriminator:NO]
                       ]];
    }

    return self;
}

- (BOOL)hasData {
    return self.data ? YES : NO;
}

- (BOOL)hasError {
    return self.error ? YES : NO;
}


- (PDMessageDescriptor *)descriptor {
    return _descriptor;
}
@end
