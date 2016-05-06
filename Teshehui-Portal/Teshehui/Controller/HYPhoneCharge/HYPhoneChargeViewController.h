//
//  HYPhoneChargeViewController.h
//  Teshehui
//
//  Created by 成才 向 on 16/2/25.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYPhoneChargeOrder.h"


@protocol HYPhoneChargeViewControllerDelegate <NSObject>

- (void)payWithOrder:(HYPhoneChargeOrder *)order;

@end

/**
 *  @brief 话费充值界面
 *
 */
typedef NS_ENUM(NSUInteger, ChargeTypeController) {
    PhoneChargeController,
    FlowChargeController,
};

@interface HYPhoneChargeViewController : HYMallViewBaseController
<HYPhoneChargeViewControllerDelegate>

- (instancetype)initWithChildControllerType:(ChargeTypeController)type;


@end
