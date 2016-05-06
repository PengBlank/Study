//
//  HYHotelFillUserEmailInfoCell.m
//  Teshehui
//
//  Created by HYZB on 14-8-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelFillUserEmailInfoCell.h"

@interface HYHotelFillUserEmailInfoCell ()

@property (nonatomic, strong) UITextField *emailField;

@end

@implementation HYHotelFillUserEmailInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(14, 88, 306, 1)];
        line2.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                    topCapHeight:0];
        [self.contentView addSubview:line2];
        
        self.phoneField.returnKeyType = UIReturnKeyNext;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 100, 150, 20)];
        
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"邮件";
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
        
        CGRect rect = CGRectMake(64, 100, 200, 20);
        _emailField = [[UITextField alloc] initWithFrame:rect];
        _emailField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailField.placeholder = @"预付酒店需要填写邮件";
        _emailField.delegate = self;
        _emailField.font = [UIFont systemFontOfSize:16];
        _emailField.returnKeyType = UIReturnKeyDone;
        _emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_emailField];
        
        [self configFields];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
