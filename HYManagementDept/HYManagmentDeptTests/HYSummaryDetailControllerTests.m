//
//  HYSummaryDetailControllerTests.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-18.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HYSummaryDetailViewController.h"
#import <OCMock/OCMock.h>

@interface HYSummaryDetailControllerTests : XCTestCase
@property (nonatomic, strong) HYSummaryDetailViewController *instance;
@end

@implementation HYSummaryDetailControllerTests

- (void)setUp
{
    [super setUp];
    _instance = [[HYSummaryDetailViewController alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDidAppear
{
    id mInstance = OCMPartialMock(_instance);
    OCMVerify([[mInstance expect] sendRequest]);
}

- (void)testViewDidLoad
{
    [_instance view];
    XCTAssertNotNil(_instance.tableView, @"");
}

- (void)testTableViewRow
{
    [_instance view];
    NSInteger section = [_instance numberOfSectionsInTableView:_instance.tableView];
    NSInteger row = [_instance tableView:_instance.tableView
                   numberOfRowsInSection:0];
    
    XCTAssertEqual(section, 3, @"");
    XCTAssertEqual(row, 1, @"");
}

@end
