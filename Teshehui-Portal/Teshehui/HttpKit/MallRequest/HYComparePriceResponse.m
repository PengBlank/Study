//
//  HYComparePriceResponse.m
//  Teshehui
//
//  Created by Kris on 15/9/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYComparePriceResponse.h"

@implementation HYComparePriceResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *info = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        
        self.comparePriceModel = [[HYComparePriceModel alloc]initWithDictionary:info error:nil];
        
        NSArray *array = GETOBJECTFORKEY(info, @"productSKUWebPriceArray", [NSArray class]);
        if ([array count] > 0)
        {
            NSArray *productSKUArray = [HYProductSKUWebPriceArrayModel arrayOfModelsFromDictionaries:array error:nil];
            self.comparePriceModel.productSKUWebPriceArray = productSKUArray;
        }
    }
    return self;
}
@end

@implementation HYProductSKUWebPriceArrayModel

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation HYComparePriceModel

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end