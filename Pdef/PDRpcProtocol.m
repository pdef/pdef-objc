//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//

#import "PDJsonFormat.h"
#import "PDDescriptors.h"
#import "PDRpcProtocol.h"
#import "PDInvocation.h"
#import "PDRpcRequest.h"
#import "PDErrors.h"


@implementation PDRpcProtocol

+ (PDRpcRequest *)requestWithInvocation:(PDInvocation *)invocation error:(NSError **)error {
    NSParameterAssert(invocation);

    PDMethodDescriptor *method = invocation.method;
    NSParameterAssert(method.isTerminal);

    NSMutableString *path = [[NSMutableString alloc] init];
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *post = [[NSMutableDictionary alloc] init];

    for (PDInvocation *inv in invocation.toChain) {
        BOOL success = [self writeInvocation:inv path:path query:query post:post error:error];
        if (!success) {
            return nil;
        }
    }

    PDRpcRequest *request = method.post ? [PDRpcRequest POST] : [PDRpcRequest GET];
    request.path = path;
    request.query = query;
    request.post = post;
    return request;
}

+ (BOOL)writeInvocation:(PDInvocation *)invocation path:(NSMutableString *)path
                  query:(NSMutableDictionary *)query post:(NSMutableDictionary *)post error:(NSError **)error{
    PDMethodDescriptor *method = invocation.method;
    NSDictionary *args = invocation.args;
    NSArray *argds = method.args;

    [path appendString:@"/"];
    [path appendString:method.name];

    for (PDArgumentDescriptor *argd in argds) {
        NSString *name = argd.name;

        id arg = [args objectForKey:name];
        if (!arg || arg == [NSNull null]) {
            if (method.isTerminal) {
                continue;
            }

            // Interface method do not support nil arguments.
            NSString *reason = NSLocalizedStringFromTable(@"Method path argument cannot be nil/NSNull", @"PDef", nil);
            NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey : reason};
            *error = [NSError errorWithDomain:PDefErrorDomain code:PDRpcNillPathArg userInfo:userInfo];
            return NO;
        }

        NSString *value = [self toJson:arg descriptor:argd.type error:error];
        if (!value) {
            return NO;
        }

        if (method.isInterface) {
            NSString *encoded = [self urlencode:value];
            [path appendString:@"/"];
            [path appendString:encoded];
        } else if (method.isPost) {
            [post setObject:value forKey:name];
        } else {
            [query setObject:value forKey:name];
        }
    }

    return YES;
}

+ (NSString *)toJson:(id)arg descriptor:(PDDataTypeDescriptor *)descriptor error:(NSError **)error {
    NSString *value = [PDJsonFormat writeString:arg descriptor:descriptor error:error];
    if (!value) {
        return nil;
    }


    PDType type = descriptor.type;
    if (type == PDTypeString || type == PDTypeDatetime || type == PDTypeEnum) {
        // Remove the quotes.
        value = [value substringWithRange:(NSRange){1, value.length -2}];
    }
    return value;
}

+ (NSString *)urlencode:(NSString *)value {
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
            NULL,
            (__bridge CFStringRef)value,
            NULL,
            (CFStringRef)@"!*'();@&=+$/?%#",
            kCFStringEncodingUTF8 );
}
@end

