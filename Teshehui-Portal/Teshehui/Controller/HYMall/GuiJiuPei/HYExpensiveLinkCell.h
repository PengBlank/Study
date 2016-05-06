//
//  HYExpensiveLinkCell.h
//  Teshehui
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseLineCell.h"

@protocol HYExpensiveLinkCellDelegate <NSObject>

@optional
- (void)expensiveLinkCellDidBeginEditing;
- (void)expensiveLinkCellDidEndEditing:(NSString *)string;
- (void)expensiveLinkCellDidClickQustionButton;

@end

@interface HYExpensiveLinkCell : HYBaseLineCell

@property (nonatomic, weak) id<HYExpensiveLinkCellDelegate> delegate;

@end
