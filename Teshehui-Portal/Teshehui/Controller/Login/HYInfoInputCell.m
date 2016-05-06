//
//  HYInfoInputCell.m
//  Teshehui
//
//  Created by 成才 向 on 16/2/19.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYInfoInputCell.h"
#import "Masonry.h"

@interface HYInfoInputCell ()
<UITextFieldDelegate>
@end

@implementation HYInfoInputCell

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
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:field];
        self.valueField = field;
        
        self.showName = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.showName)
    {
        self.valueField.frame = CGRectMake(100, 0, self.frame.size.width-100-10, self.frame.size.height);
    }
    else
    {
        self.valueField.frame = CGRectMake(20, 0, self.frame.size.width-20-10, self.frame.size.height);
    }
}

- (void)setName:(NSString *)name
{
    if (self.showName) {
        self.textLabel.text = name;
    }
    else {
        self.textLabel.text = nil;
    }
//    self.valueField.placeholder
}

- (void)setValue:(NSString *)value
{
    if (_value != value)
    {
        _value = value;
        self.valueField.text = value;
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.valueField.placeholder = placeholder;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    _value = result;
    if (self.didGetValue) {
        self.didGetValue(_value);
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    
    _value = nil;
    if (self.didGetValue) {
        self.didGetValue(_value);
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.didReturn) {
        self.didReturn();
    }
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
