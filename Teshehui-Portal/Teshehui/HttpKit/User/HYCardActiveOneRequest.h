//
//  HYCardActiveOneRequest.h
//  Teshehui
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYCardActiveOneResponse.h"

@interface HYCardActiveOneRequest : CQBaseRequest

@property (nonatomic, strong) NSString *memberCardNumber; //会员卡号
@property (nonatomic, strong) NSString *memberCardPassword;

@end
