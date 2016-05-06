//
//  HYAfterSaleAddDeliveryRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/15.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYAfterSaleAddDeliveryRequest.h"

@implementation HYAfterSaleAddDeliveryRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/afterSeller/addReturnDelivery.action", kJavaRequestBaseURL];
        self.httpMethod = @"POST";
        self.businessType = @"01";
        self.version = @"1.0.1";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.returnFlowDetailId)
        {
            [newDic setObject:self.returnFlowDetailId forKey:@"returnFlowDetailId"];
        }
        if (self.deliveryName)
        {
            [newDic setObject:self.deliveryName forKey:@"deliveryName"];
        }
        if (self.deliveryCode)
        {
            [newDic setObject:self.deliveryCode forKey:@"deliveryCode"];
        }
        if (self.deliveryNo)
        {
            [newDic setObject:self.deliveryNo forKey:@"deliveryNo"];
        }
        if (self.freightFee)
        {
            [newDic setObject:self.freightFee forKey:@"freightFee"];
        }
    }
    
    return newDic;
}

@end
