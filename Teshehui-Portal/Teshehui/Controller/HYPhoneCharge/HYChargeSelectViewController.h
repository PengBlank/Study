//
//  HYChargeSelectViewController.h
//  Teshehui
//
//  Created by 成才 向 on 16/2/25.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallViewBaseController.h"
#import "HYPhoneChargeViewController.h"

/**
 *  @brief 话费选项
 *  
 */
@interface HYChargeSelectViewController : HYMallViewBaseController

@property (nonatomic, weak) id<HYPhoneChargeViewControllerDelegate> delegate;

@end
