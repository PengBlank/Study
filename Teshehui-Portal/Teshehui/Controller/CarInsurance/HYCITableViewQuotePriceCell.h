//
//  HYCITableViewQuotePriceCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseLineCell.h"
#import "HYCICarInfoFillType.h"

@class HYCITableViewQuotePriceCell;
@protocol HYCITableViewQuotePriceDelegate <NSObject>
@optional
- (void)quoteCellDidClick:(HYCITableViewQuotePriceCell *)cell;

@end

@interface HYCITableViewQuotePriceCell : HYBaseLineCell

@property (nonatomic, weak) IBOutlet UILabel *nameLab;
@property (nonatomic, weak) IBOutlet UIButton *selectBtn;
@property (nonatomic, weak) IBOutlet UILabel *priceLab;

@property (nonatomic, strong) HYCICarInfoFillType *fillType;
@property (nonatomic, weak) id<HYCITableViewQuotePriceDelegate> delegate;

@end
