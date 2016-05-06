//
//  HYMallCategoryInfo.m
//  Teshehui
//
//  Created by HYZB on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallCategoryInfo.h"

@implementation HYMallCategoryInfo

//- (id)initWithDataInfo:(NSDictionary *)data
//{
//    self = [super init];
//    
//    if (self)
//    {
//        self.cate_id = GETOBJECTFORKEY(data, @"categoryId", [NSString class]);
//        self.cate_name = GETOBJECTFORKEY(data, @"categoryName", [NSString class]);
//        self.parent_id = GETOBJECTFORKEY(data, @"parent_id", [NSString class]);
//        self.gcategory_logo = GETOBJECTFORKEY(data, @"gcategory_logo", [NSString class]);
//        self.brief = GETOBJECTFORKEY(data, @"brief", [NSString class]);
//        self.thumbnail_small = GETOBJECTFORKEY(data, @"thumbnail_small", [NSString class]);
//        self.thumbnail_middle = GETOBJECTFORKEY(data, @"thumbnail_middle", [NSString class]);
//        self.thumbnail_tetragonal = GETOBJECTFORKEY(data, @"thumbnail_tetragonal", [NSString class]);
//        
//        NSArray *subCategoryArray = GETOBJECTFORKEY(data, @"childCategoryList", [NSArray class]);
//        if (subCategoryArray.count > 0)
//        {
//            NSMutableArray *subcategories = [NSMutableArray array];
//            for (NSDictionary *subcategoryDict in subCategoryArray)
//            {
//                HYMallCategoryInfo *subcategory = [[HYMallCategoryInfo alloc] initWithDataInfo:subcategoryDict];
//                [subcategories addObject:subcategory];
//            }
//            self.subcategories = [subcategories copy];
//        }
//    }
//    
//    return self;
//}

- (instancetype)init
{
    if (self = [super init]) {
        self.expandIdx = -1;
    }
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{@"categoryId": @"cate_id",
                                 @"categoryName": @"cate_name",
                                 @"categoryPicUrl": @"thumbnail_tetragonal",
                                 @"children": @"subcategories",
                                 @"parentId": @"parent_id"}];
}


@end
