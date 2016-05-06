//
//  HYHotelRoomInfoCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelRoomInfoCell.h"

@implementation HYHotelRoomInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 14, 14)];
        [self.contentView addSubview:_iconView];
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
        self.detailTextLabel.textColor = [UIColor blackColor];
        self.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.detailTextLabel.numberOfLines = 2;
        
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.textColor = [UIColor grayColor];
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
    
    if (self.textLabel.text == nil)
    {
        self.detailTextLabel.frame = TFRectMakeFixWidth(44, 4, 246, 16);
    }
    else
    {
        self.textLabel.frame = TFRectMakeFixWidth(44, 5, 40, 14);
        self.detailTextLabel.frame = TFRectMakeFixWidth(100, 4, 190, 16);
    }
}

@end
