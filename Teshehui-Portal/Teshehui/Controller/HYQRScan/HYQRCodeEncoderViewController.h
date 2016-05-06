//
//  HYQRScanViewController.h
//  Teshehui
//
//  Created by HYZB on 14-7-1.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "CQBaseViewController.h"

@interface HYQRCodeEncoderViewController : HYMallViewBaseController
//根视图控制器,处于界面底层
@property (nonatomic, weak) CQBaseViewController *baseViewController;

@property (nonatomic, assign) BOOL showBottom;

@end
