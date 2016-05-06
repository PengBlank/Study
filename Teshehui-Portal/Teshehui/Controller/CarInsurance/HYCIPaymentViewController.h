//
//  HYCIPaymentViewController.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/15.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"

@interface HYCIPaymentViewController : HYMallViewBaseController

@property (nonatomic, strong) NSString *paymentURL;

@property (nonatomic, assign) NSInteger pageFrom;   //0 首页 1订单

@end
