//
//  CityListRequest.m
//  Teshehui
//
//  Created by apple_administrator on 15/8/28.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CityListRequest.h"
#import "CitySelectInfo.h"
#import "DefineConfig.h"
#import "UIUtils.h"
#import "NSString+Addition.h"
@implementation CityListRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {

    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    [newDic removeAllObjects];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        
        NSString *token = V3Token;      //初步写死
        NSString *action = @"";
        NSString *app_key = @"shop";
        NSString *dataJsonString = @"";
        NSString *format = @"json";
        NSString *platform = @"iOS";
        NSString *sign_method = @"md5";
        NSString *timestamp = [UIUtils timestamp];
        NSString *version = [UIUtils getVersion];
        NSString *signString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",token,@"action",action,@"app_key",app_key,@"data",dataJsonString,@"format",format,@"platform",platform,@"sign_method",sign_method,@"timestamp",timestamp,@"version",version,token];
        NSString *sign = [signString MD5EncodedString];
        
        
        [newDic setObject:[NSString stringWithFormat:@"%@", action]
                   forKey:@"action"];
        [newDic setObject:[NSString stringWithFormat:@"%@", app_key]
                   forKey:@"app_key"];
        [newDic setObject:[NSString stringWithFormat:@"%@", dataJsonString]
                   forKey:@"data"];
        [newDic setObject:[NSString stringWithFormat:@"%@", format]
                   forKey:@"format"];
        [newDic setObject:[NSString stringWithFormat:@"%@", platform]
                   forKey:@"platform"];
        [newDic setObject:[NSString stringWithFormat:@"%@", sign_method]
                   forKey:@"sign_method"];
        [newDic setObject:[NSString stringWithFormat:@"%@", timestamp]
                   forKey:@"timestamp"];
        [newDic setObject:[NSString stringWithFormat:@"%@", version]
                   forKey:@"version"];
        [newDic setObject:[NSString stringWithFormat:@"%@", sign]
                   forKey:@"sign"];
        
        
        
    }
    
    return newDic;
}


//- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
//{
//    CityListResponse *respose = [[CityListResponse alloc]initWithJsonDictionary:info];
//    return respose;
//}
@end
