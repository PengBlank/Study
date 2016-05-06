//
//  HYSeckillAddRemindReq.h
//  Teshehui
//
//  Created by 成才 向 on 15/12/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYSeckillAddRemindReq : CQBaseRequest

@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *productCode;

@end
