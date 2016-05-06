//
//  HYOrderSelectView.h
//  Teshehui
//
//  Created by 成才 向 on 15/12/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CCPopoverView.h"

@interface HYOrderSelectView : CCPopoverView

+ (instancetype)getView;

/**
 *  @brief 订单选择界面回调
 *  方便调用者使用，这里直接返回相应的controller
 *  如需使用相应的orderType可以新增一个回调方法来使用
 */
@property (nonatomic, copy) void (^didGetOrderController)(UIViewController *);

@end
