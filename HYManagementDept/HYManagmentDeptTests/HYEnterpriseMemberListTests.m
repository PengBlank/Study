//
//  HYEnterpriseMemberListTests.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HYEnterpriseMemberListRequest.h"
#import "HYEnterpriseMemberApplyListRequest.h"
#import "HYLoginParam.h"

@interface HYEnterpriseMemberListTests : XCTestCase

@end

@implementation HYEnterpriseMemberListTests

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

- (void)testEnterpriseRequest
{
    HYEnterpriseMemberListRequest *request = [[HYEnterpriseMemberListRequest alloc] init];
    request.page = 1;
    request.num_per_page = 10;
    //__block BOOL stop;
    [request sendReuqest:^(id result, NSError *error) {
        CFRunLoopStop(CFRunLoopGetCurrent());
    }];
    
    CFRunLoopRun();
}

- (void)testEnterpriseApplyRequest
{
    HYLoginParam *login = [[HYLoginParam alloc] init];
    login.user_name = @"ticketcenterc";
    login.password = @"123456";
    
    [login sendReuqest:^(id result, NSError *error) {
        CFRunLoopStop(CFRunLoopGetCurrent());
    }];
    CFRunLoopRun();
    HYEnterpriseMemberApplyListRequest *request = [[HYEnterpriseMemberApplyListRequest alloc] init];
    request.page = 1;
    request.num_per_page = 10;
    //__block BOOL stop;
    [request sendReuqest:^(id result, NSError *error) {
        CFRunLoopStop(CFRunLoopGetCurrent());
    }];
    
    CFRunLoopRun();
}

@end
