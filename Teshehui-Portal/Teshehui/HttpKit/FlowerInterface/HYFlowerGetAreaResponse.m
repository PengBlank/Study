//
//  HYFlowerGetAreaResponse.m
//  Teshehui
//
//  Created by ichina on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerGetAreaResponse.h"

@implementation HYFlowerGetAreaResponse
- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSArray *result = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        for (id obj in result)
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *d = (NSDictionary *)obj;
                HYFlowerCityInfo *fType = [[HYFlowerCityInfo alloc] initWithDataInfo:d];
                [muArray addObject:fType];
            }
        }
        
        if ([muArray count] > 0)
        {
            self.AreaList = [muArray copy];
        }
    }
    
    return self;
}

@end
