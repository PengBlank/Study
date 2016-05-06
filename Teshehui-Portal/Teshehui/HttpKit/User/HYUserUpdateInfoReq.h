//
//  HYUserUpdateInfoReq.h
//  Teshehui
//
//  Created by Kris on 15/9/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYUserUpdateInfoReq : CQBaseRequest

@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *email;

@end
