//
//  HYActivateFillUserInfoView.h
//  Teshehui
//
//  Created by 成才 向 on 16/1/9.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYCardType.h"
#import "HYPolicyType.h"

@protocol HYActivateFillUserInfoViewDelegate <NSObject>
@optional
- (void)didClickCommit;
- (void)didClickInsuranceComments;
- (void)didSelectInsurace;
- (void)didSelectCardType;

@end

@interface HYActivateFillUserInfoView : UIView

@property(nonatomic, strong) HYCardType *cardInfo;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, strong) NSString *idNum;
@property (nonatomic, assign) HYUserInfoSex sex;
@property (nonatomic, assign) BOOL agreeInsurance;
@property (nonatomic, strong) HYPolicyType *policeType; // 保险类型

@property (nonatomic, assign) BOOL isAuthentificated;   //是否实名
@property (nonatomic, assign) BOOL sexCanEdit;

@property (nonatomic, weak) id<HYActivateFillUserInfoViewDelegate> delegate;

/////   回调事件
/// 点击证件
@property (nonatomic, copy) void (^didSelectCardType)(void);
/// 点击保险类型
@property (nonatomic, copy) void (^didSelectInsurace)(void);
/// 点击提交
@property (nonatomic, copy) void (^didClickCommit)(void);
/// 点击保险条文
@property (nonatomic, copy) void (^didClickInsuranceComments)(void);

- (void)reloadData;

@property (nonatomic, copy) NSString *commitBtnTitle;
@property (nonatomic, copy) NSString *feeDesc;

@end
