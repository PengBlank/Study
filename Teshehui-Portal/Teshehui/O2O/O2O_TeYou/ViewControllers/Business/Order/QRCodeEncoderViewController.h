//
//  QRCodeEncoderViewController.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/17.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/**
    O2O附近商家二维码页
 **/


#import "HYMallViewBaseController.h"
#import "HYTabbarViewController.h"
@interface QRCodeEncoderViewController : HYMallViewBaseController

@property (nonatomic, weak) HYTabbarViewController *baseViewController;

@property (nonatomic, assign) BOOL showBottom;

@end
