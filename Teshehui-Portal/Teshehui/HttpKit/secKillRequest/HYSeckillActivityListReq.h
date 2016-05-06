//
//  HYSeckillActivityListReq.h
//  Teshehui
//
//  Created by 成才 向 on 15/12/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYSeckillActivityListResp.h"

@interface HYSeckillActivityListReq : CQBaseRequest

@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;

@end
