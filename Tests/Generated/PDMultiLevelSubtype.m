// Generated by Pdef Objective-C generator.

#import "PDMultiLevelSubtype.h"
#import "PDSubtype.h"


@implementation PDMultiLevelSubtype {
    BOOL _mfield_isset;
}
static PDMessageDescriptor *_PDMultiLevelSubtypeDescriptor;

- (id) init {
    if (self = [super init]) {
        self.type = PDPolymorphicType_MULTILEVEL_SUBTYPE ;
    }
    return self;
}

// mfield
- (BOOL)hasMfield {
    return _mfield_isset;
}

- (void)setMfield:(NSString *)mfield {
    _mfield = mfield;
    _mfield_isset = YES;
}

- (void)clearMfield {
    _mfield = nil;
    _mfield_isset = NO;
}


- (PDMessageDescriptor *)descriptor {
    return [PDMultiLevelSubtype typeDescriptor];
}

+ (PDMessageDescriptor *)typeDescriptor {
    return _PDMultiLevelSubtypeDescriptor;
}

+ (void)initialize {
    if (self != [PDMultiLevelSubtype class]) {
        return;
    }

    _PDMultiLevelSubtypeDescriptor = [[PDMessageDescriptor alloc]
            initWithClass:[PDMultiLevelSubtype class]
                     base:[PDSubtype typeDescriptor]
       discriminatorValue:PDPolymorphicType_MULTILEVEL_SUBTYPE 
         subtypeSuppliers:@[]
                   fields:@[
    [[PDFieldDescriptor alloc] initWithName:@"mfield" typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors string]; } discriminator:NO],
                           ]];
}
@end

