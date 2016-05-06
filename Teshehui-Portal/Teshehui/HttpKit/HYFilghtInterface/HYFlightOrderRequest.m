//
//  HYFlightOrderRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightOrderRequest.h"
#import "JSONKit_HY.h"
#import "HYUserInfo.h"

@implementation HYFlightOrderRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/addTicketOrder.action"];
        self.httpMethod = @"POST";
//        self.cabin_level = 0;
        self.businessType = @"02";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
//        [self.userAddressId length] > 0 &&
//        [self.contactName length] > 0 &&
        [self.contactPhone length] > 0 &&
        [self.guestItems count] > 0 &&
        self.cabin.productSKUId.length > 0)
    {
        if (self.userAddressId.length > 0)
        {
            [newDic setObject:self.userAddressId forKey:@"userAddressId"];
        }
        
//        [newDic setObject:self.contactName forKey:@"contactName"];
        [newDic setObject:self.contactPhone forKey:@"contactPhone"];
        NSString *userid = [HYUserInfo getUserInfo].userId;
        if (userid.length > 0)
        {
            [newDic setObject:userid forKey:@"userId"];
        }
        
        //航班和仓位信息
        NSArray *skus = @[@{@"productSKUCode": self.cabin.productSKUId}];
        NSString *skusjson = [skus JSONString];
        [newDic setObject:skusjson forKey:@"orderItemPOList"];
        
        //旅客信息
        NSMutableArray *guestids = [NSMutableArray array];
        for (HYPassengers *passenger in self.guestItems)
        {
            [guestids addObject:passenger.passengerId];
        }
        NSString *guestjson = [guestids JSONString];
        [newDic setObject:guestjson forKey:@"guestIdList"];
        
        //标量参数，请在构造方法中设默认值
        if (_itemTotalAmount > 0)
        {
            [newDic setObject:@(self.itemTotalAmount) forKey:@"itemTotalAmount"];
        }
        if (self.orderTbAmount > 0)
        {
            [newDic setObject:@(self.orderTbAmount) forKey:@"orderTbAmount"];
        }
        if (self.deliveryFee > 0)
        {
            [newDic setObject:@(self.deliveryFee) forKey:@"deliveryFee"];
        }
        if (self.discountAmount > 0)
        {
            [newDic setObject:@(self.discountAmount) forKey:@"discountAmount"];
        }
        [newDic setObject:@(self.isNeedInvoice) forKey:@"isNeedInvoice"];
        [newDic setObject:@(self.isNeenJourney) forKey:@"isNeenJourney"];
        
        if ([self.discountDescription length] > 0)
        {
            [newDic setObject:self.discountDescription forKey:@"discountDescription"];
        }
        if ([self.invoiceType length] > 0)
        {
            [newDic setObject:self.invoiceType forKey:@"invoiceType"];
        }
        if ([self.invoiceTitle length] > 0)
        {
            [newDic setObject:self.invoiceTitle forKey:@"invoiceTitle"];
        }
        if ([self.creditCardType length] > 0)
        {
            [newDic setObject:self.creditCardType forKey:@"creditCardType"];
        }
        if ([self.creditCardNumber length] > 0)
        {
            [newDic setObject:self.creditCardNumber forKey:@"creditCardNumber"];
        }
        if ([self.creditCardSeriesCode length] > 0)
        {
            [newDic setObject:self.creditCardSeriesCode forKey:@"creditCardSeriesCode"];
        }
        if ([self.creditCardEffectiveDate length] > 0)
        {
            [newDic setObject:self.creditCardEffectiveDate forKey:@"creditCardEffectiveDate"];
        }
        if ([self.creditCardHolderName length] > 0)
        {
            [newDic setObject:self.creditCardHolderName forKey:@"creditCardHolderName"];
        }
        if ([self.creditCardHolderIDCardType length] > 0)
        {
            [newDic setObject:self.creditCardHolderIDCardType forKey:@"creditCardHolderIDCardType"];
        }
        if ([self.creditCardHolderIDCardNumber length] > 0)
        {
            [newDic setObject:self.creditCardHolderIDCardNumber forKey:@"creditCardHolderIDCardNumber"];
        }
        if ([self.creditCardHolderMobile length] > 0)
        {
            [newDic setObject:self.creditCardHolderMobile forKey:@"creditCardHolderMobile"];
        }
        
        if ([self.isEnterprise length] > 0)
        {
            [newDic setObject:self.isEnterprise forKey:@"isEnterprise"];
        }
        if ([self.remark length] > 0)
        {
            [newDic setObject:self.remark forKey:@"remark"];
        }
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"机票预定请求缺少必须参数");
    }
#endif
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlightOrderResponse *respose = [[HYFlightOrderResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
