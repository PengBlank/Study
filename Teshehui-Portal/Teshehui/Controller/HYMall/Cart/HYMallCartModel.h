//
//  HYMallCartModel.h
//  Teshehui
//
//  Created by 成才 向 on 15/9/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYMallCartShopInfo.h"
#import "HYMallCartProduct.h"


@interface HYMallCartModel : NSObject
{
    NSArray *_seletedModel;
}
@property (nonatomic, strong) NSMutableArray *storeList;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) NSString *spareAmount;
@property (nonatomic, strong) NSString *amountAfterSpare;
@property (nonatomic, strong) NSString *pointAfterSpare;

- (NSInteger)storeCount;
- (NSInteger)rowForStoreAtIndex:(NSInteger)store;
- (HYMallCartProduct *)productForIndexPath:(NSIndexPath *)path;
- (HYMallCartProduct *)findProductAccordingToProductCode:(NSString *)productCode;
- (HYMallCartShopInfo *)shopForIndex:(NSInteger)idx;

//判断所有商品是否选中
- (BOOL)allProductIsSelect;

//设定店铺为选中
- (void)setShopAtIndex:(NSInteger)shopIdx isSelect:(BOOL)select;
- (void)setGoodsAtPath:(NSIndexPath *)path isSelect:(BOOL)select;

//设为编辑状态
- (void)resetAllEditStats;
//- (void)setShopAtIndex:(NSInteger)shopIdx isEdit:(BOOL)edit;

//选中所有
- (void)setAllProductIsSelect:(BOOL)select;

//取出选中商品列表
- (NSArray *)getSelectedShopListToOrder;       //-->[HYCartShop]
- (NSArray *)getSelectedProductList;    //-->[HYCartProduct]
- (NSArray *)getProductList;            //-> [HYCartProduct]
- (NSArray *)getSelectedProductListForSpareAmount;  //取出商品列表用于计划阶梯价，与直接取选中商品不同地方在于，没有数量的不进行计算

//更新店铺列表。
//如果购物车中有商品，对比新旧列表的状态，将旧列表的选中状态复制到新列表中
//如果购物车中没有商品，则默认将新列表所有商品选中
- (void)updateWithNewShopList:(NSArray *)list;

//更新序列为index的shop的选中状态，然后以各shop选中状态更新总购物车的选中状态
- (void)updateCheckStatusWithShopIndex:(NSInteger)index;

//更新所有购物车是否选中状态，isSelect = allshop.select
- (void)updateCartCheckStatus;

//获取价格
- (void)getPrice:(CGFloat*)price point:(NSInteger*)point spare:(NSInteger*)spare;

@end
