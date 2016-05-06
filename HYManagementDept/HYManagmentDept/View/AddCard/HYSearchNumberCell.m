//
//  HYSearchNumberCell.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-29.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYSearchNumberCell.h"

@implementation HYSearchNumberCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        _numberLabel.autoresizingMask = UIViewAutoresizingFlexibleAll;
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.font = [UIFont systemFontOfSize:18.0];
        [self addSubview:_numberLabel];
    }
    return self;
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
