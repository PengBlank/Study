//
//  HYCIGetCityListResp.m
//  Teshehui
//
//  Created by HYZB on 15/7/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIGetCityListResp.h"
#import "HYCICityInfo.h"

@implementation HYCIGetCityListResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSArray *list = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        
        if ([list count])
        {
            self.cityList = [[HYCICityInfo arrayOfModelsFromDictionaries:list] copy];
        }
    }
    
    return self;
}

@end
