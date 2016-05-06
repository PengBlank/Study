//
//  HYMallGoodDetailInfo.h
//  Teshehui
//
//  Created by HYZB on 14-9-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQResponseResolve.h"

@interface HYProductParamBaseInfo : NSObject<CQResponseResolve>

@property (nonatomic, assign) NSInteger index;  //本地缓存数据,用来处理界面问题

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *spec_id;

@end

@interface HYProductParamDetailInfo : HYProductParamBaseInfo

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSArray *items; //<HYProductParamBaseInfo>

@end

@interface HYProductPriceSpec : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *spec_id;
@property (nonatomic, copy) NSString *color_rgb;
@property (nonatomic, copy) NSString *sku;

@property (nonatomic, assign) CGFloat marketing_price;
@property (nonatomic, assign) NSInteger stock;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) NSInteger points;

@end

@interface HYMallGoodSpec : NSObject<CQResponseResolve>
{
    CGFloat _itemsHeight;
    HYProductParamDetailInfo *_associatedApec;
}
@property (nonatomic, copy) NSString *specDesc;  //产品参数的第一个说明  类似： 颜色
@property (nonatomic, copy) NSString *itemDesc;  //产品参数的第二个说明  类似： 尺寸
@property (nonatomic, strong) NSArray *items;  //<HYProductParamDetailInfo>

@property (nonatomic, assign, readonly) CGFloat itemsHeight;
@property (nonatomic, strong, readonly) HYProductParamDetailInfo *associatedApec;  //关联的属性

//本地缓存信息，由内存中赋值
@property (nonatomic, copy) NSString *currSelectSpecId;

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) NSInteger quantity;

@end

@interface HYMallGoodDetailInfo : NSObject<CQResponseResolve>
{
    HYProductPriceSpec *_priceInfo;
}
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *ret_url;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *cate_id;
@property (nonatomic, copy) NSString *cate_name;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *last_update;
@property (nonatomic, copy) NSString *default_spec;
@property (nonatomic, copy) NSString *default_image;
@property (nonatomic, copy) NSString *cate_id_2;
@property (nonatomic, assign) CGFloat marketing_price;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat discount;  //折扣
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) NSInteger views;
@property (nonatomic, copy) NSString *collects;
@property (nonatomic, copy) NSString *carts;
@property (nonatomic, copy) NSString *orders;
@property (nonatomic, copy) NSString *sales;
@property (nonatomic, copy) NSString *comments;

@property (nonatomic, assign) BOOL isPraise;  //是否点过赞
@property (nonatomic, assign) BOOL isFavorite;  //是否收藏
@property (nonatomic, assign) NSInteger evaluation_count;
@property (nonatomic, assign) CGFloat evaluation;  //评价 星级
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *store_tel;

@property (nonatomic, strong) NSArray  *tags;
@property (nonatomic, strong) NSArray  *images;

@property (nonatomic, strong) NSArray  *specs;  //价格信息
@property (nonatomic, strong) HYMallGoodSpec *goodSpecInfos;  //参数信息，不同的产品，对应的价格也不同，需要处理
@property (nonatomic, strong, readonly) HYProductPriceSpec *priceInfo;  //选定参数后对应会发生变化
@property (nonatomic, strong) NSDictionary *spec_data;

@end

/*
 {
 "status": 200,
 "data": {
 "goods_id": "64",
 "store_id": "82",
 "goods_name": "PRADA\/普拉达男款压纹牛皮黑色手提\/公文包",
 "description": " ",
 "cate_id": "2119",
 "cate_name": "鞋具箱包\t潮款男包\t手提包",
 "brand": "PRADA\/普拉达",
 "spec_qty": "0",
 "spec_name_1": "",
 "spec_name_2": "",
 "last_update": "1391972580",
 "default_spec": "123",
 "default_image": "http:\/\/www.teshehui.com\/data\/files\/store_82\/goods_24\/small_201401141423443962.JPG",
 "cate_id_2": "1750",
 "cost_price": "14860.00",
 "marketing_price": "17980.00",
 "tags": [
 "手提包",
 "商务包",
 "公文包"
 ],
 "price_rate": "0.10",
 "price": 16346,
 "points": 0,
 "_specs": [
 {
 "spec_id": "123",
 "goods_id": "64",
 "spec_1": "",
 "spec_2": "",
 "color_rgb": "",
 "cost_price": "14860.00",
 "marketing_price": "17980.00",
 "stock": "100",
 "sku": "",
 "price_rate": "0.10",
 "price": 16346,
 "points": 0
 }
 ],
 "_images": [
 {
 "image_id": "214",
 "goods_id": "64",
 "image_url": "http:\/\/www.teshehui.com\/data\/files\/store_82\/goods_24\/201401141423443962.JPG",
 "thumbnail": "http:\/\/www.teshehui.com\/data\/files\/store_82\/goods_24\/small_201401141423443962.JPG",
 "sort_order": "1",
 "file_id": "473"
 },
 {
 "image_id": "215",
 "goods_id": "64",
 "image_url": "http:\/\/www.teshehui.com\/data\/files\/store_82\/goods_25\/201401141423454284.JPG",
 "thumbnail": "http:\/\/www.teshehui.com\/data\/files\/store_82\/goods_25\/small_201401141423454284.JPG",
 "sort_order": "255",
 "file_id": "474"
 },
 {
 "image_id": "216",
 "goods_id": "64",
 "image_url": "http:\/\/www.teshehui.com\/data\/files\/store_82\/goods_25\/201401141423457649.JPG",
 "thumbnail": "http:\/\/www.teshehui.com\/data\/files\/store_82\/goods_25\/small_201401141423457649.JPG",
 "sort_order": "255",
 "file_id": "475"
 },
 {
 "image_id": "217",
 "goods_id": "64",
 "image_url": "http:\/\/www.teshehui.com\/data\/files\/store_82\/goods_26\/201401141423463672.jpg",
 "thumbnail": "http:\/\/www.teshehui.com\/data\/files\/store_82\/goods_26\/small_201401141423463672.jpg",
 "sort_order": "255",
 "file_id": "476"
 }
 ],
 "_scates": [
 
 ],
 "views": "42",
 "collects": "0",
 "carts": "0",
 "orders": "0",
 "sales": "0",
 "comments": "0",
 "spec_data": {
 
 }
 }
 }
 */