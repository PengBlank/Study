//
//  HYCIConfirmPaymentViewController.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/16.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYCIOrderDetail.h"

@interface HYCIConfirmPaymentViewController : HYMallViewBaseController

@property (nonatomic, strong) NSString *sessionid;
@property (nonatomic, strong) HYCIOrderDetail *order;
@property (nonatomic, assign) NSInteger pageFrom;

@end
