//
//  HYMallBigClassInfo.h
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQResponseResolve.h"

@interface HYMallBigClassInfo : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString* cate_id;
@property (nonatomic, copy) NSString* cate_name;
@property (nonatomic, copy) NSString* parent_id;
@property (nonatomic, copy) NSString* gcategory_logo;
@property (nonatomic, copy) NSString* thumbnail_middle;
@property (nonatomic, copy) NSString* thumbnail_small;
@property (nonatomic, copy) NSString* thumbnail_tetragonal;

@property (nonatomic, copy) NSString* brief;

@property (nonatomic, strong) NSArray *subcategories;


@end

/*
 "cate_id": "1239",
 "cate_name": "天天最大牌",
 "parent_id": "0",
 "gcategory_logo": "http://www.teshehui.com/data/files/mall/gcategory/1239.png"
*/