//
//  HYInfoValidateCell.m
//  Teshehui
//
//  Created by 成才 向 on 16/2/19.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYInfoValidateCell.h"
#import "Masonry.h"
#import "CCCountTimer.h"

@interface HYInfoValidateCell ()
<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *mobField;
@property (nonatomic, strong) UIButton *validateBtn;

@property (nonatomic, strong) CCCountTimer *timer;

@end

@implementation HYInfoValidateCell

- (void)dealloc
{
    [self.timer stop];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont systemFontOfSize:15.0];
        self.textLabel.textColor = [UIColor colorWithWhite:.5 alpha:1];
        
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 100, 44)];
        field.font = [UIFont systemFontOfSize:15.0];
        field.delegate = self;
        field.keyboardType = UIKeyboardTypeDecimalPad;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.placeholder = @"请输入您的手机号码";
        [self.contentView addSubview:field];
        self.mobField = field;
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(100);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-105);
        }];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        btn.backgroundColor = [UIColor colorWithRed:230/255.0
                                              green:37/255.0
                                               blue:47/255.0
                                              alpha:1];
        [btn addTarget:self
                action:@selector(validateAction)
      forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        self.validateBtn = btn;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(40);
        }];
        
        self.textLabel.text = @"手机号";
        
        self.showName = YES;
        _canEditPhone = YES;
    }
    return self;
}

- (void)setCanEditPhone:(BOOL)canEditPhone
{
    if (_canEditPhone != canEditPhone)
    {
        _canEditPhone = canEditPhone;
        self.mobField.enabled = canEditPhone;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.showName)
    {
        self.mobField.frame = CGRectMake(100, 0, self.frame.size.width-100-10, self.frame.size.height);
    }
    else
    {
        self.mobField.frame = CGRectMake(20, 0, self.frame.size.width-20-10, self.frame.size.height);
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    self.mobField.placeholder = placeHolder;
}

- (void)validateAction
{
    if (self.startValidate)
    {
        self.startValidate(self.mob);
    }
}

- (void)startCounting
{
    self.timer = [[CCCountTimer alloc] initWithCount:60];
    WS(weakSelf);
    [self.validateBtn setEnabled:NO];
    self.validateBtn.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    self.timer.countCallback = ^(NSInteger count, BOOL stop)
    {
        NSString *title = [NSString stringWithFormat:@"%ldS重新获取", (long)count];
        [weakSelf.validateBtn setTitle:title forState:UIControlStateDisabled];
        if (count == 0)
        {
            weakSelf.validateBtn.enabled = YES;
            weakSelf.validateBtn.backgroundColor = [UIColor colorWithRed:230/255.0
                                                                   green:37/255.0
                                                                    blue:47/255.0
                                                                   alpha:1];
            [weakSelf.validateBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            [weakSelf.validateBtn setTitle:@"60S重新获取" forState:UIControlStateDisabled];
        }
    };
    [self.timer start];
}

- (void)setShowName:(BOOL)showName
{
    _showName = showName;
    if (!showName) {
        self.textLabel.text = nil;
        [self.mobField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-105);
        }];
    }
}

- (void)setMob:(NSString *)mob
{
    if (_mob != mob) {
        _mob = mob;
        self.mobField.text = mob;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    _mob = result;
    if (self.didGetValue) {
        self.didGetValue(_mob);
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _mob = nil;
    if (self.didGetValue) {
        self.didGetValue(_mob);
    }
    return YES;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    self.mob = textField.text;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self validateAction];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
