//
//  PTHttpManager.m
//  ContactHub
//
//  Created by ChengQian on 13-3-11.
//  Copyright (c) 2013年 www.putao.cn. All rights reserved.
//

#import "PTHttpManager.h"
#import "JSONKit_HY.h"
#import "NSString+Addition.h"
#import "SFHFKeychainUtils.h"
#import "ASIDownloadCache.h"

#define kRequestTimeOutInterval 30
#define kAppName  @"mgdept"
#define kAppToken @"ca78ac3ffb618e6588ce309d2566533f"
#define kAppService  @"HYZB123"

@interface PTHttpManager ()

@property (nonatomic, strong) NSMutableDictionary *requestDic;
@property (nonatomic, strong) ASINetworkQueue *requsestQueue;
@property (nonatomic, copy) NSString *appKey;

@end

static PTHttpManager *instantane = nil;

@implementation PTHttpManager

@synthesize requestDic = _requestDic;
@synthesize requsestQueue = _requsestQueue;

+ (PTHttpManager *)getInstantane
{
    @synchronized(self) {
        if(instantane == nil)
        {
            instantane = [[super allocWithZone:NULL] init];
        }
    }
    
    return instantane;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        _requsestQueue = [[ASINetworkQueue alloc] init];
        _requestTag = 1000;
    }
    return self;
}

- (void)clean
{
    if (_requsestQueue)
    {
        [_requsestQueue reset];
        _requsestQueue = nil;
    }
    
    _requestTag = 0;
    
    if (_requestDic)
    {
        _requestDic = nil;
    }
    
    instantane = nil;
}

#pragma mark public methods

- (NSInteger)getRequestTag
{
    return ++_requestTag;
}

- (ASIHTTPRequest *)getPostReuqestWithParam:(id)requestParam
{
    ASIHTTPRequest *reuqet = nil;
    return reuqet;
}

- (void)sendPostRequestWithParam:(HYBaseRequestParam *)requestParam
{
    [self sendPostRequestWithParam:requestParam tag:requestParam.tag];
}

- (void)sendPostRequestWithParam:(HYBaseRequestParam *)param tag:(NSInteger)tag
{
    BOOL post = [param.httpMethod isEqualToString:@"POST"];
    
    NSString *url = nil;
//    NSString *requestBodyJson = nil;
    
    //区分post和get
    if (post)
    {
        const char *str = [param.interfaceURL UTF8String];
        url = [NSString stringWithUTF8String:str];
        
//        NSDictionary *dic = param.getJsonDictionary;
//        NSError *error = NULL;
//        requestBodyJson = [dic JSONStringWithOptions:JKSerializeOptionNone
//                                               error:&error];
//        
//        if (error || (NSNull *)requestBodyJson==[NSNull null])
//        {
//#ifndef __OPTIMIZE__
//            DebugNSLog(@"send requst encode json error");
//#endif
//            return;
//        }
    }
    else
    {
        NSString *urlString = [self serializeURL:param.interfaceURL
                                          params:param.getJsonDictionary
                                      httpMethod:param.httpMethod];
        const char *str = [urlString UTF8String];
        url = [NSString stringWithUTF8String:str];
    }
    
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    DebugNSLog(@"http request url = %@", url);
    
    NSURL *parsedURL = [NSURL URLWithString:url];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:parsedURL];
    [request setRequestMethod:param.httpMethod];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request addRequestHeader:@"app-key" value:self.appKey];

    NSString *time = [self timestamp];
    [request addRequestHeader:@"timestamp" value:time];
    
    NSString *signature = [self getSigantureWittTimestpamp:time];
    [request addRequestHeader:@"signature" value:signature];
    
    [request addRequestHeader:@"app-from" value:@"iOS-Clearing"];
    [request addRequestHeader:@"imei" value:@""];
    if (param.postType == JSON) {
        [request addRequestHeader:@"Content-Type"
                            value:@"application/json"];
    } else {
        [request addRequestHeader:@"Content-Type"
                            value:@"application/x-www-form-urlencoded"];
    }
    
    [request addRequestHeader:@"User-Agent"
                        value:@"iOS"];
    [request addRequestHeader:@"Accept-Charset"
                        value:@"UTF-8"];
    
    
    //如果为post，则将参数转换为data 加入到body中
    if (post)
    {
        if (param.postType == JSON)
        {
            const char *str = [param.interfaceURL UTF8String];
            url = [NSString stringWithUTF8String:str];
            
            NSDictionary *dic = param.getJsonDictionary;
            NSError *error = NULL;
            
            NSString *requestBodyJson = [dic JSONStringWithOptions:JKSerializeOptionNone
                                                             error:&error];
            
            
            DebugNSLog(@"body %@", requestBodyJson);
            if (error || (NSNull *)requestBodyJson==[NSNull null])
            {
#ifndef __OPTIMIZE__
                DebugNSLog(@"send requst encode json error");
#endif
                return;
            }
            
            NSData *data = [requestBodyJson dataUsingEncoding:NSUTF8StringEncoding];
            [request appendPostData:data];
        }
        else
        {
            NSDictionary *params = param.getJsonDictionary;
            for (NSString* key in [params keyEnumerator])
            {
                id val = [params objectForKey:key];
                if ([val isKindOfClass:[NSData class]])
                {
                    NSString *contentType = [self contentTypeForImageData:val];
                    if (contentType)
                    {
                        [request addData:val
                            withFileName:@"upload.jpg"
                          andContentType:contentType
                                  forKey:key];
                    }
                    else
                    {
                        [request addData:val forKey:key];
                    }
                }
                else
                {
                    [request addPostValue:val forKey:key];
                    DebugNSLog(@"prameter: %@:%@", key, val);
                }
            }
        }
        
    }
    
    //    [request setShouldCompressRequestBody:YES];

    __weak ASIFormDataRequest *_bRequest = request;
    __weak typeof(self) bself = self;
    [request setCompletionBlock :^{
        NSString *responseString = [_bRequest responseString];
        [param requestCompletionCallback:responseString];
        [bself cleanRequestCacheWithTag:_bRequest.tag];
    }];
    
    [request setFailedBlock :^{
        NSError *error = [_bRequest error];
        [param requestFailedCallback:error];
        [bself cleanRequestCacheWithTag:_bRequest.tag];
    }];

    [request setTimeOutSeconds:kRequestTimeOutInterval];
    [request startAsynchronous];
    
//    NSDictionary *di = request.requestHeaders;
//    NSData *jsonD = [NSJSONSerialization dataWithJSONObject:di options:0 error:NULL];
//    NSString *json = [[NSString alloc] initWithData:jsonD encoding:NSUTF8StringEncoding];
//    DebugNSLog(@"header json: %@", json);
    
    if (tag)
    {
        NSNumber *key = [NSNumber numberWithInteger:tag];
        if (!_requestDic)
        {
            _requestDic = [[NSMutableDictionary alloc] init];
        }
        [_requestDic setObject:request forKey:key];
    }
    

}

- (void)cancelRequestWithParamTag:(NSInteger)paramTag
{
    if (_requestDic && paramTag)
    {
        NSNumber *key = [NSNumber numberWithInteger:paramTag];
        ASIFormDataRequest *request = [_requestDic objectForKey:key];
        if (request)
        {
            //[request clearDelegatesAndCancel];
            request.delegate = nil;
            [request clearDelegatesAndCancel];
            [_requestDic removeObjectForKey:key];
        }
    }
}

- (void)cleanRequestCacheWithTag:(NSInteger)tag
{
    if (tag > 0)
    {
        NSNumber *key = [NSNumber numberWithInteger:tag];
        [_requestDic removeObjectForKey:key];
    }
}

- (void)cancelAll
{
    for (id obj in [_requestDic allValues])
    {
        if ([obj isKindOfClass:[ASIFormDataRequest class]])
        {
            ASIFormDataRequest *request = (ASIFormDataRequest *)obj;
            request.delegate = nil;
            [request clearDelegatesAndCancel];
        }
    }
    
    [_requestDic removeAllObjects];
}

- (void)cleanCache
{
    [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
}

- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

#pragma mark handle request param

//sina
- (NSString *)stringFromDictionary:(NSDictionary *)dict
{
    NSMutableArray *pairs = [NSMutableArray array];
	for (NSString *key in [dict keyEnumerator])
	{
		if (!([[dict valueForKey:key] isKindOfClass:[NSString class]]))
		{
			continue;
		}
		
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [[dict objectForKey:key] URLEncodedString]]];
	}
	
	return [pairs componentsJoinedByString:@"&"];
}

- (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString
{
    [body appendData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
}

//生成url请求链接
- (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod
{
    /*
     NSURL *parsedURL = [NSURL URLWithString:baseURL];
     NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
     NSString *query = [self stringFromDictionary:params];
     
     return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
     */
    NSURL* parsedURL = [NSURL URLWithString:baseURL];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator])
    {
        if (([[params objectForKey:key] isKindOfClass:[UIImage class]])
            ||([[params objectForKey:key] isKindOfClass:[NSData class]]))
        {
            if ([httpMethod isEqualToString:@"GET"])
            {
                DebugNSLog(@"can not use GET to upload a file");
            }
            continue;
        }
        
        NSString* escaped_value = [params objectForKey:key];//[[params objectForKey:key] URLEncodedString];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    if ([query length] > 0)
    {
        return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
    }
    else
    {
        return baseURL;
    }
}

#pragma mark private methods
- (NSString *)appKey
{
    if (!_appKey)
    {
        NSString *key = [self readAuthorizeDataFromKeychain];
        if (!key)
        {
            key = [self saveAuthorizeDataToKeychain];
        }
        
        _appKey = [key copy];
    }
    
    return _appKey;
}

- (NSString *)timestamp
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    NSString *curTime = [NSString stringWithFormat:@"%llu", dTime];
    
    return curTime;
}

- (NSString *)saveAuthorizeDataToKeychain
{
    NSString *uid = [NSString GUIDString];
    NSString *time = [self timestamp];
    
    NSString *appkey = [NSString stringWithFormat:@"%@%@", time, uid];
    appkey = [appkey MD5EncodedString];
     
    [SFHFKeychainUtils storeUsername:kAppName
                         andPassword:appkey
                      forServiceName:kAppService
                      updateExisting:YES
                               error:nil];
    return appkey;
}

- (NSString *)readAuthorizeDataFromKeychain
{
    return [SFHFKeychainUtils getPasswordForUsername:kAppName
                                      andServiceName:kAppService
                                               error:nil];
}

- (void)deleteAuthorizeDataInKeychain
{
    [SFHFKeychainUtils deleteItemForUsername:kAppName andServiceName:kAppService error:nil];
}

- (NSString *)getSigantureWittTimestpamp:(NSString *)timeStamp
{
    NSString *siganture = [NSString stringWithFormat:@"%@%@%@", kAppToken, self.appKey, timeStamp];
    return [siganture MD5EncodedString];
}
@end
