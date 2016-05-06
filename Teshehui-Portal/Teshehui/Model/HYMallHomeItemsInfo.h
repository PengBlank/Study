//
//  HYMallHomeItemsInfo.h
//  Teshehui
//
//  Created by ichina on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQResponseResolve.h"

#import "HYMallStoreInfo.h"
#import "HYMallCategoryInfo.h"
#import "HYMallCategorySummary.h"

typedef enum _ItemType
{
    Store = 1,  //店铺
    WebURL,  //网页
    GoodsDetail,  //商品
    GoodsCategory,
    Flower_detail,
    Flower_list,
    Air_detail,
    Air_list,
    Hotel_detail,
    Hotel_list,
    ActivityGoodsList,
    ActivityList,
    WeeklyStore,
    HotSales,
    ShowHands
}ItemType;


@interface TypeInfo : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *cate_id;
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *layer;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *region_id;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *props;

@property (nonatomic, copy) NSString *ProductID;  //鲜花详情
@property (nonatomic, copy) NSString *CategoryID;  //鲜花列表
@property (nonatomic, copy) NSString *title;  //分类名

@property (nonatomic, copy) NSString *goodsID;
@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *activity_id;
@property (nonatomic, copy) NSString *activity_cate_id;

@end

@interface HYMallHomeItemsInfo : NSObject<CQResponseResolve>

@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* desc;
@property(nonatomic,copy) NSString* image;

@property (nonatomic, assign) ItemType type;
@property (nonatomic, strong) TypeInfo *itemInfo;

- (id)initWithStoreInfo:(HYMallStoreInfo *)store;
- (id)initWithCategoryInfo:(HYMallCategoryInfo *)cate;
- (id)initWithCategorySummary:(HYMallCategorySummary *)cate;

@end

/*
 "title": "今日最大牌",
 "description": "",
 "type": "search",
 "image": "http://www.teshehui.com/data/files/mall/images/1392343773_6243.jpg",
 "params": {
 "cate_id": "1743"
 }
*/