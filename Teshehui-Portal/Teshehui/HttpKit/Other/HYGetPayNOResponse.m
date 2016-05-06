//
//  HYGetPayNOResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetPayNOResponse.h"

@interface HYGetPayNOResponse ()

@property (nonatomic, copy) NSString *tradeItemCode;
@property (nonatomic, copy) NSString *ylPrepayNo;
@property (nonatomic, copy) NSString *cashAmount;
@property (nonatomic, copy) NSString *notifyUrl;

@property (nonatomic, strong) PayReq *wxPayInfo;

@end

@implementation HYGetPayNOResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.tradeItemCode = GETOBJECTFORKEY(data, @"tradeItemCode", [NSString class]);
        self.ylPrepayNo = GETOBJECTFORKEY(data, @"prepayNo", [NSString class]);
        self.cashAmount = GETOBJECTFORKEY(data, @"cashAmount", [NSString class]);
        self.notifyUrl = GETOBJECTFORKEY(data, @"notifyUrl", [NSString class]);
        
        PayReq *pay = [[PayReq alloc] init];
        pay.partnerId = GETOBJECTFORKEY(data, @"partnerId", [NSString class]);
        pay.prepayId = GETOBJECTFORKEY(data, @"prepayId", [NSString class]);
        pay.nonceStr = GETOBJECTFORKEY(data, @"nonceString", [NSString class]);
        pay.package = GETOBJECTFORKEY(data, @"packageValue", [NSString class]);
        pay.timeStamp = (UInt32)[GETOBJECTFORKEY(data, @"timestamp", [NSString class]) longLongValue];
        pay.sign = GETOBJECTFORKEY(data, @"sign", [NSString class]);
        self.wxPayInfo = pay;
    }
    
    return self;
}

@end
