//
//  HYMallCartModel.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallCartModel.h"

@implementation HYMallCartModel

- (instancetype)init
{
    if (self = [super init]) {
        _isSelect = NO;
    }
    return self;
}

- (NSMutableArray *)storeList
{
    if (!_storeList) {
        _storeList = [NSMutableArray array];
    }
    return _storeList;
}

- (NSInteger)storeCount
{
    return _storeList.count;
}

- (HYMallCartShopInfo *)shopForIndex:(NSInteger)idx
{
    if (_storeList.count > idx) {
        return [_storeList objectAtIndex:idx];
    }
    return nil;
}

- (NSInteger)rowForStoreAtIndex:(NSInteger)store
{
    if (_storeList.count > store) {
        HYMallCartShopInfo *shop = [_storeList objectAtIndex:store];
        return shop.goods.count;
    }
    return 0;
}
- (HYMallCartProduct *)productForIndexPath:(NSIndexPath *)path
{
    if (_storeList.count > path.section) {
        HYMallCartShopInfo *shop = [_storeList objectAtIndex:path.section];
        if (shop.goods.count > path.row) {
            return [shop.goods objectAtIndex:path.row];
        }
    }
    return nil;
}

- (HYMallCartProduct *)findProductAccordingToProductCode:(NSString *)productCode
{
    for (HYMallCartShopInfo *shop in _storeList)
    {
        for (HYMallCartProduct *goods in shop.goods)
        {
            if ([goods.productSKUId isEqualToString:productCode])
            {
                return goods;
            }
        }
    }
    return nil;
}

//判断所有商品是否选中
- (BOOL)allProductIsSelect
{
    BOOL allselect = YES;
    for (HYMallCartShopInfo *shop in _storeList)
    {
        if (!shop.isSelect)
        {
            allselect = NO;
            break;
        }
        else
        {
            for (HYMallCartProduct *product in shop.goods)
            {
                if (!product.isSelect)
                {
                    allselect = NO;
                    break;
                }
            }
            if (!allselect)
            {
                break;
            }
        }
    }
    return allselect;
}

//设定店铺为选中
- (void)setShopAtIndex:(NSInteger)shopIdx isSelect:(BOOL)select
{
    HYMallCartShopInfo *shop = [self shopForIndex:shopIdx];
    if (shop)
    {
        for (HYMallCartProduct *product in shop.goods)
        {
            if (product.isOverStock != 0) {
                product.isSelect = select;
            }
        }
        shop.isSelect = select;
        
        //更新购物车状态
        [self updateCartCheckStatus];
    }
}

- (void)setGoodsAtPath:(NSIndexPath *)path isSelect:(BOOL)select
{
    HYMallCartProduct *product = [self productForIndexPath:path];
    if (product && product.isSelect != select)
    {
        product.isSelect = select;
        [self updateCheckStatusWithShopIndex:path.section];
    }
}

//选中所有
- (void)setAllProductIsSelect:(BOOL)select
{
    for (int i = 0; i < _storeList.count; i++)
    {
        [self setShopAtIndex:i isSelect:select];
    }
}

//取出选中商品列表
//这里使用copy的原因是，如果对原来的shop对象的goods属性进行操作，会影响原来购物车里面的数据
//并不需要,因为进入界面时会刷新
- (NSArray *)getSelectedShopListToOrder
{
    NSMutableArray *selected = [NSMutableArray array];
    for (HYMallCartShopInfo *shop in _storeList)
    {
        BOOL hasProductSelected = NO;
        HYMallCartShopInfo *new = nil;
        NSMutableArray *newGoods = nil;
        for (HYMallCartProduct *product in shop.goods)
        {
            if (product.isSelect)   //如果该店铺下有商品被选中,创建一个新的店铺,将选中商品放入
            {
                if (!hasProductSelected)
                {
                    hasProductSelected = YES;
                    new = [shop copy];
                    new.isSelect = YES;
                    newGoods = [NSMutableArray array];
                }
                //如果有促销价格,则将所有促销价全部赋为计算价
                //否则用原来的价格计算
                if (product.amountAfterSpare.length > 0)
                {
                    product.salePrice = product.amountAfterSpare;
                    product.salePoints = product.pointAterSpare;
                    product.subTotal = [NSString stringWithFormat:@"%.2f",
                                        product.amountAfterSpare.doubleValue*product.quantity.integerValue];
                    product.subTotalPoints = [NSString stringWithFormat:@"%@",
                                              [NSNumber numberWithLongLong:product.pointAterSpare.longLongValue*product.quantity.integerValue]];
                }
                
                [newGoods addObject:product];
            }
        }
        if (new)    //如果有选中的商品，就加入
        {
            new.goods = newGoods;
            [selected addObject:new];
        }
    }
    _seletedModel = selected;
    return _seletedModel;
}

- (NSArray *)getSelectedProductList
{
    NSMutableArray *selected = [NSMutableArray array];
    for (HYMallCartShopInfo *shop in _storeList)
    {
        for (HYMallCartProduct *product in shop.goods)
        {
            if (product.isSelect)
            {
                [selected addObject:product];
            }
        }
    }
    return [NSArray arrayWithArray:selected];
}

- (NSArray *)getSelectedProductListForSpareAmount
{
    NSMutableArray *selected = [NSMutableArray array];
    for (HYMallCartShopInfo *shop in _storeList)
    {
        for (HYMallCartProduct *product in shop.goods)
        {
            if (product.isSelect && product.quantity.integerValue > 0)
            {
                [selected addObject:product];
            }
        }
    }
    return [NSArray arrayWithArray:selected];
}

- (NSArray *)getProductList
{
    NSMutableArray *selected = [NSMutableArray array];
    for (HYMallCartShopInfo *shop in _storeList)
    {
        for (HYMallCartProduct *product in shop.goods)
        {
            [selected addObject:product];
        }
    }
    return [NSArray arrayWithArray:selected];
}


- (void)updateWithNewShopList:(NSArray *)list
{
    if (_storeList.count == 0)  //从无到有,设置所有商品及店铺的属性.默认全为非选中
    {
        for (HYMallCartShopInfo *shop in list)
        {
            shop.isSelect = NO;
            shop.isEdit = NO;
            for (HYMallCartProduct *good in shop.goods)
            {
                /// 默认为未选中
                good.isSelect = NO;
                
                /// 如果数量为零，认为是库为零时的强制清除数量
                /// 否则清除库存提示
                if (good.quantity.integerValue == 0)
                {
                    good.isOverStock = 0;
                    good.isSelect = NO;
                }
                else
                {
                    good.isOverStock = -1;
                }
            }
        }
        _isSelect = NO;
        self.storeList = [NSMutableArray arrayWithArray:list];
    }
    else
    {
        //获得所有商铺中,所有选中的商品
        //selectionState->[store_id: [selectedProduct.productSKUId...]]
        NSMutableDictionary *selectionState = [NSMutableDictionary dictionary];
        NSMutableSet *editshop = [NSMutableSet set];
        for (HYMallCartShopInfo *shop in self.storeList)    //遍历所有已有店铺列表
        {
            NSString *key = shop.store_id;
            NSMutableSet *selectset = [selectionState objectForKey:key];
            if (!selectset && key)
            {
                selectset = [NSMutableSet set];
                [selectionState setObject:selectset forKey:key];
            }
            for (HYMallCartProduct *goods in shop.goods)
            {
                if (goods.isSelect)
                {
                    [selectset addObject:goods.productSKUId];
                }
            }
            
            if (shop.isEdit)
            {
                [editshop addObject:shop.store_id];
            }
        }
        
        //遍历新的店铺列表
        for (HYMallCartShopInfo *shop in list)
        {
            NSMutableSet *selected = [selectionState objectForKey:shop.store_id];
            BOOL allSelect = YES;
            //这个变量用于判断全部商品被选中，每找到一个选中商品就加1,如果全选中,那么店铺也应被选中
            for (HYMallCartProduct *goods in shop.goods)
            {
                //如果set里面包含了访skuId,说明该sku是原来就有并选中的
                if (selected && [selected containsObject:goods.productSKUId])
                {
                    goods.isSelect = YES;
                }
                else    //否则该商品未被选中
                {
                    goods.isSelect = NO;
                    if (goods.quantity.integerValue != 0) {
                        allSelect = NO;
                    }
                }
                
                /// 如果数量为零，认为是库为零时的强制清除数量
                /// 否则清除库存提示
                if (goods.quantity.integerValue == 0)
                {
                    goods.isOverStock = 0;
                    goods.isSelect = NO;
                }
                else
                {
                    goods.isOverStock = -1;
                }
                
            }
            shop.isSelect = allSelect;
            
            //编辑状态
            if ([editshop containsObject:shop.store_id])
            {
                shop.isEdit = YES;
            }
            else
            {
                shop.isEdit = NO;
            }
        }
        
        self.storeList = [NSMutableArray arrayWithArray:list];
        [self updateCartCheckStatus];   //更新购物车的选中状态
    }
}

- (void)updateCheckStatusWithShopIndex:(NSInteger)index
{
    if (index >= 0 && self.storeList.count > index)
    {
        HYMallCartShopInfo *shop = [self.storeList objectAtIndex:index];
        BOOL allSelect = YES;
        for (HYMallCartProduct *goods in shop.goods)
        {
            //  如果有一个商品未选中，而且他是有库存的，那么这个商店就未被选中
            if (!goods.isSelect && goods.isOverStock != 0)
            {
                allSelect = NO;
                break;
            }
        }
        shop.isSelect = allSelect;
    }
    
    [self updateCartCheckStatus];
}

- (void)updateCartCheckStatus
{
    BOOL allShopSelect = YES;
    for (HYMallCartShopInfo *shop in self.storeList)
    {
        if (!shop.isSelect)
        {
            allShopSelect = NO;
            break;
        }
    }
    _isSelect = allShopSelect;
}

-(void)getPrice:(CGFloat *)price point:(NSInteger *)point spare:(NSInteger *)spare
{
    if (self.spareAmount.length > 0)
    {
        *price = self.amountAfterSpare.floatValue;
        *point = self.pointAfterSpare.integerValue;
        *spare = self.spareAmount.integerValue;
    }
    else
    {
        CGFloat money = 0.0;
        NSInteger points = 0;
        for (HYMallCartShopInfo *shop in self.storeList)
        {
            for (HYMallCartProduct *goods in shop.goods)
            {
                if (goods.isSelect)
                {
                    money += [goods.salePrice floatValue] * goods.quantity.integerValue;
                    points += [goods.salePoints integerValue] *  goods.quantity.integerValue;
                }
            }
        }
        *price = money;
        *point = points;
        *spare = points;
    }
}

- (void)resetAllEditStats
{
    for (HYMallCartShopInfo *shop in _storeList)
    {
        shop.isEdit = NO;
    }
}


@end
