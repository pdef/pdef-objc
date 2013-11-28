//
//  PDRpcRequest.h
//  
//
//  Created by Ivan Korobkov on 28.11.13.
//
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

