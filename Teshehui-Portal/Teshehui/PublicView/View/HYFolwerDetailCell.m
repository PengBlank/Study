//
//  HYFolwerDetailCell.m
//  Teshehui
//
//  Created by ichina on 14-2-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFolwerDetailCell.h"
#import "UIImageView+WebCache.h"

@implementation HYFolwerDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
        CGFloat width = ScreenRect.size.width;
        
        _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10,10,100,100)];
        _headImg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_headImg];
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(132.5, 17.5, 100, 16)];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.textColor = [UIColor colorWithRed:16.0/255.0
                                             green:16.0/255.0
                                              blue:16.0/255.0
                                             alpha:1.0];
        _nameLab.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:_nameLab];
        
        _moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nameLab.frame), 14.5, width-CGRectGetMaxX(_nameLab.frame), 20)];
        _moneyLab.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                                    green:86.0/255.0
                                                     blue:101.0/255.0
                                                    alpha:1.0];
        _moneyLab.textColor = [UIColor whiteColor];
        _moneyLab.textAlignment = NSTextAlignmentCenter;
        _moneyLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_moneyLab];
        
        _desLab = [[UILabel alloc]initWithFrame:CGRectMake(132.5,30,width-132.5,60)];
        _desLab.numberOfLines = 4;
        _desLab.backgroundColor = [UIColor clearColor];
        _desLab.textColor = [UIColor colorWithRed:116.0/255.0
                                            green:114.0/255.0
                                             blue:114.0/255.0
                                            alpha:1.0];
        _desLab.font = [UIFont systemFontOfSize:10.0f];
        [self.contentView addSubview:_desLab];
        
        _pointLab = [[UILabel alloc]initWithFrame:CGRectMake(122.5, 90, width-122.5, 16)];
        _pointLab.backgroundColor = [UIColor colorWithRed:246.0/255.0
                                                    green:248.0/255.0
                                                     blue:242.0/255.0
                                                    alpha:1.0];
        _pointLab.textColor = [UIColor colorWithRed:47.0/255.0
                                              green:46.0/255.0
                                               blue:46.0/255.0
                                              alpha:1.0];
        _pointLab.font = [UIFont systemFontOfSize:8.0f];
        _pointLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_pointLab];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_headImg setFrame:CGRectMake(10,10,100,100)];
    _nameLab.frame = CGRectMake(132.5, 15.5, CGRectGetWidth(self.frame)-132.5-70, 16);
    _moneyLab.frame = CGRectMake(CGRectGetMaxX(_nameLab.frame), 14.5, 70, 16);
    _desLab.frame = CGRectMake(132.5,38,CGRectGetWidth(self.frame)-142.5,56);
    _pointLab.frame = CGRectMake(122.5, 98, CGRectGetWidth(self.frame)-132.5, 16);
}

#pragma mark setter/getter
- (void)setFlowerData:(HYFlowerListSummary *)flowerData
{
    if (flowerData != _flowerData)
    {
        _flowerData = flowerData;
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:flowerData.productPicUrl]
                        placeholderImage:[UIImage imageNamed:@"loading"]];
        self.nameLab.text = flowerData.productName;
        self.moneyLab.text = [NSString stringWithFormat:@"¥%@", flowerData.price];
        self.desLab.text = flowerData.flowerLanguage;
        self.pointLab.text = [NSString stringWithFormat:@"    赠送现金券:%ld",flowerData.points];
    }
}

/*
- (void)setCellData:(HYFlowerDetailInfo *)data
{
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:@"http://portal.flower.teshehui.com/v2/phpThumb/phpThumb.php?src=http://image.wodinghua.com//behindImg/goods/2015/02/02/1181aeef811/1181aeef811.jpg&w=240&hash=14550475c534b8313eb15256317397de"]
                    placeholderImage:[UIImage imageNamed:@"loading"]];
    self.nameLab.text = data.product_name;
    self.moneyLab.text = [NSString stringWithFormat:@"¥%0.2f", data.weekday_price];
    self.desLab.text = data.desc;
    self.pointLab.text = [NSString stringWithFormat:@"    赠送现金券:%d",data.points];
}
 */

-(void)setCellData:(NSString *)headImg
           andName:(NSString *)name
          andMoney:(NSString *)money
            andDss:(NSString *)dic
          andPoint:(NSString *)point
           andMuch:(NSString*)much
{
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:headImg]
                 placeholderImage:[UIImage imageNamed:@"loading"]];
    self.nameLab.text = name;
    self.moneyLab.text = [NSString stringWithFormat:@"¥%@",money];
    self.desLab.text = dic;
    self.pointLab.text = [NSString stringWithFormat:@"    赠送现金券:%d",[point intValue]];
}
@end
