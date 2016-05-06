//
//  HYPayWaysViewController.h
//  Teshehui
//
//  Created by Kris on 15/5/12.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"

@interface HYPayWaysViewController : HYMallViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, copy) NSString *payCode;
@property (nonatomic, copy) NSString *QRcodeStr;

@end
