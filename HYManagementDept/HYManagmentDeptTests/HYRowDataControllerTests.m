//
//  HYRowDataControllerTests.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-18.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HYRowDataViewController.h"
#import <OCMock/OCMock.h>

@interface HYRowDataControllerTests : XCTestCase
@property (nonatomic, strong) HYRowDataViewController *instance;
@end

@implementation HYRowDataControllerTests

- (void)setUp
{
    [super setUp];
    _instance = [[HYRowDataViewController alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit
{
    XCTAssertEqual(_instance.page, 1, @"");
}

@end
