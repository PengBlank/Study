//
//  HYCardActiveThreeRequest.h
//  Teshehui
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYCardActiveThreeResponse.h"

@interface HYCardActiveThreeRequest : CQBaseRequest

@property (nonatomic, strong) NSString *memberCardNumber;
@property (nonatomic, strong) NSString *checkCode;

@end
