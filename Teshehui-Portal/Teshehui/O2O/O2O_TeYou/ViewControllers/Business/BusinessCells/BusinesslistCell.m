//
//  BusinesslistCell.m
//  Teshehui
//
//  Created by apple_administrator on 15/8/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "BusinesslistCell.h"
#import "HYQRCodeGetShopListResponse.h"
#import "UIImageView+WebCache.h"
#import "BusinessListInfo.h"
#import "UIImageView+WebCache.h"
#import "UIColor+hexColor.h"
#import "DefineConfig.h"
#import "Masonry.h"
#import "UIView+Frame.h"

@implementation BusinesslistCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageV];
        
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setTextColor:[UIColor colorWithHexColor:@"272727" alpha:1]];
        [_nameLabel setFont:g_fitSystemFontSize(@[@13,@14,@15])];
        [self.contentView addSubview:_nameLabel];

        _desLabel = [[UILabel alloc] init];
        [_desLabel setFont:g_fitSystemFontSize(@[@11,@12,@13])];
        [_desLabel setNumberOfLines:2];
        [_desLabel setTextColor:[UIColor colorWithHexColor:@"434343" alpha:1]];
        [self.contentView addSubview:_desLabel];
        
        _categoryLabel = [[UILabel alloc] init];
        [_categoryLabel setFont:g_fitSystemFontSize(@[@10,@11,@12])];
        [_categoryLabel setTextColor:[UIColor colorWithHexColor:@"757575" alpha:1]];
        [self.contentView addSubview:_categoryLabel];
        
        _distanceLabel = [[UILabel alloc] init];
        [_distanceLabel setFont:g_fitSystemFontSize(@[@10,@11,@12])];
        [_distanceLabel setTextAlignment:NSTextAlignmentRight];
        [_distanceLabel setTextColor:[UIColor colorWithHexColor:@"b80000" alpha:1]];
        [self.contentView addSubview:_distanceLabel];
        
        _addressImageV = [[UIImageView alloc] init];
        [_addressImageV setImage:IMAGE(@"location")];
        [self.contentView addSubview:_addressImageV];
        
        WS(weakSelf);
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.5);
            make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(ScaleHEIGHT(74), ScaleHEIGHT(74)));
            
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imageV.mas_right).offset(10);
            make.top.mas_equalTo(_imageV.mas_top);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).mas_equalTo(-10);
        }];
        
        [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.centerY.mas_equalTo(_imageV.mas_centerY);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-10);
        }];


    }
    return self;
}

- (void)setWithShop:(BusinessListInfo *)shop{

    _nameLabel.text = shop.MerchantsName;
    _desLabel.text = shop.Strategy;
    
    if (shop.Category.length == 0) {
           _categoryLabel.text = [NSString stringWithFormat:@"                  %@",shop.Address];
    }else{
           _categoryLabel.text = [NSString stringWithFormat:@"%@   %@",shop.Category,shop.Address];
    }

    if (shop.Distance == 0) {
        [_distanceLabel setText:@"0km"];

    }else{
        [_distanceLabel setText:[NSString stringWithFormat:@"%.2fkm",shop.Distance]];;
    }
    

    CGSize tmpSize;
    tmpSize = [_distanceLabel.text sizeWithFont:g_fitSystemFontSize(@[@10,@11,@12]) constrainedToSize:CGSizeMake(kScreen_Width/2 , 100000)];
    [_distanceLabel setFrame:CGRectMake(kScreen_Width - tmpSize.width - 10,  ScaleHEIGHT(94) - 15 - ((ScaleHEIGHT(94) - ScaleHEIGHT(74))/2), tmpSize.width, 15)];
    
    [_addressImageV setFrame:CGRectMake(_distanceLabel.x - 16, 0, _addressImageV.image.size.width, _addressImageV.image.size.height)];
    [_addressImageV setCenterY:_distanceLabel.centerY];
    
    
    [_categoryLabel setFrame:CGRectMake(ScaleHEIGHT(74) + 22.5, 0,kScreen_Width - ScaleHEIGHT(74) - _addressImageV.width - _distanceLabel.width - 30 , 15)];
    [_categoryLabel setCenterY:_distanceLabel.centerY];
    
    NSString *url = [NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",shop.Logo];
    DebugNSLog(@"实体店列表：%@",url);
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loading"]];
    
}

@end
