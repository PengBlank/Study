//
//  HYFlightDateUpdateView.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYFlightDateUpdateViewDeleage;

/**
 *  机票航班顶部日期选择
 */
@interface HYFlightDateUpdateView : UIView

@property (nonatomic, weak) id<HYFlightDateUpdateViewDeleage> delegate;
@property (nonatomic, readonly, strong) UILabel *dateLabel;

@end

/**
 *  机示航班日期代理，点击前一天、后一天时触发事件
 */
@protocol HYFlightDateUpdateViewDeleage <NSObject>

@optional
- (void)searchLastDayFlight;
- (void)searchNextDayFlight;

@end