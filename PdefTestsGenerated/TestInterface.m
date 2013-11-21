// Generated by Pdef Objective-C generator.

#import "TestInterface.h"
#import "TestException.h"
#import "TestMessage.h"
#import "TestMessage.h"


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
                                                         [[PDArgumentDescriptor alloc]
                                                                 initWithName:@"arg0"
                                                                         type:[PDDescriptors int32]
                                                                       isPost:NO
                                                                      isQuery:NO],
                                                         [[PDArgumentDescriptor alloc]
                                                                 initWithName:@"arg1"
                                                                         type:[PDDescriptors int32]
                                                                       isPost:NO
                                                                      isQuery:NO],
                                                    ]
                                                  exc:[TestException typeDescriptor]
                                               isPost:NO],
                                 [[PDMethodDescriptor alloc]
                                         initWithName:@"query"
                                       resultSupplier:^PDDescriptor *() { return [PDDescriptors int32]; }
                                                 args:@[
                                                         [[PDArgumentDescriptor alloc]
                                                                 initWithName:@"arg0"
                                                                         type:[PDDescriptors int32]
                                                                       isPost:NO
                                                                      isQuery:YES],
                                                         [[PDArgumentDescriptor alloc]
                                                                 initWithName:@"arg1"
                                                                         type:[PDDescriptors int32]
                                                                       isPost:NO
                                                                      isQuery:YES],
                                                    ]
                                                  exc:[TestException typeDescriptor]
                                               isPost:NO],
                                 [[PDMethodDescriptor alloc]
                                         initWithName:@"post"
                                       resultSupplier:^PDDescriptor *() { return [PDDescriptors int32]; }
                                                 args:@[
                                                         [[PDArgumentDescriptor alloc]
                                                                 initWithName:@"arg0"
                                                                         type:[PDDescriptors int32]
                                                                       isPost:YES
                                                                      isQuery:NO],
                                                         [[PDArgumentDescriptor alloc]
                                                                 initWithName:@"arg1"
                                                                         type:[PDDescriptors int32]
                                                                       isPost:YES
                                                                      isQuery:NO],
                                                    ]
                                                  exc:[TestException typeDescriptor]
                                               isPost:YES],
                                 [[PDMethodDescriptor alloc]
                                         initWithName:@"string0"
                                       resultSupplier:^PDDescriptor *() { return [PDDescriptors string]; }
                                                 args:@[
                                                         [[PDArgumentDescriptor alloc]
                                                                 initWithName:@"text"
                                                                         type:[PDDescriptors string]
                                                                       isPost:NO
                                                                      isQuery:NO],
                                                    ]
                                                  exc:[TestException typeDescriptor]
                                               isPost:NO],
                                 [[PDMethodDescriptor alloc]
                                         initWithName:@"datetime0"
                                       resultSupplier:^PDDescriptor *() { return [PDDescriptors datetime]; }
                                                 args:@[
                                                         [[PDArgumentDescriptor alloc]
                                                                 initWithName:@"dt"
                                                                         type:[PDDescriptors datetime]
                                                                       isPost:NO
                                                                      isQuery:NO],
                                                    ]
                                                  exc:[TestException typeDescriptor]
                                               isPost:NO],
                                 [[PDMethodDescriptor alloc]
                                         initWithName:@"message0"
                                       resultSupplier:^PDDescriptor *() { return [TestMessage typeDescriptor]; }
                                                 args:@[
                                                         [[PDArgumentDescriptor alloc]
                                                                 initWithName:@"msg"
                                                                         type:[TestMessage typeDescriptor]
                                                                       isPost:NO
                                                                      isQuery:NO],
                                                    ]
                                                  exc:[TestException typeDescriptor]
                                               isPost:NO],
                                 [[PDMethodDescriptor alloc]
                                         initWithName:@"collections"
                                       resultSupplier:^PDDescriptor *() { return [PDDescriptors int32]; }
                                                 args:@[
                                                         [[PDArgumentDescriptor alloc]
                                                                 initWithName:@"list0"
                                                                         type:[PDDescriptors listWithElement:[PDDescriptors int32]]
                                                                       isPost:NO
                                                                      isQuery:YES],
                                                         [[PDArgumentDescriptor alloc]
                                                                 initWithName:@"set0"
                                                                         type:[PDDescriptors setWithElement:[PDDescriptors int32]]
                                                                       isPost:NO
                                                                      isQuery:YES],
                                                         [[PDArgumentDescriptor alloc]
                                                                 initWithName:@"map0"
                                                                         type:[PDDescriptors mapWithKey:[PDDescriptors int32] value:[PDDescriptors int32]]
                                                                       isPost:NO
                                                                      isQuery:YES],
                                                    ]
                                                  exc:[TestException typeDescriptor]
                                               isPost:NO],
                                 [[PDMethodDescriptor alloc]
                                         initWithName:@"interface0"
                                       resultSupplier:^PDDescriptor *() { return TestInterfaceDescriptor(); }
                                                 args:@[
                                                         [[PDArgumentDescriptor alloc]
                                                                 initWithName:@"arg0"
                                                                         type:[PDDescriptors int32]
                                                                       isPost:NO
                                                                      isQuery:NO],
                                                         [[PDArgumentDescriptor alloc]
                                                                 initWithName:@"arg1"
                                                                         type:[PDDescriptors int32]
                                                                       isPost:NO
                                                                      isQuery:NO],
                                                    ]
                                                  exc:[TestException typeDescriptor]
                                               isPost:NO],
                                 [[PDMethodDescriptor alloc]
                                         initWithName:@"void0"
                                       resultSupplier:^PDDescriptor *() { return [PDDescriptors void0]; }
                                                 args:@[]
                                                  exc:[TestException typeDescriptor]
                                               isPost:NO],
                                 [[PDMethodDescriptor alloc]
                                         initWithName:@"exc0"
                                       resultSupplier:^PDDescriptor *() { return [PDDescriptors void0]; }
                                                 args:@[]
                                                  exc:[TestException typeDescriptor]
                                               isPost:NO],
                                 [[PDMethodDescriptor alloc]
                                         initWithName:@"serverError"
                                       resultSupplier:^PDDescriptor *() { return [PDDescriptors void0]; }
                                                 args:@[]
                                                  exc:[TestException typeDescriptor]
                                               isPost:NO],
                         ]];
    });
    return _TestInterfaceDescriptor;
}