//
//  HYMallHomeTileCollectionCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HYMallHomeCellDelegate.h"

@interface HYMallHomeTileCollectionCell : UICollectionViewCell

@property (nonatomic, assign) id<HYMallHomeCellDelegate> delegate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *items;
//@property (nonatomic, strong) HYMallHomeBoard *board;

@property (nonatomic, assign) NSInteger boardType;

@end
