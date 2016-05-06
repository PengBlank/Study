//
//  HYHotelReviewDetailCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelReviewDetailCell.h"

@interface HYHotelReviewDetailCell ()
{
    CGFloat _contentHeight;
}
@property (nonatomic, strong) UILabel *allLabel;
@property (nonatomic, strong) UILabel *healthLabel;
@property (nonatomic, strong) UILabel *environmentLabel;
@property (nonatomic, strong) UILabel *serviceLabel;
@property (nonatomic, strong) UILabel *deviceLabel;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation HYHotelReviewDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _allLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 9, 64, 16)];
        _allLabel.textColor = [UIColor colorWithRed:51.0f/255.0f
                                              green:147.0f/255.0f
                                               blue:196.0f/255.0f
                                              alpha:1.0];
        [_allLabel setFont:[UIFont systemFontOfSize:14]];
        _allLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_allLabel];

        _healthLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 9, 50, 16)];
        _healthLabel.textColor = [UIColor grayColor];
        [_healthLabel setFont:[UIFont systemFontOfSize:12]];
        _healthLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_healthLabel];
        
        _environmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 9, 50, 16)];
        _environmentLabel.textColor = [UIColor grayColor];
        [_environmentLabel setFont:[UIFont systemFontOfSize:12]];
        _environmentLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_environmentLabel];
        
        _serviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 9, 50, 16)];
        _serviceLabel.textColor = [UIColor grayColor];
        [_serviceLabel setFont:[UIFont systemFontOfSize:12]];
        _serviceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_serviceLabel];
        
        _deviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 9, 50, 16)];
        _deviceLabel.textColor = [UIColor grayColor];
        [_deviceLabel setFont:[UIFont systemFontOfSize:12]];
        _deviceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_deviceLabel];
        
        _userLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 32, 180, 16)];
        _userLabel.textColor = [UIColor grayColor];
        [_userLabel setFont:[UIFont systemFontOfSize:12]];
        _userLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_userLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 32, 120, 16)];
        _dateLabel.textColor = [UIColor grayColor];
        [_dateLabel setFont:[UIFont systemFontOfSize:12]];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_dateLabel];
        
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.textLabel.numberOfLines = 0;
        self.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
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
    self.textLabel.frame = CGRectMake(12, 50, 276, _contentHeight);
}

#pragma mark setter
- (void)setHotelReviewDetail:(HYHotelReviewDetail *)hotelReviewDetail
{
    if (hotelReviewDetail != _hotelReviewDetail)
    {
        _hotelReviewDetail = hotelReviewDetail;
        
        self.allLabel.text = [NSString stringWithFormat:@"总评%.1f分", hotelReviewDetail.RatingAll];
        self.healthLabel.text = [NSString stringWithFormat:@"卫生:%.1f", hotelReviewDetail.RatingRoom];
        self.environmentLabel.text = [NSString stringWithFormat:@"环境:%.1f", hotelReviewDetail.RatingPosit];
        self.serviceLabel.text = [NSString stringWithFormat:@"服务:%.1f", hotelReviewDetail.RatingService];
        self.deviceLabel.text = [NSString stringWithFormat:@"设施:%.1f", hotelReviewDetail.RatingCostBenefit];
        self.userLabel.text = hotelReviewDetail.UID;
        self.dateLabel.text = hotelReviewDetail.WritingDate;
        self.textLabel.text = hotelReviewDetail.Content;
        
        CGSize size = [hotelReviewDetail.Content sizeWithFont:[UIFont systemFontOfSize:12]
                                 constrainedToSize:CGSizeMake(268, MAXFLOAT)
                                     lineBreakMode:NSLineBreakByCharWrapping];

        _contentHeight = size.height;
    }
}

@end
