//
//  HYUserPortraitResponse.m
//  Teshehui
//
//  Created by 成才 向 on 15/5/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYUserPortraitResponse.h"

@implementation HYUserPortraitResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSArray *datas = GETOBJECTFORKEY(dictionary, @"data", NSArray);
        if (datas.count > 0)
        {
            NSDictionary *data = datas[0];
            NSString *url = [NSString stringWithFormat:@"%@%@", data[@"imageUrl"], data[@"imageFileType"]];
            if (url.length > 0)
            {
                self.imgURL = url;
            }
        }
    }
    return self;
}

@end
