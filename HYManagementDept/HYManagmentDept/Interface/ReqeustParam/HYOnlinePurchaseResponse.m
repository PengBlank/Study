//
//  HYPurchaseResponse.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-11-4.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYOnlinePurchaseResponse.h"

@implementation HYOnlinePurchaseResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSInteger order_id = [GETOBJECTFORKEY(self.jsonDic, @"order_id", [NSString class]) intValue];
        self.order_id = [NSString stringWithFormat:@"%ld", (long)order_id];
        self.order_no = GETOBJECTFORKEY(self.jsonDic, @"order_no", [NSString class]);
        self.order_name = GETOBJECTFORKEY(self.jsonDic, @"order_name", [NSString class]);
        self.pay_total = GETOBJECTFORKEY(self.jsonDic, @"pay_total", [NSString class]);
    }
    
    return self;
}

@end
