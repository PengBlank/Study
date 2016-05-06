//
//  HYRealnameConfirmViewController.h
//  Teshehui
//
//  Created by Kris on 15/9/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"

@protocol GetUserInfoDelegate <NSObject>

@optional
-(void)updateUserInfo;

@end

/**
 *  @brief 实名登记
 */
@interface HYRealnameConfirmViewController : HYMallViewBaseController

@property (nonatomic, weak) id<GetUserInfoDelegate> delegate;

@end
