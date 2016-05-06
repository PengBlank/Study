//
//  HYLoginResponseTests.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-3.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HYLoginParam.h"
#import "HYLoginResponse.h"
#import <OCMock/OCMock.h>

@interface HYLoginResponseTests : XCTestCase

@end

@implementation HYLoginResponseTests

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

- (void)testResponse
{
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [testBundle pathForResource:@"login_response_test_datas" ofType:@"json"];
    NSData *jData = [NSData dataWithContentsOfFile:path];
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:jData options:0 error:NULL];
    
    XCTAssert(dataArray.count > 0, @"response datas missing");
    
    for (NSDictionary *dataDict in dataArray)
    {
        HYLoginResponse *response = [[HYLoginResponse alloc] initWithJsonDictionary:dataDict];
        
        XCTAssertEqual(response.status, [dataDict[@"code"] integerValue], @"code not equal");
        XCTAssertEqualObjects(response.rspDesc, dataDict[@"msg"], @"msg not equeal");
        
    }
}


@end
