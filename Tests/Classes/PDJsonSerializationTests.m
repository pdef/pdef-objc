//
// Created by Ivan Korobkov on 27.11.13.
// Copyright (c) 2013 pdef. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "PDJsonSerialization.h"

@interface PDJsonSerializationTests : XCTestCase
@end

@implementation PDJsonSerializationTests
- (void)testBool {
    NSError *error = nil;
    id object = @YES;

    NSString *json = [PDJsonSerialization stringWithJSONObject:object error:&error];
    XCTAssert([json isEqualToString:@"true"]);

    id value = [PDJsonSerialization JSONObjectWithString:json error:&error];
    XCTAssert([object isEqual:value]);
}

- (void)testInt {
    NSError *error = nil;
    id object = @-123;

    NSString *json = [PDJsonSerialization stringWithJSONObject:object error:&error];
    XCTAssert([json isEqualToString:@"-123"]);

    id value = [PDJsonSerialization JSONObjectWithString:json error:&error];
    XCTAssert([object isEqual:value]);
}

- (void)testLong {
    NSError *error = nil;
    id object = @LONG_MAX;

    NSString *json = [PDJsonSerialization stringWithJSONObject:object error:&error];
    id value = [PDJsonSerialization JSONObjectWithString:json error:&error];
    XCTAssert([object isEqual:value]);
}

- (void)testString {
    NSError *error = nil;
    id object = @"привет, как дела?";

    NSString *json = [PDJsonSerialization stringWithJSONObject:object error:&error];
    XCTAssert([json isEqualToString:@"\"привет, как дела?\""]);

    id value = [PDJsonSerialization JSONObjectWithString:json error:&error];
    XCTAssert([object isEqual:value]);
}
@end
