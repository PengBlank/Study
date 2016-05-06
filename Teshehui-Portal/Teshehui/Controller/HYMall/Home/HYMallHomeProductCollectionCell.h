//
//  HYMallHomeProductCollectionCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  首页更多精品cell
 */
@class  HYMallHomeItem;
@class HYMallHomeBoard;
@interface HYMallHomeProductCollectionCell : UICollectionViewCell

@property (nonatomic, strong) HYMallHomeItem *item;
@property (nonatomic, strong) HYMallHomeBoard *board;

@end
