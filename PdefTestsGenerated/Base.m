// Generated by Pdef Objective-C generator.

#import "Base.h"
#import "Subtype.h"
#import "Subtype2.h"
#import "MultiLevelSubtype.h"


@implementation Base
static PDMessageDescriptor *_BaseDescriptor;

+ (PDMessageDescriptor *)typeDescriptor {
    return _BaseDescriptor;
}

- (PDMessageDescriptor *)descriptor {
    return [Base typeDescriptor];
}

+ (void)initialize {
    if (self != [Base class]) {
        return;
    }

    _BaseDescriptor = [[PDMessageDescriptor alloc]
            initWithClass:[Base class]
                     base:nil
       discriminatorValue:0
         subtypeSuppliers:@[
                           ^PDMessageDescriptor *() { return [Subtype typeDescriptor]; },
                           ^PDMessageDescriptor *() { return [Subtype2 typeDescriptor]; },
                           ^PDMessageDescriptor *() { return [MultiLevelSubtype typeDescriptor]; },
                          ]
                   fields:@[
                           [[PDFieldDescriptor alloc] initWithName:@"type"
                                   typeSupplier:^PDDataTypeDescriptor *() { return PolymorphicTypeDescriptor(); }
                                isDiscriminator:YES],
                           [[PDFieldDescriptor alloc] initWithName:@"field"
                                   typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors string]; }
                                isDiscriminator:NO],
                           ]];
}
@end

