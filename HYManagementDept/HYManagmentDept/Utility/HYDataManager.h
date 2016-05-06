//
//  HYDataManager.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-21.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYUserInfo.h"

@interface HYDataManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) HYUserInfo *userInfo;

@property (nonatomic, strong) NSString *inviteCode;

@end
