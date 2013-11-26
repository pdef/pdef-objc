// Generated by Pdef Objective-C generator.

#import "Subtype.h"
#import "Base.h"
#import "MultiLevelSubtype.h"


@implementation Subtype {
    BOOL _subfield_isset;
}
static PDMessageDescriptor *_SubtypeDescriptor;

- (id) init {
    if (self = [super init]) {
        self.type = PolymorphicType_SUBTYPE ;
    }
    return self;
}

// subfield
- (BOOL)hasSubfield {
    return _subfield_isset;
}

- (void)setSubfield:(NSString *)subfield {
    _subfield = subfield;
    _subfield_isset = YES;
}

- (void)clearSubfield {
    _subfield = nil;
    _subfield_isset = NO;
}


- (PDMessageDescriptor *)descriptor {
    return [Subtype typeDescriptor];
}

+ (PDMessageDescriptor *)typeDescriptor {
    return _SubtypeDescriptor;
}

+ (void)initialize {
    if (self != [Subtype class]) {
        return;
    }

    _SubtypeDescriptor = [[PDMessageDescriptor alloc]
            initWithClass:[Subtype class]
                     base:[Base typeDescriptor]
       discriminatorValue:PolymorphicType_SUBTYPE 
         subtypeSuppliers:@[
                           ^PDMessageDescriptor *() { return [MultiLevelSubtype typeDescriptor]; },
                          ]
                   fields:@[
    [[PDFieldDescriptor alloc] initWithName:@"subfield" typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors string]; } discriminator:NO],
                           ]];
}
@end


