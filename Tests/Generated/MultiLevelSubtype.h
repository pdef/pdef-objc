// Generated by Pdef Objective-C generator.

#import <Foundation/Foundation.h>
#import "PDef.h"
#import "Subtype.h"
#import "PolymorphicType.h"


@interface MultiLevelSubtype : Subtype
@property (nonatomic) NSString *mfield;

- (BOOL) hasMfield;
- (void) clearMfield;


+ (PDMessageDescriptor *)typeDescriptor;
@end

