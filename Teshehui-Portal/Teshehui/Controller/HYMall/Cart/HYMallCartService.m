//
//  HYMallCartService.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallCartService.h"
#import "HYGetShoppingCarRequest.h"
#import "HYMallCartShopResponse.h"
#import "HYMallCartShopDropRequest.h"
#import "HYMallCartShopDropResponse.h"
#import "HYMallCartShopUpdateRequest.h"
#import "HYMallCartShopUpdateResponse.h"
#import "HYUserInfo.h"
#import "HYPromoteSellingRequest.h"
#import "HYPromoteSellingResponse.h"
#import "HYMallGoodDetailRequest.h"
#import "HYGetCartGoodsAmountRequest.h"
#import "HYAddToFavoritesReq.h"
#import "HYAddToFavoritesResponse.h"
#import "HYBatchCheckProductStockReq.h"
#import "HYBatchCheckProductStockResponse.h"

@interface HYMallCartService ()

@property (nonatomic, strong) HYGetShoppingCarRequest *shopcarListRequest;
@property (nonatomic, strong) HYMallCartShopDropRequest* dropShopcarRequest;
@property (nonatomic, strong) HYMallCartShopUpdateRequest* updateQuantityRequest;
@property (nonatomic, strong) HYPromoteSellingRequest *promoteRequest;
@property (nonatomic, strong) HYMallGoodDetailRequest *getGoodDetailReq;
@property (nonatomic, strong) HYAddToFavoritesReq *addToFavoritesReq;
@property (nonatomic, strong) HYGetCartGoodsAmountRequest *countRequest;
@property (nonatomic, strong) HYBatchCheckProductStockReq *batchCheckProductStockReq;

@end

@implementation HYMallCartService

- (void)dealloc
{
    [self cancel];
}

- (void)cancel
{
    [_updateQuantityRequest cancel];
    _updateQuantityRequest = nil;
    
    [_shopcarListRequest cancel];
    _shopcarListRequest = nil;
    
    [_dropShopcarRequest cancel];
    _dropShopcarRequest = nil;
    
    [_promoteRequest cancel];
    _promoteRequest = nil;
    
    [_getGoodDetailReq cancel];
    
    [_countRequest cancel];
    
    [_addToFavoritesReq cancel];
}

#pragma mark getter and setter
- (HYGetShoppingCarRequest *)shopcarListRequest
{
    if (!_shopcarListRequest) {
        _shopcarListRequest = [[HYGetShoppingCarRequest alloc] init];
    }
    return _shopcarListRequest;
}

- (HYMallCartShopDropRequest *)dropShopcarRequest
{
    if (!_dropShopcarRequest) {
        _dropShopcarRequest = [[HYMallCartShopDropRequest alloc] init];
    }
    return _dropShopcarRequest;
}

- (HYMallCartShopUpdateRequest *)updateQuantityRequest
{
    if (!_updateQuantityRequest) {
        _updateQuantityRequest = [[HYMallCartShopUpdateRequest alloc] init];
    }
    return _updateQuantityRequest;
}

- (HYAddToFavoritesReq *)addToFavoritesReq
{
    if (!_addToFavoritesReq) {
        _addToFavoritesReq = [[HYAddToFavoritesReq alloc] init];
    }
    return _addToFavoritesReq;
}

#pragma mark private methods
- (void)checkBatchProducts:(NSArray *)products
                     callback:(void (^)(BOOL, NSString *,NSArray *))callback
{
    if (!_batchCheckProductStockReq)
    {
        _batchCheckProductStockReq = [[HYBatchCheckProductStockReq alloc] init];
    }
    [_batchCheckProductStockReq cancel];
    
    _batchCheckProductStockReq.products = products;
    
    [_batchCheckProductStockReq sendReuqest:^(HYBatchCheckProductStockResponse *result, NSError *error)
     {
         [HYLoadHubView dismiss];
         if (result && [result isKindOfClass:[HYBatchCheckProductStockResponse class]])
         {
             HYBatchCheckProductStockResponse *response = (HYBatchCheckProductStockResponse *)result;
             callback(response.status == 200, response.suggestMsg, result.overStockedProductList);
         }
     }];
}

- (void)addProductToFavorites:(NSArray *)products
                     callback:(void (^)(BOOL, NSString *,NSString *))callback
{
    HYUserInfo *user = [HYUserInfo getUserInfo];
    
    if (!_addToFavoritesReq)
    {
        _addToFavoritesReq = [[HYAddToFavoritesReq alloc] init];
    }
    [_addToFavoritesReq cancel];

    _addToFavoritesReq.products = products;
    _addToFavoritesReq.userId = user.userId;
    
    [_addToFavoritesReq sendReuqest:^(id result, NSError *error)
     {
         [HYLoadHubView dismiss];
         if (result && [result isKindOfClass:[HYAddToFavoritesResponse class]])
         {
             HYAddToFavoritesResponse *response = (HYAddToFavoritesResponse *)result;
             callback(response.status == 200, response.suggestMsg, response.message);
         }
     }];
}

- (void)getProductList:(void (^)(NSArray *, NSString *))callback
{
    HYUserInfo *user = [HYUserInfo getUserInfo];
    
    if (_shopcarListRequest) {
        [_shopcarListRequest cancel];
    }
    _shopcarListRequest = [[HYGetShoppingCarRequest alloc] init];
    _shopcarListRequest.userId = user.userId;
    
    [_shopcarListRequest sendReuqest:^(id result, NSError *error)
     {
         [HYLoadHubView dismiss];
         NSArray* array = nil;
         NSString *err = nil;
         if (result && [result isKindOfClass:[HYMallCartShopResponse class]])
         {
             HYMallCartShopResponse *response = (HYMallCartShopResponse *)result;
             if (response.status == 200) {
                 array = response.productsArray;
                 if (response.code == 29901038) {
                     err = response.suggestMsg;
                 }
             }
             else
             {
                 err = response.suggestMsg;
             }
         }
         
         if (callback)
         {
             callback(array, err);
         }
     }];
}

- (void)updateProduct:(HYMallCartProduct *)product
         withQuantity:(NSInteger)quantity
               newSKU:(NSString *)newsku
             callback:(void (^)(BOOL, NSString *))callback
{
    HYUserInfo *user = [HYUserInfo getUserInfo];
    
    if (_updateQuantityRequest) {
        [_updateQuantityRequest cancel];
    }
    _updateQuantityRequest = [[HYMallCartShopUpdateRequest alloc] init];
    _updateQuantityRequest.productSKUId = product.productSKUId;
    _updateQuantityRequest.quantity = [NSString stringWithFormat:@"%ld", (long)quantity];
    _updateQuantityRequest.userId = user.userId;
    if (newsku)
    {
        _updateQuantityRequest.editType = @"02";
        _updateQuantityRequest.anotherSKUId = newsku;
    }
    
    [_updateQuantityRequest sendReuqest:^(id result, NSError *error)
     {
         if (!error && result && [result isKindOfClass:[HYMallCartShopUpdateResponse class]])
         {
             callback(YES, nil);
         }
         else
         {
             callback(NO, error.domain);
         }
     }];
}

- (void)dropProduct:(NSArray *)products callback:(void (^)(BOOL, NSString *))callback
{
    HYUserInfo *user = [HYUserInfo getUserInfo];
    if (_dropShopcarRequest)
    {
        [_dropShopcarRequest cancel];
    }
    _dropShopcarRequest = [[HYMallCartShopDropRequest alloc] init];
    _dropShopcarRequest.productSKUIds = products;
    _dropShopcarRequest.userId = user.userId;
    
    [_dropShopcarRequest sendReuqest:^(id result, NSError *error)
     {
         [HYLoadHubView dismiss];
         if (result && [result isKindOfClass:[HYMallCartShopDropResponse class]])
         {
             HYMallCartShopDropResponse *response = (HYMallCartShopDropResponse *)result;
             callback(response.status == 200, response.suggestMsg);
         }
     }];
}

- (void)getSpareInfoWithProductList:(HYMallCartModel*)cartModel callback:(HYServiceCallbackSucc)callback
{
    if (_promoteRequest) {
        [_promoteRequest cancel];
    }
    _promoteRequest = [[HYPromoteSellingRequest alloc] init];
    _promoteRequest.settleType = HYSettleTypeCart;
    NSMutableArray *skuInfos = [NSMutableArray array];
    NSArray *selectedProduct = [cartModel getSelectedProductListForSpareAmount];
    
    //如果没有选中的,就直接置空
    if (selectedProduct.count == 0)
    {
        NSArray *allproductExist = [cartModel getProductList];
        for (HYMallCartProduct *product in allproductExist)
        {
            product.spareAmount = nil;
            product.amountAfterSpare = nil;
            product.pointAterSpare = nil;
        }
        cartModel.spareAmount = nil;
        cartModel.amountAfterSpare = nil;
        cartModel.pointAfterSpare = nil;
        callback(YES, nil);
    }
    else
    {
        for (HYMallCartProduct *product in selectedProduct)
        {
            if (product.productSKUId && product.quantity)
            {
                [skuInfos addObject:@{@"productSKUId": product.productSKUId,
                                      @"quantity": product.quantity}];
            }
        }
        _promoteRequest.productSKUInfos = skuInfos;
        [_promoteRequest sendReuqest:^(HYPromoteSellingResponse* result, NSError *error)
         {
             if (result.status == 200)
             {
                 HYProductSpareAmount *amount = result.spareAmount;
                 cartModel.spareAmount = amount.totalSpareAmount;
                 cartModel.amountAfterSpare = amount.totalAmount;
                 cartModel.pointAfterSpare = amount.totalPoints;
                 NSArray *allproductExist = [cartModel getProductList];
                 for (HYMallCartProduct *product in allproductExist)
                 {
                     BOOL found = NO;
                     for (HYSpareItem *spareItem in amount.productSKUArray)
                     {
                         if ([product.productSKUId isEqualToString:spareItem.productSKUId])
                         {
                             product.spareAmount = spareItem.spareAmount;
                             product.amountAfterSpare = spareItem.amount;
                             product.pointAterSpare = spareItem.points;
                             found = YES;
                         }
                     }
                     if (!found)
                     {
                         product.spareAmount = nil;
                         product.amountAfterSpare = nil;
                         product.pointAterSpare = nil;
                     }
                 }
                 callback(YES, nil);
             }
             else
             {
                 NSArray *allproductExist = [cartModel getProductList];
                 for (HYMallCartProduct *product in allproductExist)
                 {
                     product.spareAmount = nil;
                     product.amountAfterSpare = nil;
                     product.pointAterSpare = nil;
                 }
                 callback(NO, result.suggestMsg);
             }
         }];
    }
}

- (void)getProductDetailCartProduct:(HYMallCartProduct *)cartProduct callback:(void (^)(HYMallGoodsDetail *, NSString *))callback
{
    [HYLoadHubView show];
    
    _getGoodDetailReq = [[HYMallGoodDetailRequest alloc] init];
    _getGoodDetailReq.productId = cartProduct.productId;
//    _getGoodDetailReq.dataType = @[HYGoodsDetailBase,HYGoodsDetailSKU, HYGoodsDetailPhoto];
    _getGoodDetailReq.userId = [[HYUserInfo getUserInfo] userId];
    
    [_getGoodDetailReq sendReuqest:^(id result, NSError *error) {
        [HYLoadHubView dismiss];
        
        if (!error && [result isKindOfClass:[HYMallGoodDetailResponse class]])
        {
            HYMallGoodDetailResponse *response = (HYMallGoodDetailResponse *)result;
            callback(response.goodDetailInfo, nil);
        }
        else
        {
            callback(nil, error.domain);
        }
    }];
}

- (void)getPromotionInfoWithSKU:(NSString *)productSKU quantity:(NSInteger)quantity callback:(void (^)(HYProductSpareAmount *))callback
{
    if (!productSKU || productSKU.length == 0)
    {
        return;
    }
    
    if (_promoteRequest) {
        [_promoteRequest cancel];
    }
    _promoteRequest = [[HYPromoteSellingRequest alloc] init];
    _promoteRequest.settleType = HYSettleTypeCart;
    _promoteRequest.productSKUInfos = @[@{@"productSKUId": productSKU,
                                          @"quantity": @(quantity)}];
    [_promoteRequest sendReuqest:^(HYPromoteSellingResponse* result, NSError *error)
    {
        callback(result.spareAmount);
    }];
}

- (void)getPromotionInfoWithProductList:(NSArray *)selectedShopList
                               callback:(void (^)(CGFloat totalQueryAmount))callback
{
    
//    __block CGFloat totalQueryAmount = 0;
//    for (HYMallCartShopInfo *store in selectedShopList)
//    {
//        totalQueryAmount += store.expressInfo.price;
//        
//        for (HYMallCartProduct *goods in store.goods)
//        {
//            if (goods.isSelect && goods.productSKUId)
//            {
//                
//                
//            }
//        }
//    }
//});
//callback(totalQueryAmount);
}

- (void)getCartCount:(void (^)(NSInteger))callback
{
    if (_countRequest) {
        [_countRequest cancel];
    }
    _countRequest = [[HYGetCartGoodsAmountRequest alloc] init];
    [_countRequest sendReuqest:^(id result, NSError *error)
     {
         if ([result isKindOfClass:[HYGetCartGoodsAmountResponse class]])
         {
             HYGetCartGoodsAmountResponse *resp = (HYGetCartGoodsAmountResponse *)result;
             if (resp.status == 200) {
                 callback(resp.amount);
                 return ;
             }
         }
         callback(0);
    }];
}


@end
