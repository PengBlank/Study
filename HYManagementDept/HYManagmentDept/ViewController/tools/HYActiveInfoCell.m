//
//  HYActiveInfoCell.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-11-3.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYActiveInfoCell.h"

@implementation HYActiveInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.frame = CGRectMake(0, 0, 100, 50);
        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        self.textLabel.font = [UIFont systemFontOfSize:16.0f];
        
        UITextField * _authcodeField = [[UITextField alloc] initWithFrame:CGRectMake(100, 5, 220, 40)];
        _authcodeField.keyboardType = UIKeyboardTypeDefault;
        _authcodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _authcodeField.font = [UIFont systemFontOfSize:16];
        _authcodeField.returnKeyType = UIReturnKeyDone;
        _authcodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_authcodeField];
        self.valueField = _authcodeField;
        
        self.valueField.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleLeftMargin;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame) * (80/320.0);
    self.textLabel.frame = CGRectMake(15, 0, width, 50);
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
