//
//  HYCommentAddOneStepModel.h
//  Teshehui
//
//  Created by HYZB on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYCommentAddOneStepModel : JSONModel

@property (nonatomic, copy) NSString *orderCode; // 订单编号
@property (nonatomic, copy) NSString *productName; // 商品名称
@property (nonatomic, copy) NSString *productCode; // 商品编码
@property (nonatomic, copy) NSString *productSKUCode; // 商品SKU编码
@property (nonatomic, copy) NSString *specifications; // 规格
@property (nonatomic, copy) NSString *price; // 商品价格
@property (nonatomic, assign) NSInteger points; // 现金券
@property (nonatomic, copy) NSString *thumbnailPicUrl; // 缩略图
@property (nonatomic, assign) NSInteger quantity; // 商品数量
@property (nonatomic, assign) NSInteger isEvaluable; // 是否可评论 0不可评价  1可评价  2可追评

@end