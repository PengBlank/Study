//
//  HYMallHomeTileTypeCell.h
//  Teshehui
//
//  Created by HYZB on 15/1/21.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallHomeItem.h"
#import "HYMallProductListCellDelegate.h"

@interface HYMallHomeTileTypeCell : HYBaseLineCell

@property (nonatomic, assign) id<HYMallProductListCellDelegate> delegate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *items;

@end
