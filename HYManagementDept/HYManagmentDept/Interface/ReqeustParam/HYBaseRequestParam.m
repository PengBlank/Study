//
//  HYBaseRequest.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseRequestParam.h"
#import "PTHttpManager.h"
#import "JSONKit_HY.h"
#import "HYAppDelegate.h"
#import "Reachability.h"
#import "UIAlertView+Utils.h"

@interface HYBaseRequestParam()

@property (nonatomic, strong) NSMutableDictionary *jsonDictionary;
@property (nonatomic, copy) RequestResult requestResult;

@end

@implementation HYBaseRequestParam

- (void)dealloc
{
    DebugNSLog(@"request %@ canceled  dealloc", NSStringFromClass([self class]));
    self.requestResult = nil;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.postType = JSON;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    if (!_jsonDictionary)
    {
        _jsonDictionary = [[NSMutableDictionary alloc] init];
    }
    
    if (_jsonDictionary.count > 0) {
        [_jsonDictionary removeAllObjects];
    }
    return _jsonDictionary;
}

#pragma mark request
- (void)sendReuqest:(RequestResult)result
{
	self.requestResult = result;
    
    //在arc下，导致回调的时候 delegate有问题
    PTHttpManager *manager = [PTHttpManager getInstantane];
    if(_tag > 0)
    {
        [manager sendPostRequestWithParam:self tag:_tag];
    }
    else
    {
        self.tag = [manager getRequestTag];
        [manager sendPostRequestWithParam:self];
    }
}

- (void)cancel
{
    PTHttpManager *manager = [PTHttpManager getInstantane];
    [manager cancelRequestWithParamTag:self.tag];
    self.requestResult = nil;
}

//统一的返回数据
- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYBaseResponse *response = [[HYBaseResponse alloc] initWithJsonDictionary:info];
    return response;
}

- (void)requestCompletionCallback:(NSString *)response
{
    NSError *error = nil;
    DebugNSLog(@"服务器返回数据%@", response);
    
    id result = [response objectFromJSONStringWithParseOptionsHY:JKParseOptionIgnoreDatatypes error:&error];
    
    if (error)
    {
        error = [NSError errorWithDomain:@"服务器请求异常"
                                    code:100000
                                userInfo:nil];
        DebugNSLog(@"服务器返回数据解析错误%@", error);
    }
    else
    {
        //        DebugNSLog(@"request response = %@", result);
        if ([result isKindOfClass:[NSDictionary class]])
        {
            result = [self getResponseWithInfo:(NSDictionary *)result];
            
            if ([result isKindOfClass:[HYBaseResponse class]])
            {
                HYBaseResponse *response = (HYBaseResponse *)result;
                
                if (response.status != 200)
                {
                    //异地登陆
                    if (response.status == 10002)
                    {
                        HYAppDelegate *delegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
                        self.requestResult = nil;
                        [delegate handleOtherLogined];
                        return;
                    }
                    else if (response.status == 10026)  //操作员被挤掉
                    {
                        HYAppDelegate *delegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
                        self.requestResult = nil;
                        [delegate handleNotPromoters];
                        return;
                    }
                    else
                    {
                        if (response.rspDesc)
                        {
                            error = [NSError errorWithDomain:response.rspDesc
                                                        code:100
                                                    userInfo:nil];
                        }
                    }
                }
            }
        }
    }
    
    self.requestResult(result, error);
}

- (void)requestFailedCallback:(NSError *)error
{
    DebugNSLog(@"request response error = %@", error);
    self.requestResult(NULL, error);
    self.requestResult = nil;
}

#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request;
{
    NSString *responseStr = request.responseString;
    
    NSError *error = nil;
    
    id result = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionStrict error:&error];
    
    if (error)
    {
        error = [NSError errorWithDomain:@"服务器请求异常"
                                    code:100000
                                userInfo:nil];
        DebugNSLog(@"服务器返回数据解析错误%@", error);
    }
    else
    {
        if ([result isKindOfClass:[NSDictionary class]])
        {
            result = [self getResponseWithInfo:(NSDictionary *)result];
            
            if ([result isKindOfClass:[HYBaseResponse class]])
            {
                HYBaseResponse *response = (HYBaseResponse *)result;
                
                if (response.status != 0)
                {
                    if (response.rspDesc)
                    {
                        error = [NSError errorWithDomain:response.rspDesc
                                                    code:100
                                                userInfo:nil];
                    }
                }
            }
        }
    }
    
    self.requestResult(result, error);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
#ifndef __OPTIMIZE__
    NSString *responseStr = request.responseString;
    DebugNSLog(@"PTRequest response %@", responseStr);
#endif
    self.requestResult(NULL, request.error);
    self.requestResult = nil;
}

@end
