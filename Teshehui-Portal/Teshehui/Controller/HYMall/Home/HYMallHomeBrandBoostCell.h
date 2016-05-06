//
//  HYMallHomeBrandBoostCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYMallHomeItem;
#import "HYMallHomeCellDelegate.h"

@protocol HYMallHomeBrandBoostDelegate <NSObject>

- (void)brandBoostWillCheckMore;

@end


@interface HYMallHomeBrandBoostCell : UICollectionViewCell

@property (nonatomic, strong) NSArray<HYMallHomeItem*> *items;
@property (nonatomic, assign) NSInteger boardType;

@property (nonatomic, assign) id<HYMallHomeBrandBoostDelegate, HYMallHomeCellDelegate> delegate;

@end
