//
//  HYO2OFilterView.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/16.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYO2OFilterView : UIControl

{
    BOOL _valueChange;
    
    NSInteger _touchBeganIndex;
    UIView *_lineView;
}

@property (nonatomic, strong) NSArray *conditions;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL clickSelected;
@property (nonatomic, assign) BOOL isSelected;

@end
