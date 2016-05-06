//
//  HYProductImageInfo.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYProductImageInfo.h"

@implementation HYProductImageInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.image_id = GETOBJECTFORKEY(data, @"image_id", [NSString class]);
        self.goods_id = GETOBJECTFORKEY(data, @"goods_id", [NSString class]);
        self.sort_order = GETOBJECTFORKEY(data, @"sort_order", [NSString class]);
        self.file_id = GETOBJECTFORKEY(data, @"file_id", [NSString class]);
        self.image_url = GETOBJECTFORKEY(data, @"image_url", [NSString class]);
        self.thumbnail = GETOBJECTFORKEY(data, @"thumbnail", [NSString class]);
        self.thumbnail_middle = GETOBJECTFORKEY(data, @"thumbnail_middle", [NSString class]);
        self.thumbnail_small = GETOBJECTFORKEY(data, @"thumbnail_small", [NSString class]);
    }
    
    return self;
}

@end
