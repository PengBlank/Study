//
//  HYThirdpartyValidateRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYThirdpartyValidateResponse.h"

/**
 *  第三方发送验证码
 */
@interface HYThirdpartyValidateRequest : CQBaseRequest

@property (nonatomic, strong) NSString *mobilePhone;

@end
