//
//  HYCIConfirmCodeViewController.h
//  Teshehui
//
//  Created by Kris on 15/7/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYCIOrderDetail.h"

@interface HYCIConfirmCodeViewController : HYMallViewBaseController

@property (nonatomic, strong) NSString *sessionid;
@property (nonatomic, strong) HYCIOrderDetail *order;

@end
