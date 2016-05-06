//
//  HYGetRechargeGoodsResponse.m
//  Teshehui
//
//  Created by Kris on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYGetRechargeGoodsResponse.h"

@interface HYGetRechargeGoodsResponse ()

@property (nonatomic, strong) NSArray *dataList;

@end

@implementation HYGetRechargeGoodsResponse

-(id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        if (data)
        {
            NSArray *goods = GETOBJECTFORKEY(data, @"goods", [NSArray class]);
            if (goods.count > 0)
            {
                self.dataList = [HYPhoneChargeModel arrayOfModelsFromDictionaries:goods];
            }
        }
    }
    return self;
}

@end
