//
//  HYSekillActivityListResp.h
//  Teshehui
//
//  Created by 成才 向 on 15/12/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYSeckillActivityModel.h"

@interface HYSeckillActivityListResp : CQBaseResponse

@property (nonatomic, strong) NSArray<HYSeckillActivityModel *> *activityList;

@end
