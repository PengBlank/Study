//
//  HYFlowerSummaryCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-4-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerSummaryCell.h"
#import "UIImageView+WebCache.h"

@interface HYFlowerSummaryCell ()

@property (nonatomic, strong) UIImageView* headImg;
@property (nonatomic, strong) UILabel* nameLab;
@property (nonatomic, strong) UILabel* priceLab;
@property (nonatomic, strong) UILabel* pointsLab;
@property (nonatomic, strong) UILabel* muchLab;
@property (nonatomic, strong) UILabel* moneyLab;
@property (nonatomic, strong) UILabel* yfLab;
@property (nonatomic, strong) UILabel* pointLab;
@end

@implementation HYFlowerSummaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
        _headImg.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_headImg];
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 10,CGRectGetWidth(self.frame)-110, 20)];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.textColor = [UIColor darkTextColor];
        _nameLab.font = [UIFont systemFontOfSize:14.0f];
        _nameLab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_nameLab];
        
        _muchLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 30,CGRectGetWidth(self.frame)-110, 20)];
        _muchLab.backgroundColor = [UIColor clearColor];
        _muchLab.textColor = [UIColor darkTextColor];
        _muchLab.font = [UIFont systemFontOfSize:14.0f];
        _muchLab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview: _muchLab];
        
        _priceLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 50,CGRectGetWidth(self.frame)-110, 20)];
        _priceLab.backgroundColor = [UIColor clearColor];
        _priceLab.textColor = [UIColor darkTextColor];
        _priceLab.font = [UIFont systemFontOfSize:14.0f];
        _priceLab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:  _priceLab];
        
        _pointsLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 70, CGRectGetWidth(self.frame)-110, 20)];
        _pointsLab.backgroundColor = [UIColor clearColor];
        _pointsLab.textColor = [UIColor darkTextColor];
        _pointsLab.font = [UIFont systemFontOfSize:14.0f];
        _pointsLab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_pointsLab];
        
        UILabel* spLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 95, 100, 20)];
        spLab.backgroundColor = [UIColor clearColor];
        spLab.text = @"商品总金额:";
        spLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:spLab];
        
        _moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-190, 95, 180, 20)];
        _moneyLab.textAlignment = NSTextAlignmentRight;
        _moneyLab.backgroundColor = [UIColor clearColor];
        _moneyLab.font = [UIFont systemFontOfSize:14.0f];
        _moneyLab.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_moneyLab];
        
        UILabel* yfLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 115, 100, 20)];
        yfLab.backgroundColor = [UIColor clearColor];
        yfLab.text = @"运费:";
        yfLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:yfLab];
        
        _yfLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-190, 115, 180, 20)];
        _yfLab.textAlignment = NSTextAlignmentRight;
        _yfLab.backgroundColor = [UIColor clearColor];
        _yfLab.font = [UIFont systemFontOfSize:14.0f];
        _yfLab.text = @"包邮";
        _yfLab.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview: _yfLab];
        
        UILabel* ptLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 135, 100, 20)];
        ptLab.backgroundColor = [UIColor clearColor];
        ptLab.text = @"赠送总现金券:";
        ptLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:ptLab];
        
        _pointLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-190, 135, 180, 20)];
        _pointLab.textAlignment = NSTextAlignmentRight;
        _pointLab.backgroundColor = [UIColor clearColor];
        _pointLab.textColor = [UIColor redColor];
        _pointLab.font = [UIFont systemFontOfSize:14.0f];
        _pointLab.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview: _pointLab];
    }
    return self;
}

#pragma mark setter/getter
- (void)setFlowerInfo:(HYFlowerDetailInfo *)flowerInfo
{
    if (_flowerInfo != flowerInfo)
    {
        _flowerInfo = flowerInfo;
        
        NSString *img = nil;
        if (flowerInfo.midImgList.count > 0)
        {
            img = [flowerInfo.midImgList objectAtIndex:0];
            [_headImg sd_setImageWithURL:[NSURL URLWithString:img]
                        placeholderImage:[UIImage imageNamed:@"loading"]];
        }
        else
        {
            _headImg.image = [UIImage imageNamed:@"loading"];
        }
        
        _nameLab.text = [NSString stringWithFormat:@"名称:%@",flowerInfo.productName];
        _priceLab.text = [NSString stringWithFormat:@"价格:%0.2f",flowerInfo.price.floatValue];
        _pointsLab.text = [NSString stringWithFormat:@"赠送现金券:%ld",flowerInfo.points.integerValue];
        
        CGFloat totalprice = flowerInfo.price.floatValue * self.total;
        NSInteger totalpoint = flowerInfo.points.integerValue * self.total;
        _moneyLab.text = [NSString stringWithFormat:@"%.02f",totalprice];
        _pointLab.text = [NSString stringWithFormat:@"%ld",totalpoint];
    }
}

- (void)setTotal:(NSInteger)total
{
    if (total != _total)
    {
        _total = total;
        _muchLab.text = [NSString stringWithFormat:@"数量:%ld",total];
        CGFloat totalprice = self.flowerInfo.price.floatValue * self.total;
        NSInteger totalpoint = self.flowerInfo.points.integerValue * self.total;
        _moneyLab.text = [NSString stringWithFormat:@"%.02f",totalprice];
        _pointLab.text = [NSString stringWithFormat:@"%ld",totalpoint];
    }
}

@end
