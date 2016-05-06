//
//  HYHotelImageResponse.m
//  Teshehui
//
//  Created by RayXiang on 14-11-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelImageResponse.h"

@implementation HYHotelImageResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSArray *datas = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        if (datas.count > 0)
        {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *data in datas)
            {
                HYHotelPictureInfo *info = [[HYHotelPictureInfo alloc] initWithDataInfo:data];
                [array addObject:info];
            }
            self.imageList = [NSArray arrayWithArray:array];
        }
    }
    
    return self;
}

@end
