//
//  HYNullView.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-6.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


/*
 * 数据为空，或者加载失败的界面
 */
#import <UIKit/UIKit.h>


@interface HYNullView : UIControl

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, assign) BOOL needTouch;
@property (nonatomic, copy) NSString *descInfo;

@property (nonatomic, strong, readonly) UILabel *descLab;
@property (nonatomic, strong, readonly) UIImageView *defIamgeView;

@property (nonatomic, strong) UIButton *eventBtn;


@end
