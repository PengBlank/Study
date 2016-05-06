//
//  HYHotelDetailSummaryCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelDetailSummaryCell.h"
#import "HYHotelPictureInfo.h"
#import "UIButton+WebCache.h"
#import "Masonry.h"


@interface HYHotelDetailSummaryCell ()


@end

@implementation HYHotelDetailSummaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _hotelNameLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, CGRectGetWidth(self.frame)-104, 44)];
        _hotelNameLab.textColor = [UIColor blackColor];
        _hotelNameLab.backgroundColor = [UIColor clearColor];
        [_hotelNameLab setFont:[UIFont systemFontOfSize:18]];
        _hotelNameLab.numberOfLines = 2;
        _hotelNameLab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_hotelNameLab];
        
        _hotelTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 262, 16)];
        _hotelTypeLab.textColor = [UIColor colorWithRed:77/255.0 green:208/255.0 blue:246/255.0 alpha:1];
        _hotelTypeLab.backgroundColor = [UIColor clearColor];
        [_hotelTypeLab setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:_hotelTypeLab];
        
        _hotelScoreLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 50, 16)];
        _hotelScoreLab.textColor = [UIColor colorWithRed:77/255.0 green:208/255.0 blue:246/255.0 alpha:1];
        _hotelScoreLab.backgroundColor = [UIColor clearColor];
        [_hotelScoreLab setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:_hotelScoreLab];
        
        _hotelReviewLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 90, 100, 16)];
        _hotelReviewLab.textColor = [UIColor blackColor];
        _hotelReviewLab.backgroundColor = [UIColor clearColor];
        [_hotelReviewLab setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:_hotelReviewLab];
        
        _hotelPicTotaLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 64, 20)];
        _hotelPicTotaLab.textColor = [UIColor whiteColor];
        _hotelPicTotaLab.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _hotelPicTotaLab.textAlignment = NSTextAlignmentRight;
        [_hotelPicTotaLab setFont:[UIFont boldSystemFontOfSize:12]];
        [_hotelPicTotaLab setHidden:YES];
        
        self.iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-64-20, 42, 64, 64);
        [_iconBtn addTarget:self
                     action:@selector(checkPictures:)
           forControlEvents:UIControlEventTouchUpInside];
        [_iconBtn setAdjustsImageWhenHighlighted:NO];
        _iconBtn.layer.cornerRadius = 2;
        _iconBtn.layer.masksToBounds = YES;
        [_iconBtn addSubview:_hotelPicTotaLab];
        [self.contentView addSubview:_iconBtn];
        
        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        
        [_hotelPicTotaLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(18);
            make.bottom.mas_equalTo(0);
        }];
        
        [_hotelNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconBtn.mas_right).offset(20);
            make.top.equalTo(_iconBtn.mas_top);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(70);
        }];
        
        [_hotelTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_hotelNameLab.mas_left);
            make.top.equalTo(_hotelNameLab.mas_bottom);
        }];
        
        [_hotelScoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_hotelTypeLab.mas_right).offset(5);
            make.top.equalTo(_hotelTypeLab.mas_top);
            make.right.mas_lessThanOrEqualTo(0);
        }];
        
        /*
        _hotelEnvironmentLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 96, 50, 16)];
        _hotelEnvironmentLab.textColor = [UIColor grayColor];
        _hotelEnvironmentLab.backgroundColor = [UIColor clearColor];
        [_hotelEnvironmentLab setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:_hotelEnvironmentLab];
        
        _hotelDeviceLab = [[UILabel alloc] initWithFrame:CGRectMake(66, 96, 50, 20)];
        _hotelDeviceLab.textColor = [UIColor grayColor];
        _hotelDeviceLab.backgroundColor = [UIColor clearColor];
        [_hotelDeviceLab setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:_hotelDeviceLab];
        
        _hotelServiceLab = [[UILabel alloc] initWithFrame:CGRectMake(120, 96, 50, 20)];
        _hotelServiceLab.textColor = [UIColor grayColor];
        _hotelServiceLab.backgroundColor = [UIColor clearColor];
        [_hotelServiceLab setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:_hotelServiceLab];
        
        _hotelHealthLab = [[UILabel alloc] initWithFrame:CGRectMake(174, 96, 50, 20)];
        _hotelHealthLab.textColor = [UIColor grayColor];
        _hotelHealthLab.backgroundColor = [UIColor clearColor];
        [_hotelHealthLab setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:_hotelHealthLab];

        //line
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(12, 86, 190, 2)];
        line.image = [UIImage imageNamed:@"line_hotel_dotted"];
        [self.contentView addSubview:line];
        
        UIImageView *assView = [[UIImageView alloc] initWithFrame:CGRectMake(212, 80, 10, 15)];
        assView.image = [UIImage imageNamed:@"ico_arrow_list"];
        [self.contentView addSubview:assView];
        
        _hotelPicTotaLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 64, 20)];
        _hotelPicTotaLab.textColor = [UIColor whiteColor];
        _hotelPicTotaLab.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _hotelPicTotaLab.textAlignment = NSTextAlignmentRight;
        [_hotelPicTotaLab setFont:[UIFont boldSystemFontOfSize:13]];
        [_hotelPicTotaLab setHidden:YES];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(12, 56, 218, 104);
        [btn addTarget:self
                     action:@selector(checkUserRating:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
         */
    }
    return self;
}

//- (UIButton *)iconBtn
//{
//    if (!_iconBtn)
//    {
//        self.iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _iconBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-64-20, 42, 64, 64);
//        [_iconBtn addTarget:self
//                     action:@selector(checkPictures:)
//           forControlEvents:UIControlEventTouchUpInside];
//        [_iconBtn setAdjustsImageWhenHighlighted:NO];
//        _iconBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//        [_iconBtn addSubview:_hotelPicTotaLab];
//        [self.contentView addSubview:_iconBtn];
//    }
//    return _iconBtn;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)checkPictures:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(checkHotelPictures)])
    {
        [self.delegate checkHotelPictures];
    }
}

- (void)checkUserRating:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(checkHotelRating)])
    {
        [self.delegate checkHotelRating];
    }
}

- (void)setHotelInfo:(HYHotelInfoDetail *)hotelInfo
{
    if (hotelInfo != _hotelInfo)
    {
        _hotelInfo = hotelInfo;
        
        self.hotelNameLab.text = hotelInfo.productName;
        
        if (hotelInfo.hotelStar)
        {
            self.hotelTypeLab.text = hotelInfo.hotelStar;
        }
        else
        {
            self.hotelTypeLab.text = hotelInfo.hotelType;
        }
        
        if (hotelInfo.score)
        {
            NSNumber *score = [NSNumber numberWithFloat:[hotelInfo.score floatValue]];
            self.hotelScoreLab.text = [NSString stringWithFormat:@"%@分", score];
        }
        
        if (hotelInfo.bigLogoUrl)
        {
            __weak typeof (self) b_self = self;
            [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:hotelInfo.bigLogoUrl]
                                    forState:UIControlStateNormal
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       [b_self.hotelPicTotaLab setHidden:NO];
                                   }];
        }
        
//        if (hotelInfo.distance > 0)
//        {
//            self.hotelReviewLab.text = [NSString stringWithFormat:@"距离您%.2f米", _hotelInfo.distance];//hotelInfo.ratingCount;
//        }
//        else
//        {
//            self.hotelReviewLab.text = nil;
//        }
        
        
        
        
        
        /*
        if (hotelInfo.RatingPosit)
        {
            self.hotelEnvironmentLab.text = [NSString stringWithFormat:@"环境 %@", hotelInfo.RatingPosit];
        }
        
        if (hotelInfo.RatingCostBenefit)
        {
            self.hotelDeviceLab.text = [NSString stringWithFormat:@"设施 %@", hotelInfo.RatingCostBenefit];
        }
        
        if (hotelInfo.RatingService)
        {
            self.hotelServiceLab.text = [NSString stringWithFormat:@"服务 %@", hotelInfo.RatingService];
        }
        
        if (hotelInfo.RatingRoom)
        {
            self.hotelHealthLab.text = [NSString stringWithFormat:@"卫生 %@", hotelInfo.RatingRoom];
        }
         */
        
        
    }
}

- (void)setPicList:(NSArray *)picList
{
    if (picList != _picList)
    {
        _picList = picList;
        self.hotelPicTotaLab.text = [NSString stringWithFormat:@"%ld张", [picList count]];
        
        if (!self.hotelInfo.bigLogoUrl && [picList count] > 0)
        {
            HYHotelPictureInfo *p = [picList objectAtIndex:0];
            __weak typeof (self) b_self = self;
            [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:p.midUrl]
                                    forState:UIControlStateNormal
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       [b_self.hotelPicTotaLab setHidden:NO];
                                   }];
        }
    }
}


@end
