//
//  HYFlowSelectViewController.h
//  Teshehui
//
//  Created by 成才 向 on 16/2/25.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYPhoneChargeViewController.h"

/**
 *  @brief 流量选择
 */

@interface HYFlowSelectViewController : UIViewController

@property (nonatomic, weak) id<HYPhoneChargeViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *phoneNumber;

@end
