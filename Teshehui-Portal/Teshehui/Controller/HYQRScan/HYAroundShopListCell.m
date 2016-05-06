//
//  HYAroundShopListCell.m
//  Teshehui
//
//  Created by HYZB on 14-7-2.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAroundShopListCell.h"
#import "HYQRCodeGetShopListResponse.h"
#import "UIImageView+WebCache.h"

@implementation HYAroundShopListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        CGRect frame = [UIScreen mainScreen].bounds;
        self.frame = CGRectMake(0, 0, frame.size.width, 71);
        
        UILabel *label = [[UILabel alloc]
                          initWithFrame:CGRectMake(5, 7, CGRectGetWidth(self.frame)-73-30, 20)];
        label.font = [UIFont systemFontOfSize:16.0];
        label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:label];
        _nameLabel = label;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-10-50, 7, 50, 10)];
        label.font = [UIFont systemFontOfSize:11.0];
        label.textColor = [UIColor colorWithWhite:.43 alpha:1];
        label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:label];
        _distanceLabel = label;
        
        UIImage *distance = [UIImage imageNamed:@"aroundMall_distance.png"];
        UIImageView *distanceIcon = [[UIImageView alloc]
                                     initWithFrame:CGRectMake(CGRectGetMinX(_distanceLabel.frame)-13,
                                                              CGRectGetMaxY
                                                              (_distanceLabel.frame)-11,
                                                              10,
                                                              12)];
        distanceIcon.image = distance;
        [self.contentView addSubview:distanceIcon];
        _distanceIcon = distanceIcon;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame),
                                                          CGRectGetMaxY(_distanceLabel.frame) + 5,
                                                          CGRectGetWidth(self.frame)-CGRectGetMaxX(_nameLabel.frame)-10,
                                                          10)];
        label.font = [UIFont systemFontOfSize:11.0];
        label.textColor = [UIColor colorWithWhite:.43 alpha:1];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:label];
        _merchantCateLabel = label;
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_nameLabel.frame)+10, CGRectGetWidth(ScreenRect)-2*10, 1)];
        sep.backgroundColor = [UIColor colorWithWhite:.93 alpha:1];
        [self.contentView addSubview:sep];
        
        
        UIImageView *photov = [[UIImageView alloc]
                               initWithFrame:CGRectMake(10, CGRectGetMaxY(sep.frame) + 5, 56, 56)];
        [self.contentView addSubview:photov];
        photov.layer.borderColor = [UIColor colorWithWhite:.73 alpha:1].CGColor;
        photov.layer.borderWidth = 1;
        self.photoView = photov;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(79, CGRectGetMaxY(sep.frame) + 5, CGRectGetWidth(self.frame) - 30 - 85, 40)];
        label.font = [UIFont systemFontOfSize:13.0];
        label.textColor = [UIColor colorWithWhite:.53 alpha:1];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        //label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:label];
        _addrLabel = label;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(79, CGRectGetMaxY(_addrLabel.frame), CGRectGetWidth(self.frame) - 30 - 85, 20)];
        label.font = [UIFont systemFontOfSize:13.0];
        label.textColor = [UIColor colorWithWhite:.53 alpha:1];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
        _onSaleTimeLabel = label;
        
        UIImage *indicator = [UIImage imageNamed:@"aroundMall_right.png"];
        UIImage *indicator_h = [UIImage imageNamed:@"aroundMall_right.png"];
        UIImageView *indicatorIcon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-20, TFScalePoint(64), 10, 17)];
        indicatorIcon.image = indicator;
        indicatorIcon.highlightedImage = indicator_h;
        [self.contentView addSubview:indicatorIcon];
        _indicatorIcon = indicatorIcon;
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        
    }
    return self;
}

- (void)setWithShop:(HYQRCodeShop *)shop
{
    _nameLabel.text = shop.store_name;
    
    if (shop.merchant_brief)
    {
        UIFont *font = _addrLabel.font;
        CGSize size = [shop.merchant_brief sizeWithFont:font constrainedToSize:CGSizeMake(_addrLabel.frame.size.width, 35)];
        _addrLabel.frame = CGRectMake(_addrLabel.frame.origin.x,
                                      _addrLabel.frame.origin.y,
                                      _addrLabel.frame.size.width,
                                      size.height);
        _addrLabel.text = shop.merchant_brief;
    } else {
        _addrLabel.frame = CGRectMake(_addrLabel.frame.origin.x,
                                      _addrLabel.frame.origin.y,
                                      _addrLabel.frame.size.width,
                                      0);
        _addrLabel.text = nil;
    }
    
    if (shop.img_url.count > 0)
    {
        NSString *url = [shop.img_url objectAtIndex:0];
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loading"]];
    }
    else
    {
        self.photoView.image = [UIImage imageNamed:@"loading"];
    }
    
    //距离显示
    NSString *distanceT;
    if (shop.distance.length > 0)
    {
        double distanceKm = [shop.distance longLongValue] / 1000.0;
        if (distanceKm > 50)
        {
            distanceT = @">50km";
        }
        else
        {
            distanceT = [NSString stringWithFormat:@"%0.2fkm", distanceKm];
        }
    }
    else
    {
        distanceT = @"距离未知";
    }
    
    _distanceLabel.text = distanceT;
    
    //营业时间
    if (shop.business_hours_end.length > 0 && shop.business_hours_start.length > 0)
    {
        NSString *onSale = [NSString stringWithFormat:@"营业时间 %@~%@",shop.business_hours_start,shop.business_hours_end];
        _onSaleTimeLabel.text = onSale;
    }
    
    //商户类型
    if (shop.merchant_cate_name.length > 0)
    {
        _merchantCateLabel.text = shop.merchant_cate_name;
    }
    else
    {
        _merchantCateLabel.text = nil;
    }
}


//- (void)drawRect:(CGRect)rect
//{
//    CGRect bounds = [UIScreen mainScreen].bounds;
//    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    CGContextMoveToPoint(ctx, 0, 10);
//    CGContextSetLineWidth(ctx, 10);
//    [[UIColor blackColor]set];
//    CGContextAddLineToPoint(ctx, 50, 10);
//    
//    CGContextStrokeRect(ctx, CGRectMake(10, 10, 10, 10));
//}

@end
