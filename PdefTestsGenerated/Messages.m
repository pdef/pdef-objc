// Generated by Pdef Objective-C generator.

#import "Messages.h"
#import "InheritanceDescriptors.h"


@implementation TestMessage
- (PDMessageDescriptor *)descriptor {
    return TestMessageDescriptor();
}
@end


@implementation TestComplexMessage
- (PDMessageDescriptor *)descriptor {
    return TestComplexMessageDescriptor();
}
@end


// Descriptors
static dispatch_once_t _TestEnumOnce;
static PDEnumDescriptor *_TestEnumDescriptor;
PDEnumDescriptor *TestEnumDescriptor() {
    dispatch_once(&_TestEnumOnce, ^() {
        _TestEnumDescriptor = [[PDEnumDescriptor alloc] initWithNumbersToNames:@{
                @(1): @"ONE",
                @(2): @"TWO",
                @(3): @"THREE",
        }];
    });
    return _TestEnumDescriptor;
}


static dispatch_once_t _TestMessageOnce;
static PDMessageDescriptor *_TestMessageDescriptor;
PDMessageDescriptor *TestMessageDescriptor() {
    dispatch_once(&_TestMessageOnce, ^() {
        _TestMessageDescriptor = [[PDMessageDescriptor alloc]
                initWithClass:[TestMessage class]
                         base:nil
           discriminatorValue:0
             subtypeSuppliers:@[]
                       fields:@[
                               [[PDFieldDescriptor alloc] initWithName:@"string0"
                                       typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors string]; }
                                    isDiscriminator:NO],
                               [[PDFieldDescriptor alloc] initWithName:@"bool0"
                                       typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors bool0]; }
                                    isDiscriminator:NO],
                               [[PDFieldDescriptor alloc] initWithName:@"int0"
                                       typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors int32]; }
                                    isDiscriminator:NO],
                               ]];
    });
    return _TestMessageDescriptor;
}


static dispatch_once_t _TestComplexMessageOnce;
static PDMessageDescriptor *_TestComplexMessageDescriptor;
PDMessageDescriptor *TestComplexMessageDescriptor() {
    dispatch_once(&_TestComplexMessageOnce, ^() {
        _TestComplexMessageDescriptor = [[PDMessageDescriptor alloc]
                initWithClass:[TestComplexMessage class]
                         base:TestMessageDescriptor()
           discriminatorValue:0
             subtypeSuppliers:@[]
                       fields:@[
                               [[PDFieldDescriptor alloc] initWithName:@"short0"
                                       typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors int16]; }
                                    isDiscriminator:NO],
                               [[PDFieldDescriptor alloc] initWithName:@"long0"
                                       typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors int64]; }
                                    isDiscriminator:NO],
                               [[PDFieldDescriptor alloc] initWithName:@"float0"
                                       typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors float0]; }
                                    isDiscriminator:NO],
                               [[PDFieldDescriptor alloc] initWithName:@"double0"
                                       typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors double0]; }
                                    isDiscriminator:NO],
                               [[PDFieldDescriptor alloc] initWithName:@"datetime0"
                                       typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors datetime]; }
                                    isDiscriminator:NO],
                               [[PDFieldDescriptor alloc] initWithName:@"list0"
                                       typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors listWithElement:[PDDescriptors int32]]; }
                                    isDiscriminator:NO],
                               [[PDFieldDescriptor alloc] initWithName:@"set0"
                                       typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors setWithElement:[PDDescriptors int32]]; }
                                    isDiscriminator:NO],
                               [[PDFieldDescriptor alloc] initWithName:@"map0"
                                       typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors mapWithKey:[PDDescriptors int32] value:[PDDescriptors float0]]; }
                                    isDiscriminator:NO],
                               [[PDFieldDescriptor alloc] initWithName:@"enum0"
                                       typeSupplier:^PDDataTypeDescriptor *() { return TestEnumDescriptor(); }
                                    isDiscriminator:NO],
                               [[PDFieldDescriptor alloc] initWithName:@"message0"
                                       typeSupplier:^PDDataTypeDescriptor *() { return TestMessageDescriptor(); }
                                    isDiscriminator:NO],
                               [[PDFieldDescriptor alloc] initWithName:@"polymorphic"
                                       typeSupplier:^PDDataTypeDescriptor *() { return BaseDescriptor(); }
                                    isDiscriminator:NO],
                               [[PDFieldDescriptor alloc] initWithName:@"datatypes"
                                       typeSupplier:^PDDataTypeDescriptor *() { return TestComplexMessageDescriptor(); }
                                    isDiscriminator:NO],
                               ]];
    });
    return _TestComplexMessageDescriptor;
}

