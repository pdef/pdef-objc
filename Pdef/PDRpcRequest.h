//
// Created by Ivan Korobkov on 27.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface PDRpcRequest : NSObject
@property (nonatomic) NSString *method;
@property (nonatomic) NSString *path;
@property (nonatomic) NSDictionary *query;
@property (nonatomic) NSDictionary *post;
@end
