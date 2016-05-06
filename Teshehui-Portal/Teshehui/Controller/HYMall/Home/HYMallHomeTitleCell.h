//
//  HYMallHomeTitleCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYMallHomeTitleCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *iconImg;
@property (nonatomic, strong) IBOutlet UILabel *moreLabel;
@property (nonatomic, strong) IBOutlet UILabel *descLabel;

@property (nonatomic, assign) BOOL showMore;

@end
