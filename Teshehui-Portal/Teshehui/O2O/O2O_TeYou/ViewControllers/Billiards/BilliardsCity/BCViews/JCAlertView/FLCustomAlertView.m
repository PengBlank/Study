//
//  FLCustomAlertView.m
//  Teshehui
//
//  Created by macmini5 on 15/12/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "FLCustomAlertView.h"
#import "Masonry.h"
#import "DefineConfig.h"
#import "UIColor+hexColor.h"
#import "UIUtils.h"
@interface FLCustomAlertView()
{
    JCAlertView         *_alertView;
    ButtonClickBlock    _buttonClickBlock;
}

@property (nonatomic, assign)   NSInteger       type;

@property (nonatomic, strong)   UILabel         *titleLabel;
@property (nonatomic, strong)   UILabel         *subTitleLabel; // 开台成功时用到了
@property (nonatomic, strong)   UILabel         *messageLabel;

@property (nonatomic, strong)   UIButton        *okButton;
@property (nonatomic, strong)   UIButton        *cancelButton;

@property (nonatomic, strong)   UIButton        *button1;
@property (nonatomic, strong)   UIButton        *button2;
@property (nonatomic, strong)   UIButton        *button3;

@end

@implementation FLCustomAlertView

- (id)initWithFrame:(CGRect)frame TheViewType:(FLCAlertViewType)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4; // 圆边
        self.clipsToBounds = YES;    // 子试图不许超过父试图
        _type = type;
        
        switch (type) {
            case OneButton_TitleMessage:
            {
                // 一个按钮有标题
                [self createOneButtonView];
            }
                break;
                
            case TwoButton_TitleMessage:
            {
                // 两个按钮有标题
                [self createTwoButtonView];
            }
                break;
                
            case ThreeButton_NoTM:
            {
                // 三个按钮
                [self createThreeButtonView];
                
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}

#pragma mark - 创建View

#pragma mark -- 有标题有消息 一个按钮的
- (void)createOneButtonView
{
    self.backgroundColor = [UIColor whiteColor];
    // 标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.text = @"提示";
    [self addSubview:_titleLabel];
    // 副标题
    _subTitleLabel = [[UILabel alloc] init];
    _subTitleLabel.backgroundColor = [UIColor clearColor];
    _subTitleLabel.numberOfLines = 0;
    _subTitleLabel.font = [UIFont systemFontOfSize:14];
    _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    _subTitleLabel.text = @"副标题";
    [self addSubview:_subTitleLabel];
    // 内容
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.numberOfLines = 0;
    _messageLabel.font = [UIFont systemFontOfSize:14];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.text = @"暂无内容";
    [self addSubview:_messageLabel];
    
    CGRect rect = CGRectMake(0, self.frame.size.height-45, self.frame.size.width, 45);
    // 确认按钮
    _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_okButton setFrame: rect];
    [_okButton setTitle:@"ok" forState:UIControlStateNormal];
    [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_okButton setBackgroundColor:[UIColor blackColor]];
    [_okButton setBackgroundImage:IMAGE(@"prompthl") forState:UIControlStateHighlighted]; // 高亮图片
    [_okButton setTag:ButtonTag_OkBtn];
    [_okButton addTarget:self action:@selector(okCancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_okButton];
    // 线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _okButton.frame.origin.y-0.5, self.frame.size.width, 0.5)];
    [line setBackgroundColor:[UIColor colorWithHexColor:@"c7c7c7" alpha:1]];
    [self addSubview:line];
    
    // 约束
    // 标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(25);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    // 副标题
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
    }];
    // 内容
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_subTitleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
    }];
}

#pragma mark -- 有标题有消息 两个按钮的
- (void)createTwoButtonView
{
    self.backgroundColor = [UIColor whiteColor];
    // 标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.text = @"提示";
    [self addSubview:_titleLabel];
    // 内容
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.numberOfLines = 0;
    _messageLabel.font = [UIFont systemFontOfSize:14];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.text = @"暂无内容";
    [self addSubview:_messageLabel];
    
    CGRect rect1 = CGRectMake(0, self.frame.size.height-40, self.frame.size.width/2, 40);
    CGRect rect2 = CGRectMake(rect1.size.width, self.frame.size.height-40, self.frame.size.width/2, 40);
    // 确认按钮
    _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_okButton setFrame: rect1];
    [_okButton setTitle:@"ok" forState:UIControlStateNormal];
    [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_okButton setBackgroundColor:[UIColor blackColor]];
    [_okButton setBackgroundImage:IMAGE(@"confirmhl") forState:UIControlStateHighlighted]; // 高亮图片
    [_okButton setTag:ButtonTag_OkBtn];
    [_okButton addTarget:self action:@selector(okCancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_okButton];
    // 取消按钮
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setFrame: rect2];
    [_cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_cancelButton setBackgroundColor:[UIColor grayColor]];
    [_cancelButton setBackgroundImage:IMAGE(@"cancelhl") forState:UIControlStateHighlighted]; // 高亮图片
    [_cancelButton setTag:ButtonTag_CancelBtn];
    [_cancelButton addTarget:self action:@selector(okCancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    // 约束
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(21);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_okButton.mas_top).offset(-20);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
    }];
}

#pragma mark -- 无标题无消息 三个按钮的
- (void)createThreeButtonView
{
    UIFont *titleFont = [UIFont systemFontOfSize:g_fitFloat(@[@15, @17, @20])];
    
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button1 setFrame:CGRectMake(0, (self.frame.size.height/3)*0, self.frame.size.width, self.frame.size.height/3)];
    [_button1 setTitle:@"index0" forState:UIControlStateNormal];
    [_button1.titleLabel setFont:titleFont];
    [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button1 setBackgroundColor:[UIColor whiteColor]];
    [_button1 setBackgroundImage:IMAGE(@"payhl") forState:UIControlStateHighlighted]; // 高亮图片
    [_button1 setTag:ButtonTag_Index0];
    [_button1 addTarget:self action:@selector(threeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button1];
    [UIUtils addLineInView:_button1 top:NO leftMargin:0 rightMargin:0];
    
    _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button2 setFrame:CGRectMake(0, (self.frame.size.height/3)*1, self.frame.size.width, self.frame.size.height/3)];
    [_button2 setTitle:@"index1" forState:UIControlStateNormal];
    [_button2.titleLabel setFont:titleFont];
    [_button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button2 setBackgroundColor:[UIColor whiteColor]];
    [_button2 setBackgroundImage:IMAGE(@"payhl") forState:UIControlStateHighlighted]; // 高亮图片
    [_button2 setTag:ButtonTag_Index1];
    [_button2 addTarget:self action:@selector(threeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button2];
    
   // [UIUtils addLineInView:_button2 top:YES leftMargin:0 rightMargin:0];
    
    _button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button3 setFrame:CGRectMake(0, (self.frame.size.height/3)*2, self.frame.size.width, self.frame.size.height/3)];
    [_button3 setTitle:@"index2" forState:UIControlStateNormal];
    [_button3.titleLabel setFont:titleFont];
    [_button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button3 setBackgroundColor:[UIColor whiteColor]];
    [_button3 setBackgroundImage:IMAGE(@"payhl") forState:UIControlStateHighlighted]; // 高亮图片
    [_button3 setTag:ButtonTag_Index2];
    [_button3 addTarget:self action:@selector(threeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button3];
    
     [UIUtils addLineInView:_button3 top:YES leftMargin:0 rightMargin:0];
}


#pragma mark - 按钮点击事件
#pragma mark -- 两个按钮的
- (void)okCancelBtnClick:(UIButton *)sender
{
    [_alertView dismissWithCompletion:^{
        if (_buttonClickBlock)
        {
            _buttonClickBlock(sender.tag);
        }
    }];
}
#pragma mark -- 三个按钮的
- (void)threeButtonClick:(UIButton *)sender
{
    [_alertView dismissWithCompletion:^{
        if (_buttonClickBlock)
        {
            _buttonClickBlock(sender.tag);
        }
    }];
}

#pragma mark - 其它方法
- (void)setTitleLabeltextFont:(UIFont *)font
{
    _titleLabel.font = font;
}

- (void)setTitle:(NSString *)title
      TitleColor:(UIColor *)titleColor
        subTitle:(NSString *)subTitle
AndSubTitleColor:(UIColor *)subTitleColor
      andMessage:(NSString *)message
    MessageColor:(UIColor *)messageColor
{
    if (_type != OneButton_TitleMessage) {
        return;
    }
    _titleLabel.text            = title;
    _titleLabel.textColor       = titleColor;
    
    _subTitleLabel.text         = subTitle;
    _subTitleLabel.textColor    = subTitleColor;
    
    _messageLabel.text          = message;
    _messageLabel.textColor     = messageColor;
}

- (void)setTitle:(NSString *)title
      TitleColor:(UIColor *)titleColor
      andMessage:(NSString *)message
    MessageColor:(UIColor *)messageColor
{
    if (_type == ThreeButton_NoTM) {
        return;
    }
    _titleLabel.text        = title;
    _titleLabel.textColor   = titleColor;
// 设置一下行距离 正值增加行距，负值减小行距
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:message attributes:@{}];
//    NSMutableParagraphStyle *parastyle = [[NSMutableParagraphStyle alloc] init];
//    parastyle.lineSpacing = 8;
//    NSUInteger strLength = [attStr length];
//    [attStr addAttribute:NSParagraphStyleAttributeName value:parastyle range:NSMakeRange(0, strLength)];
    
//    _messageLabel.attributedText    = attStr;
    _messageLabel.text              = message;
    _messageLabel.textColor         = messageColor;
}

- (void)setOkButtonWithTitle:(NSString *)title
                  TitleColor:(UIColor *)titleColor
             BackgroundColor:(UIColor *)backgroundColor
{
    if (_type == ThreeButton_NoTM) {
        return;
    }
    
    [_okButton setTitle: title forState:UIControlStateNormal];
    [_okButton setTitleColor:titleColor forState:UIControlStateNormal];
    [_okButton setBackgroundColor:backgroundColor];
    
}

- (void)setCancelButtonWithTitle:(NSString *)title
                      TitleColor:(UIColor *)titleColor
                 BackgroundColor:(UIColor *)backgroundColor
{
    if (_type == ThreeButton_NoTM) {
        return;
    }
    
    [_cancelButton setTitle:title forState:UIControlStateNormal];
    [_cancelButton setTitleColor:titleColor forState:UIControlStateNormal];
    [_cancelButton setBackgroundColor:backgroundColor];
    
}

- (void)setIndex0ButtonWithTitle:(NSString *)title
                      TitleColor:(UIColor *)titleColor
                 BackgroundColor:(UIColor *)backgroundColor
{
    if (_type != ThreeButton_NoTM) {
        return;
    }
    [_button1 setTitle:title forState:UIControlStateNormal];
    [_button1 setTitleColor:titleColor forState:UIControlStateNormal];
    [_button1 setBackgroundColor:backgroundColor];
}
- (void)setIndex1ButtonWithTitle:(NSString *)title
                      TitleColor:(UIColor *)titleColor
                 BackgroundColor:(UIColor *)backgroundColor
{
    if (_type != ThreeButton_NoTM) {
        return;
    }
    [_button2 setTitle:title forState:UIControlStateNormal];
    [_button2 setTitleColor:titleColor forState:UIControlStateNormal];
    [_button2 setBackgroundColor:backgroundColor];
}
- (void)setIndex2ButtonWithTitle:(NSString *)title
                      TitleColor:(UIColor *)titleColor
                 BackgroundColor:(UIColor *)backgroundColor
{
    if (_type != ThreeButton_NoTM) {
        return;
    }
    [_button3 setTitle:title forState:UIControlStateNormal];
    [_button3 setTitleColor:titleColor forState:UIControlStateNormal];
    [_button3 setBackgroundColor:backgroundColor];
}

// 三个按钮样式 分割线的颜色 就是self的背景色
//- (void)setIndexButtonLineColor:(UIColor *)color
//{
//    if (_type != ThreeButton_NoTM) {
//        return;
//    }
//    self.backgroundColor = color;
//}

#pragma mark -- 按钮点击回调方法
- (void)buttonClickBlock:(ButtonClickBlock)btnClickBlock
{
    _buttonClickBlock = btnClickBlock;
}
#pragma mark -- 显示
- (void)show
{
    _alertView = [[JCAlertView alloc] initWithCustomView:self dismissWhenTouchedBackground:NO];
    [_alertView show];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
