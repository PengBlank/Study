//
//  HYModifyPasswordRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-4-1.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYModifyPasswordRespone.h"

@interface HYModifyPasswordRequest : CQBaseRequest

@property(nonatomic,copy)NSString* password_new;
@property(nonatomic,copy)NSString* password_old;

@end
