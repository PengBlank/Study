//
//  HYBaseDetailControllerTests.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-17.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HYBaseDetailViewController.h"
#import <OCMock/OCMock.h>
#import "HYSplitViewController.h"

@interface HYBaseDetailControllerTests : XCTestCase

@property (nonatomic, strong) HYBaseDetailViewController *controller;

@end

@implementation HYBaseDetailControllerTests

- (void)setUp
{
    [super setUp];
    _controller = [[HYBaseDetailViewController alloc] init];
}

- (void)tearDown
{
    
    [super tearDown];
}

- (void)testKeyboardShow
{
    [_controller keyboardShow:nil];
    XCTAssertEqual(_controller.keyboardIsShow, YES, @"");
}

- (void)testKeyboardHide
{
    [_controller keyboardHide:nil];
    XCTAssertEqual(_controller.keyboardIsShow, NO, @"");
}

- (void)testMenuItemAction
{
    HYSplitViewController *split = [[HYSplitViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_controller];
    [split addChildViewController:nav];
    id split_mock = OCMPartialMock(split);
    [_controller menuItemClicked:nil];
    OCMVerify([split_mock changeSlideState]);
}

@end
