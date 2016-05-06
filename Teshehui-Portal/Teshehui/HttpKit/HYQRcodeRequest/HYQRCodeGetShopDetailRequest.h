//
//  HYQRCodeGetShopDetailRequest.h
//  Teshehui
//
//  Created by HYZB on 14-7-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 获取支持扫码消费的商户详情
 */

#import "CQBaseRequest.h"
#import "HYQRCodeGetShopDetailResponse.h"

@interface HYQRCodeGetShopDetailRequest : CQBaseRequest

@property (nonatomic, assign) NSInteger merchant_id;

@end
