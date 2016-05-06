//
//  HYPayWaysRequest.m
//  Teshehui
//
//  Created by Kris on 15/5/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYPayWaysRequest.h"

@implementation HYPayWaysRequest

-(instancetype)init
{
    if (self = [super init]) {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/voucher/add_voucher"];
        self.httpMethod = @"POST";
    }
    return self;
}

-(NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.buyer_id)
        {
            [newDic setObject:self.buyer_id
                       forKey:@"buyer_id"];
        }
        
        if (self.voucher_code)
        {
            [newDic setObject:self.voucher_code
                       forKey:@"voucher_code"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYPayWaysResponse *respose = [[HYPayWaysResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
