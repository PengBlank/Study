//
//  HYMallStoreInfo.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 商城店铺信息
 */

#import "HYMallStoreInfo.h"

@implementation HYMallStoreInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.store_id = GETOBJECTFORKEY(data, @"store_id", [NSString class]);
        self.store_name = GETOBJECTFORKEY(data, @"store_name", [NSString class]);
        self.owner_name = GETOBJECTFORKEY(data, @"owner_name", [NSString class]);
        self.keyword = GETOBJECTFORKEY(data, @"keyword", [NSString class]);
        self.desc = GETOBJECTFORKEY(data, @"description", [NSString class]);
        self.img = GETOBJECTFORKEY(data, @"img", [NSString class]);
        self.thumb = GETOBJECTFORKEY(data, @"thumb", [NSString class]);
    }
    
    return self;
}

@end
