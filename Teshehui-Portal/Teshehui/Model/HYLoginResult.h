//
//  HYLoginResult.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYLoginResult : JSONModel

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *memberCardNumber;
@property (nonatomic, assign) NSInteger loginStatus;
@property (nonatomic, strong) NSString *token;

@end
