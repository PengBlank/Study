//
//  HYChannelBrandCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallProductListCellDelegate.h"
#import "HYMallChannelItem.h"

@interface HYChannelBrandCell : HYBaseLineCell

@property (nonatomic, assign) id<HYMallProductListCellDelegate> delegate;
@property (nonatomic, strong) NSArray<HYMallChannelItem*> *items;
@property (nonatomic, strong) HYMallChannelBoard *channelBoard;

@end
