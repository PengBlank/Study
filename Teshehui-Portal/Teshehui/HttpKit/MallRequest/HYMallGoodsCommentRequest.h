//
//  HYMallGoodsCommendRequest.h
//  Teshehui
//
//  Created by HYZB on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYMallGoodsCommentResponse.h"
#import "HYCommentAddSecondStepResponse.h"
#import "HYCommentModel.h"

@interface HYMallGoodsCommentRequest : CQBaseRequest

@property (nonatomic, copy) NSString *orderCode; //订单编号
@property (nonatomic, copy) NSString *productCode;  //商品标识
@property (nonatomic, copy) NSString *productSkuCode;  //订单商品标识
@property (nonatomic, copy) NSString *isReplyComment;  //是否为追评，0：不是，1是
@property (nonatomic, copy) NSString *productScore;  //商品评分
@property (nonatomic, copy) NSString *serviceScore;  //商品服务评分
@property (nonatomic, copy) NSString *deliveryScore;  //商品发货评分
@property (nonatomic, copy) NSString *comment; //商品评论具体内容
@property (nonatomic, copy) NSString *isAnonymous; //评论类型，0：普通评论，1：匿名评论
@property (nonatomic, copy) NSString *rltId; //追评关联ID
@property (nonatomic, copy) NSString *userName;

@property (nonatomic, strong) NSArray *uploadfile; //商品评论上传的图片 需要转换为NSData;

 + (instancetype)requestWithCommentModel:(HYCommentModel *)model;

@end
