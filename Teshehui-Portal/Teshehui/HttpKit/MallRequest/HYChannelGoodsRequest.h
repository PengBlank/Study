//
//  HYChannelGoodsRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/13.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYChannelGoodsResponse.h"

@interface HYChannelGoodsRequest : CQBaseRequest

@property (nonatomic, strong) NSString *cateCode;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;

@end
