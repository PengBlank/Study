//
//  HYMallCartService.h
//  Teshehui
//
//  Created by 成才 向 on 15/9/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYMallCartProduct.h"
#import "HYMallCartShopInfo.h"
#import "HYMallCartModel.h"
#import "HYMallGoodsDetail.h"
#import "HYProductSpareAmount.h"
#import "HYBatchCheckProductStockResponse.h"

typedef void(^HYServiceCallbackSucc)(BOOL succ, NSString *err);

@interface HYMallCartService : NSObject

/**
 *  获取购物车列表
 *
 *  @param callback
 */
- (void)getProductList:(void (^)(NSArray *array, NSString *err))callback;

/**
 *  更新购物车商品数量
 *
 *  @param product  商品
 *  @param quantity 新的数量
 *  @param newSKUId 新的SKU
 *  @param callback 回调
 */
- (void)updateProduct:(HYMallCartProduct *)product withQuantity:(NSInteger)quantity newSKU:(NSString *)newsku callback:(void (^) (BOOL succ, NSString *error))callback;

/**
 *  删除商品
 *
 *  @param product  商品
 *  @param callback 回调
 */
- (void)dropProduct:(NSArray *)products callback:(void(^)(BOOL succ, NSString *err))callback;

/**
 *  获取优惠信息
 *  @param cartModel    购物车对象s
 *  @param callback
 *  @result 对cartModel的amountAfterSpare属性及products中各商品进行设置
 */
- (void)getSpareInfoWithProductList:(HYMallCartModel *)cartModel
                           callback:(HYServiceCallbackSucc)callback;

/**
 *  根据购物车商品，获取商品详情
 *
 *  @param cartProduct 购物车商品
 *  @param callback    回调
 */
- (void)getProductDetailCartProduct:(HYMallCartProduct *)cartProduct
                           callback:(void (^)(HYMallGoodsDetail *detail, NSString *err))callback;


- (void)getPromotionInfoWithSKU:(NSString *)productSKU
                       quantity:(NSInteger)quantity
                       callback:(void (^)(HYProductSpareAmount *spare))callback;

- (void)getPromotionInfoWithProductList:(NSArray *)selectedShopList
                       callback:(void (^)(CGFloat totalQueryAmount))callback;

/**
 *  根据购物车商品，加入到收藏夹
 *
 *  @param cartProduct 购物车商品
 *  @param callback    回调
 */
- (void)addProductToFavorites:(NSArray *)products
                     callback:(void (^)(BOOL, NSString *,NSString *))callback;

/// 批量检查库存
- (void)checkBatchProducts:(NSArray *)products
                  callback:(void (^)(BOOL succ, NSString *message,NSArray *overStockedProductList))callback;

- (void)cancel;

- (void)getCartCount:(void (^)(NSInteger count))callback;


@end
