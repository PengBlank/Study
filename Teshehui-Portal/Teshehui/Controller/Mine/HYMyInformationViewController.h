//
//  HYMyInformationViewController.h
//  Teshehui
//
//  Created by Kris on 15/9/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYCardType.h"
#import "HYUserInfo.h"

/**
 *  个人资料 新版
 */
@interface HYMyInformationViewController : HYMallViewBaseController


typedef void (^PopBlock)(NSString *idAuth);

@property (nonatomic, assign) HYUserInfoSex sex;
@property (nonatomic, strong) NSString *idNum;
@property (nonatomic, copy) NSString *cardNum;
@property (nonatomic, copy) NSString *cellphoneNum;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, strong) NSString *userName;
@property(nonatomic, strong) HYCardType* cardInfo;
@property(nonatomic, strong) HYUserInfo* userInfo;
@property (nonatomic, copy) PopBlock callback;

-(instancetype)initWithAuthType:(NSString *)type;

@end
