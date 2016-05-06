//
//  MapViewCell.m
//  Teshehui
//
//  Created by apple_administrator on 16/3/3.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "MapViewCell.h"
#import "HYQRCodeGetShopListResponse.h"
#import "UIImageView+WebCache.h"
#import "BusinessListInfo.h"
#import "UIImageView+WebCache.h"
#import "UIColor+hexColor.h"
#import "DefineConfig.h"
#import "Masonry.h"
#import "UIView+Frame.h"
@implementation MapViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageV];
        
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setTextColor:[UIColor colorWithHexColor:@"272727" alpha:1]];
        [_nameLabel setFont:[UIFont systemFontOfSize:16]];
        [self.contentView addSubview:_nameLabel];
        
        _desLabel = [[UILabel alloc] init];
        [_desLabel setFont:[UIFont systemFontOfSize:15]];
        [_desLabel setNumberOfLines:2];
        [_desLabel setTextColor:[UIColor colorWithHexColor:@"434343" alpha:1]];
        [self.contentView addSubview:_desLabel];
        
        _categoryLabel = [[UILabel alloc] init];
        [_categoryLabel setFont:[UIFont systemFontOfSize:15]];
        [_categoryLabel setTextColor:[UIColor colorWithHexColor:@"919191" alpha:1]];
        [self.contentView addSubview:_categoryLabel];
        
        _distanceLabel = [[UILabel alloc] init];
        [_distanceLabel setFont:[UIFont systemFontOfSize:14]];
        [_distanceLabel setTextAlignment:NSTextAlignmentRight];
        [_distanceLabel setTextColor:[UIColor colorWithHexColor:@"b80000" alpha:1]];
        [self.contentView addSubview:_distanceLabel];
        
        _addressImageV = [[UIImageView alloc] init];
        [_addressImageV setImage:IMAGE(@"location")];
        [self.contentView addSubview:_addressImageV];
        
        WS(weakSelf);
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(g_fitFloat(@[@5,@5,@10]));
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(g_fitFloat(@[@5,@5,@10]));
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-g_fitFloat(@[@5,@5,@10]));
            make.width.mas_equalTo(_imageV.mas_height);
            
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

- (void)setWithShopToMapView:(BusinessListInfo *)shop{
    
    
    [_nameLabel setFont:[UIFont systemFontOfSize:g_fitFloat(@[@12,@13,@13])]];
    [_desLabel setFont:[UIFont systemFontOfSize:g_fitFloat(@[@11,@12,@12])]];
    
    [_categoryLabel setFont:[UIFont systemFontOfSize:g_fitFloat(@[@12,@13,@13])]];
    [_distanceLabel setFont:[UIFont systemFontOfSize:g_fitFloat(@[@12,@13,@13])]];
    
    
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
        [_distanceLabel setText:[NSString stringWithFormat:@"%.2fkm",shop.Distance]];
    }
    
   
    CGSize tmpSize;
    tmpSize = [_distanceLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kScreen_Width/2 , 100000)];
    [_distanceLabel setFrame:CGRectMake(kScreen_Width - tmpSize.width - 10,  g_fitFloat(@[@64.5,@75.5,@83.5]) - g_fitFloat(@[@20,@22.5,@30]), tmpSize.width, 20)];
    
    [_addressImageV setFrame:CGRectMake(_distanceLabel.x - 16, 0, _addressImageV.image.size.width, _addressImageV.image.size.height)];
    [_addressImageV setCenterY:_distanceLabel.centerY];
    
    
    [_categoryLabel setFrame:CGRectMake(g_fitFloat(@[@69.5,@80.5,@83.5]), 0,kScreen_Width - g_fitFloat(@[@64.5,@75.5,@83.5]) - _addressImageV.width - _distanceLabel.width - 16 , 20)];
    [_categoryLabel setCenterY:_distanceLabel.centerY];
    
    NSString *url = [NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",shop.Logo];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loading"]];
}


@end
