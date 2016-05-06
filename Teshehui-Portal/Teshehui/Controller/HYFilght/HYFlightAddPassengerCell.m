//
//  HYFlightAddPassengerCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightAddPassengerCell.h"

@implementation HYFlightAddPassengerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        _addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TFScalePoint(280), 12, 20, 20)];
        _addImageView.image = [UIImage imageNamed:@"flight_addPassenger"];
        [self.contentView addSubview:_addImageView];
        self.textLabel.text = @"添加乘机人";
        self.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//    if (selected)
//    {
//        _addImageView.image = [UIImage imageNamed:@"btn_flightadd_pressed"];
//    }
//    else
//    {
//        _addImageView.image = [UIImage imageNamed:@"btn_flightadd"];
//    }
//}

@end
