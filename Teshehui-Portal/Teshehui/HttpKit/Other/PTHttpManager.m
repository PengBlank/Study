//
//  PTHttpManager.m
//  ContactHub
//
//  Created by ChengQian on 13-3-11.
//  Copyright (c) 2013年 www.putao.cn. All rights reserved.
//

#import "PTHttpManager.h"
#import "JSONKit_HY.h"
#import "CQBaseRequest.h"
#import "NSString+Addition.h"
#import "SFHFKeychainUtils.h"
#import "ASIDownloadCache.h"

#import "HYUserInfo.h"

#define kRequestTimeOutInterval 120
#define kAppName  @"teshehui"
#define kAppToken @"4320949f91f066e71860832f4f0b07b2"
#define kAppService  @"HYZB528"

@interface PTHttpManager ()

@property (nonatomic, strong) NSMutableDictionary *requestDic;
@property (nonatomic, copy) NSString *appKey;

@end

static PTHttpManager *instantane = nil;

@implementation PTHttpManager

@synthesize requestDic = _requestDic;

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
        _requestTag = 1000;
    }
    return self;
}

- (void)clean
{
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

- (void)sendPostRequestWithParam:(CQBaseRequest *)requestParam
{
    [self sendPostRequestWithParam:requestParam tag:requestParam.tag];
}

- (void)sendPostRequestWithParam:(CQBaseRequest *)param tag:(NSInteger)tag
{
    BOOL post = [param.httpMethod isEqualToString:@"POST"];
    NSString *url = nil;
    
    if (post)
    {
        const char *str = [param.interfaceURL UTF8String];
        url = [NSString stringWithUTF8String:str];
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
    
    //处理中文
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:parsedURL];
    request.shouldAttemptPersistentConnection = NO;  //不做长连接
    [request setValidatesSecureCertificate:NO];  //验证
    [request setShouldCompressRequestBody:NO];  //设置请求zip压缩
    [request setAllowCompressedResponse:YES];  //设置response为zip压缩
    [request setSecondsToCache:60*60*24];  //缓存1天
    [request setRequestMethod:param.httpMethod];
    [[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
    request.downloadCache = [ASIDownloadCache sharedCache];
    request.cachePolicy = ASIFallbackToCacheIfLoadFailsCachePolicy;  //服务器读取失败才读缓存
    request.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
    
    if (post)
    {
        NSDictionary *params = param.getJsonDictionary;
        
        if (param.postType == JSON)
        {
            const char *str = [param.interfaceURL UTF8String];
            url = [NSString stringWithUTF8String:str];
            
            NSError *error = NULL;
            
            NSString *requestBodyJson = [params JSONStringWithOptions:JKSerializeOptionNone
                                                                error:&error];
            
            DebugNSLog(@"request params %@", requestBodyJson);
            if (error || (NSNull *)requestBodyJson==[NSNull null])
            {
#ifndef __OPTIMIZE__
                DebugNSLog(@"send requst encode json error");
#endif
                return;
            }
            
            NSData *data = [requestBodyJson dataUsingEncoding:NSUTF8StringEncoding];
            [request appendPostData:data];
            
            [request addRequestHeader:@"Content-Type"
                                value:@"application/json;"];
        }
        else if (param.postType == KeyValue)
        {
            DebugNSLog(@"request params %@", params);
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
                else if ([val isKindOfClass:[NSArray class]])  //兼容处理同一个key对应多个value的奇葩情况（主要是protal层的评论商品接口）
                {
                    BOOL mulitKey = NO;
                    for (id obj in (NSArray *)val)
                    {
                        mulitKey = [obj isKindOfClass:[NSDictionary class]];
                        if (mulitKey)
                        {
                            NSDictionary *paramDic = (NSDictionary *)obj;
                            
                            for (NSString *paramKey in paramDic.allKeys)
                            {
                                id param = [paramDic objectForKey:paramKey];
                                
                                NSString *contentType = [self contentTypeForImageData:param];
                                if (contentType)
                                {
                                    [request addData:param
                                        withFileName:@"upload.jpg"
                                      andContentType:contentType
                                              forKey:paramKey];
                                }
                                else
                                {
                                    [request addData:param forKey:paramKey];
                                }
                            }
                        }
                    }
                    
                    if (!mulitKey)
                    {
                        [request addPostValue:val forKey:key];
                    }
                }
                else
                {
                    [request addPostValue:val forKey:key];
                }
            }
        }
    }
    
    if (param.interfaceType == PHP)
    {
        [request addRequestHeader:@"app-key" value:self.appKey];
        
        NSString *time = [self timestamp];
        [request addRequestHeader:@"timestamp" value:time];
        
        NSString *signature = [self getSigantureWittTimestpamp:time];
        [request addRequestHeader:@"signature" value:signature];
        
        [request addRequestHeader:@"app-from" value:@"ios"];
        [request addRequestHeader:@"imei" value:@""];
//        [request addRequestHeader:@"internal_version"
//                            value:@"20150313003"];

        [request addRequestHeader:@"internal_version"
                            value:@"20150408001"];
        
    }else if (param.interfaceType == DotNET && [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]){
        
        HYUserInfo *user = [HYUserInfo getUserInfo];
        NSString *token = @"1f3517e7f8c994bb7b546655afa55628";      //初步写死
        NSString *nameString = user.realName.length == 0 ? user.mobilePhone : user.realName;
        NSString *aName = [nameString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //转个码
        
        NSString *aid   = user.userId.length == 0 ? @"" : user.userId;
        NSString *sign = [[NSString stringWithFormat:@"%@%@%@%@",token,aid,aName,token] MD5EncodedString];
        
        [request addRequestHeader:@"Aid" value:aid];
        [request addRequestHeader:@"AName" value:aName];
        [request addRequestHeader:@"Sign" value:sign];
        
    }
    else
    {
        /**
         *  添加设备唯一码
         */
        
        NSString *time = [self timestamp];
        [request addRequestHeader:@"timestamp" value:time];
        
        NSString *signature = [self getSigantureWittTimestpamp:time];
        [request addRequestHeader:@"signature" value:signature];
    }
    
    [request addRequestHeader:@"User-Agent"
                        value:@"iOS"];
    [request addRequestHeader:@"Accept-Charset"
                        value:@"UTF-8"];
    
    //    [request setShouldCompressRequestBody:YES];
    /*
     */
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
    
//    request.delegate = param;
//    request.shouldCompressRequestBody = NO;
    [request setTimeOutSeconds:kRequestTimeOutInterval];
    [request startAsynchronous];
    
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
- (NSString *)serializeURL:(NSString *)baseURL
                    params:(NSDictionary *)params
                httpMethod:(NSString *)httpMethod
{
    /*
     NSURL *parsedURL = [NSURL URLWithString:baseURL];
     NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
     NSString *query = [self stringFromDictionary:params];
     
     return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
     */
//    NSURL* parsedURL = [NSURL URLWithString:baseURL];
//    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
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
        return [NSString stringWithFormat:@"%@?%@", baseURL, query];
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
    NSDate *date = [NSDate date];    
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;
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


//php的签名算法
- (NSString *)getSigantureWittTimestpamp:(NSString *)timeStamp
{
    NSString *siganture = [NSString stringWithFormat:@"%@%@%@", kAppToken, self.appKey, timeStamp];
    return [siganture MD5EncodedString];
}

- (NSString *)signWithURL:(NSString *)URL
{
    if (URL.length > 0)
    {
        PTHttpManager *mg = [PTHttpManager getInstantane];
        NSString *user_id = [NSString stringWithFormat:@"user_id=%@",[[HYUserInfo getUserInfo] userId]];
        NSString *appkey = [NSString stringWithFormat:@"app_key=%@", [mg appKey]];
        NSString *token = [NSString stringWithFormat:@"token=%@", [HYUserInfo getUserInfo].token];
        
        NSString *timestamp = [mg timestamp];
        NSString *signature = [mg getSigantureWittTimestpamp:timestamp];
        signature = [NSString stringWithFormat:@"signature=%@", signature];
        timestamp = [NSString stringWithFormat:@"timestamp=%@", timestamp];
        
        //app version
        NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
        NSString* appVersion =[infoDict objectForKey:@"CFBundleShortVersionString"];
        
        NSMutableString *str = [NSMutableString string];
        if ([appkey length]&&
            [timestamp length]&&
            [signature length] &&
            [token length]&&
            [appVersion length])
        {
            [str appendString:appkey];
            [str appendString:[NSString stringWithFormat:@"&%@", timestamp]];
            [str appendString:[NSString stringWithFormat:@"&%@", signature]];
            [str appendString:@"&app_from=IOS"];
            [str appendString:[NSString stringWithFormat:@"&%@", user_id]];
            [str appendString:[NSString stringWithFormat:@"&%@", token]];
            [str appendString:[NSString stringWithFormat:@"&appVersion=%@", appVersion]];
            
            
            NSURL* parsedURL = [NSURL URLWithString:URL];
            NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
            
            NSString *url = [NSString stringWithFormat:@"%@%@%@", URL, queryPrefix, str];
            url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            
            return url;
        }
    }
    return nil;
}

@end
