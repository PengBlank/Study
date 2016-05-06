//
//  HYCITableViewQuoteCheckCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseLineCell.h"

@class HYCITableViewQuoteCheckCell;
@protocol HYCITableViewQuoteCheckCellDelegate <NSObject>
@optional
- (void)checkCellDidCheck:(HYCITableViewQuoteCheckCell *)cell;

@end

@interface HYCITableViewQuoteCheckCell : HYBaseLineCell

@property (nonatomic, weak) IBOutlet UILabel *nameLab;
@property (nonatomic, weak) IBOutlet UIButton *checkBtn;

@property (nonatomic, weak) id<HYCITableViewQuoteCheckCellDelegate> delegate;

@end
