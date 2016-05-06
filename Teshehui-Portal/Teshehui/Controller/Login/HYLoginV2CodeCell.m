//
//  HYLoginV2CodeCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLoginV2CodeCell.h"

@implementation HYLoginV2CodeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont systemFontOfSize:16.0];
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        UITextFieldEx *textField = [[UITextFieldEx alloc] initWithFrame:CGRectZero];
        textField.font = [UIFont systemFontOfSize:13.0];
        textField.leftPadding = 5;
        textField.rightPadding = 5;
        self.textField = textField;
        self.textField.backgroundColor = [UIColor whiteColor];
        self.textField.layer.borderColor = [UIColor colorWithWhite:.91 alpha:1].CGColor;
        self.textField.layer.borderWidth = 1.;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:_textField];
        
//        UIImage *line = [[UIImage imageNamed:@"Line_InCell"]
//                         stretchableImageWithLeftCapWidth:2 topCapHeight:0
//                         ];
//        UIImageView *linev = [[UIImageView alloc] initWithImage:line];
//        linev.tag = 1002;
//        [self.contentView addSubview:linev];
        UIImage *normal = [UIImage imageNamed:@"btn_login_new"];
        self.codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 55)];
        [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_codeBtn setBackgroundImage:normal forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:_codeBtn];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textField.frame = CGRectMake(24,
                                      0,
                                      CGRectGetWidth(self.frame)-2*24-80-5,
                                      CGRectGetHeight(self.frame)-18);
    _codeBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-24-80,
                                2,
                                80,
                                CGRectGetHeight(self.frame)-18-4);
}

- (void)startTiming
{
    _count = 60;
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    _codeBtn.enabled = NO;
    [_codeBtn setTitle:[NSString stringWithFormat:@"%lu", _count] forState:UIControlStateDisabled];
}

- (void)timerAction:(NSTimer *)timer
{
    _count --;
    [_codeBtn setTitle:[NSString stringWithFormat:@"%lu", _count] forState:UIControlStateDisabled];
    
    if (_count == 0)
    {
        _codeBtn.enabled = YES;
        [_timer invalidate];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
