//
//  HYMallOrderAddressCell.m
//  Teshehui
//
//  Created by HYZB on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderAddressCell.h"

@interface HYMallOrderAddressCell ()
{
    UILabel *_zoneLab;
    UILabel *_detailAddressLab;
    UILabel *_userLab;
}

@end

@implementation HYMallOrderAddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        self.textLabel.text = @"收货信息：";
        
        _zoneLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 34, 280, 20)];
        _zoneLab.font = [UIFont systemFontOfSize:13];
        _zoneLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _zoneLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_zoneLab];
        
        _detailAddressLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 56, 280, 20)];
        _detailAddressLab.font = [UIFont systemFontOfSize:13];
        _detailAddressLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _detailAddressLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_detailAddressLab];
        
        _userLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 76, 280, 20)];
        _userLab.font = [UIFont systemFontOfSize:13];
        _userLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _userLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_userLab];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(10, 12, 110, 20);
}

#pragma mark setter/getter
- (void)setAdressInfo:(HYAddressInfo *)adressInfo
{
    if (adressInfo != _adressInfo)
    {
        _adressInfo = adressInfo;
        _zoneLab.text = [_adressInfo fullRegion];
        _detailAddressLab.text = _adressInfo.address;
        
        NSString *userinfo = [NSString stringWithFormat:@"%@   %@", adressInfo.consignee, adressInfo.phoneMobile];
        _userLab.text = userinfo;
    }
}

@end
