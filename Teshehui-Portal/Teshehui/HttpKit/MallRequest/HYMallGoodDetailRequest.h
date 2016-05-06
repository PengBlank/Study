//
//  HYMallGoodDetailRequest.h
//  Teshehui
//
//  Created by ichina on 14-2-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYMallGoodDetailResponse.h"

extern NSString *const HYGoodsDetailBase;
extern NSString *const HYGoodsDetailDetail;
extern NSString *const HYGoodsDetailPhoto;
extern NSString *const HYGoodsDetailSKU;

@interface HYMallGoodDetailRequest : CQBaseRequest

@property (nonatomic, copy) NSString *productId;

//1基本信息，商品详情描述02，商品图片03，商品SKU数据04
@property (nonatomic, strong) NSArray *dataType;


@end
