//
//  HYRealnameProtocolViewController.h
//  Teshehui
//
//  Created by Kris on 15/9/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"



@protocol HYCheckInsuranceDelegate <NSObject>

@optional
- (void)didAgreeInsurance;

@end

/**
 *  @brief 实名登记保险条款
 */
@interface HYRealnameProtocolViewController : HYMallViewBaseController

@property (nonatomic, weak) id<HYCheckInsuranceDelegate> delegate;
@property (nonatomic, assign) BOOL isAgree;

@end
