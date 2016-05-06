//
//  HYMasterTableViewTests.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HYMasterTableViewController.h"

@interface HYMasterTableViewTests : XCTestCase

@end

@implementation HYMasterTableViewTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNavigations
{
    HYMasterTableViewController *master = [[HYMasterTableViewController alloc] init];
    NSArray *navNames = @[@"summaryNav", @"accountNav", @"orderListNav", @"agencyCenterNav", @"cardListNav", @"addCardNav", @"vipListNav", @"companyIncomeNav", @"agencyIncomeNav"];
    NSArray *navClasses = @[@"HYSummaryDetailViewController", @"HYAccountViewController", @"HYOrderListViewController", @"HYAgencyCenterViewController", @"HYCardListViewController", @"HYAddCardViewController", @"HYVIPListViewController", @"HYCompanyIncomeViewController", @"HYAgencyIncomeViewController"];
    for (NSUInteger i = 0; i < navNames.count; i++)
    {
        NSString *navName = [navNames objectAtIndex:i];
        UINavigationController *nav = [master valueForKey:navName];
        XCTAssertNotNil(nav, @"");
        id root = [[nav viewControllers] objectAtIndex:0];
        
        NSString *cName = [navClasses objectAtIndex:i];
        Class c = NSClassFromString(cName);
        XCTAssert([root isKindOfClass:c], @"");
    }
}

- (void)testTableViewNumberRows
{
    //0 company, 1 agency, 2 unkonw
    HYMasterTableViewController *master = [[HYMasterTableViewController alloc] init];
    [master setValue:@0 forKey:@"organType"];
    NSInteger number = [master tableView:nil numberOfRowsInSection:0];
    XCTAssertEqual(number, 9, @"");
    [master setValue:@1 forKey:@"organType"];
    number = [master tableView:nil numberOfRowsInSection:0];
    XCTAssertEqual(number, 7, @"");
    [master setValue:@2 forKey:@"organType"];
    number = [master tableView:nil numberOfRowsInSection:0];
    XCTAssertEqual(number, 0, @"");
}

- (void)testTableViewNumberSubRows
{
    HYMasterTableViewController *master = [[HYMasterTableViewController alloc] init];
    [master setValue:@0 forKey:@"organType"];
    for (NSUInteger i = 0; i < 9; i++) {
        NSInteger row = (NSInteger)i;
        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
        NSInteger n = [master tableView:nil numberOfSubRowsAtIndexPath:path];
        if (i == 1)
        {
            XCTAssertEqual(n , 4, @"");
        }
        if (i == 3)
        {
            XCTAssertEqual(n, 2, @"");
        }
        if (i == 7)
        {
            XCTAssertEqual(n, 2, @"");
        }
    }
    
    [master setValue:@1 forKey:@"organType"];
    for (NSUInteger i = 0; i < 7; i++) {
        NSInteger row = (NSInteger)i;
        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
        NSInteger n = [master tableView:nil numberOfSubRowsAtIndexPath:path];
        if (i == 1)
        {
            XCTAssertEqual(n, 4, @"");
        }
        if (i == 2)
        {
            XCTAssertEqual(n, 1, @"");
        }
        if (i == 5)
        {
            XCTAssertEqual(n ,3, @"");
        }
    }
}

@end
