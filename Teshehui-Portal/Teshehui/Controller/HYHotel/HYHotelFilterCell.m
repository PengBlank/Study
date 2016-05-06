//
//  HYHotelFilterCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-14.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelFilterCell.h"

@implementation HYHotelFilterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.detailTextLabel.font = [UIFont systemFontOfSize:16];
        self.detailTextLabel.textColor = [UIColor colorWithRed:51.0f/255.0f
                                                         green:147.0f/255.0f
                                                          blue:196.0f/255.0f
                                                         alpha:1.0];
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        self.detailTextLabel.backgroundColor = [UIColor clearColor];

        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        self.textLabel.backgroundColor = [UIColor clearColor];
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
    self.detailTextLabel.frame = CGRectMake(140, 12, 150, 20);
}

@end
