//
//  HYMallCategoryInfo.h
//  Teshehui
//
//  Created by HYZB on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@protocol HYMallCategoryInfo <NSObject>

@end

@interface HYMallCategoryInfo : JSONModel

@property (nonatomic, copy) NSString* cate_id;
@property (nonatomic, copy) NSString* cate_name;
@property (nonatomic, copy) NSString* parent_id;
@property (nonatomic, copy) NSString* thumbnail_tetragonal;
@property (nonatomic, assign) NSInteger categoryProductCount;
@property (nonatomic, copy) NSString* brief;

@property (nonatomic, strong) NSArray<HYMallCategoryInfo> *subcategories;

@property (nonatomic, assign) CGFloat cachedHeight;
@property (nonatomic, assign) CGFloat cachedHeight2;
@property (nonatomic, assign) NSInteger expandIdx;

@end

/*
 "cate_id": "1239",
 "cate_name": "天天最大牌",
 "parent_id": "0",
 "gcategory_logo": "http://www.teshehui.com/data/files/mall/gcategory/1239.png"
*/