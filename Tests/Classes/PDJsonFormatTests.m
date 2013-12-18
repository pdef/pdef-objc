//
// Copyright: 2013 Pdef <http://pdef.io/>
// Licensed under the Apache License, Version 2.0.
//


#import <XCTest/XCTest.h>
#import "PDef.h"
#import "PDTestMessage.h"
#import "PDTestEnum.h"
#import "PDMultiLevelSubtype.h"

@interface PDJsonFormatTests : XCTestCase
@end


@implementation PDJsonFormatTests

- (void)test:(PDDataTypeDescriptor *)descriptor object:(id)object json:(NSString *)json {
    NSError *error;

    // String.
    id result = [PDJsonFormat readString:json descriptor:descriptor error:&error];
    NSString *jsonResult = [PDJsonFormat writeString:object descriptor:descriptor error:&error];
    XCTAssert([result isEqual:object]);
    XCTAssert([jsonResult isEqual:json]);

    // Data.
    NSData *data = [jsonResult dataUsingEncoding:NSUTF8StringEncoding];
    result = [PDJsonFormat readData:data descriptor:descriptor error:&error];
    NSData *dataResult = [PDJsonFormat writeData:object descriptor:descriptor error:&error];
    XCTAssert([result isEqual:object]);
    XCTAssert([dataResult isEqualToData:data]);

    // Nulls.
    XCTAssert([[PDJsonFormat writeString:[NSNull null] descriptor:descriptor error:&error] isEqual:@"null"]);
}

- (void)testReadFromNSNull:(PDDataTypeDescriptor *)descriptor object:(id)object {
    NSError *error;

    id result = [PDJsonFormat readString:@"null" descriptor:descriptor error:&error];
    XCTAssertEqualObjects(result, object);
}

- (void)testBool {
    [self test:[PDDescriptors bool0] object:@YES json:@"true"];
    [self test:[PDDescriptors bool0] object:@NO json:@"false"];
    [self testReadFromNSNull:[PDDescriptors bool0] object:@NO];
}

- (void)testInt16 {
    [self test:[PDDescriptors int16] object:@-16 json:@"-16"];
    [self testReadFromNSNull:[PDDescriptors int16] object:@0];
}

- (void)testInt32 {
    [self test:[PDDescriptors int32] object:@-32 json:@"-32"];
    [self testReadFromNSNull:[PDDescriptors int32] object:@0];
}

- (void)testInt64 {
    [self test:[PDDescriptors int64] object:@-64 json:@"-64"];
    [self testReadFromNSNull:[PDDescriptors int64] object:@0];
}

- (void)testFloat {
    [self test:[PDDescriptors float0] object:@-1.5f json:@"-1.5"];
    [self testReadFromNSNull:[PDDescriptors float0] object:@0];
}

- (void)testDouble {
    [self test:[PDDescriptors double0] object:@-2.5 json:@"-2.5"];
    [self testReadFromNSNull:[PDDescriptors double0] object:@0];
}

- (void)testString {
    [self test:[PDDescriptors string] object:@"hello, world" json:@"\"hello, world\""];
    [self testReadFromNSNull:[PDDescriptors string] object:[NSNull null]];
}

- (void)testEmptyString {
    [self test:[PDDescriptors string] object:@"" json:@"\"\""];
}

- (void)testDatetime {
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    [self test:[PDDescriptors datetime] object:date json:@"\"1970-01-01T00:00:00Z\""];
    [self testReadFromNSNull:[PDDescriptors datetime] object:[NSNull null]];
}

- (void)testEnum {
    [self test:PDTestEnumDescriptor() object:@(PDTestEnum_ONE) json:@"\"one\""];
    [self test:PDTestEnumDescriptor() object:@(PDTestEnum_TWO) json:@"\"two\""];
    [self test:PDTestEnumDescriptor() object:@(PDTestEnum_THREE) json:@"\"three\""];
    [self testReadFromNSNull:PDTestEnumDescriptor() object:@0];

    NSError *error = nil;
    XCTAssert([PDJsonFormat readString:@"\"unknown\"" descriptor:PDTestEnumDescriptor() error:&error] == [NSNull null]);
}

- (void)testList {
    NSError *error = nil;
    NSArray *object = @[[self fixtureMessage]];
    PDListDescriptor *descriptor = [PDDescriptors listWithElement:[PDTestMessage typeDescriptor]];

    NSString *json = [PDJsonFormat writeString:object descriptor:descriptor error:&error];
    [self test:descriptor object:object json:json];

    [self testReadFromNSNull:descriptor object:[NSNull null]];
}

- (void)testList_nullElements {
    NSError *error = nil;
    NSArray *array = @[[NSNull null]];
    PDListDescriptor *descriptor = [PDDescriptors listWithElement:[PDDescriptors string]];

    NSString *json = [PDJsonFormat writeString:array descriptor:descriptor error:&error];
    XCTAssertEqualObjects(json, @"[null]");

    NSArray *result = [PDJsonFormat readString:json descriptor:descriptor error:&error];
    XCTAssertEqualObjects(result, array);
}

- (void)testSet {
    NSError *error = nil;
    NSSet *object = [NSSet setWithObject:[self fixtureMessage]];
    PDSetDescriptor *descriptor = [PDDescriptors setWithElement:[PDTestMessage typeDescriptor]];

    NSString *json = [PDJsonFormat writeString:object descriptor:descriptor error:&error];
    [self test:descriptor object:object json:json];

    [self testReadFromNSNull:descriptor object:[NSNull null]];
}

- (void)testSet_nullElements {
    NSError *error = nil;
    NSSet *set = [NSSet setWithObject:[NSNull null]];
    PDSetDescriptor *descriptor = [PDDescriptors setWithElement:[PDDescriptors string]];

    NSString *json = [PDJsonFormat writeString:set descriptor:descriptor error:&error];
    XCTAssertEqualObjects(json, @"[null]");

    NSSet *result = [PDJsonFormat readString:json descriptor:descriptor error:&error];
    XCTAssertEqualObjects(result, set);
}

- (void)testMap {
    NSError *error = nil;
    NSDictionary *object = @{@-32 : [self fixtureMessage]};
    PDMapDescriptor *descriptor = [PDDescriptors mapWithKey:[PDDescriptors int32] value:[PDTestMessage typeDescriptor]];

    NSString *json = [PDJsonFormat writeString:object descriptor:descriptor error:&error];
    [self test:descriptor object:object json:json];

    [self testReadFromNSNull:descriptor object:[NSNull null]];
}

- (void)testMap_nullElements {
    NSError *error = nil;
    NSDictionary *map = @{@-1: [NSNull null]};
    PDMapDescriptor *descriptor = [PDDescriptors mapWithKey:[PDDescriptors int32] value:[PDDescriptors string]];

    NSString *json = [PDJsonFormat writeString:map descriptor:descriptor error:&error];
    XCTAssertEqualObjects(json, @"{\"-1\":null}");

    NSDictionary *result = [PDJsonFormat readString:json descriptor:descriptor error:&error];
    XCTAssertEqualObjects(result, map);
}

- (void)testMap_stringKeys {
    NSError *error = nil;
    NSDictionary *map = @{@"hello": @"world"};
    PDMapDescriptor *descriptor = [PDDescriptors mapWithKey:[PDDescriptors string] value:[PDDescriptors string]];

    NSString *json = [PDJsonFormat writeString:map descriptor:descriptor error:&error];
    XCTAssertEqualObjects(json, @"{\"hello\":\"world\"}");

    NSDictionary *result = [PDJsonFormat readString:json descriptor:descriptor error:&error];
    XCTAssertEqualObjects(result, map);
}

- (void)testMessage {
    NSError *error = nil;
    PDTestMessage *object = [self fixtureMessage];

    NSString *json = [PDJsonFormat writeString:object descriptor:[PDTestMessage typeDescriptor] error:&error];
    [self test:[PDTestMessage typeDescriptor] object:object json:json];

    [self testReadFromNSNull:[PDTestMessage typeDescriptor] object:[NSNull null]];
}

- (void)testPolymorphicMessage {
    NSError *error = nil;
    PDMultiLevelSubtype *object = [[PDMultiLevelSubtype alloc] init];
    object.field = @"field";
    object.subfield = @"subfield";
    object.mfield = @"mfield";

    NSString *json = [PDJsonFormat writeString:object descriptor:[PDMultiLevelSubtype typeDescriptor] error:&error];
    [self test:[PDBase typeDescriptor] object:object json:json];
    [self test:[PDSubtype typeDescriptor] object:object json:json];
    [self test:[PDMultiLevelSubtype typeDescriptor] object:object json:json];
}

- (PDTestMessage *)fixtureMessage {
    PDTestMessage *message = [[PDTestMessage alloc] init];
    message.bool0 = YES;
    message.int0 = 123;
    message.string0 = @"hello, world";
    return message;
}
@end
