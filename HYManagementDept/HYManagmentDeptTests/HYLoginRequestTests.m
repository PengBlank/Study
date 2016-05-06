//
//  HYLoginRequestTests.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-3.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HYLoginParam.h"

@interface HYLoginRequestTests : XCTestCase

@end

@implementation HYLoginRequestTests

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

- (void)testInit
{
    HYLoginParam *request = [[HYLoginParam alloc] init];
    XCTAssertNotNil(request.httpMethod, @"");
    XCTAssert(request.interfaceURL.length > 0, @"");
}

- (void)testGetJsonDictionary
{
    HYLoginParam *request = [self getAnomosRequest];
    
    NSDictionary *jsonDict = [request getJsonDictionary];
    NSString *username = [jsonDict objectForKey:@"user_name"];
    XCTAssertEqualObjects(@"xcc", username, @"user name not tequ");
    NSString *password = [jsonDict objectForKey:@"password"];
    XCTAssertEqualObjects(@"abc", password, @"pass not equal");
    
    HYLoginParam *request1 = [[HYLoginParam alloc] init];
    request1.password = @"123";
    jsonDict = [request1 getJsonDictionary];
    XCTAssertEqualObjects(@"123", jsonDict[@"password"], @"");
    XCTAssert(![[jsonDict allKeys] containsObject:@"user_name"], @"");
    
    HYLoginParam *request2 = [[HYLoginParam alloc] init];
    request2.user_name = @"123";
    jsonDict = [request2 getJsonDictionary];
    XCTAssertEqualObjects(@"123", jsonDict[@"user_name"], @"");
    XCTAssert(![[jsonDict allKeys] containsObject:@"password"], @"");
}

- (void)testRequest
{
    HYLoginParam *request = [self getAnomosRequest];
    
    __block BOOL finished = NO;
    
    RequestResult result = ^(id result, NSError *error)
    {
        XCTAssertNotNil(result, @"");
        XCTAssert([result isKindOfClass:[HYBaseResponse class]], @"response not class");
        HYBaseResponse *rp = (HYBaseResponse *)result;
        XCTAssertNotEqual(rp.status, 200, @"wrong user name success");
        
        finished = YES;
    };
    
    [request sendReuqest:result];
    
    while (!finished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (HYLoginParam *)getAnomosRequest
{
    HYLoginParam *request = [[HYLoginParam alloc] init];
    request.user_name = @"xcc";
    request.password = @"abc";
    return  request;
}

@end













