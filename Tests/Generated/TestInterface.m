// Generated by Pdef Objective-C generator.

#import "TestInterface.h"
#import "TestException.h"
#import "TestMessage.h"
#import "TestMessage.h"


#pragma mark TestInterface client
@implementation TestInterfaceClient

- (NSOperation *) methodArg0:(int32_t )arg0
        arg1:(int32_t )arg1
        callback:(void (^)(id result, NSError *error))callback {
    PDInvocation *_invocation = [self
            captureInvocation:[self getMethodForName:@"method"]
                         args:@{
                                 @"arg0" :@(arg0),
                                 @"arg1" :@(arg1),
                         }];
    return [self.handler handleInvocation:_invocation callback:callback];
}
- (NSOperation *) queryArg0:(int32_t )arg0
        arg1:(int32_t )arg1
        callback:(void (^)(id result, NSError *error))callback {
    PDInvocation *_invocation = [self
            captureInvocation:[self getMethodForName:@"query"]
                         args:@{
                                 @"arg0" :@(arg0),
                                 @"arg1" :@(arg1),
                         }];
    return [self.handler handleInvocation:_invocation callback:callback];
}
- (NSOperation *) postArg0:(int32_t )arg0
        arg1:(int32_t )arg1
        callback:(void (^)(id result, NSError *error))callback {
    PDInvocation *_invocation = [self
            captureInvocation:[self getMethodForName:@"post"]
                         args:@{
                                 @"arg0" :@(arg0),
                                 @"arg1" :@(arg1),
                         }];
    return [self.handler handleInvocation:_invocation callback:callback];
}
- (NSOperation *) string0Text:(NSString *)text
        callback:(void (^)(id result, NSError *error))callback {
    PDInvocation *_invocation = [self
            captureInvocation:[self getMethodForName:@"string0"]
                         args:@{
                                 @"text" :text,
                         }];
    return [self.handler handleInvocation:_invocation callback:callback];
}
- (NSOperation *) datetime0Dt:(NSDate *)dt
        callback:(void (^)(id result, NSError *error))callback {
    PDInvocation *_invocation = [self
            captureInvocation:[self getMethodForName:@"datetime0"]
                         args:@{
                                 @"dt" :dt,
                         }];
    return [self.handler handleInvocation:_invocation callback:callback];
}
- (NSOperation *) message0Msg:(TestMessage *)msg
        callback:(void (^)(id result, NSError *error))callback {
    PDInvocation *_invocation = [self
            captureInvocation:[self getMethodForName:@"message0"]
                         args:@{
                                 @"msg" :msg,
                         }];
    return [self.handler handleInvocation:_invocation callback:callback];
}
- (NSOperation *) collectionsList0:(NSArray *)list0
        set0:(NSSet *)set0
        map0:(NSDictionary *)map0
        callback:(void (^)(id result, NSError *error))callback {
    PDInvocation *_invocation = [self
            captureInvocation:[self getMethodForName:@"collections"]
                         args:@{
                                 @"list0" :list0,
                                 @"set0" :set0,
                                 @"map0" :map0,
                         }];
    return [self.handler handleInvocation:_invocation callback:callback];
}
- (id<TestInterface> ) interface0Arg0:(int32_t )arg0
        arg1:(int32_t )arg1
{
    PDInvocation *_invocation = [self
            captureInvocation:[self getMethodForName:@"interface0"]
                         args:@{
                                 @"arg0" :@(arg0),
                                 @"arg1" :@(arg1),
                         }];
    return [[TestInterfaceClient alloc] initWithHandler: self.handler parentInvocation:_invocation];
}
- (NSOperation *) void0Callback:(void (^)(id result, NSError *error))callback {
    PDInvocation *_invocation = [self
            captureInvocation:[self getMethodForName:@"void0"]
                         args:@{
                         }];
    return [self.handler handleInvocation:_invocation callback:callback];
}
- (NSOperation *) exc0Callback:(void (^)(id result, NSError *error))callback {
    PDInvocation *_invocation = [self
            captureInvocation:[self getMethodForName:@"exc0"]
                         args:@{
                         }];
    return [self.handler handleInvocation:_invocation callback:callback];
}
- (NSOperation *) serverErrorCallback:(void (^)(id result, NSError *error))callback {
    PDInvocation *_invocation = [self
            captureInvocation:[self getMethodForName:@"serverError"]
                         args:@{
                         }];
    return [self.handler handleInvocation:_invocation callback:callback];
}

- (PDMethodDescriptor *)getMethodForName:(NSString *)name {
    return [TestInterfaceDescriptor() getMethodForName:name];
}
@end


#pragma mark TestInterface descriptor
static dispatch_once_t TestInterfaceOnce;
static PDInterfaceDescriptor *_TestInterfaceDescriptor;

PDInterfaceDescriptor *TestInterfaceDescriptor() {
    dispatch_once(&TestInterfaceOnce, ^() {
        _TestInterfaceDescriptor = [[PDInterfaceDescriptor alloc]
                initWithProtocol:@protocol(TestInterface)
                             exc:[TestException typeDescriptor]
                         methods:@[
     [[PDMethodDescriptor alloc]
             initWithName:@"method"
           resultSupplier:^PDDescriptor *() { return [PDDescriptors int32]; }
                     args:@[
           [[PDArgumentDescriptor alloc] initWithName:@"arg0" type: [PDDescriptors int32] post:NO query:NO],
           [[PDArgumentDescriptor alloc] initWithName:@"arg1" type: [PDDescriptors int32] post:NO query:NO],
                        ]
                     post:NO],
     [[PDMethodDescriptor alloc]
             initWithName:@"query"
           resultSupplier:^PDDescriptor *() { return [PDDescriptors int32]; }
                     args:@[
           [[PDArgumentDescriptor alloc] initWithName:@"arg0" type: [PDDescriptors int32] post:NO query:YES],
           [[PDArgumentDescriptor alloc] initWithName:@"arg1" type: [PDDescriptors int32] post:NO query:YES],
                        ]
                     post:NO],
     [[PDMethodDescriptor alloc]
             initWithName:@"post"
           resultSupplier:^PDDescriptor *() { return [PDDescriptors int32]; }
                     args:@[
           [[PDArgumentDescriptor alloc] initWithName:@"arg0" type: [PDDescriptors int32] post:YES query:NO],
           [[PDArgumentDescriptor alloc] initWithName:@"arg1" type: [PDDescriptors int32] post:YES query:NO],
                        ]
                     post:YES],
     [[PDMethodDescriptor alloc]
             initWithName:@"string0"
           resultSupplier:^PDDescriptor *() { return [PDDescriptors string]; }
                     args:@[
           [[PDArgumentDescriptor alloc] initWithName:@"text" type: [PDDescriptors string] post:NO query:NO],
                        ]
                     post:NO],
     [[PDMethodDescriptor alloc]
             initWithName:@"datetime0"
           resultSupplier:^PDDescriptor *() { return [PDDescriptors datetime]; }
                     args:@[
           [[PDArgumentDescriptor alloc] initWithName:@"dt" type: [PDDescriptors datetime] post:NO query:NO],
                        ]
                     post:NO],
     [[PDMethodDescriptor alloc]
             initWithName:@"message0"
           resultSupplier:^PDDescriptor *() { return [TestMessage typeDescriptor]; }
                     args:@[
           [[PDArgumentDescriptor alloc] initWithName:@"msg" type: [TestMessage typeDescriptor] post:NO query:NO],
                        ]
                     post:NO],
     [[PDMethodDescriptor alloc]
             initWithName:@"collections"
           resultSupplier:^PDDescriptor *() { return [PDDescriptors int32]; }
                     args:@[
           [[PDArgumentDescriptor alloc] initWithName:@"list0" type: [PDDescriptors listWithElement:[PDDescriptors int32]] post:NO query:YES],
           [[PDArgumentDescriptor alloc] initWithName:@"set0" type: [PDDescriptors setWithElement:[PDDescriptors int32]] post:NO query:YES],
           [[PDArgumentDescriptor alloc] initWithName:@"map0" type: [PDDescriptors mapWithKey:[PDDescriptors int32] value:[PDDescriptors int32]] post:NO query:YES],
                        ]
                     post:NO],
     [[PDMethodDescriptor alloc]
             initWithName:@"interface0"
           resultSupplier:^PDDescriptor *() { return TestInterfaceDescriptor(); }
                     args:@[
           [[PDArgumentDescriptor alloc] initWithName:@"arg0" type: [PDDescriptors int32] post:NO query:NO],
           [[PDArgumentDescriptor alloc] initWithName:@"arg1" type: [PDDescriptors int32] post:NO query:NO],
                        ]
                     post:NO],
     [[PDMethodDescriptor alloc]
             initWithName:@"void0"
           resultSupplier:^PDDescriptor *() { return [PDDescriptors void0]; }
                     args:@[]
                     post:NO],
     [[PDMethodDescriptor alloc]
             initWithName:@"exc0"
           resultSupplier:^PDDescriptor *() { return [PDDescriptors void0]; }
                     args:@[]
                     post:NO],
     [[PDMethodDescriptor alloc]
             initWithName:@"serverError"
           resultSupplier:^PDDescriptor *() { return [PDDescriptors void0]; }
                     args:@[]
                     post:NO],
                         ]];
    });
    return _TestInterfaceDescriptor;
}
