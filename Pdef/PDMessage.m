//
// Created by Ivan Korobkov on 19.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import "PDMessage.h"
#import "PDDescriptors.h"


@implementation PDGeneratedMessage
/** Override this method in a subclass, and return a custom descriptor. */
+ (PDMessageDescriptor *)typeDescriptor {
    return nil;
}

/** Override this method in a subclass, and return the subclass typeDescriptor. */
- (PDMessageDescriptor *)descriptor {
    return nil;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    return [self init];
}

- (id)initWithJson:(NSString *)json {
    return [self init];
}

- (NSDictionary *)toDictionary {
    return nil;
}

- (NSString *)toJson {
    return nil;
}

@end
