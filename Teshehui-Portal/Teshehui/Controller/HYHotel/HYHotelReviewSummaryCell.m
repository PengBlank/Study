//
//  HYHotelReviewSummaryCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelReviewSummaryCell.h"

@implementation HYHotelReviewSummaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor colorWithRed:51.0f/255.0f
                                                   green:147.0f/255.0f
                                                    blue:196.0f/255.0f
                                                   alpha:1.0];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.textColor = [UIColor colorWithRed:51.0f/255.0f
                                                         green:147.0f/255.0f
                                                          blue:196.0f/255.0f
                                                         alpha:1.0];
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
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
    self.textLabel.frame = CGRectMake(12, (self.frame.size.height-20)/2, 120, 20);
    self.detailTextLabel.frame = CGRectMake(130, (self.frame.size.height-20)/2, 120, 20);
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
