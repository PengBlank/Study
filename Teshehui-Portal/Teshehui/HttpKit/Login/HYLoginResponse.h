//
//  CQLoginResponse.h
//  Teshehui
//
//  Created by ChengQian on 13-11-16.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYUserInfo.h"

@interface HYLoginResponse : CQBaseResponse

@property (nonatomic, strong) HYUserInfo *userInfo;

@end
