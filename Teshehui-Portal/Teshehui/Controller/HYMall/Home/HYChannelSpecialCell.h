//
//  HYChannelSpecialCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallChannelItem.h"
#import "HYMallProductListCellDelegate.h"

/**
 *  专题特辑
 *
 */
@interface HYChannelSpecialCell : HYBaseLineCell

@property (nonatomic, strong) NSArray<HYMallChannelItem*> *items;
@property (nonatomic, assign) id<HYMallProductListCellDelegate> delegate;
@property (nonatomic, strong) HYMallChannelBoard *channelBoard;;

@end
