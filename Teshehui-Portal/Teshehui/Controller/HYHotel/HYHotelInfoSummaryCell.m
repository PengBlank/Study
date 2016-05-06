//
//  HYHotelInfoSummaryCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/29.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYHotelInfoSummaryCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface HYHotelInfoSummaryCell ()

@property (nonatomic, strong) UIImageView *summaryImage;
@property (nonatomic, strong) UILabel *summaryLabel;

@end

@implementation HYHotelInfoSummaryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIImageView *sumImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        sumImg.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:sumImg];
        self.summaryImage = sumImg;
        
        UILabel *sumLab = [[UILabel alloc] initWithFrame:CGRectZero];
        sumLab.font = [UIFont boldSystemFontOfSize:18.0];
        sumLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:sumLab];
        self.summaryLabel = sumLab;
        
        //layout
        [sumImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [sumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sumImg.mas_right).offset(16);
            make.right.mas_equalTo(-12);
            make.centerY.equalTo(sumImg.mas_centerY);
        }];
    }
    return self;
}

- (void)setHotelInfo:(HYHotelInfoDetail *)hotelInfo
{
    if (_hotelInfo != hotelInfo)
    {
        _hotelInfo = hotelInfo;
        [self.summaryImage sd_setImageWithURL:[NSURL URLWithString:_hotelInfo.smallLogoUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
        self.summaryLabel.text = [NSString stringWithFormat:@"%@设施", _hotelInfo.productName];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
