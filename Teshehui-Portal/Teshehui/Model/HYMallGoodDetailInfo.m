//
//  HYMallGoodDetailInfo.m
//  Teshehui
//
//  Created by HYZB on 14-9-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallGoodDetailInfo.h"
#import "HYProductImageInfo.h"

@implementation HYProductParamBaseInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.spec_id = GETOBJECTFORKEY(data, @"spec_id", [NSString class]);
        self.name = GETOBJECTFORKEY(data, @"name", [NSString class]);
    }
    
    return self;
}

@end

@implementation HYProductParamDetailInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super initWithDataInfo:data];
    
    if (self)
    {
        NSArray *array = GETOBJECTFORKEY(data, @"items", [NSArray class]);
        NSMutableArray *muTempArray = [[NSMutableArray alloc] init];
        
        NSInteger index = 0;
        for (NSDictionary *dic in array)
        {
            HYProductParamBaseInfo *item = [[HYProductParamBaseInfo alloc] initWithDataInfo:dic];
            item.index = index;
            [muTempArray addObject:item];
            index++;
        }
        
        self.selectIndex = 0;
        self.items = [muTempArray copy];
    }
    
    return self;
}

@end


@implementation HYProductPriceSpec

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.spec_id = GETOBJECTFORKEY(data, @"spec_id", [NSString class]);
        self.color_rgb = GETOBJECTFORKEY(data, @"color_rgb", [NSString class]);

        self.marketing_price = [GETOBJECTFORKEY(data, @"marketing_price", [NSString class]) floatValue];
        self.stock = [GETOBJECTFORKEY(data, @"stock", [NSString class]) integerValue];

        self.sku = GETOBJECTFORKEY(data, @"sku", [NSString class]);
        self.price = [GETOBJECTFORKEY(data, @"price", [NSString class]) floatValue];
        self.points = [GETOBJECTFORKEY(data, @"points", [NSString class]) integerValue];
    }
    
    return self;
}

@end


@implementation HYMallGoodSpec

@synthesize itemsHeight = _itemsHeight;
@synthesize associatedApec = _associatedApec;

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.quantity = 1;
        self.selectIndex = 0;
        self.specDesc = GETOBJECTFORKEY(data, @"name", [NSString class]);
        self.itemDesc = GETOBJECTFORKEY(data, @"name2", [NSString class]);
        
        NSArray *array = GETOBJECTFORKEY(data, @"items", [NSArray class]);
        
        NSMutableArray *muTempArray = [[NSMutableArray alloc] init];
        
        NSString *specid = nil;
        NSInteger index = 0;
        for (NSDictionary *dic in array)
        {
            HYProductParamDetailInfo *item = [[HYProductParamDetailInfo alloc] initWithDataInfo:dic];
            [muTempArray addObject:item];
            
            //如果
            if (!specid && (item.spec_id.intValue>0))
            {
                specid = item.spec_id;
            }
            item.index = index;
            index++;
        }
        
        self.items = [muTempArray copy];
        
        
        if (!specid && [self.items count] > 0)
        {
            HYProductParamDetailInfo *item = [self.items objectAtIndex:self.selectIndex];
            
            if ([item.items count] > item.selectIndex)
            {
                HYProductParamBaseInfo *item2 = [item.items objectAtIndex:item.selectIndex];
                specid = item2.spec_id;
            }
        }
        
        self.currSelectSpecId = specid;
    }
    
    return self;
}

- (HYProductParamDetailInfo *)associatedApec
{
    for (HYProductParamDetailInfo *item in self.items)
    {
        if (self.selectIndex == item.index)
        {
            _associatedApec = item;
            break;
        }
    }
    
    return _associatedApec;
}

- (CGFloat)itemsHeight
{
    if (_itemsHeight<=0 && ([self.specDesc length]>0||[self.itemDesc length]>0))
    {
        CGFloat oirg_y = 0;
        CGFloat oirg_x = 0;
        
        CGFloat height = 36;
        _itemsHeight = 0;
        for (HYProductParamDetailInfo *item in self.items)
        {
            if ([item.name length] > 0)
            {
                CGSize size = [item.name sizeWithFont:[UIFont systemFontOfSize:14]
                                    constrainedToSize:CGSizeMake((ScreenRect.size.width-70), 20)];
                
                size.width = (size.width < 30) ? 60 : (size.width+30);
                
                if ((oirg_x+(size.width+12)) > (ScreenRect.size.width-40))
                {
                    oirg_x = 0;
                    oirg_y += 34;
                }
                
                oirg_x += (size.width+12);
            }
        }
        
        _itemsHeight += (oirg_y+height);
        
        if ([self.associatedApec.items count] > 0)
        {
            oirg_x = 0;
            oirg_y = 0;
            for (HYProductParamBaseInfo *item in self.associatedApec.items)
            {
                if ([item.name length] > 0)
                {
                    CGSize size = [item.name sizeWithFont:[UIFont systemFontOfSize:14]
                                        constrainedToSize:CGSizeMake((ScreenRect.size.width-70), 20)];
                    size.width = (size.width < 30) ? 60 : (size.width+30);
                    
                    if ((oirg_x+(size.width+12)) > (ScreenRect.size.width-40))
                    {
                        oirg_x = 0;
                        oirg_y += 34;
                    }
                    
                    oirg_x += (size.width+12);
                }
            }
            
            _itemsHeight += (oirg_y+height);
        }
        
        _itemsHeight += 20;
    }
    else if (_itemsHeight <= 0)
    {
        _itemsHeight += 20;
    }
    
    return _itemsHeight;
}

@end

@implementation HYMallGoodDetailInfo

@synthesize priceInfo = _priceInfo;

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.goods_id = GETOBJECTFORKEY(data, @"goods_id", [NSString class]);
        self.goods_name = GETOBJECTFORKEY(data, @"goods_name", [NSString class]);
        self.ret_url = GETOBJECTFORKEY(data, @"ret_url", [NSString class]);
        self.desc = GETOBJECTFORKEY(data, @"description", [NSString class]);
        self.default_spec = GETOBJECTFORKEY(data, @"default_spec", [NSString class]);
        self.marketing_price = [GETOBJECTFORKEY(data, @"marketing_price", [NSString class]) floatValue];
        self.price = [GETOBJECTFORKEY(data, @"price", [NSString class]) floatValue];
        self.points = [GETOBJECTFORKEY(data, @"points", [NSString class]) integerValue];
        self.comments = GETOBJECTFORKEY(data, @"comments", [NSString class]);
        self.evaluation_count = [GETOBJECTFORKEY(data, @"evaluation_count", [NSString class]) integerValue];
        self.evaluation = [GETOBJECTFORKEY(data, @"evaluation", [NSString class]) floatValue];
        
        self.store_tel = GETOBJECTFORKEY(data, @"store_tel", [NSString class]);
        self.store_id = GETOBJECTFORKEY(data, @"store_id", [NSString class]);
        self.store_name = GETOBJECTFORKEY(data, @"store_name", [NSString class]);
        self.views = [GETOBJECTFORKEY(data, @"points", [NSString class]) integerValue];
        self.isPraise = [GETOBJECTFORKEY(data, @"applaud", [NSString class]) boolValue];
        self.isFavorite = [GETOBJECTFORKEY(data, @"favorited", [NSString class]) boolValue];
        //price
        NSArray *specsPrice = GETOBJECTFORKEY(data, @"_specs", [NSArray class]);
        
        NSMutableArray *muTempArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dic in specsPrice)
        {
            HYProductPriceSpec *item = [[HYProductPriceSpec alloc] initWithDataInfo:dic];
            [muTempArray addObject:item];
        }
        
        self.specs = [muTempArray copy];
        
        //param info
        NSDictionary *specData = GETOBJECTFORKEY(data, @"spec_data", [NSDictionary class]);
        self.goodSpecInfos = [[HYMallGoodSpec alloc] initWithDataInfo:specData];
        if (self.goodSpecInfos.currSelectSpecId.intValue <= 0)
        {
            self.goodSpecInfos.currSelectSpecId = self.default_spec;
        }
        
        // images
        NSArray *images = GETOBJECTFORKEY(data, @"_images", [NSArray class]);
        if ([images count] > 0)
        {
            NSMutableArray *muImages = [[NSMutableArray alloc] init];
            for (id obj in images)
            {
                HYProductImageInfo *image = [[HYProductImageInfo alloc] initWithDataInfo:obj];
                [muImages addObject:image];
            }
            self.images = [muImages copy];
        }
    }
    
    return self;
}

- (HYProductPriceSpec *)priceInfo
{
    if (self.goodSpecInfos.currSelectSpecId.intValue > 0)
    {
        for (HYProductPriceSpec *p in self.specs)
        {
            if ([p.spec_id isEqualToString:self.goodSpecInfos.currSelectSpecId])
            {
                return p;
            }
        }
    }
    else if ([self.specs count] > 0)
    {
        return [self.specs objectAtIndex:0];
    }
    
    return nil;
}

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
