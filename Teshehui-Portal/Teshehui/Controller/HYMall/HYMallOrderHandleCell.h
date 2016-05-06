//
//  HYMallOrderListCell.h
//  Teshehui
//
//  Created by HYZB on 14-9-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallOrderSummary.h"
#import "HYMallOrderHandleCellDelegate.h"

@interface HYMallOrderHandleCell : HYBaseLineCell

@property (nonatomic, weak) id<HYMallOrderHandleCellDelegate> delegate;
@property (nonatomic, strong) HYMallOrderSummary *orderInfo;

@end
