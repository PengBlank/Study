//
//  HYMallBigClassInfo.m
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallBigClassInfo.h"

@implementation HYMallBigClassInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.cate_id = GETOBJECTFORKEY(data, @"cate_id", [NSString class]);
        self.cate_name = GETOBJECTFORKEY(data, @"cate_name", [NSString class]);
        self.parent_id = GETOBJECTFORKEY(data, @"parent_id", [NSString class]);
        self.gcategory_logo = GETOBJECTFORKEY(data, @"gcategory_logo", [NSString class]);
        self.brief = GETOBJECTFORKEY(data, @"brief", [NSString class]);
        self.thumbnail_small = GETOBJECTFORKEY(data, @"thumbnail_small", [NSString class]);
        self.thumbnail_middle = GETOBJECTFORKEY(data, @"thumbnail_middle", [NSString class]);
        self.thumbnail_tetragonal = GETOBJECTFORKEY(data, @"thumbnail_tetragonal", [NSString class]);
        
        NSArray *subCategoryArray = GETOBJECTFORKEY(data, @"subcategories", [NSArray class]);
        if (subCategoryArray.count > 0)
        {
            NSMutableArray *subcategories = [NSMutableArray array];
            for (NSDictionary *subcategoryDict in subCategoryArray)
            {
                HYMallBigClassInfo *subcategory = [[HYMallBigClassInfo alloc] initWithDataInfo:subcategoryDict];
                [subcategories addObject:subcategory];
            }
            self.subcategories = [subcategories copy];
        }
    }
    
    return self;
}


@end
