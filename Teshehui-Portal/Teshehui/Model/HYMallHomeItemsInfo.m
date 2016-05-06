//
//  HYMallHomeItemsInfo.m
//  Teshehui
//
//  Created by ichina on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallHomeItemsInfo.h"

@implementation TypeInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.keyword = GETOBJECTFORKEY(data, @"keyword", [NSString class]);
        self.cate_id = GETOBJECTFORKEY(data, @"cate_id", [NSString class]);
        self.store_id = GETOBJECTFORKEY(data, @"store_id", [NSString class]);
        self.layer = GETOBJECTFORKEY(data, @"layer", [NSString class]);
        self.brand = GETOBJECTFORKEY(data, @"brand", [NSString class]);
        self.region_id = GETOBJECTFORKEY(data, @"region_id", [NSString class]);
        self.price = GETOBJECTFORKEY(data, @"price", [NSString class]);
        self.points = GETOBJECTFORKEY(data, @"points", [NSString class]);
        self.props = GETOBJECTFORKEY(data, @"props", [NSString class]);
        self.goodsID = GETOBJECTFORKEY(data, @"goods_id", [NSString class]);
        self.url = GETOBJECTFORKEY(data, @"url", [NSString class]);
        
        self.title = GETOBJECTFORKEY(data, @"title", [NSString class]);
        self.ProductID = GETOBJECTFORKEY(data, @"ProductID", [NSString class]);
        self.CategoryID = GETOBJECTFORKEY(data, @"CategoryID", [NSString class]);
        
        self.activity_id = GETOBJECTFORKEY(data, @"activity_id", [NSString class]);
        self.activity_cate_id = GETOBJECTFORKEY(data, @"activity_cate_id", [NSString class]);
    }
    
    return self;
}

@end

@implementation HYMallHomeItemsInfo
- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.title = GETOBJECTFORKEY(data, @"title", [NSString class]);
        self.desc = GETOBJECTFORKEY(data, @"description", [NSString class]);
        self.image = GETOBJECTFORKEY(data, @"image", [NSString class]);
        
        NSString *typeStr = GETOBJECTFORKEY(data, @"type", [NSString class]);
        NSDictionary *params = GETOBJECTFORKEY(data, @"params", [NSDictionary class]);
        
        if ([typeStr isEqualToString:@"url"]) // url
        {
            self.type = WebURL;
        }
        else if ([typeStr isEqualToString:@"search"])  // 商店
        {
            self.type = Store;
        }
        else if([typeStr isEqualToString:@"goods"])  //商品详情
        {
            self.type = GoodsDetail;
        }
        else if([typeStr isEqualToString:@"cate_id"])  //商品详情
        {
            self.type = GoodsCategory;
        }
        else if([typeStr isEqualToString:@"flower_detail"])  //商品详情
        {
            self.type = Flower_detail;
        }
        else if([typeStr isEqualToString:@"flower_list"])  //商品详情
        {
            self.type = Flower_list;
        }
        else if([typeStr isEqualToString:@"air_detail"])  //商品详情
        {
            self.type = Air_detail;
        }
        else if([typeStr isEqualToString:@"air_list"])  //商品详情
        {
            self.type = Air_list;
        }
        else if([typeStr isEqualToString:@"hotel_detail"])  //商品详情
        {
            self.type = Hotel_detail;
        }
        else if([typeStr isEqualToString:@"hotel_list"])  //商品详情
        {
            self.type = Hotel_list;
        }
        else if ([typeStr isEqualToString:@"activity_goods_list"])  //促销活动商品列表
        {
            self.type = ActivityGoodsList;
        }
        else if ([typeStr isEqualToString:@"activity_list"])  //促销活动类别列表
        {
            self.type = ActivityList;
        }
        else if ([typeStr isEqualToString:@"new_weekly"])  //调用每周新品接口
        {
            self.type = WeeklyStore;
        }
        else if ([typeStr isEqualToString:@"hot_sales"])  //调用热品推荐接口
        {
            self.type = HotSales;
        }
        else if ([typeStr isEqualToString:@"show_hand"])
        {
            self.type = ShowHands;
        }
        
        self.itemInfo = [[TypeInfo alloc] initWithDataInfo:params];
    }
    
    return self;
}


- (id)initWithStoreInfo:(HYMallStoreInfo *)store
{
    self = [super init];
    
    if (self)
    {
        self.type = Store;
        self.title = store.store_name;
        self.desc = store.desc;
        
        TypeInfo *item = [[TypeInfo alloc] init];
        item.store_id = store.store_id;
        
        self.itemInfo = item;
    }
    
    return self;
}

- (id)initWithCategoryInfo:(HYMallCategoryInfo *)cate
{
    self = [super init];
    
    if (self)
    {
        self.type = Store;
        self.title = cate.cate_name;
        self.desc = cate.brief;
        
        TypeInfo *item = [[TypeInfo alloc] init];
        item.cate_id = cate.cate_id;
        
        self.itemInfo = item;
    }
    
    return self;
}

- (id)initWithCategorySummary:(HYMallCategorySummary *)cate
{
    self = [super init];
    
    if (self)
    {
        self.type = Store;
        self.title = cate.cate_name;
        
        TypeInfo *item = [[TypeInfo alloc] init];
        item.cate_id = cate.cate_id;
        
        self.itemInfo = item;
    }
    
    return self;
}

@end
