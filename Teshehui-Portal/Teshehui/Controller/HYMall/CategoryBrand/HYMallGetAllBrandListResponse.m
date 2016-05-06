//
//  HYMallGetAllBrandListResponse.m
//  Teshehui
//
//  Created by Kris on 16/3/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallGetAllBrandListResponse.h"
#import "HYMallAllBrandModel.h"

@implementation HYMallGetAllBrandListResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSArray *data = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        if (data.count > 0)
        {
            self.dataList = [HYMallAllBrandModel arrayOfModelsFromDictionaries:data];
        }
    }
    return self;
}

@end
