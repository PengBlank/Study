//
//  HYCodeCheckViewController.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/26.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"

/**
 *  @brief 扫二维码界面
 */

@interface HYCodeCheckViewController : HYMallViewBaseController

/// 获取二维码回调
@property (nonatomic,  copy) void (^didGetCode)(NSString *code);

@end
