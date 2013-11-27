//
// Created by Ivan Korobkov on 27.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "PDef.h"
#import "TestMessage.h"
#import "TestEnum.h"
#import "MultiLevelSubtype.h"

@interface PDJsonFormatTests : XCTestCase
@end


@implementation PDJsonFormatTests

- (void)test:(PDDataTypeDescriptor *)descriptor object:(id)object json:(NSString *)json {
    NSError *error = nil;

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
    XCTAssert([PDJsonFormat readString:@"null" descriptor:descriptor error:&error] == [NSNull null]);
    XCTAssert([[PDJsonFormat writeString:[NSNull null] descriptor:descriptor error:&error] isEqual:@"null"]);
}

- (void)testBool {
    [self test:[PDDescriptors bool0] object:@YES json:@"true"];
    [self test:[PDDescriptors bool0] object:@NO json:@"false"];
}

- (void)testInt16 {
    [self test:[PDDescriptors int16] object:@-16 json:@"-16"];
}

- (void)testInt32 {
    [self test:[PDDescriptors int32] object:@-32 json:@"-32"];
}

- (void)testInt64 {
    [self test:[PDDescriptors int64] object:@-64 json:@"-64"];
}

- (void)testFloat {
    [self test:[PDDescriptors float0] object:@-1.5f json:@"-1.5"];
}

- (void)testDouble {
    [self test:[PDDescriptors double0] object:@-2.5 json:@"-2.5"];
}

- (void)testString {
    [self test:[PDDescriptors string] object:@"hello, world" json:@"\"hello, world\""];
}

- (void)testEmptyString {
    [self test:[PDDescriptors string] object:@"" json:@"\"\""];
}

- (void)testDatetime {
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    [self test:[PDDescriptors datetime] object:date json:@"\"1970-01-01T00:00:00Z\""];
}

- (void)testEnum {
    [self test:TestEnumDescriptor() object:@(TestEnum_ONE) json:@"\"one\""];
    [self test:TestEnumDescriptor() object:@(TestEnum_TWO) json:@"\"two\""];
    [self test:TestEnumDescriptor() object:@(TestEnum_THREE) json:@"\"three\""];

    NSError *error = nil;
    XCTAssert([PDJsonFormat readString:@"\"unknown\"" descriptor:TestEnumDescriptor() error:&error] == [NSNull null]);
}

- (void)testList {
    NSError *error = nil;
    NSArray *object = @[[self fixtureMessage]];
    PDListDescriptor *descriptor = [PDDescriptors listWithElement:[TestMessage typeDescriptor]];

    NSString *json = [PDJsonFormat writeString:object descriptor:descriptor error:&error];
    [self test:descriptor object:object json:json];
}

- (void)testSet {
    NSError *error = nil;
    NSSet *object = [NSSet setWithObject:[self fixtureMessage]];
    PDSetDescriptor *descriptor = [PDDescriptors setWithElement:[TestMessage typeDescriptor]];

    NSString *json = [PDJsonFormat writeString:object descriptor:descriptor error:&error];
    [self test:descriptor object:object json:json];
}

- (void)testMap {
    NSError *error = nil;
    NSDictionary *object = @{@-32 : [self fixtureMessage]};
    PDMapDescriptor *descriptor = [PDDescriptors mapWithKey:[PDDescriptors int32] value:[TestMessage typeDescriptor]];

    NSString *json = [PDJsonFormat writeString:object descriptor:descriptor error:&error];
    [self test:descriptor object:object json:json];
}

- (void)testMessage {
    NSError *error = nil;
    TestMessage *object = [self fixtureMessage];

    NSString *json = [PDJsonFormat writeString:object descriptor:[TestMessage typeDescriptor] error:&error];
    [self test:[TestMessage typeDescriptor] object:object json:json];
}

- (void)testPolymorphicMessage {
    NSError *error = nil;
    MultiLevelSubtype *object = [[MultiLevelSubtype alloc] init];
    object.field = @"field";
    object.subfield = @"subfield";
    object.mfield = @"mfield";

    NSString *json = [PDJsonFormat writeString:object descriptor:[MultiLevelSubtype typeDescriptor] error:&error];
    [self test:[Base typeDescriptor] object:object json:json];
    [self test:[Subtype typeDescriptor] object:object json:json];
    [self test:[MultiLevelSubtype typeDescriptor] object:object json:json];
}

- (TestMessage *)fixtureMessage {
    TestMessage *message = [[TestMessage alloc] init];
    message.bool0 = YES;
    message.int0 = 123;
    message.string0 = @"hello, world";
    return message;
}
@end
