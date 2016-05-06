//
//  HYGridRowView.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-14.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYGridRowView;
@protocol HYGridRowViewDelegate <NSObject>
@optional
- (void)gridRowView:(HYGridRowView *)rowView atIndexPath:(NSIndexPath *)path didClickColumn:(NSInteger)column;

@end

@interface HYGridRowView : UIView {
    NSArray *_labels;
    
    NSInteger _totalWidth;
    
    CGFloat _action_start;
    CGFloat _action_end;
}

/**
 *  设置该行各列宽度，同时相当于设置列数
 */
@property (nonatomic, strong) NSArray *columnWidths;    //array of NSNumbers

/**
 *  获得某一列的label，用于具体内容的设置
 *
 *  @param idx 列序号
 *
 *  @return 该列label对象
 */
- (UILabel *)labelAtIndex:(NSInteger)idx;

@property (nonatomic, strong) NSArray *contents;
- (void)addContent:(NSString *)content;
- (void)setContent:(NSString *)content atIndex:(NSInteger)idx;
//- (void)setContents:(NSArray *)contents;

/**
 *  Label的默认字体
 */
@property (nonatomic, strong) UIFont *defaultFont;

@property (nonatomic, assign) BOOL columnWidthFixed;

/**
 *  action...
 *  必须先设delegate，再设actionColums，点击事件再会起作用
 */
@property (nonatomic, strong) NSIndexPath *indexPath;
//@property (nonatomic, assign) NSInteger actionColumn;
//@property (nonatomic, assign) NSInteger actionColumn2;
@property (nonatomic, strong) NSArray *actionColums;
@property (nonatomic, weak) id<HYGridRowViewDelegate> delegate;
@property (nonatomic, strong) UIColor *actionColor;

//风格
@property (nonatomic, assign) BOOL topLineBold; //default all is no.
@property (nonatomic, assign) BOOL bottomLineBold;

@end
