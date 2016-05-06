//
//  OrderStatusRequest.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "OrderStatusRequest.h"

@implementation OrderStatusRequest

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    [newDic removeAllObjects];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        
        [newDic setObject:[NSString stringWithFormat:@"%@", self.UserId]
                   forKey:@"UserId"];
        
        [newDic setObject:[NSString stringWithFormat:@"%@", self.Coupon]
                   forKey:@"Coupon"];
        
        [newDic setObject:[NSString stringWithFormat:@"%@", self.O2O_Order_Number]
                   forKey:@"O2O_Order_Number"];
        
        [newDic setObject:[NSString stringWithFormat:@"%@", self.C2B_Order_Number]
                   forKey:@"C2B_Order_Number"];
        
        [newDic setObject:[NSString stringWithFormat:@"%@", self.CardNo]
                   forKey:@"CardNo"];
        
    }
    
    return newDic;
}

@end
