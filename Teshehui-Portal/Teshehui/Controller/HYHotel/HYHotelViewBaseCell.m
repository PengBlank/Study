//
//  HYHotelViewBaseCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelViewBaseCell.h"

@implementation HYHotelViewBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textColor = [UIColor colorWithRed:108.0f/255.0f
                                                   green:108.0f/255.0f
                                                    blue:108.0f/255.0f
                                                   alpha:1.0];
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(24, 11, 21, 21)];
        _iconView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_iconView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _iconView.frame = CGRectMake(20, (self.frame.size.height-21)/2, 21, 21);
    self.textLabel.frame = CGRectMake(48, (self.frame.size.height-20)/2, 120, 20);
}

@end
