//
//  CreatOrderRequest.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CreatOrderRequest.h"
#import "DefineConfig.h"
#import "UIUtils.h"
#import "NSString+Addition.h"
#import "NSObject+ObjectMap.h"
@implementation CreatOrderRequest
- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    [newDic removeAllObjects];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        
        NSDictionary *tmpDic = @{@"userId":self.userId,
                                 @"userName":self.UserName,
                                 @"coupon":@(self.Coupon),
                                 @"cardNo":self.CardNo,
                                 @"mobile":self.Mobile,
                                 @"merId":self.MerId,
                                 @"merchantName":self.MerchantName,
                                 @"merchantLogo":self.MerchantLogo,
                                 @"amount":@(self.Amount),
                                 @"productName":self.productName,
                                 @"first_area_id":@(self.first_area_id),
                                 @"second_area_id":@(self.second_area_id),
                                 @"third_area_id":@(self.third_area_id),
                                 @"fourth_area_id":@(self.fourth_area_id)};
        
        
        NSString *token = CenterToken;
        NSString *action = @"";
        NSString *app_key = @"TSH";
        NSString *dataJsonString = [tmpDic JSONString];
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
//- (NSMutableDictionary *)getJsonDictionary
//{
//    NSMutableDictionary *newDic = [super getJsonDictionary];
//    [newDic removeAllObjects];
//    
//    if (newDic && (NSNull *)newDic != [NSNull null])
//    {
//        
//        [newDic setObject:[NSString stringWithFormat:@"%@", self.UserId]
//                   forKey:@"UserId"];
//        
//        [newDic setObject:[NSString stringWithFormat:@"%@", @(self.Coupon)]
//                   forKey:@"Coupon"];
//        
//        [newDic setObject:[NSString stringWithFormat:@"%@", @(self.Amount)]
//                   forKey:@"Amount"];
//        
//        [newDic setObject:[NSString stringWithFormat:@"%@", self.UserName]
//                   forKey:@"UserName"];
//        
//        [newDic setObject:[NSString stringWithFormat:@"%@", self.CardNo]
//                   forKey:@"CardNo"];
//        
//        [newDic setObject:[NSString stringWithFormat:@"%@", self.Mobile]
//                   forKey:@"Mobile"];
//
//        [newDic setObject:[NSString stringWithFormat:@"%@", self.MerId]
//                   forKey:@"MerId"];
//        
//        [newDic setObject:[NSString stringWithFormat:@"%@", self.MerchantName]
//                   forKey:@"MerchantName"];
//        
//        [newDic setObject:[NSString stringWithFormat:@"%@", self.MerchantLogo]
//                   forKey:@"MerchantLogo"];
//        
//        [newDic setObject:[NSString stringWithFormat:@"%@", @(self.first_area_id)]
//                   forKey:@"first_area_id"];
//        
//        [newDic setObject:[NSString stringWithFormat:@"%@", @(self.second_area_id)]
//                   forKey:@"second_area_id"];
//        
//        [newDic setObject:[NSString stringWithFormat:@"%@", @(self.third_area_id)]
//                   forKey:@"third_area_id"];
//        
//        [newDic setObject:[NSString stringWithFormat:@"%@", @(self.fourth_area_id)]
//                   forKey:@"fourth_area_id"];
//        
//        
//    }
//    
//    return newDic;
//}
@end
