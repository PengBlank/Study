//
//  HYHotelOrderRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelOrderRequest.h"
#import "HYHotelOrderResponse.h"
#import "JSONKit_HY.h"
#import "HYPassengers.h"

@interface HYHotelOrderRequest ()

@end

@implementation HYHotelOrderRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/addHotelOrder.action"];
        self.httpMethod = @"POST";
        self.businessType = @"03";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.userId length] > 0)
        {
            [newDic setObject:self.userId forKey:@"userId"];
        }
        if ([self.remark length] > 0)
        {
            [newDic setObject:self.remark forKey:@"remark"];
        }
        
        CGFloat itemTotalAmount = (CGFloat)self.quantity * ([self.price floatValue]);
        self.itemTotalAmount = itemTotalAmount;
        
        [newDic setObject:[NSNumber numberWithFloat:self.itemTotalAmount]
                   forKey:@"itemTotalAmount"];
        
        if (self.discountAmount)
        {
            [newDic setObject:self.discountAmount forKey:@"discountAmount"];
        }
        
        self.orderTotalAmount = itemTotalAmount;
        if (self.invoiceModel)
        {
            self.orderTotalAmount += self.invoiceModel.method.shippingMethodFee;
        }
        [newDic setObject:[NSNumber numberWithFloat:self.itemTotalAmount]
                   forKey:@"orderTotalAmount"];
        
        //酒店信息数组参数
        NSMutableDictionary *orderItemListDic = [NSMutableDictionary dictionary];
        
        if (self.productSKUCode)
        {
            [orderItemListDic setObject:self.productSKUCode forKey:@"productSKUCode"];
        }
        
        [orderItemListDic setObject:[NSNumber numberWithInteger:self.quantity]
                             forKey:@"quantity"];
        
        if (orderItemListDic.count > 0)
        {
            NSArray *list = [NSArray arrayWithObject:orderItemListDic];
            NSString *jsonStr = [list JSONString];
            
            [newDic setObject:jsonStr forKey:@"orderItemList"];
        }
        
        if ([self.startTimeSpan length] > 0)
        {
            [newDic setObject:self.startTimeSpan forKey:@"startTimeSpan"];
        }
        if ([self.endTimeSpan length] > 0)
        {
            [newDic setObject:self.endTimeSpan forKey:@"endTimeSpan"];
        }
        if ([self.latestArrivalTime length] > 0)
        {
            [newDic setObject:self.latestArrivalTime forKey:@"latestArrivalTime"];
        }
        if ([self.contactName length] > 0)
        {
            [newDic setObject:self.contactName forKey:@"contactName"];
        }
        if ([self.contactPhone length] > 0)
        {
            [newDic setObject:self.contactPhone forKey:@"contactPhone"];
        }
        if ([self.contactEmail length] > 0)
        {
            [newDic setObject:self.contactEmail forKey:@"contactEmail"];
        }
        if ([self.isEnterprise length] > 0)
        {
            [newDic setObject:self.isEnterprise
                       forKey:@"isEnterprise"];
        }
        //旅客信息数组参数
        if ([self.guestPOList count] > 0)
        {
            NSMutableArray *passengerList = [[NSMutableArray alloc] init];
            for (HYPassengers *psg in self.guestPOList)
            {
                if (psg.passengerId)
                {
                    NSMutableDictionary *guestPOListDic = [NSMutableDictionary dictionary];
                    [guestPOListDic setObject:psg.passengerId forKey:@"guestId"];
                    [passengerList addObject:guestPOListDic];
                }
            }
            
            NSString *jsonStr = [passengerList JSONString];
            
            [newDic setObject:jsonStr forKey:@"guestPOList"];
        }
        
        //担保信息
        if ([self.creditCardType length] > 0)
        {
            [newDic setObject:self.creditCardType
                       forKey:@"creditCardType"];
        }
        if ([self.creditCardNumber length] > 0)
        {
            [newDic setObject:self.creditCardNumber
                       forKey:@"creditCardNumber"];
        }
        if ([self.creditCardSeriesCode length] > 0)
        {
            [newDic setObject:self.creditCardSeriesCode
                       forKey:@"creditCardSeriesCode"];
        }
        if ([self.creditCardEffectiveDate length] > 0)
        {
            [newDic setObject:self.creditCardEffectiveDate
                       forKey:@"creditCardEffectiveDate"];
        }
        if ([self.creditCardHolderName length] > 0)
        {
            [newDic setObject:self.creditCardHolderName
                       forKey:@"creditCardHolderName"];
        }
        if ([self.creditCardHolderIDCardNumber length] > 0)
        {
            [newDic setObject:self.creditCardHolderIDCardNumber
                       forKey:@"creditCardHolderIDCardNumber"];
        }
        if ([self.creditCardHolderMobile length] > 0)
        {
            [newDic setObject:self.creditCardHolderMobile
                       forKey:@"creditCardHolderMobile"];
        }
        
        //发票信息
        if (self.isNeedInvoice && self.invoiceModel)
        {
            [newDic setObject:@(self.isNeedInvoice) forKey:@"isNeedInvoice"];
            if ([self.invoiceModel.invoice_title length] > 0)
            {
                [newDic setObject:self.invoiceModel.invoice_title forKey:@"invoiceTitle"];
            }
            if ([self.invoiceModel.invoice_address_id length] > 0)
            {
                [newDic setObject:self.invoiceModel.invoice_address_id forKey:@"userAddressId"];
            }
            if ([self.invoiceModel.method.shippingMethodId length] > 0)
            {
                [newDic setObject:self.invoiceModel.method.shippingMethodId
                           forKey:@"deliveryId"];
            }
            if ([self.invoiceModel.invoice_description length] > 0)
            {
                [newDic setObject:self.invoiceModel.invoice_description
                           forKey:@"invoiceContent"];
            }
        }
        
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"酒店订单请求缺少必须参数");
    }
#endif
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYHotelOrderResponse *respose = [[HYHotelOrderResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
