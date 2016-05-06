//
//  HYLoginV2TextCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLoginV2TextCell.h"
#import "HYGetWebLinkRequest.h"
#import "HYGetWebLinkResponse.h"
#import "HYGetRandomInviteCodeRequest.h"
#import "HYGetRandomInviteCodeResponse.h"

@interface HYLoginV2TextCell ()
<UIAlertViewDelegate>

@end

@implementation HYLoginV2TextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
//        self.textLabel.font = [UIFont systemFontOfSize:16.0];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        UITextFieldEx *textField = [[UITextFieldEx alloc] initWithFrame:CGRectZero];
        textField.font = [UIFont systemFontOfSize:16.0];
        textField.leftPadding = 5;
        textField.rightPadding = 5;
        self.textField = textField;
        self.textField.backgroundColor = [UIColor whiteColor];
        self.textField.layer.borderColor = [UIColor colorWithWhite:.91 alpha:1].CGColor;
        self.textField.layer.borderWidth = 1.;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:_textField];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.textField.frame = CGRectMake(24,
                                      0,
                                      CGRectGetWidth(self.frame)-24*2,
                                      CGRectGetHeight(self.frame)-18);
}




@end
