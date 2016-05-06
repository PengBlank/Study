//
//  HYHotelOrderSettingCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelOrderSettingCell.h"
#import "Masonry.h"

@implementation HYHotelOrderSettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
        self.detailTextLabel.textColor = [UIColor colorWithRed:77/255.0 green:208/255.0 blue:246/255.0 alpha:1];
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        
        UIImage *arrIcon = [UIImage imageNamed:@"ico_arrow_list"];
        UIImageView *arrView1 = [[UIImageView alloc] initWithFrame:CGRectMake(300, 17, 10, 10)];
        arrView1.image = arrIcon;
        [self.contentView addSubview:arrView1];
        [arrView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 12));
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)updateConstraints
//{
//    if (self.textLabel)
//    {
//        
//    }
//    [super updateConstraints];
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //10: arraw, 12:arrow width, 5: space, 100: width
    self.detailTextLabel.frame = CGRectMake(CGRectGetWidth(self.frame)-127, 0, 100, CGRectGetHeight(self.frame));
    self.textLabel.frame = CGRectMake(10, 0, CGRectGetMinX(self.detailTextLabel.frame)-10, CGRectGetHeight(self.frame));
}

@end
