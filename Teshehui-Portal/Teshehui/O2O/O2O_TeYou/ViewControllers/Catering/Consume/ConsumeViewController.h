//
//  ConsumeViewController.h
//  Teshehui
//
//  Created by macmini5 on 16/3/2.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  账单页面

#import "HYMallViewBaseController.h"

@interface ConsumeViewController : HYMallViewBaseController

/** ConsumeViewController 商家id*/
@property (nonatomic, strong) NSString *merId;

@property (nonatomic, assign) NSInteger type; // 0为普通商家 1为桌球商家

@end
