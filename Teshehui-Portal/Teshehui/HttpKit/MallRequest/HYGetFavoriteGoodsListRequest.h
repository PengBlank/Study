//
//  HYGetFavoriteGoodsListRequest.h
//  Teshehui
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


//获取
#import "CQBaseRequest.h"
#import "HYGetFavoriteGoodsListResponse.h"

@interface HYGetFavoriteGoodsListRequest : CQBaseRequest

@property (nonatomic, assign) NSInteger num_per_page;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *productid;


@end
