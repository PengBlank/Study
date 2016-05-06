//
//  HYTabbarBaseView.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-31.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYTabbarItem.h"

@protocol HYTabbarBaseViewDelegate;

@interface HYTabbarBaseView : UIView

@property (nonatomic, weak) id<HYTabbarBaseViewDelegate>delegate;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIImage *backgroudImage;  //default is nil
@property (nonatomic, strong, readonly) NSArray *items;

- (void)setItems:(NSArray*)items;
- (void)setSelectedItemIndex:(NSInteger)index;

@end


@protocol HYTabbarBaseViewDelegate <NSObject>

@optional
- (void)didChangeTabbarItem:(HYTabbarItem *)tabbarItem;
- (void)updateWithDoubleClick:(HYTabbarItem *)tabbarItem;

@end