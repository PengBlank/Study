//
//  HYMallRecommend.m
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallRecommend.h"
#import "HYMallHomeItemsInfo.h"

@implementation HYMallRecommend

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.title = GETOBJECTFORKEY(data, @"title", [NSString class]);
        
        NSArray *items = GETOBJECTFORKEY(data, @"items", [NSArray class]);
        
        NSMutableArray *muTempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *d in items)
        {
            HYMallHomeItemsInfo *item = [[HYMallHomeItemsInfo alloc] initWithDataInfo:d];
            [muTempArray addObject:item];
        }
        
        self.products = [muTempArray copy];
    }
    
    return self;
}

@end
