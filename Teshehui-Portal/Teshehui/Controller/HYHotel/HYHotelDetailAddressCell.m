//
//  HYHotelDetailAddressCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelDetailAddressCell.h"
#import "Masonry.h"

@implementation HYHotelDetailAddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 11, 11)];
        _iconView.frame = CGRectMake(10, CGRectGetHeight(self.frame)/2-5, 11, 11);
        [self.contentView addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(11, 11));
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        _accessaryView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-18, 14.5, 8, 12)];
        [self.contentView addSubview:_accessaryView];
        [_accessaryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(8, 12));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(-10);
        }];
        
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.textColor = [UIColor grayColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.detailTextLabel.textColor = [UIColor colorWithRed:77/255.0 green:208/255.0 blue:246/255.0 alpha:1];
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
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
//    if (self.textLabel.superview)
//    {
//        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_iconView.mas_right).offset(5);
//            make.centerY.equalTo(self.contentView.mas_centerY);
//            make.right.lessThanOrEqualTo(self.detailTextLabel.mas_left);
//        }];
//    }
//    
//    if (self.detailTextLabel.superview)
//    {
//        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.contentView.mas_centerY);
//            make.right.equalTo(_accessaryView.mas_left).offset(-5);
//            make.width.mas_equalTo(50);
//        }];
//    }
//    
//    [super updateConstraints];
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.detailTextLabel.frame = CGRectMake(CGRectGetMinX(_accessaryView.frame)-50-10, 0, 50, CGRectGetHeight(self.frame));
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(_iconView.frame)+10, 0, CGRectGetMinX(self.detailTextLabel.frame)-CGRectGetMaxX(_iconView.frame)-10, CGRectGetHeight(self.frame));
    
    //self.detailTextLabel.frame = CGRectMake(265, 12, 35, 20);
}

@end
