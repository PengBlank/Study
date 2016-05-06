//
//  HYCIQueryCarTypeListResp.m
//  Teshehui
//
//  Created by HYZB on 15/7/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIQueryCarTypeListResp.h"

@implementation HYCIQueryCarTypeListResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *items = GETOBJECTFORKEY(data, @"items", [NSArray class]);
        if (items.count > 0)
        {
            self.typeList = [[HYCICarBrandInfo arrayOfModelsFromDictionaries:items] copy];
        }
    }
    return self;
}

@end
