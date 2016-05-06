//
//  HYSeckillAddRemindResp.m
//  Teshehui
//
//  Created by 成才 向 on 15/12/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYSeckillAddRemindResp.h"

@implementation HYSeckillAddRemindResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        self.data = GETOBJECTFORKEY(dictionary, @"data", NSString);
    }
    return self;
}

@end
