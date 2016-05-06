//
//  HYActivityGoodsResponse.h
//  Teshehui
//
//  Created by RayXiang on 14-8-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
@class HYActivityGoods;
@interface HYActivityGoodsResponse : CQBaseResponse

@property (nonatomic, strong, readonly) NSArray *goodsArray;

@end
