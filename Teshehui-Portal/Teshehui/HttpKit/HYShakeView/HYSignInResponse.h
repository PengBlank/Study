//
//  HYSignInResponse.h
//  Teshehui
//
//  Created by HYZB on 16/3/28.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"

@interface HYSignInResponse : CQBaseResponse

/** 当前连续签到次数 */
@property (nonatomic, copy) NSString *currentSignNum;

@end
