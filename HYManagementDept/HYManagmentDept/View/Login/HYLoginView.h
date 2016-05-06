//
//  HYLoginView.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-4.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYLoginTextFrameView.h"

@interface HYLoginView : UIView

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *passField;

@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *rememberNameBtn;
@property (nonatomic, strong) UIButton *rememberPassBtn;
@property (nonatomic, strong) UIButton *password;
@property (nonatomic, strong) UIButton *user;

@property (nonatomic, strong) UIView *loginFrameView;

@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *userFrame;
@property (nonatomic, strong) UIImageView *passwordFrame;

@property (nonatomic, strong) UILabel *rememberCode;

- (void)setupiPadPortrait;
- (void)setupiPadLanscape;
@end
