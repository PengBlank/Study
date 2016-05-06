//
//  HYGetUpdateInfoRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-4-28.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetUpdateInfoRequest.h"

@interface HYGetUpdateInfoRequest ()

@property (nonatomic, copy) NSString *version_no;  //订单id
@property (nonatomic, copy) NSString *terminal;  //终端类型

@end

@implementation HYGetUpdateInfoRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"version/yy_get_version"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{ 
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
//        NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
//        self.version_no =[infoDict objectForKey:@"CFBundleVersion"];
//        
//        if ([self.version_no length] > 0)
//        {
//            
//        }
//#warning 该值表示服务器版本号，不对应appstore，从1开始，每次版本发布前需要升级
        //[newDic setObject:@"3" forKey:@"version_no"];
        [newDic setObject:@"4" forKey:@"version_no"];
        
        //4代表ios运营
        [newDic setObject:@"4" forKey:@"type"];
    }
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetUpdateInfoResponse *respose = [[HYGetUpdateInfoResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
