//
//  HYActivateInputCell.m
//  Teshehui
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYActivateInputCell.h"

@implementation HYActivateInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat width = CGRectGetWidth(ScreenRect);
        self.textLabel.frame = CGRectMake(10, 0, 60, 44);
        self.textLabel.text = @"验证码";
        
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, width-90-10, 54)];
        field.placeholder = @"请输入验证码";
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:field];
        self.codeField = field;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
