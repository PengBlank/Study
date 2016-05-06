//
//  HYLoginFootView.h
//  Teshehui
//
//  Created by HYZB on 16/2/20.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYImageButton.h"

@interface HYLoginFootView : UIView

@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *quicklyRegisterBtn;
@property (nonatomic, strong) UIButton *activateBtn;
@property (nonatomic, strong) UIButton *buyCardBtn;
@property (nonatomic, strong) HYImageButton *qqBtn;

@property (nonatomic, strong) UILabel *declareLabel;
@property (nonatomic, strong) UIButton *forgetBtn;

- (void)setupThirdLonginWithFrame:(CGRect)frame footH:(CGFloat)footH;
- (void)setupthirdLonginButtonWithFootH:(CGFloat)footH info:(NSDictionary *)info x:(CGFloat)x width:(CGFloat)width;

@end
