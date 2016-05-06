//
//  HYMallOrderDetailBuyerCell.m
//  Teshehui
//
//  Created by HYZB on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderDetailBuyerCell.h"

@interface HYMallOrderDetailBuyerCell ()
{
    UILabel *_zoneLab;
    UILabel *_detailAddressLab;
    UILabel *_detailAddressInfoLab;
    
    UILabel *_userLab;
    UILabel *_mobileLab;
    
    UIImageView *_bgView;
    UIImageView *_receiver;
    UIImageView *_receiverAddress;
}

@end

@implementation HYMallOrderDetailBuyerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect frame = [UIScreen mainScreen].bounds;
        
        _bgView = [UIImageView new];
        _bgView.image = [UIImage imageNamed:@"mallOrder_address"];
        _bgView.frame = CGRectMake(0, 0, frame.size.width, TFScalePoint(90));
        _bgView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:_bgView];
        
        _receiver = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mallOrder_receiver"]];
        _receiver.frame = CGRectMake(15, 20, 20, 20);
        [_bgView addSubview:_receiver];
        
        _receiverAddress = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mallOrder_AddressIcon"]];
        _receiverAddress.frame = CGRectMake(15, 50, 20, 20);
        [_bgView addSubview:_receiverAddress];
        
        _userLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, ScreenRect.size.width-180, 20)];
        _userLab.font = [UIFont systemFontOfSize:TFScalePoint(13)];
        _userLab.textColor = [UIColor blackColor];
        _userLab.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_userLab];
        
        _mobileLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenRect.size.width-140, 20, 120, 20)];
        _mobileLab.font = [UIFont systemFontOfSize:TFScalePoint(13)];
        _mobileLab.textColor = [UIColor blackColor];
        _mobileLab.backgroundColor = [UIColor clearColor];
        _mobileLab.textAlignment = NSTextAlignmentRight;
        [_bgView addSubview:_mobileLab];
        
        _detailAddressLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 50, TFScalePoint(70), 20)];
        _detailAddressLab.font = [UIFont systemFontOfSize:TFScalePoint(13)];
        _detailAddressLab.textColor = [UIColor blackColor];
        _detailAddressLab.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_detailAddressLab];
        
        _detailAddressInfoLab = [[UILabel alloc] initWithFrame:
                                 CGRectMake(CGRectGetMaxX(_detailAddressLab.frame), 45, ScreenRect.size.width-CGRectGetMaxX(_detailAddressLab.frame), 50)];
        _detailAddressInfoLab.font = [UIFont systemFontOfSize:TFScalePoint(13)];
        _detailAddressInfoLab.textColor = [UIColor blackColor];
        _detailAddressInfoLab.backgroundColor = [UIColor clearColor];
        _detailAddressInfoLab.numberOfLines = 2;
        [_bgView addSubview:_detailAddressInfoLab];
    }
    return self;
}

#pragma mark setter/getter
- (void)setAdressInfo:(HYAddressInfo *)adressInfo
{
    if (adressInfo != _adressInfo)
    {
        _adressInfo = adressInfo;
        
        _detailAddressLab.text = @"收货地址:";
        
        NSMutableString *province = [[NSMutableString alloc] init];;
        if (_adressInfo.provinceName)
        {
            [province appendString:_adressInfo.provinceName];
        }
        
        if (_adressInfo.cityName)
        {
            [province appendString:_adressInfo.cityName];
        }
        
        if (_adressInfo.regionName)
        {
            [province appendString:_adressInfo.regionName];
        }
        
        if (_adressInfo.address)
        {
            [province appendString:_adressInfo.address];
        }
        
        _detailAddressInfoLab.text = province;
        
        _userLab.text = [NSString stringWithFormat:@"收货人：  %@",
                         _adressInfo.name];
        _mobileLab.text = adressInfo.mobile;
    }
}

@end
