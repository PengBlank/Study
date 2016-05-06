//
//  HYApplyAfterSaleServiceListResponse.m
//  Teshehui
//
//  Created by Kris on 15/10/13.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYApplyAfterSaleServiceListResponse.h"

@implementation HYApplyAfterSaleServiceListResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *info = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *items = GETOBJECTFORKEY(info, @"items", [NSArray class]);
        
        self.dataList = [HYMallChildOrder arrayOfModelsFromDictionaries:items];
    }
    return self;
}

@end
