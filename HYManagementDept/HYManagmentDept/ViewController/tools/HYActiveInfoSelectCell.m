//
//  HYActiveInfoSelectCell.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-11-3.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYActiveInfoSelectCell.h"

@implementation HYActiveInfoSelectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        self.textLabel.font = [UIFont systemFontOfSize:16.0f];
        
        UILabel * _sexLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 220, 40)];
        _sexLab.textColor = [UIColor colorWithRed:51.0f/255.0f
                                            green:147.0f/255.0f
                                             blue:196.0f/255.0f
                                            alpha:1.0];
        [_sexLab setFont:[UIFont systemFontOfSize:16]];
        _sexLab.backgroundColor = [UIColor clearColor];
        _sexLab.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_sexLab];
        self.valueLabel = _sexLab;
        
        UIImage *arrIcon = [UIImage imageNamed:@"ico_arrow_list"];
        UIImageView *arrView1 = [[UIImageView alloc] initWithFrame:CGRectMake(300, 14.5, 10, 15)];
        arrView1.image = arrIcon;
        arrView1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:arrView1];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame) * (80/320.0);
    self.textLabel.frame = CGRectMake(15, 0, width, 50);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
