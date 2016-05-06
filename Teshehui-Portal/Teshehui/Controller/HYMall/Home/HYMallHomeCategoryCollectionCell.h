//
//  HYMallHomeCategoryCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallHomeItem.h"

typedef NS_ENUM(NSUInteger, HYMallHomeCategoryStyle)
{
    HYMallHomeCategoryHorizontal,
    HYMallHomeCategoryVerticle
};

@interface HYMallHomeCategoryCollectionCell : UICollectionViewCell

@property (nonatomic, assign) HYMallHomeCategoryStyle style;

@property (nonatomic, strong) HYMallHomeItem *item;

@end
