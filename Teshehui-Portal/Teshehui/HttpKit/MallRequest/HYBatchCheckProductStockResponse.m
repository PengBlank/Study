//
//  HYBatchCheckProductStockResponse.m
//  Teshehui
//
//  Created by Kris on 15/12/31.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYBatchCheckProductStockResponse.h"
#import "HYMallCartProduct.h"

@implementation HYBatchCheckProductStockResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSArray *data = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        self.overStockedProductList = [HYProductStockCheck arrayOfModelsFromDictionaries:data];
    }
    return self;
}

@end

@implementation HYProductStockCheck

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
