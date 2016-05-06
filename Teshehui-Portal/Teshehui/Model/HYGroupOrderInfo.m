//
//  HYGroupOrderInfo.m
//  Teshehui
//
//  Created by HYZB on 2014/12/17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGroupOrderInfo.h"

@implementation HYGroupOrderInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    if (self)
    {
        self.localOrderId = GETOBJECTFORKEY(data, @"orderId", [NSString class]);
        self.thirdOrderId = GETOBJECTFORKEY(data, @"thirdOrderId", [NSString class]);
        self.buyerId = GETOBJECTFORKEY(data, @"buyerId", [NSString class]);
        self.orderType = GETOBJECTFORKEY(data, @"orderType", [NSString class]);
        self.orderAmount = [GETOBJECTFORKEY(data, @"orderPayAmount", [NSString class]) floatValue];
        self.points = [GETOBJECTFORKEY(data, @"orderTbAmount", [NSString class]) intValue];
        self.itemAmount = [GETOBJECTFORKEY(data, @"itemTotalAmount", [NSString class]) floatValue];
        self.actualAmount = [GETOBJECTFORKEY(data, @"orderToatalAmount", [NSString class]) floatValue];
        self.payStatus = GETOBJECTFORKEY(data, @"payStatus", [NSString class]);
        self.orderStatus = GETOBJECTFORKEY(data, @"orderStatus", [NSString class]);
        self.orderCreateTime = GETOBJECTFORKEY(data, @"creationTime", [NSString class]);
        self.orderUpdateTime = GETOBJECTFORKEY(data, @"updateTime", [NSString class]);
        self.whetherTebi = [GETOBJECTFORKEY(data, @"whetherTebi", [NSString class]) boolValue];
        self.whetherSettlement = GETOBJECTFORKEY(data, @"whetherSettlement", [NSString class]);
        self.agencyId = GETOBJECTFORKEY(data, @"agencyId", [NSString class]);
        self.companyId = GETOBJECTFORKEY(data, @"companyId", [NSString class]);
        self.promotersId = GETOBJECTFORKEY(data, @"promotersId", [NSString class]);
        
        NSArray *orderDetails = GETOBJECTFORKEY(data, @"orderItemPOList", [NSArray class]);
        
        for (id obj in orderDetails)
        {
            self.orderDetail = [[HYGroupOrderDetailInfo alloc] initWithDataInfo:obj];
            break;
        }
    }
    
    return self;
        
//        self.orderFrom = GETOBJECTFORKEY(data, @"orderFrom", [NSString class]);
        
//        self.orderCancelTime = GETOBJECTFORKEY(data, @"orderCancelTime", [NSString class]);
//        self.deliverType = GETOBJECTFORKEY(data, @"deliverType", [NSString class]);
//        self.orderDeliverAddress = GETOBJECTFORKEY(data, @"orderDeliverAddress", [NSString class]);
//        self.lpType = GETOBJECTFORKEY(data, @"lpType", [NSString class]);
//        self.buyerMessage = GETOBJECTFORKEY(data, @"buyerMessage", [NSString class]);
//        
//        
//        
//        self.payType = GETOBJECTFORKEY(data, @"payType", [NSString class]);
//        
//        
//        self.lpStatus = GETOBJECTFORKEY(data, @"lpStatus", [NSString class]);
//        
//        
//        self.invoiceId = GETOBJECTFORKEY(data, @"invoiceId", [NSString class]);
}

/*
"data":[
        {
            "orderId":0,
            "thirdOrderId":"966302515",
            "buyerId":"13080",
            "orderType":"coupon",
            "orderPayAmount":449.5,
            "orderTbAmount":450,
            "itemTotalAmount":449.5,
            "orderToatalAmount":449.5,
            "payStatus":"未支付",
            "orderStatus":"已下单",
            "creationTime":"2015-01-30 21:23:06",
            "updateTime":"2015-01-30 21:23:06",
            "whetherTebi":0,
            "whetherSettlement":0,
            "agencyId":222,
            "companyId":11,
            "promotersId":0,
            "orderItemPOList":[
                               {
                                   "productName":"潮州府砂锅粥代金券",
                                   "quantity":5
                               }
                               ]
        }
        ],
*/
@end
