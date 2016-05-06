//
//  HYAddRechargeOrderResponse.m
//  Teshehui
//
//  Created by Kris on 16/3/2.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYAddRechargeOrderResponse.h"

@interface HYAddRechargeOrderResponse ()

//@property (nonatomic, strong) HYPhoneChargeOrderModel *order;

@end

@implementation HYAddRechargeOrderResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        NSDictionary *porder = GETOBJECTFORKEY(data, @"parentOrder", NSDictionary);
        HYPhoneChargeOrder *order = [[HYPhoneChargeOrder alloc] initWithDictionary:porder
                                                                             error:nil];
        self.order = order;
    }
    return self;
}

//- (id)initWithJsonDictionary:(NSDictionary *)dictionary
//{
//    if (self = [super initWithJsonDictionary:dictionary])
//    {
//        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
//        if (data)
//        {
//            NSDictionary *parentOrder = GETOBJECTFORKEY(data, @"parentOrder", [NSDictionary class]);
//            
//            if (parentOrder)
//            {
//                self.order = [[HYPhoneChargeOrderModel alloc]initWithDictionary:parentOrder
//                                                                          error:nil];
//            }
//        }
//    }
//    return self;
//}

@end
