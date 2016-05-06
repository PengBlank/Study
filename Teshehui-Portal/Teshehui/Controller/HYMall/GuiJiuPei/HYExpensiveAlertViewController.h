//
//  HYExpensiveAlertViewController.h
//  Teshehui
//
//  Created by apple on 15/3/31.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"

/**
 *  @brief  贵就赔信息提示界面，点击贵就赔按钮时弹出，包含我要申请和取消申请按钮，点击可到下一步
 */
@interface HYExpensiveAlertViewController : HYMallViewBaseController

@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, copy) NSString *productSKUCode;

@end
