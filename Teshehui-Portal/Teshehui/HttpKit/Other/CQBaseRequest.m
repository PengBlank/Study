//
//  CQBaseRequest.m
//  Teshehui
//
//  Created by ChengQian on 13-11-15.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQBaseRequest.h"
#import "PTHttpManager.h"
#import "JSONKit_HY.h"
#import "HYAppDelegate.h"
#import <objc/runtime.h>
#import "HYUserInfo.h"
#import "NSString+Addition.h"

@interface CQBaseRequest()

@property (nonatomic, strong) NSMutableDictionary *jsonDictionary;
@property (nonatomic, copy) RequestResult requestResult;

//处理返回的response
- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info;
@end

@implementation CQBaseRequest

- (void)dealloc
{
    DebugNSLog(@"123");
    self.requestResult = nil;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.postType = KeyValue;
        self.interfaceType = PHP;
        self.version = @"1.0.0";
        self.clientType = @"IPHONE";
        self.repIsJsonData = YES;
        
        NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
        NSString* versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
        self.clientVersion = versionNum;
        
        HYUserInfo *user = [HYUserInfo getUserInfo];
        if (user)
        {
            self.userId = user.userId;
        }
    }
    
    return self;
}

#pragma mark setter/getter
- (void)setUserId:(NSString *)userId
{
    if (userId != _userId)
    {
        self.jsonDictionary = nil;  //解决在用户发生变更的时候，或者登录状态变更的时候，请求对象没有clean导致的请求基础参数不对的问题
        _userId = userId;
    }
}

- (NSDictionary *)getDataDictionary
{
    return nil;
}

- (NSMutableDictionary *)getJsonDictionary
{
    if (!_jsonDictionary)
    {
        _jsonDictionary = [[NSMutableDictionary alloc] init];
        [_jsonDictionary setObject:self.version
                            forKey:@"version"];
        [_jsonDictionary setObject:self.clientType
                            forKey:@"clientType"];
        [_jsonDictionary setObject:self.clientVersion
                            forKey:@"clientVersion"];
        
        PTHttpManager *manager = [PTHttpManager getInstantane];
        if (manager.appKey)
        {
            [_jsonDictionary setObject:manager.appKey
                                forKey:@"imei"];
        }
        
        if (self.businessType.length > 0)
        {
            [_jsonDictionary setObject:self.businessType
                                forKey:@"businessType"];
        }
        
        NSMutableArray *signatureArr = [NSMutableArray arrayWithObjects:self.version, self.clientType, nil];
        
        BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
        if (isLogin)
        {
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kToken];
            if ([token length] > 0)
            {
                [_jsonDictionary setObject:token forKey:@"token"];
                [signatureArr addObject:token];
            }
            
            if (self.userId.length > 0)
            {
                [_jsonDictionary setObject:self.userId forKey:@"userId"];
            }
        }
        
        [signatureArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return ([obj1 compare:obj2]==NSOrderedDescending);
        }];
        
        //protal层的签名
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970]*1000;  //毫秒
        NSString *timestamp = [NSString stringWithFormat:@"%lld", (long long)timeInterval];
        [_jsonDictionary setObject:timestamp
                            forKey:@"timestamp"];
        
        NSString *param = [signatureArr componentsJoinedByString:@""];
        NSString *tempSignature = [NSString stringWithFormat:@"%@%@%@", kProtalAPIKey, param, timestamp];
        tempSignature = [[tempSignature MD5EncodedString] lowercaseString];
        [_jsonDictionary setObject:tempSignature forKey:@"signature"];
    }
    
    //data数据域
    NSMutableDictionary *data = [self getDataDictionary];
    if (data)
    {
        NSString *datajson = [data JSONString];
        if (datajson.length > 0)
        {
            [_jsonDictionary setObject:datajson forKey:@"data"];
        }
    }
    
    if (self.requestParams)
    {
        NSDictionary *params = [_requestParams toDictionary];
        [_jsonDictionary addEntriesFromDictionary:params];
    }
    
    return _jsonDictionary;
}

- (NSDictionary *)getDicFromProperty
{
    NSMutableArray* propertyArray = [[NSMutableArray alloc] init];
    NSMutableArray* valueArray = [[NSMutableArray alloc] init];
    
    Class subclass = [self class];
    
    while (subclass != [NSObject class])
    {
        u_int count = 0;
        
        objc_property_t* properties = class_copyPropertyList(subclass, &count);
        
        for (int i = 0; i < count ; i++)
        {
            objc_property_t prop=properties[i];
            const char* propertyName = property_getName(prop);
            NSString *property = [NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding];
            
            id value = [self valueForKey: [NSString stringWithUTF8String:propertyName]];// [self performSelector:sel];
            
            if (value != nil)
            {
                if (property)
                {
                    [propertyArray addObject:property];
                    [valueArray addObject:value];
                }
            }
        }
        free(properties);
        
        subclass = class_getSuperclass(subclass);
    }
    
    NSMutableDictionary* returnDic = [NSMutableDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
    
    // 移除无效参数
    [returnDic removeObjectForKey:@"reqType"];
    [returnDic removeObjectForKey:@"postType"];
    [returnDic removeObjectForKey:@"tag"];
    [returnDic removeObjectForKey:@"url"];
    [returnDic removeObjectForKey:@"requestResult"];
    
    [returnDic removeObjectForKey:@"debugDescription"];
    [returnDic removeObjectForKey:@"description"];
    [returnDic removeObjectForKey:@"hash"];
    [returnDic removeObjectForKey:@"superclass"];
    return returnDic;
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
    self.jsonDictionary = nil;
}

//统一的返回数据
- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    CQBaseResponse *response = [[CQBaseResponse alloc] initWithJsonDictionary:info];
    return response;
}

- (void)requestCompletionCallback:(NSString *)response
{
    NSError *error = nil;
    DebugNSLog(@"服务器返回数据%@", response);
    
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\\\]\n" options:0 error:&error];
    //response = [response stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
//    response = [regex stringByReplacingMatchesInString:response options:0 range:NSMakeRange(0, response.length) withTemplate:@""];
    
    if (self.repIsJsonData && self.requestResult)
    {
        id result = [response objectFromJSONStringWithParseOptionsHY:JKParseOptionIgnoreDatatypes
                                                               error:&error];
        
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
                
                if ([result isKindOfClass:[CQBaseResponse class]])
                {
                    CQBaseResponse *response = (CQBaseResponse *)result;
                    
                    if (response.status != 200 && response.status != 0)
                    {
                        //异地登陆
                        if (response.status == -1)
                        {
                            HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
                            [appDelegate loginOther:YES];
                            
                            [HYLoadHubView dismiss];
                            return;
                        }
                        else if (response.status == 918)
                        {
                            HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
                            [appDelegate showUpGrade];
                            [HYLoadHubView dismiss];
                            return;
                        }
                        else
                        {
                            NSString *errorMsg = response.rspDesc;
                            if (!errorMsg)
                            {
                                errorMsg = @"请求失败, 请稍后再试";
                            }
                            error = [NSError errorWithDomain:errorMsg
                                                        code:response.status
                                                    userInfo:nil];
                        }
                    }
                }
            }
        }
        
        self.requestResult(result, error);
    }
    else
    {
        if (self.requestResult)
        {
            self.requestResult(response, error);
        }
    }
}

- (void)requestFailedCallback:(NSError *)error
{
    DebugNSLog(@"request response error = %@", error);
    if (self.requestResult) {
        self.requestResult(nil, error);
        self.requestResult = nil;
    }
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
            
            if ([result isKindOfClass:[CQBaseResponse class]])
            {
                CQBaseResponse *response = (CQBaseResponse *)result;
                
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
