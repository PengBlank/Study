//
//  HYChannelGoodsResponse.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/13.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"

@class HYMallChannelGoods;
@interface HYChannelGoodsResponse : CQBaseResponse

@property (nonatomic, strong) NSArray<HYMallChannelGoods*> *goodsList;

@end
