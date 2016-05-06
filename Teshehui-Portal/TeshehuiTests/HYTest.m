//
//  HYTest.m
//  Teshehui
//
//  Created by Charse on 16/2/26.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+Addition.h"

@interface HYTest : XCTestCase

@end

@implementation HYTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSString *str = @"18682128689";
    NSString *local = [str getPhoneNumberAttribution];
    NSLog(@"归属地是%@", local);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
