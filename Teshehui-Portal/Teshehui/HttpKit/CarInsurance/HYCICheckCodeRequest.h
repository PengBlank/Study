//
//  HYCICheckCodeRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/16.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIBaseReq.h"

@interface HYCICheckCodeRequest : HYCIBaseReq

@property (nonatomic, strong) NSString *sessionid;
@property (nonatomic, strong) NSString *checkcode;

@end
