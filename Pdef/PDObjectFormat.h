//
// Created by Ivan Korobkov on 26.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import <Foundation/Foundation.h>

@class PDDescriptor;
@class PDMessage;
@class PDMessageDescriptor;


/** Converts pdef data types into primitives and collections and vice versa. */
@interface PDObjectFormat : NSObject

+ (PDObjectFormat *)sharedInstance;

- (id)toObject:(id)object descriptor:(PDDescriptor *)descriptor;

- (id)fromObject:(id)object descriptor:(PDDescriptor *)descriptor;
@end
