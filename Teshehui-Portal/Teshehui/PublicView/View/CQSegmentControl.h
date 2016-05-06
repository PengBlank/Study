//
//  CQSegmentControl.h
//  Teshehui
//
//  Created by ChengQian on 13-10-28.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQSegmentItem.h"

/**
 *  分段控件
 */
@interface CQSegmentControl : UIView

@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, assign, readonly) NSInteger currentIndex;

//是否显示选中状态，为no则均为黑色
@property (nonatomic, assign) BOOL showSelectStatus;

//是否支持第二次点击，为yes则每个item支持三种状态 normal, select, double
@property (nonatomic, assign) BOOL supportDouble;

@property (nonatomic,retain) NSString* selectColor;
@property (nonatomic,retain) NSString* normalColor;
@property (nonatomic, strong) UIColor *textColor;


- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;
- (void)setSelectedItemIndex:(NSUInteger)index;
- (void)cancelSelcteStatus;

- (void)addEventforSelectChangeTarget:(id)target
                               action:(SEL)action;

@end
