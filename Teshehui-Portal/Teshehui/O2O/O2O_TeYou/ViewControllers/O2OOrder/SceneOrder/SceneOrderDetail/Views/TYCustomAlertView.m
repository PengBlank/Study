//
//  TYCustomAlertView.m
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/12.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "TYCustomAlertView.h"
#import "DefineConfig.h"
#import "Masonry.h"
#import "UIColor+expanded.h"

@interface TYCustomAlertView ()

@property (nonatomic, strong) JCAlertView *alertView;
@property (nonatomic, copy)   ButtonClickBlock btnBlock;

@property (nonatomic, strong) UILabel   *titleLabel;    // 标题
@property (nonatomic, strong) UILabel   *msgLabel;      // 内容

@property (nonatomic, strong) UIButton  *okButton;      // 确认按钮
@property (nonatomic, strong) UIButton  *cancelButton;  // 取消按钮

@property (nonatomic, strong) UIView    *lineHorizontal;// 水平线
@property (nonatomic, strong) UIView    *lineVertical;  // 垂直线

@end

@implementation TYCustomAlertView

-(id)initWithFrame:(CGRect)frame WithType:(TYCAlertViewType)type
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4; // 弧边
        self.clipsToBounds = YES;
        
        switch (type)
        {
            case Type_Default:
            {// 默认样式
                [self createDefaultTypeView];
            }
                break;
                
            default:
                break;
        }
        
    }
    return self;
}
#pragma mark - 创建UI
-(void)createDefaultTypeView
{
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"标题";
    
    self.msgLabel = [[UILabel alloc] init];
    [self.msgLabel setTextColor:[UIColor blackColor]];
    [self.msgLabel setFont:[UIFont systemFontOfSize:13]];
    [self.msgLabel setTextAlignment:NSTextAlignmentCenter];
    [self.msgLabel setNumberOfLines:2];
    [self addSubview:self.msgLabel];
    self.msgLabel.text = @"文字内容";
    
    
    self.lineHorizontal = [[UIView alloc] init];
    [self.lineHorizontal setBackgroundColor:[UIColor blackColor]];
    [self addSubview:self.lineHorizontal];
    
    self.lineVertical = [[UIView alloc] init];
    [self.lineVertical setBackgroundColor:[UIColor blackColor]];
    [self addSubview:self.lineVertical];
    
    self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.okButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.okButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.okButton setBackgroundImage:[UIImage imageNamed:@"prompthl"] forState:UIControlStateHighlighted];
    self.okButton.tag = ButtonTag_OkBtn;
    [self.okButton addTarget:self action:@selector(defaultButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.okButton];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"prompthl"] forState:UIControlStateHighlighted];
    self.cancelButton.tag = ButtonTag_CancelBtn;
    [self.cancelButton addTarget:self action:@selector(defaultButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    
    WS(weakSelf);
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(5);
        make.top.mas_equalTo(weakSelf.mas_top).with.offset(15);
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-5);
    }];
    // 内容
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(5);
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).with.offset(6);
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-5);
    }];
    // 水平线
    [self.lineHorizontal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(-44);
        make.height.mas_equalTo(@1);
    }];
    // 垂直线
    [self.lineVertical mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.lineHorizontal.mas_bottom);
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.width.mas_equalTo(@1);
    }];
    // 按钮
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left);
        make.top.mas_equalTo(weakSelf.lineHorizontal.mas_bottom);
        make.right.mas_equalTo(weakSelf.lineVertical.mas_left);
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.lineVertical.mas_right);
        make.top.mas_equalTo(weakSelf.lineHorizontal.mas_bottom);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
    }];
}

#pragma mark - 点击事件
-(void)defaultButtonClick:(UIButton *)sender
{
    WS(weakSelf);
    [self.alertView dismissWithCompletion:^{
        if (weakSelf.btnBlock) {
            weakSelf.btnBlock(sender.tag);
        }
    }];
}

#pragma mark -- 按钮点击回调方法
- (void)buttonClickBlock:(ButtonClickBlock)btnClickBlock
{
    self.btnBlock = btnClickBlock;
}

#pragma mark -- 显示
- (void)show
{
    self.alertView = [[JCAlertView alloc] initWithCustomView:self dismissWhenTouchedBackground:NO];
    [self.alertView show];
}

#pragma mark - 设置属性
/** 修改标题属性*/
-(void)setTitle:(NSString *)title Color:(UIColor *)color Font:(CGFloat)font
{
    [self.titleLabel setText:title];
    [self.titleLabel setTextColor:color];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:font]]; // 加粗
}
/** 修改内容属性*/
-(void)setMsg:(NSString *)msg Color:(UIColor *)color Font:(CGFloat)font
{
    [self.msgLabel setText:msg];
    [self.msgLabel setTextColor:color];
    [self.msgLabel setFont:[UIFont systemFontOfSize:font]];
}
/** 修改 左边按钮 属性*/
-(void)setButtonTitle_Left:(NSString *)title Color:(UIColor *)color Font:(CGFloat)font
{
    [self.okButton.titleLabel setFont:[UIFont systemFontOfSize:font]];
    [self.okButton setTitle:title forState:UIControlStateNormal];
    [self.okButton setTitleColor:color forState:UIControlStateNormal];
}
/** 修改 右边按钮 属性*/
-(void)setButtonTitle_Rigth:(NSString *)title Color:(UIColor *)color Font:(CGFloat)font
{
    [self.cancelButton.titleLabel setFont:[UIFont systemFontOfSize:font]];
    [self.cancelButton setTitle:title forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:color forState:UIControlStateNormal];
}
/** 线颜色*/
-(void)setLineColor:(UIColor *)color
{
    [self.lineHorizontal setBackgroundColor:color];
    [self.lineVertical setBackgroundColor:color];
}

@end
