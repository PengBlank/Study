//
//  HYPromoteSellingResponse.m
//  Teshehui
//
//  Created by Kris on 15/9/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYPromoteSellingResponse.h"

@implementation HYPromoteSellingResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *info = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        
        self.spareAmount = [[HYProductSpareAmount alloc]initWithDictionary:info error:nil];
    }
    return self;
}

@end
