//
//  HYLoginV2InputCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLoginV2InputCell.h"

@implementation HYLoginV2InputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.textLabel.font = [UIFont systemFontOfSize:16.0];
        self.textLabel.textColor = [UIColor colorWithWhite:.4 alpha:1];
        self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.textField.font = [UIFont systemFontOfSize:16.0];
        self.textField.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.textField];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(25, 0, 90, self.frame.size.height);
    self.textField.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame), 0, self.frame.size.width-15-CGRectGetMaxX(self.textLabel.frame), self.frame.size.height);
}


@end
