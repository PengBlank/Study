//
//  HYMallGoodImageInfo.m
//  Teshehui
//
//  Created by ichina on 14-2-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallGoodImageInfo.h"

@implementation HYMallGoodImageInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.image_id = GETOBJECTFORKEY(data, @"image_id", [NSString class]);
        self.goods_id = GETOBJECTFORKEY(data, @"goods_id", [NSString class]);
        self.image_url = GETOBJECTFORKEY(data, @"image_url", [NSString class]);
        self.thumbnail = GETOBJECTFORKEY(data, @"thumbnail", [NSString class]);
        self.sort_order = GETOBJECTFORKEY(data, @"sort_order", [NSString class]);
        self.file_id = GETOBJECTFORKEY(data, @"file_id", [NSString class]);
        self.thumbnail_small = GETOBJECTFORKEY(data, @"thumbnail_small", [NSString class]);
        self.thumbnail_middle = GETOBJECTFORKEY(data, @"thumbnail_middle", [NSString class]);
    }
    
    return self;
}
@end

/*
 {
 "image_id": "121",
 "goods_id": "35",
 "image_url": "http:\/\/www.teshehui.com\/data\/files\/store_68\/goods_140\/201401101115401363.jpg",
 "thumbnail": "http:\/\/www.teshehui.com\/data\/files\/store_68\/goods_140\/small_201401101115401363.jpg",
 "sort_order": "1",
 "file_id": "337"
 }
 */
