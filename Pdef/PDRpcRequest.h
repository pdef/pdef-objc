//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@interface PDRpcRequest : NSObject
@property (nonatomic) NSString *method;
@property (nonatomic) NSString *path;
@property (nonatomic) NSDictionary *query;
@property (nonatomic) NSDictionary *post;

- (id)initWithMethod:(NSString *)method;

+ (PDRpcRequest *)POST;

+ (PDRpcRequest *)GET;

- (BOOL)isPost;
@end

