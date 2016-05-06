//
//  HYHYMallCartProduct.h
//  Teshehui
//
//  Created by HYZB on 15/5/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYImageInfo.h"

@interface HYMallCartProduct : JSONModel

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *businessType;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productSKUPicUrl;
@property (nonatomic, strong) HYImageInfo *productSKUImage;
@property (nonatomic, copy) NSString *productSKUId;
@property (nonatomic, copy) NSString *productSKUSpecification;
@property (nonatomic, copy) NSString *salePrice;
@property (nonatomic, copy) NSString *salePoints;
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, copy) NSString *subTotal;
@property (nonatomic, copy) NSString *subTotalPoints;
@property (nonatomic, copy) NSString *stock; //剩余库存

@property (nonatomic, copy) NSString *subPromotionAmount;  //单个商品阶计算后总价
@property (nonatomic, copy) NSString *subPromotionSpareAmount; //单个商品阶梯计算后省的价
@property (nonatomic, copy) NSString *subPromotionPoints;  //单个商品阶梯计算后的特币

// 海淘增加字段
// supplierType：01   普通类型    06    海淘类型（String）
@property (nonatomic, strong) NSString *supplierType;

@property (nonatomic, assign) BOOL isSelect;  //购物车中是否选择，默认选择YES

/// -1表示库存足够，0表示没有库存，即失效，>0表示库存有限
@property (nonatomic, assign) NSInteger isOverStock;  //判断是否超过库存

/**
 *  组个阶梯计价数据,由接口计算得出后赋值
 *  注意,这里均是单价,
 */
@property (nonatomic, strong) NSString *spareAmount;    //组合阶梯计价后省的钱
@property (nonatomic, strong) NSString *amountAfterSpare;   //组合阶梯计价后优惠后的单价,算总价需乘个数
@property (nonatomic, strong) NSString *pointAterSpare; //组合阶梯计价后的单个特币

/// 这两个数据暂时只有统计时才用到
@property (nonatomic, copy) NSString *attributeValue1;
@property (nonatomic, copy) NSString *attributeValue2;
@property (nonatomic, copy) NSString *brandId;

@end
