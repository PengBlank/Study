//
//  HYChannelMoreCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYChannelMoreProductView.h"
#import "HYMallProductListCellDelegate.h"

@interface HYChannelMoreCell : HYBaseLineCell

@property (nonatomic, strong, readonly) HYChannelMoreProductView *leftView;
@property (nonatomic, strong, readonly) HYChannelMoreProductView *rightView;

@property (nonatomic, weak) id<HYMallProductListCellDelegate> delegate;
@property (nonatomic, strong) HYMallChannelBoard *channelBoard;

@end
