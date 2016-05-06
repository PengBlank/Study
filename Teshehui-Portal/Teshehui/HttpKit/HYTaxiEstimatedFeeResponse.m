//
//  HYTaxiEstimatedFeeResponse.m
//  Teshehui
//
//  Created by Kris on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiEstimatedFeeResponse.h"

@implementation HYTaxiEstimatedFeeResponse

-(id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSArray *data = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        if (data.count > 0)
        {
            self.dataList = [HYTaxiFeeModel arrayOfModelsFromDictionaries:data];
        }
    }
    return self;
}

@end
