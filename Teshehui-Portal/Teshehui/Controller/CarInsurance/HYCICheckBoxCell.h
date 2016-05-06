//
//  HYCICheckBoxCell.h
//  Teshehui
//
//  Created by HYZB on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"

@class HYCICheckBoxCell;
@protocol HYCICheckBoxCellDelegate <NSObject>
@optional
- (void)checkBoxCellIsChecked:(HYCICheckBoxCell *)cell;

@end

@interface HYCICheckBoxCell : HYBaseLineCell
{
    UIButton *_checkBtn;
}

@property (nonatomic, assign) BOOL isChecked;
@property (nonatomic, strong) NSIndexPath *path;

@property (nonatomic, weak) id<HYCICheckBoxCellDelegate> delegate;

@end
