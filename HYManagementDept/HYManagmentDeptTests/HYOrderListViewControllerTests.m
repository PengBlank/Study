//
//  HYOrderListViewControllerTests.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-28.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HYOrderListViewController.h"
#import <OCMock/OCMock.h>

@interface HYOrderListViewControllerTests : XCTestCase
@property (nonatomic, strong) HYOrderListViewController *vc;
@end

@implementation HYOrderListViewControllerTests

- (void)setUp
{
    [super setUp];
    _vc = [[HYOrderListViewController alloc] init];
}

- (void)tearDown
{
    
    [super tearDown];
}

- (void)testViewDidLoad
{
    
    id vcm = OCMPartialMock(_vc);
    OCMExpect([vcm headView]);
    OCMExpect([vcm tableView]);
    OCMExpect([vcm refreshHeader]);
    OCMExpect([vcm refreshFooter]);
    OCMExpect([vcm setTotalNumber:0]);
    [vcm viewDidLoad];
    
    OCMVerifyAll(vcm);
    //XCTAssertEqual(vc.headView.delegate, vc, @"");
}

- (void)testGetTableColumnWidth
{
    NSArray *widths = [_vc getTableColumnWidth];
    XCTAssert(widths.count > 0, @"");
}

- (void)testTableHeaderTexts
{
    NSArray *texts = [_vc tableHeaderTexts];
    XCTAssert(texts.count > 0, @"");
}

- (void)testHeadViewDidClickedAllBtn
{
    NSDate *tdate = [NSDate date];
    [_vc setValue:tdate forKey:@"_fromDate"];
    [_vc setValue:tdate forKey:@"_toDate"];
    _vc.headView.fromField.text = @"123";
    _vc.headView.toField.text = @"123";
    id vcm = OCMPartialMock(_vc);
    OCMExpect([vcm sendRequest]);
    
    [_vc headViewDidClickedAllBtn:nil];
    //[vcm headViewDidClickedAllBtn:nil];
    
    XCTAssert(_vc.headView.fromField.text.length == 0, @"");
    XCTAssert(_vc.headView.toField.text.length == 0, @"");
    NSDate *gdate = [_vc valueForKey:@"_fromDate"];
    XCTAssert(gdate == nil, @"");
    OCMVerifyAll(vcm);
}

@end
