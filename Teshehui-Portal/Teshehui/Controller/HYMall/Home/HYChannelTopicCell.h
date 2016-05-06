//
//  HYChannelTopicCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallProductListCellDelegate.h"
#import "HYMallChannelItem.h"

/**
 *  频道界面主题活动版块
 *  左边单个, 右边2x2块
 */
@interface HYChannelTopicCell : HYBaseLineCell

@property (nonatomic, assign) id<HYMallProductListCellDelegate> delegate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<HYMallChannelItem*> *items;
@property (nonatomic, strong) HYMallChannelBoard *channelBoard;

@end
