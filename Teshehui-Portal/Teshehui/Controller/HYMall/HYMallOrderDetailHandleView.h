//
//  HYMallOrderDetailHandleView.h
//  Teshehui
//
//  Created by HYZB on 14-9-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallOrderHandleCellDelegate.h"
#import "HYMallChildOrder.h"

@interface HYMallOrderDetailHandleView : UIView

@property (nonatomic, weak) id<HYMallOrderHandleCellDelegate> delegate;
@property (nonatomic, strong) HYMallOrderSummary *orderInfo;
//@property (nonatomic, strong) HYMallChildOrder *orderInfo;

@end
