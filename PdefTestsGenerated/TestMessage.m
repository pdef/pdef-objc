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

- (BOOL)isEqualToMessage:(PDMessage *)message {
    if (self == message)
        return YES;
    if (message == nil)
        return NO;
    if (![[message class] isEqual:[self class]])
        return NO;
    if (![super isEqualToMessage:message])
        return NO;

    TestMessage *cast = (TestMessage *)message;
    if (self.string0 != cast.string0 && ![self.string0 isEqual:cast.string0])
        return NO;
    if (self.bool0 != cast.bool0 && ![self.bool0 isEqual:cast.bool0])
        return NO;
    if (self.int0 != cast.int0 && ![self.int0 isEqual:cast.int0])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [super hash];
    hash = hash * 31u + [self.string0 hash];
    hash = hash * 31u + [self.bool0 hash];
    hash = hash * 31u + [self.int0 hash];
    return hash;
}

- (id)copyWithZone:(NSZone *)zone {
    TestMessage *copy = (TestMessage *)[super copyWithZone:zone];

    if (copy != nil) {
        copy.string0 = _string0;
        copy.bool0 = _bool0;
        copy.int0 = _int0;
    }

    return copy;
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
    [[PDFieldDescriptor alloc] initWithName:@"string0" typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors string]; } discriminator:NO],
    [[PDFieldDescriptor alloc] initWithName:@"bool0" typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors bool0]; } discriminator:NO],
    [[PDFieldDescriptor alloc] initWithName:@"int0" typeSupplier:^PDDataTypeDescriptor *() { return [PDDescriptors int32]; } discriminator:NO],
                           ]];
}
@end


