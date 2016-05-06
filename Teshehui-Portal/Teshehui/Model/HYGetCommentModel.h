//
//  HYGetCommentModel.h
//  Teshehui
//
//  Created by HYZB on 15/10/19.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYGetCommentModel : JSONModel

@property (nonatomic, copy) NSString *commentId;// 主建ID
@property (nonatomic, copy) NSString *orderCode;// 订单编号
@property (nonatomic, copy) NSString *userId; // 用户ID
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *productCode; // 商品ID
@property (nonatomic, copy) NSString *commentType; // 评论类型 1.首评 2.追评
@property (nonatomic, copy) NSString *status; // 状态 1有效   2无效
@property (nonatomic, copy) NSString *productScore; // 商品评分
@property (nonatomic, copy) NSString *serviceScore; // 商品服务评分
@property (nonatomic, copy) NSString *deliveryScore; // 商品发货评分
@property (nonatomic, copy) NSString *commentMessage; // 商品评论具体内容

@property (nonatomic, strong) NSArray *imageList; // 评论图片

@end
