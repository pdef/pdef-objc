//
// Created by Ivan Korobkov on 26.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "PDef.h"
#import "TestMessage.h"
#import "TestEnum.h"
#import "MultiLevelSubtype.h"

@interface PDObjectFormatTests : XCTestCase
@end

@implementation PDObjectFormatTests {
    PDObjectFormat *format;
}

- (void)setUp {
    [super setUp];
    format = [PDObjectFormat sharedInstance];
}

- (void)testPrimitiveWithDescriptor:(PDDataTypeDescriptor *)descriptor
                             string:(NSString *)string
                           expected:(id)expected {
    XCTAssert([format fromObject:nil descriptor:descriptor] == nil);
    XCTAssert([[format fromObject:string descriptor:descriptor] isEqual:expected]);
    XCTAssert([[format fromObject:expected descriptor:descriptor] isEqual:expected]);

    XCTAssert([format toObject:nil descriptor:descriptor] == nil);
    XCTAssert([[format toObject:expected descriptor:descriptor] isEqual:expected]);
}

- (void)testBool {
    [self testPrimitiveWithDescriptor:[PDDescriptors bool0] string:@"true" expected:@YES];
    [self testPrimitiveWithDescriptor:[PDDescriptors bool0] string:@"1" expected:@YES];

    [self testPrimitiveWithDescriptor:[PDDescriptors bool0] string:@"false" expected:@NO];
    [self testPrimitiveWithDescriptor:[PDDescriptors bool0] string:@"0" expected:@NO];
}

- (void)testInt16 {
    [self testPrimitiveWithDescriptor:[PDDescriptors int16] string:@"-16" expected:@-16];
}

- (void)testInt32 {
    [self testPrimitiveWithDescriptor:[PDDescriptors int32] string:@"-32" expected:@-32];
}

- (void)testInt64 {
    [self testPrimitiveWithDescriptor:[PDDescriptors int64] string:@"-64" expected:@-64];
}

- (void)testFloat {
    [self testPrimitiveWithDescriptor:[PDDescriptors float0] string:@"-1.5" expected:@-1.5f];
}

- (void)testDouble {
    [self testPrimitiveWithDescriptor:[PDDescriptors double0] string:@"-2.5" expected:@-2.5];
}

- (void)testDatetime {
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    [self testPrimitiveWithDescriptor:[PDDescriptors datetime] string:@"1970-01-01T00:00:00Z" expected:date];
}

- (void)testString {
    [self testPrimitiveWithDescriptor:[PDDescriptors string] string:@"hello, world" expected:@"hello, world"];
}

- (void)testObjectWithDescriptor:(PDDataTypeDescriptor *)descriptor
                      serialized:(id)serialized
                        expected:(id)expected {
    XCTAssert([format fromObject:nil descriptor:descriptor] == nil);
    XCTAssert([[format fromObject:serialized descriptor:descriptor] isEqual:expected]);

    XCTAssert([format toObject:nil descriptor:descriptor] == nil);
    XCTAssert([[format toObject:expected descriptor:descriptor] isEqual:serialized]);
}


- (void)testList {
    PDListDescriptor *descriptor = [PDDescriptors listWithElement:[TestMessage typeDescriptor]];
    NSArray *serialized = @[[self fixtureMessageDict]];
    NSArray *expected = @[[self fixtureMessage]];

    [self testObjectWithDescriptor:descriptor serialized:serialized expected:expected];
}

- (void)testSet {
    PDSetDescriptor *descriptor = [PDDescriptors setWithElement:[TestMessage typeDescriptor]];
    NSSet *serialized = [NSSet setWithObject:[self fixtureMessageDict]];
    NSSet *expected = [NSSet setWithObject:[self fixtureMessage]];

    [self testObjectWithDescriptor:descriptor serialized:serialized expected:expected];
}

- (void)testMap {
    PDMapDescriptor *descriptor = [PDDescriptors mapWithKey:[PDDescriptors int32] value:[TestMessage typeDescriptor]];
    NSDictionary *serialized = @{@-32 : [self fixtureMessageDict]};
    NSDictionary *expected = @{@-32 : [self fixtureMessage]};

    [self testObjectWithDescriptor:descriptor serialized:serialized expected:expected];
}

- (void)testEnum {
    [self testObjectWithDescriptor:TestEnumDescriptor() serialized:@"one" expected:@(TestEnum_ONE)];
    [self testObjectWithDescriptor:TestEnumDescriptor() serialized:@"two" expected:@(TestEnum_TWO)];
    [self testObjectWithDescriptor:TestEnumDescriptor() serialized:@"three" expected:@(TestEnum_THREE)];

    XCTAssert([format fromObject:@"unknown enum value" descriptor:TestEnumDescriptor()] == nil);
}

- (void)testMessage {
    TestMessage *message = [self fixtureMessage];
    NSDictionary *dictionary = [self fixtureMessageDict];

    [self testObjectWithDescriptor:[TestMessage typeDescriptor] serialized:dictionary expected:message];
}

- (void)testPolymorphicMessage {
    MultiLevelSubtype *subtype = [[MultiLevelSubtype alloc] init];
    subtype.field = @"field";
    subtype.subfield = @"subfield";
    subtype.mfield = @"mfield";

    NSDictionary *dict = @{
            @"type": @"multilevel_subtype",
            @"field": @"field",
            @"subfield": @"subfield",
            @"mfield": @"mfield"};


    [self testObjectWithDescriptor:[Base typeDescriptor] serialized:dict expected:subtype];
    [self testObjectWithDescriptor:[Subtype typeDescriptor] serialized:dict expected:subtype];
    [self testObjectWithDescriptor:[MultiLevelSubtype typeDescriptor] serialized:dict expected:subtype];
}

- (TestMessage *)fixtureMessage {
    TestMessage *message = [[TestMessage alloc] init];
    message.bool0 = YES;
    message.int0 = 123;
    message.string0 = @"hello, world";
    return message;
}

- (NSDictionary *)fixtureMessageDict {
    return @{
            @"bool0": @YES,
            @"int0": @123,
            @"string0": @"hello, world"
    };
}
@end
