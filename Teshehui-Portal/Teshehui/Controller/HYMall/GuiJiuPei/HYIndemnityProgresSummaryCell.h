//
//  HYIndemnityProgresSummaryCell.h
//  Teshehui
//
//  Created by Fei Wang on 15-3-31.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"


@class HYMallOrderItem;

@protocol HYIndemnityProgresSummaryCellDelegate <NSObject>

- (void)checkIndemnityDetail;

@end

@interface HYIndemnityProgresSummaryCell : HYBaseLineCell

@property (nonatomic, weak) id<HYIndemnityProgresSummaryCellDelegate> delegate;
@property (nonatomic, strong) HYMallOrderItem *goodsInfo;

@end
