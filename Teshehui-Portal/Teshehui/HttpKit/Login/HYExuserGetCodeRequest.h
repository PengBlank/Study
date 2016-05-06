//
//  HYExuserGetCodeRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/17.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYExuserGetCodeResponse.h"

@interface HYExuserGetCodeRequest : CQBaseRequest

@property (nonatomic, strong) NSString *mobilephone;

@end
