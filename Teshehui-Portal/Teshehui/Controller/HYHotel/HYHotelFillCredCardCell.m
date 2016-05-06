//
//  HYJptelFillCredCardCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-21.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelFillCredCardCell.h"

@interface HYHotelFillCredCardCell ()

@property (nonatomic, strong) HYTextField *textField;

@end

@implementation HYHotelFillCredCardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        CGRect rect = CGRectMake(110, 12, 180, 20);
        _textField = [[HYTextField alloc] initWithFrame:rect];
        _textField.autoSpace = NO;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.secureTextEntry = NO;
        _textField.tag = 1;
        _textField.delegate = self;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_textField];
        
        _infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _infoBtn.frame = CGRectMake(260, 0, 60, 44);
        [_infoBtn setImage:[UIImage imageNamed:@"btn_info"]
                  forState:UIControlStateNormal];
        [_infoBtn setImage:[UIImage imageNamed:@"btn_info_pressed"]
                  forState:UIControlStateHighlighted];
        [_infoBtn setHidden:YES];
        _infoBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_infoBtn];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textField resignFirstResponder];
    return YES;
}

@end
