//
//  HYMallAddFavoriteRequest.h
//  Teshehui
//
//  Created by HYZB on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 *  收藏商品
 */

#import "CQBaseRequest.h"
#import "HYMallAddFavoriteResponse.h"

@interface HYMallAddFavoriteRequest : CQBaseRequest

@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *userid;

@end
