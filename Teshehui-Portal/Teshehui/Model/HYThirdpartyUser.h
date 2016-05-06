//
//  HYThirdpartyUser.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYThirdpartyUser : JSONModel

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *mobilephone;
@property (nonatomic, strong) NSString *thirdpartyToken;
@property (nonatomic, strong) NSString *thirdpartyOpenId;
@property (nonatomic, strong) NSString *thirdpartyType;

@end
