//
//  BusinessDetailRequest.m
//  Teshehui
//
//  Created by apple_administrator on 15/8/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "BusinessDetailRequest.h"
#import "BusinessdetailInfo.h"
#import "NSString+Addition.h"
#import "UIUtils.h"
#import "NSObject+ObjectMap.h"
#import "DefineConfig.h"
@implementation BusinessDetailRequest

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
        NSDictionary *MerIdDic = @{@"MerId" : self.MerId};
        
        NSString *token = V3Token;      //初步写死
        NSString *action = @"";
        NSString *app_key = @"shop";
        NSString *dataJsonString = [MerIdDic JSONString];
        NSString *format = @"json";
        NSString *platform = @"iOS";
        NSString *sign_method = @"md5";
        NSString *timestamp = [UIUtils timestamp];
        NSString *version = [UIUtils getVersion];
        NSString *signString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",token,@"action",action,@"app_key",app_key,@"data",dataJsonString,@"format",format,@"platform",platform,@"sign_method",sign_method,@"timestamp",timestamp,@"version",version,token];
        NSString *sign = [signString MD5EncodedString];
        
//        NSDictionary *paramDic = @{@"action":action,
//                                   @"app_key":app_key,
//                                   @"data":dataJsonString,
//                                   @"format":format,
//                                   @"platform":platform,
//                                   @"sign_method":sign_method,
//                                   @"timestamp":timestamp,
//                                   @"version":version,
//                                   @"sign":sign
//                                   };

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
//    BusinessDetailResponse *respose = [[BusinessDetailResponse alloc]initWithJsonDictionary:info];
//    return respose;
//}
@end
