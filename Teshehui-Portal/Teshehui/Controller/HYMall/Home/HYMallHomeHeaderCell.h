//
//  HYMallHomeHeaderCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallHomeHeaderView.h"

/**
 *  Collectionview 没有tableview header ,将原来的tableHeader移到地处
 */

@interface HYMallHomeHeaderCell : UICollectionViewCell

@property (nonatomic, strong) HYMallHomeHeaderView *headerView;

@end
