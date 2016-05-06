//
//  HYGetPayNOResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetPayNOResponse.h"

@interface HYGetPayNOResponse ()

@property (nonatomic, copy) NSString *payNO;
@property (nonatomic, copy) NSString *order_cash;
@property (nonatomic, copy) NSString *order_amount;
@property (nonatomic, copy) NSString *call_back_url;

@property (nonatomic, strong) PayReq *wxPayInfo;
@end

@implementation HYGetPayNOResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.payNO = GETOBJECTFORKEY(data, @"pay_no", [NSString class]);
        self.order_cash = GETOBJECTFORKEY(data, @"order_cash", [NSString class]);
        self.order_amount = GETOBJECTFORKEY(data, @"order_amount", [NSString class]);
        self.call_back_url = GETOBJECTFORKEY(data, @"call_back_url", [NSString class]);
        
        NSDictionary *wechat = GETOBJECTFORKEY(data, @"pay_data", [NSDictionary class]);
        
        if ([wechat count] >= 6)
        {
            PayReq *pay = [[PayReq alloc] init];
            pay.partnerId = GETOBJECTFORKEY(wechat, @"partnerid", [NSString class]);
            pay.prepayId = GETOBJECTFORKEY(wechat, @"prepayid", [NSString class]);
            pay.nonceStr = GETOBJECTFORKEY(wechat, @"noncestr", [NSString class]);
            pay.package = GETOBJECTFORKEY(wechat, @"packageValue", [NSString class]);
            pay.timeStamp = (UInt32)[GETOBJECTFORKEY(wechat, @"timestamp", [NSString class]) longLongValue];
            pay.sign = GETOBJECTFORKEY(wechat, @"sign", [NSString class]);
            self.wxPayInfo = pay;
        }

    }
    
    return self;
}

@end
