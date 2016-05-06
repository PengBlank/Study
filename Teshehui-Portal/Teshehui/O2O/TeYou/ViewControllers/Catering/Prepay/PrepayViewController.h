//
//  PrepayViewController.h
//  Teshehui
//
//  Created by macmini5 on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  实体店余额充值页面

#import "HYMallViewBaseController.h"

@interface PrepayViewController : HYMallViewBaseController

/**PrepayViewController 商家id*/
@property (nonatomic, strong) NSString *merId;
@property (nonatomic, assign) NSInteger comeType;  // 进入路径 0扫码 1商家 2我的

@end
