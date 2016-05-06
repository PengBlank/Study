//
//  HYHotelListCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelListCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"


@interface HYHotelListCell ()

@property (nonatomic, strong) UILabel *hotelNameLabel;
@property (nonatomic, strong) UILabel *hotelPriceLabel;
//@property (nonatomic, strong) UILabel *hotelAddressLabel;
@property (nonatomic, strong) UILabel *hotelStarLabel;

//@property (nonatomic, strong) UILabel *hotelRatingLabel;
@property (nonatomic, strong) UILabel *hotelZoneLabel;

@property (nonatomic, strong) UILabel *desLabel;

@property (nonatomic, strong) UIImageView *park;
@property (nonatomic, strong) UIImageView *wifi;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UIImageView *hotelImageView;

@end

@implementation HYHotelListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.hotelImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_hotelImageView];
        
        [self.hotelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
//            make.top.mas_equalTo(5);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(55, 55));
        }];
        
        _hotelNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _hotelNameLabel.textColor = [UIColor blackColor];
        [_hotelNameLabel setFont:[UIFont systemFontOfSize:14]];
        _hotelNameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_hotelNameLabel];
        [_hotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.hotelImageView.mas_top);
            make.left.equalTo(self.hotelImageView.mas_right).offset(5);
            make.right.mas_lessThanOrEqualTo(25);
        }];
        
        _hotelStarLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _hotelStarLabel.textColor = [UIColor colorWithRed:77/255.0 green:208/255.0 blue:246/255.0 alpha:1];
        [_hotelStarLabel setFont:[UIFont systemFontOfSize:12]];
        _hotelStarLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_hotelStarLabel];
        [_hotelStarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_hotelImageView.mas_right).offset(5);
            make.top.equalTo(_hotelNameLabel.mas_bottom).offset(10);
        }];
        
        self.wifi = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_wifi"]];
        [self.contentView addSubview:_wifi];
        _wifi.hidden = YES;
        [_wifi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_hotelStarLabel.mas_right).offset(5);
            make.right.mas_lessThanOrEqualTo(80);
            make.height.equalTo(@15);
            make.width.equalTo(@15);
            make.centerY.equalTo(_hotelStarLabel.mas_centerY);
        }];
        
        self.park = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_park"]];
        [self.contentView addSubview:_park];
        _park.hidden = YES;
        [_park mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wifi.mas_right).offset(5);
            make.right.mas_lessThanOrEqualTo(80);
            make.height.equalTo(@15);
            make.width.equalTo(@15);
            make.centerY.equalTo(_hotelStarLabel.mas_centerY);
        }];
        
        _hotelZoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _hotelZoneLabel.textColor = [UIColor colorWithRed:147.0/255.0
                                                    green:147.0/255.0
                                                     blue:147.0/255.0
                                                    alpha:1.0];
        [_hotelZoneLabel setFont:[UIFont systemFontOfSize:12]];
        _hotelZoneLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_hotelZoneLabel];
        [_hotelZoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_hotelImageView.mas_right).offset(5);
            make.top.equalTo(_hotelStarLabel.mas_bottom).offset(5);
            make.right.mas_lessThanOrEqualTo(80);
        }];
        
        _hotelPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _hotelPriceLabel.textColor = [UIColor colorWithRed:250.0/255.0
                                                     green:113.0/255.0
                                                      blue:17.0/255.0
                                                     alpha:1.0];
        [_hotelPriceLabel setFont:[UIFont boldSystemFontOfSize:18]];
        _hotelPriceLabel.textAlignment = NSTextAlignmentRight;
        _hotelPriceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_hotelPriceLabel];
        [_hotelPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(100);
        }];
        
//        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 65, 200, 16)];
//        _distanceLabel.textColor = [UIColor colorWithRed:147.0/255.0
//                                                    green:147.0/255.0
//                                                     blue:147.0/255.0
//                                                    alpha:1.0];
//        [_distanceLabel setFont:[UIFont systemFontOfSize:12]];
//        _distanceLabel.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_distanceLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHotleSummary:(HYHotelListSummary *)hotleSummary
{
    if (_hotleSummary != hotleSummary)
    {
        _hotleSummary = hotleSummary;
        
        self.hotelNameLabel.text = hotleSummary.productName;

        //self.hotelRatingLabel.text = hotleSummary.score;
        //hotleSummary.price = 1000.0;
        if (hotleSummary.price > 0)
        {
            NSString *priceDesc = [NSString stringWithFormat:@"¥%@起", hotleSummary.price];
            
            if ([self.hotelPriceLabel respondsToSelector:@selector(setAttributedText:)])
            {
                NSMutableAttributedString *price_desc_attr = [[NSMutableAttributedString alloc] initWithString:priceDesc];
                [price_desc_attr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]} range:NSMakeRange(0, 1)];
                [price_desc_attr addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:250.0/255.0 green:113.0/255.0 blue:17.0/255.0 alpha:1.0]}
                                         range:NSMakeRange(0, priceDesc.length-1)];
                [price_desc_attr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0], NSFontAttributeName, nil] range:NSMakeRange(1, priceDesc.length-2)];
                [price_desc_attr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10.0], NSFontAttributeName, nil] range:NSMakeRange(price_desc_attr.length-1, 1)];
                [price_desc_attr addAttributes:@{NSForegroundColorAttributeName: [UIColor grayColor]} range:NSMakeRange(priceDesc.length-1, 1)];
                [self.hotelPriceLabel setAttributedText:price_desc_attr];
            }
            else
            {
                self.hotelPriceLabel.text = priceDesc;
            }
        }
        else
        {
            self.hotelPriceLabel.text = @"暂无价格";
        }
        
        if (hotleSummary.hotelStar)
        {
            self.hotelStarLabel.text = hotleSummary.hotelStar;
        }
        else
        {
            self.hotelStarLabel.text = hotleSummary.hotelType;
        }
        
        
        if (hotleSummary.park > 0)
        {
//            CGSize size = [_hotelStarLabel.text sizeWithFont:_hotelStarLabel.font];
//            CGRect frame = _hotelStarLabel.frame;
//            frame.size = size;
//            _hotelStarLabel.frame = frame;
//            _park.frame = CGRectMake(CGRectGetMaxX(frame)+3, CGRectGetMinY(frame), CGRectGetHeight(frame), CGRectGetHeight(frame));
            _park.hidden = NO;
            [_park mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(15, 15));
            }];
        }
        else
        {
            _park.hidden = YES;
            [_park mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeZero);
            }];
        }
        
        if (hotleSummary.wifi > 0)
        {
//            CGSize size = [_hotelStarLabel.text sizeWithFont:_hotelStarLabel.font];
//            CGRect frame = _hotelStarLabel.frame;
//            frame.size = size;
//            _hotelStarLabel.frame = frame;
//            CGFloat x = hotleSummary.park > 0 ? CGRectGetMaxX(_park.frame) : CGRectGetMaxX(_hotelStarLabel.frame);
//            x += 3;
//            _wifi.frame = CGRectMake(x, CGRectGetMinY(frame), CGRectGetHeight(frame), CGRectGetHeight(frame));
            _wifi.hidden = NO;
            [_wifi mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(15, 15));
            }];
        }
        else
        {
            _wifi.hidden = YES;
            [_wifi mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeZero);
            }];
        }
        
        
        self.hotelZoneLabel.text = hotleSummary.commercialName;

        [self.hotelImageView sd_setImageWithURL:[NSURL URLWithString:hotleSummary.smallLogoUrl]
                       placeholderImage:[UIImage imageNamed:@"default_hotel_logo_200"]];
        
    }
}

//- (void)layoutSubviews
//{d
//    [super layoutSubviews];
//    self.imageView.frame = CGRectMake(0, 0, 100, 100);
//    _hotelPriceLabel.frame = CGRectMake(CGRectGetWidth(self.frame)-100-30, 38, 100, 16);
//    _hotelNameLabel.frame = CGRectMake(105, 8, CGRectGetWidth(self.frame)-120, 18);
//    _hotelStarLabel.frame = CGRectMake(105, 40, CGRectGetWidth(self.frame)-120, 16);
//    _hotelZoneLabel.frame = CGRectMake(105, 65, CGRectGetWidth(self.frame)-120, 16);
//}

#pragma mark - getter

//- (UILabel *)hotelStarLabel
//{
//    if (!_hotelStarLabel)
//    {
//        _hotelStarLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 40, CGRectGetWidth(self.frame)-120, 16)];
//        _hotelStarLabel.textColor = [UIColor colorWithRed:147.0/255.0
//                                                    green:147.0/255.0
//                                                     blue:147.0/255.0
//                                                    alpha:1.0];
//        [_hotelStarLabel setFont:[UIFont systemFontOfSize:12]];
//        _hotelStarLabel.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_hotelStarLabel];
//    }
//    
//    return _hotelStarLabel;
//}

//- (UILabel *)hotelZoneLabel
//{
//    if (!_hotelZoneLabel)
//    {
//        _hotelZoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 65, CGRectGetWidth(self.frame)-120, 16)];
//        _hotelZoneLabel.textColor = [UIColor colorWithRed:147.0/255.0
//                                                    green:147.0/255.0
//                                                     blue:147.0/255.0
//                                                    alpha:1.0];
//        [_hotelZoneLabel setFont:[UIFont systemFontOfSize:12]];
//        _hotelZoneLabel.backgroundColor = [UIColor clearColor];
//        _hotelZoneLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        [self.contentView addSubview:_hotelZoneLabel];
//    }
//    
//    return _hotelZoneLabel;
//}


@end
