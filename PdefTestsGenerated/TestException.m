// Generated by Pdef Objective-C generator.

#import "TestException.h"


@implementation TestException
static PDMessageDescriptor *_TestExceptionDescriptor;

+ (PDMessageDescriptor *)typeDescriptor {
    return _TestExceptionDescriptor;
}

- (PDMessageDescriptor *)descriptor {
    return [TestException typeDescriptor];
}

+ (void)initialize {
    if (self != [TestException class]) {
        return;
    }

    _TestExceptionDescriptor = [[PDMessageDescriptor alloc]
            initWithClass:[TestException class]
                     base:nil
       discriminatorValue:0
         subtypeSuppliers:@[]
                   fields:@[
                           [[PDFieldDescriptor alloc] initWithName:@"text"
                                   typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors string]; }
                                isDiscriminator:NO],
                           ]];
}
@end

