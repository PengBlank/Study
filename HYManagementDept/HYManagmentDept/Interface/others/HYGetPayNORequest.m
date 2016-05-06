//
//  HYGetPayNORequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetPayNORequest.h"
#import "HYDataManager.h"

@implementation HYGetPayNORequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"order/select_payment"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
    }
    
    return self;
}

- (void)setType:(ProductPayType)type
{
    switch (type)
    {
        case Pay_Mall:
            self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"api/order/select_payment"];
            break;
        case Pay_BuyCard:
        case Pay_Renewal:
        case Pay_Upgrad:
            self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"api/online_card/select_payment"];
            break;
        case Pay_Hotel:
            self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL,@"json/orders/select_payment"];
            break;
        case Pay_Flight:
            self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"api/Order/select_payment"];
            break;
        case Pay_Flower:
            self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"api/orders/select_payment"];
            break;
        default:
            break;
    }
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.order_id length] > 0)
        {
            [newDic setObject:self.order_id forKey:@"order_id"];
        }
        
        if ([self.payment length] > 0)
        {
            [newDic setObject:self.payment forKey:@"payment"];
        }
        NSString *userid = [HYDataManager sharedManager].userInfo.user_id;
        if (userid.length > 0)
        {
            [newDic setObject:userid forKey:@"user_id"];
        }
        if ([self.payment length] > 0)
        {
            [newDic setObject:self.payment forKey:@"payment"];
        }
    }
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetPayNOResponse *respose = [[HYGetPayNOResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
