//
//  HYMallCartShopInfo.m
//  Teshehui
//
//  Created by ichina on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallCartShopInfo.h"
#import "NSString+Addition.h"

@implementation HYMallCartShopInfo

- (id)copy
{
    HYMallCartShopInfo *new = [[HYMallCartShopInfo alloc] init];
    new.store_name = self.store_name;
    new.amount = self.amount;
    new.amount_points = self.amount_points;
    new.quantity = self.quantity;
    new.store_id = self.store_id;
    new.isEdit = self.isEdit;
    new.isSelect = self.isSelect;
    return  new;
}

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.store_name = GETOBJECTFORKEY(data, @"storeName", [NSString class]);
        self.amount = GETOBJECTFORKEY(data, @"subAmount", [NSString class]);
        self.amount_points = GETOBJECTFORKEY(data, @"subPoints", [NSString class]);
        self.quantity = GETOBJECTFORKEY(data, @"subQuantity", [NSString class]);
        self.store_id = GETOBJECTFORKEY(data, @"storeId", [NSString class]);
        
        NSMutableArray *goods_c = [NSMutableArray array];
        NSArray *productSKU = GETOBJECTFORKEY(data, @"productSKUArray", [NSArray class]);
        
        for (NSDictionary *sku in productSKU)
        {
            HYMallCartProduct *good = [[HYMallCartProduct alloc] initWithDictionary:sku
                                                                                  error:nil];
            [goods_c addObject:good];
        }
        
        self.goods = [NSArray arrayWithArray:goods_c];
    }
    
    return self;
}

- (void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
}

- (NSString *)totalPrice
{
    //运费
    NSString *dPrice = self.expressInfo.price;
    for (HYMallCartProduct *item in self.goods)
    {
        if (item.isSelect)
        {
            if (!dPrice)
            {
                dPrice = item.subTotal;
            }
            else
            {
                dPrice = [dPrice stringDecimalByAdding:item.subTotal];
            }
        }
    }
    
    return dPrice;
}

- (NSInteger)totalPoint
{
    NSInteger totalPoint = 0;
    for (HYMallCartProduct *item in self.goods)
    {
        if (item.isSelect)
        {
            totalPoint += item.subTotalPoints.integerValue;
        }
    }
    
    return totalPoint;
}

@end
/*
 "store_name": "特奢汇",
 "amount": 446072,
 "amount_points": 0,
 "quantity": 7,
 "goods": []
 "store_id": 82
 */
