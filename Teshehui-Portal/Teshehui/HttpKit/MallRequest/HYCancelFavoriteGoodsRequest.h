//
//  HYCancelFavoriteGoodsRequest.h
//  Teshehui
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


///取消收藏
#import "CQBaseRequest.h"
#import "HYCancelFavoriteGoodsResponse.h"

@interface HYCancelFavoriteGoodsRequest : CQBaseRequest

@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *userid;

@end
