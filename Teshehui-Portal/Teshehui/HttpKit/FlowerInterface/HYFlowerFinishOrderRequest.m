//
//  HYFlowerFinishOrderRequest.m
//  Teshehui
//
//  Created by ichina on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerFinishOrderRequest.h"
#import "HYFlowerFinishOrderResponse.h"
#import "JSONKit_HY.h"

@implementation HYFlowerFinishOrderRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/addFlowerOrder.action"];
        self.httpMethod = @"POST";
        self.businessType = @"04";
        _isAnonymous = NO;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.businessType length] > 0)
        {
            [newDic setObject:self.businessType forKey:@"businessType"];
        }
        if ([self.userId length] > 0)
        {
             [newDic setObject:self.userId forKey:@"userId"];
        }
        if ([self.itemTotalAmount length] > 0) {
            [newDic setObject:self.itemTotalAmount forKey:@"itemTotalAmount"];
        }
        if ([self.discountAmount length] > 0) {
            [newDic setObject:self.discountAmount forKey:@"discountAmount"];
        }
        if ([self.orderTotalAmount length] > 0)
        {
            [newDic setObject:self.orderTotalAmount forKey:@"orderTotalAmount"];
        }
        if ([self.discountDescription length] > 0)
        {
            [newDic setObject:self.discountDescription forKey:@"discountDescription"];
        }
        if ([self.isNeedInvoice length] > 0)
        {
            [newDic setObject:self.isNeedInvoice forKey:@"isNeedInvoice"];
        }
        if ([self.invoiceType length] > 0)
        {
            [newDic setObject:self.invoiceType forKey:@"invoiceType"];
        }
        if ([self.invoiceTitle length] > 0)
        {
            [newDic setObject:self.invoiceTitle forKey:@"invoiceTitle"];
        }
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        if (self.productSKUCode)
        {
            [dic setObject:self.productSKUCode
                    forKey:@"productSKUCode"];
        }
        
        [dic setObject:[NSNumber numberWithInteger:self.quantity]
                forKey:@"quantity"];
        
        if (self.price)
        {
            [dic setObject:self.price
                    forKey:@"price"];
        }
        if (self.bless)
        {
            [dic setObject:self.bless
                    forKey:@"bless"];
        }
        
        NSArray *array = [NSArray arrayWithObjects:dic, nil];
        NSString *orderitems = [array JSONString];
        
        if ([orderitems length] > 0)
        {
            [newDic setObject:orderitems forKey:@"orderItemList"];
        }
        if ([self.deliveryTime length] > 0)
        {
            [newDic setObject:self.deliveryTime forKey:@"deliveryTime"];
        }
        
        if ([self.invoicePhone length] > 0)
        {
            [newDic setObject:self.invoicePhone forKey:@"invoicePhone"];
        }
        if ([self.invoiceReasonId length] > 0)
        {
            [newDic setObject:self.invoiceReasonId forKey:@"invoiceReasonId"];
        }
        if ([self.invoiceAddress length] > 0)
        {
            [newDic setObject:self.invoiceAddress forKey:@"invoiceAddress"];
        }
        if ([self.isEnterprise length] > 0)
        {
            [newDic setObject:self.isEnterprise forKey:@"isEnterprise"];
        }
        [newDic setObject:[NSNumber numberWithBool:self.isAnonymous]
                   forKey:@"isAnonymous"];
        
        //地址
        if ([self.presentName length] > 0)
        {
            [newDic setObject:self.presentName forKey:@"presentName"];
        }
        if ([self.presentPhone length] > 0)
        {
            [newDic setObject:self.presentPhone forKey:@"presentPhone"];
        }
        if ([self.receiverName length] > 0)
        {
            [newDic setObject:self.receiverName forKey:@"receiverName"];
        }
        if ([self.receiverPhone length] > 0)
        {
            [newDic setObject:self.receiverPhone forKey:@"receiverPhone"];
        }
        if ([self.receiverAddress length] > 0)
        {
            [newDic setObject:self.receiverAddress forKey:@"receiverAddress"];
        }
        if ([self.receiverZipCode length] > 0)
        {
            [newDic setObject:self.receiverZipCode forKey:@"receiverZipCode"];
        }
        if ([self.provinceId length] > 0)
        {
            [newDic setObject:self.provinceId forKey:@"provinceId"];
        }
        if ([self.provinceName length] > 0)
        {
            [newDic setObject:self.provinceName forKey:@"provinceName"];
        }
        if ([self.cityId length] > 0)
        {
            [newDic setObject:self.cityId forKey:@"cityId"];
        }
        if ([self.cityName length] > 0)
        {
            [newDic setObject:self.cityName forKey:@"cityName"];
        }
        if ([self.regionId length] > 0)
        {
            [newDic setObject:self.regionId forKey:@"regionId"];
        }
        if ([self.regionName length] > 0)
        {
            [newDic setObject:self.regionName forKey:@"regionName"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYFlowerFinishOrderResponse *respose = [[HYFlowerFinishOrderResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
