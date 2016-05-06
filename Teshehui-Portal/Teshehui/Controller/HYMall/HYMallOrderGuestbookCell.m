//
//  HYMallOrderRemarkCell.m
//  Teshehui
//
//  Created by HYZB on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderGuestbookCell.h"

@implementation HYMallOrderGuestbookCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *bgview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 300, 34)];
        bgview.image = [UIImage imageNamed:@""];
        [self.contentView addSubview:bgview];
        
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        
        _guestbookField = [[UITextField alloc] initWithFrame:CGRectMake(16, 4, TFScalePoint(300), 34)];
        _guestbookField.keyboardType = UIKeyboardTypeDefault;
        _guestbookField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _guestbookField.font = [UIFont systemFontOfSize:14];
        _guestbookField.returnKeyType = UIReturnKeyDone;
        _guestbookField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _guestbookField.placeholder = @"买家留言";
        _guestbookField.delegate = self.fieldDelegate;
        [self.contentView addSubview:_guestbookField];
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

#pragma mark setter/getter
- (void)setFieldDelegate:(id<UITextFieldDelegate>)fieldDelegate
{
    _guestbookField.delegate = fieldDelegate;
}

@end
