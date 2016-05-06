//
//  HYHotelConditionRightCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelConditionRightCell.h"

@implementation HYHotelConditionRightCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
//        _cImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-18-10, 13, 18, 18)];
//        _cImageView.image = [UIImage imageNamed:@"all_icon_check"];
//        _cImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//        [self.contentView addSubview:_cImageView];
//        [_cImageView setHidden:YES];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCheck:(BOOL)check
{
    self.textLabel.textColor = check ? [UIColor colorWithRed:77/255.0 green:208/255.0 blue:246/255.0 alpha:1] :[UIColor darkGrayColor];
}

@end
