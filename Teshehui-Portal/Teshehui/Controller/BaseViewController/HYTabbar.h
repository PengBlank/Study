//
//  HYTabbar.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-31.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYTabbar : UIControl

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong, readonly) NSArray *items;

@property (nonatomic, assign) BOOL isSubTabbar;
@property (nonatomic, assign, readonly) NSInteger currentIndex;

- (void)setItems:(NSArray*)items;
- (void)setSelectedItemIndex:(NSInteger)index;
- (void)cleanSelectStaus;
@end
