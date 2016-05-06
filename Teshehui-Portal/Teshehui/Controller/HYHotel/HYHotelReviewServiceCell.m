//
//  HYHotelReviewServiceCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelReviewServiceCell.h"
#import "HYHotelPointView.h"

@interface HYHotelReviewServiceCell ()

@property (nonatomic, strong) UILabel *healthLabel;
@property (nonatomic, strong) UILabel *environmentLabel;
@property (nonatomic, strong) UILabel *serviceLabel;
@property (nonatomic, strong) UILabel *deviceLabel;

@property (nonatomic, strong) HYHotelPointView *healthPointView;
@property (nonatomic, strong) HYHotelPointView *environmentPointView;
@property (nonatomic, strong) HYHotelPointView *servicePointView;
@property (nonatomic, strong) HYHotelPointView *devicePointView;

@end

@implementation HYHotelReviewServiceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel *_hLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 120, 16)];
        _hLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_hLabel setFont:[UIFont systemFontOfSize:14]];
        _hLabel.backgroundColor = [UIColor clearColor];
        _hLabel.text = NSLocalizedString(@"health", nil);
        [self.contentView addSubview:_hLabel];
        
        UILabel *_eLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 12, 120, 16)];
        _eLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_eLabel setFont:[UIFont systemFontOfSize:14]];
        _eLabel.backgroundColor = [UIColor clearColor];
        _eLabel.text = NSLocalizedString(@"environment", nil);
        [self.contentView addSubview:_eLabel];
        
        UILabel *_sLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 40, 120, 16)];
        _sLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_sLabel setFont:[UIFont systemFontOfSize:14]];
        _sLabel.backgroundColor = [UIColor clearColor];
        _sLabel.text = NSLocalizedString(@"service", nil);
        [self.contentView addSubview:_sLabel];
        
        UILabel * _dLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 40, 120, 16)];
        _dLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_dLabel setFont:[UIFont systemFontOfSize:14]];
        _dLabel.backgroundColor = [UIColor clearColor];
        _dLabel.text = NSLocalizedString(@"device", nil);
        [self.contentView addSubview:_dLabel];
        
        _healthLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 12, 40, 16)];
        _healthLabel.textColor = [UIColor blackColor];
        [_healthLabel setFont:[UIFont boldSystemFontOfSize:14]];
        _healthLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_healthLabel];
        
        _environmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 12, 40, 16)];
        _environmentLabel.textColor = [UIColor blackColor];
        [_environmentLabel setFont:[UIFont boldSystemFontOfSize:14]];
        _environmentLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_environmentLabel];
        
        _serviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 40, 40, 16)];
        _serviceLabel.textColor = [UIColor blackColor];
        [_serviceLabel setFont:[UIFont boldSystemFontOfSize:14]];
        _serviceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_serviceLabel];
        
        _deviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 40, 40, 16)];
        _deviceLabel.textColor = [UIColor blackColor];
        [_deviceLabel setFont:[UIFont boldSystemFontOfSize:14]];
        _deviceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_deviceLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark getter/setter
- (void)setHotelReview:(HYHotelReview *)hotelReview
{
    if (hotelReview != _hotelReview)
    {
        _hotelReview = hotelReview;
        self.healthPointView.currentPoint = hotelReview.RatingRoom;
        self.healthLabel.text = [NSString stringWithFormat:@"%.1f", hotelReview.RatingRoom];
        self.environmentPointView.currentPoint = hotelReview.RatingPosit;
        self.environmentLabel.text = [NSString stringWithFormat:@"%.1f", hotelReview.RatingPosit];
        self.servicePointView.currentPoint = hotelReview.RatingService;
        self.serviceLabel.text = [NSString stringWithFormat:@"%.1f", hotelReview.RatingService];
        self.devicePointView.currentPoint = hotelReview.RatingCostBenefit;
        self.deviceLabel.text = [NSString stringWithFormat:@"%.1f", hotelReview.RatingCostBenefit];
    }
}

- (HYHotelPointView *)healthPointView
{
    if (!_healthPointView)
    {
        _healthPointView = [[HYHotelPointView alloc] initWithFrame:CGRectMake(48, 16, 60, 8)];
        _healthPointView.maxPoint = 5.0;
        [self.contentView addSubview:_healthPointView];
    }
    
    return _healthPointView;
}

- (HYHotelPointView *)environmentPointView
{
    if (!_environmentPointView)
    {
        _environmentPointView = [[HYHotelPointView alloc] initWithFrame:CGRectMake(186, 16, 60, 8)];
        _environmentPointView.maxPoint = 5.0;
        [self.contentView addSubview:_environmentPointView];
    }
    
    return _environmentPointView;
}

- (HYHotelPointView *)servicePointView
{
    if (!_servicePointView)
    {
        _servicePointView = [[HYHotelPointView alloc] initWithFrame:CGRectMake(48, 44, 60, 8)];
        _servicePointView.maxPoint = 5.0;
        [self.contentView addSubview:_servicePointView];
    }
    
    return _servicePointView;
}

- (HYHotelPointView *)devicePointView
{
    if (!_devicePointView)
    {
        _devicePointView = [[HYHotelPointView alloc] initWithFrame:CGRectMake(186, 44, 60, 8)];
        _devicePointView.maxPoint = 5.0;
        [self.contentView addSubview:_devicePointView];
    }
    
    return _devicePointView;
}
@end
