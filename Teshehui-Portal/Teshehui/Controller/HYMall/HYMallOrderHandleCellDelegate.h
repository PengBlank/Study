//
//  HYMallOrderHandleCellDelegate.h
//  Teshehui
//
//  Created by HYZB on 14-9-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYMallOrderSummary.h"

@protocol HYMallOrderHandleCellDelegate <NSObject>

@optional
- (void)handleOrderWithEventType:(HYMallOrderSummary *)order
                       eventType:(MallOrderHandleType)type;

@end
