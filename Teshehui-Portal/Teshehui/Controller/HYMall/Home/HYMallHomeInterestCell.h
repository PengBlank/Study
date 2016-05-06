//
//  HYMallHomeInterestCell.h
//  Teshehui
//
//  Created by 成才 向 on 16/3/26.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "HYMallHomeCellDelegate.h"

/// 首页，兴趣选择cell
@interface HYMallHomeInterestCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger boardType;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) id <HYMallHomeCellDelegate> delegate;
@property (nonatomic, copy) void (^checkAllTags)(void);
@end
