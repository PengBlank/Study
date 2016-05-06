//
//  HYSummaryTableViewCell.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-12.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYSummaryCellBgView.h"
/**
 *  概览界面列表cell
 */
@interface HYSummaryTableViewCell : UITableViewCell
{
    HYSummaryCellBgView *_bgView;
    //NSMutableArray *_labels;
}

@property (nonatomic, strong) HYSummaryCellBgView *bgView;

@property (nonatomic, assign) NSInteger numberOfRow;
@property (nonatomic, assign) BOOL canClick;

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *secondLabel;

- (UILabel *)labelAtIndex:(NSInteger)idx;
- (UILabel *)subLabelAtIndex:(NSInteger)idx;

@property (nonatomic, assign) CGFloat font_size;

@end
