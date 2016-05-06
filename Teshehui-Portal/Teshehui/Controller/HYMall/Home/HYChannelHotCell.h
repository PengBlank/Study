//
//  HYChannelHotCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/6.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallProductListCellDelegate.h"
#import "HYMallChannelItem.h"

/**
 *  频道页热新限版块
 */
@interface HYChannelHotCell : HYBaseLineCell

@property (nonatomic, assign) id<HYMallProductListCellDelegate> delegate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) HYMallChannelBoard *channelBoard;
@property (nonatomic, strong) NSArray<HYMallChannelItem *> *items;

@end
