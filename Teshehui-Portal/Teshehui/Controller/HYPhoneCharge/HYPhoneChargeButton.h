//
//  HYPhoneChargeButton.h
//  Teshehui
//
//  Created by Kris on 16/2/29.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYPhoneChargeModel.h"

@interface HYPhoneChargeButton : UIButton

@property (nonatomic, strong, readonly) HYPhoneChargeModel *paramModel;

- (void)setTextColor:(UIColor *)color;
- (void)setPhoneChargeButtonData:(HYPhoneChargeModel *)data;

@end
