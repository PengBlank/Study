//
//  HYMallHomeTextAdsCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/5.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallProductListCellDelegate.h"
@class HYMallHomeItem;

@interface HYMallHomeTextAdsCell : UICollectionViewCell

@property (nonatomic, assign) id<HYMallProductListCellDelegate> delegate;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) HYMallHomeBoard *board;

@property (nonatomic, assign) NSInteger currentIdx;

@property (nonatomic, strong, readonly) HYMallHomeItem *currentItem;

@end
