//
//  HYMallHomeLifeCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYMallHomeItem;
#import "HYMallProductListCellDelegate.h"


@interface HYMallHomeLifeCell : UICollectionViewCell

@property (nonatomic, strong) HYMallHomeItem* item;

@property (nonatomic, assign) id<HYMallProductListCellDelegate> delegate;

@end
