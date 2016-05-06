//
//  HYGetPersonResponse.h
//  Teshehui
//
//  Created by ichina on 14-3-6.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYUserInfo.h"

@interface HYGetPersonResponse : CQBaseResponse

@property (nonatomic, strong) HYUserInfo* userInfo;

@end
