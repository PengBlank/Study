//
//  HYInterestSelectViewController.h
//  Teshehui
//
//  Created by 成才 向 on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"

/// 兴趣选择界面
@interface HYInterestSelectViewController : HYMallViewBaseController

@property (nonatomic, assign) BOOL supportSkip;  //是否支持跳过
@property (nonatomic, copy) void (^didSelectedInterest)(BOOL hasChange);

@end
