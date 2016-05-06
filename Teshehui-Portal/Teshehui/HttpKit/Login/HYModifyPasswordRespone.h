//
//  HYModifyPasswordRespone.h
//  Teshehui
//
//  Created by 回亿资本 on 14-4-1.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"

@interface HYModifyPasswordRespone : CQBaseResponse

@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *msg;

@end
