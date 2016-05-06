//
//  HYHYMallOrderListFilterView.h
//  Teshehui
//
//  Created by HYZB on 14-9-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYHYMallOrderListFilterView : UIControl
{
    BOOL _valueChange;
    
    NSInteger _touchBeganIndex;
    UIView *_lineView;
}

@property (nonatomic, strong) NSArray *conditions;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL showSpecLine;
@property (nonatomic, strong) UIFont *titleFont;

@end
