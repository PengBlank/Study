//
//  HYSeckillGoodsListResponse.h
//  Teshehui
//
//  Created by HYZB on 15/12/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYSeckillActivityModel.h"

@interface HYSeckillGoodsListResponse : CQBaseResponse

@property (nonatomic, strong) HYSeckillActivityModel *activity;

@property (nonatomic, strong) NSMutableArray *dataList;

@end
