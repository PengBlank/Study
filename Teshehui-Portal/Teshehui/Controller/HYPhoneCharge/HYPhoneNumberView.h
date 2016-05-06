//
//  HYPhoneNumberView.h
//  Teshehui
//
//  Created by 成才 向 on 16/2/25.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYPhoneChargeViewController.h"

@class HYNumberHistoryView;


@interface HYPhoneNumberView : UIView
@property (nonatomic, strong, readonly) HYNumberHistoryView *historyView;

/// 点击通讯录按钮
@property (nonatomic, copy) void (^didSelectAddressBook)(void);

/// 获取电话号码的事件
@property (nonatomic, copy) void (^didGetPhone)(NSString *phone);

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;

@property (nonatomic, assign) NSUInteger type;
/// 将当前号码存入缓存中
- (void)rememberPhone;

- (void)transformPhotoDataToMyView;

@end
