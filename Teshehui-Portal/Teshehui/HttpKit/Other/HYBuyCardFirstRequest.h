//
//  HYBuyCardFirstRequest.h
//  Teshehui
//
//  Created by Kris on 15/9/15.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYBuyCardFirstRequest : CQBaseRequest

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *phone_code;
@property (nonatomic, copy) NSString *invitationCode;

@end
