//
// Created by Ivan Korobkov on 19.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import "PDTypes.h"
#import "PDDescriptors.h"


@implementation PDGeneratedMessage

/** Override this method in a subclass, and return a custom description. */
+ (PDMessageDescriptor *)descriptor {
    return nil;
}

/** TODO: implement initWithDictionary. */
- (id)initWithDictionary:(NSDictionary *)dictionary {
    return [self init];
}

/** TODO: implement initWithJson. */
- (id)initWithJson:(NSString *)json {
    return [self init];
}

/** TODO: implement toDictionary. */
- (NSDictionary *)toDictionary {
    return nil;
}

/** TODO: implement toJson. */
- (NSString *)toJson {
    return nil;
}

@end
