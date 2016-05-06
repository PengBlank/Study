//
//  SceneBookDetailInfo.m
//  Teshehui
//
//  Created by LiuLeiMacmini on 16/4/12.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "SceneBookDetailRequest.h"

#import "NSString+Addition.h"
#import "UIUtils.h"
#import "NSObject+ObjectMap.h"
#import "DefineConfig.h"

@implementation SceneBookDetailRequest


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


        
        NSDictionary *MerIdDic = @{
                                   @"merId" : _merId,
                                   @"userId":self.userId,
                                   @"merchantName" : _merchantName
                                           ,@"cardNo" : _cardNo
                                           ,@"mobile" : _mobile
                                           ,@"userName" : _userName
                                           ,@"amount" : _amount
                                           ,@"coupon" : _coupon
                                           ,@"productName" : _productName
                                           ,@"packId" : _packId
                                           ,@"packageName" : _packageName
                                           ,@"packagePerson" : _packagePerson
                                           ,@"packageCount" : _packageCount
                                           ,@"useDate" : _useDate
                                           ,@"cityName" : _cityName};
        
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

@end
