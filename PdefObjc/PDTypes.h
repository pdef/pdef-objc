//
// Created by Ivan Korobkov on 19.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import <Foundation/Foundation.h>

@class PDMessageDescriptor;
@class PDEnumDescriptor;

@protocol PDTypes <NSObject>
+ (PDMessageDescriptor *)descriptor;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (id)initWithJson:(NSString *)json;

- (NSDictionary *)toDictionary;

- (NSString *)toJson;
@end

@interface PDGeneratedMessage : NSObject <PDTypes>
@end