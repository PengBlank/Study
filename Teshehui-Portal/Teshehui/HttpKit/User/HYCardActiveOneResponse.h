//
//  HYCardActiveOneResponse.h
//  Teshehui
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYActivateInfo.h"

@interface HYCardActiveOneResponse : CQBaseResponse

@property (nonatomic, strong) HYActivateInfo *info;

@end
