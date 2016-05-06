//
//  HYLoginV2ValidateViewController.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"

/**
 *  第三方登录，验证手机号
 */
@interface HYThirdpartyRegisterViewController : HYMallViewBaseController

//第三方登陆信息
@property (nonatomic, strong) NSString *thirdpartyType;
@property (nonatomic, strong) NSString *thirdpartyToken;
@property (nonatomic, strong) NSString *thirdpartyOpenid;

@end
