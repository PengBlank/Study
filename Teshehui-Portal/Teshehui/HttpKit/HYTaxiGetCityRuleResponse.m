//
//  HYTaxiGetCityRuleResponse.m
//  Teshehui
//
//  Created by Kris on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiGetCityRuleResponse.h"

@implementation HYTaxiGetCityRuleResponse

-(id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        if (data)
        {
            NSArray *ruleArray = GETOBJECTFORKEY(data, @"ruleArray", [NSArray class]);
            self.carDataList = [HYTaxiRule arrayOfModelsFromDictionaries:ruleArray];
            self.cityCode = GETOBJECTFORKEY(data, @"cityCode", [NSString class]);
        }
    }
    return self;
}

@end
