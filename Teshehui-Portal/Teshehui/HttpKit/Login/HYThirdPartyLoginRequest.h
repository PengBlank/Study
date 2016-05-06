//
//  HYThirdPartyLoginRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYThirdPartyLoginResponse.h"

@interface HYThirdPartyLoginRequest : CQBaseRequest

@property (nonatomic, strong) NSString *thirdpartyType;
@property (nonatomic, strong) NSString *thirdpartyToken;
@property (nonatomic, strong) NSString *thirdpartyOpenid;

@end
