// Generated by Pdef Objective-C generator.

#import "TestMessage.h"


@implementation TestMessage
static PDMessageDescriptor *_TestMessageDescriptor;

+ (PDMessageDescriptor *)typeDescriptor {
    return _TestMessageDescriptor;
}

- (PDMessageDescriptor *)descriptor {
    return [TestMessage typeDescriptor];
}

+ (void)initialize {
    if (self != [TestMessage class]) {
        return;
    }

    _TestMessageDescriptor = [[PDMessageDescriptor alloc]
            initWithClass:[TestMessage class]
                     base:nil
       discriminatorValue:0
         subtypeSuppliers:@[]
                   fields:@[
                           [[PDFieldDescriptor alloc] initWithName:@"string0"
                                                      typeSupplier:^PDDataTypeDescriptor *() {
                                                          return [PDDescriptors string];
                                                      }
                                                     discriminator:NO],
                           [[PDFieldDescriptor alloc] initWithName:@"bool0"
                                                      typeSupplier:^PDDataTypeDescriptor *() {
                                                          return [PDDescriptors bool0];
                                                      }
                                                     discriminator:NO],
                           [[PDFieldDescriptor alloc] initWithName:@"int0"
                                                      typeSupplier:^PDDataTypeDescriptor *() {
                                                          return [PDDescriptors int32];
                                                      }
                                                     discriminator:NO],
                           ]];
}
@end


