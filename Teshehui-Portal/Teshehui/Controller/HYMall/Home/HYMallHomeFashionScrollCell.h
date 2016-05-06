//
//  HYMallHomeFashionScrollCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallHomeCellDelegate.h"

@class HYMallHomeItem;
@interface HYMallHomeFashionScrollCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger boardType;

//@property (nonatomic, strong) HYMallHomeBoard *board;
@property (nonatomic, strong) NSArray<HYMallHomeItem*> *items;

@property (nonatomic, assign) id<HYMallHomeCellDelegate> delegate;

@end
