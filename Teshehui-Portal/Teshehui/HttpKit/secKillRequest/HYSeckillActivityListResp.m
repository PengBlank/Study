//
//  HYSekillActivityListResp.m
//  Teshehui
//
//  Created by 成才 向 on 15/12/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYSeckillActivityListResp.h"

@implementation HYSeckillActivityListResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSArray *data = GETOBJECTFORKEY(dictionary, @"data", NSArray);
        if (data && data.count > 0)
        {
            self.activityList = [HYSeckillActivityModel arrayOfModelsFromDictionaries:data];
        }
    }
    return self;
}


@end
