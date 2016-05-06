//
//  HYMallFullOrderGoodsInfoCell.h
//  Teshehui
//
//  Created by HYZB on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


/**
 *  商城确定订单商品信息cell
 */
#import "HYBaseLineCell.h"
#import "HYMallCartProduct.h"

UIKIT_EXTERN NSString *const kAbroadBuy;

@interface HYMallFullOrderGoodsInfoCell : HYBaseLineCell

@property (nonatomic, strong) HYMallCartProduct *goodsInfo;

/**
 *  是否海淘店铺商品
 */
@property (nonatomic, strong) NSString *supplierType;// 01   普通类型    06    海淘类型（String）

@end
