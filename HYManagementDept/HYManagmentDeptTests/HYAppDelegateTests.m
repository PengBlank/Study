//
//  HYAppDelegateTests.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-3.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "HYAppDelegate.h"

@interface HYAppDelegateTests : XCTestCase
{
    HYAppDelegate *_app;
}

@end

@implementation HYAppDelegateTests

- (void)setUp
{
    [super setUp];
    _app = (HYAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)tearDown
{
    _app = nil;
    [super tearDown];
}

- (void)testShowLogin
{
    [_app showLogin];
    XCTAssertNotNil(_app.loginViewController, @"should have login controller");
    XCTAssertNil(_app.splitViewController, @"");
    XCTAssert(_app.window.rootViewController == _app.loginViewController, @"");
}

@end





