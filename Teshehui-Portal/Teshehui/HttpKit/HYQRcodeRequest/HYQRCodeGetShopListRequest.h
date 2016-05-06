//
//  HYQRCodeGetShopListRequest.h
//  Teshehui
//
//  Created by HYZB on 14-7-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 获取支持扫码消费的商户列表
 */

#import "CQBaseRequest.h"
#import "HYQRCodeGetShopListResponse.h"

@interface HYQRCodeGetShopListRequest : CQBaseRequest

@property (nonatomic, strong) NSString* cityName;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSString *merchant_cate_id;
@property (nonatomic, assign) NSInteger sort;   //0 智能 1离我最近 2最新发布

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *lontitude;

@end
