//
//  PageBaseLoading.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/20.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageBaseLoading : UIView

@property (nonatomic,strong) UIView *animtionView;
@property (nonatomic,strong) UIImageView *circleImageView;
@property (nonatomic,strong) UIImageView *normalImageView;
@property (nonatomic,strong) UIImageView *translucentImageView;

+ (void)showLoading;
+ (void)hide_Load;
+ (void)hiddeLoad_anyway;

@end
