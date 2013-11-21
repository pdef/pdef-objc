// Generated by Pdef Objective-C generator.

#import "MultiLevelSubtype.h"
#import "Subtype.h"


@implementation MultiLevelSubtype
static PDMessageDescriptor *_MultiLevelSubtypeDescriptor;

+ (PDMessageDescriptor *)typeDescriptor {
    return _MultiLevelSubtypeDescriptor;
}

- (PDMessageDescriptor *)descriptor {
    return [MultiLevelSubtype typeDescriptor];
}

+ (void)initialize {
    if (self != [MultiLevelSubtype class]) {
        return;
    }

    _MultiLevelSubtypeDescriptor = [[PDMessageDescriptor alloc]
            initWithClass:[MultiLevelSubtype class]
                     base:[Subtype typeDescriptor]
       discriminatorValue:PolymorphicType_MULTILEVEL_SUBTYPE 
         subtypeSuppliers:@[]
                   fields:@[
                           [[PDFieldDescriptor alloc] initWithName:@"mfield"
                                   typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors string]; }
                                isDiscriminator:NO],
                           ]];
}
@end

