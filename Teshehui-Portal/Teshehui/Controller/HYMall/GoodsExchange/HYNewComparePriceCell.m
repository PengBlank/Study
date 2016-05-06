//
//  HYNewComparePriceCell.m
//  Teshehui
//
//  Created by Kris on 16/2/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYNewComparePriceCell.h"
#import "Masonry.h"

@interface HYNewComparePriceCell ()
{
    UILabel *_platFromLab;
    UILabel *_priceLab;
}

@end

@implementation HYNewComparePriceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _platFromLab = [[UILabel alloc]init];
        _platFromLab.frame = CGRectMake(10, 10, 80, 20);
        _platFromLab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_platFromLab];
        
        _priceLab = [[UILabel alloc]init];
        _priceLab.textColor = [UIColor orangeColor];
        _priceLab.frame = CGRectMake(CGRectGetMaxX(_platFromLab.frame)+6, 10, TFScalePoint(180), 20);
        _priceLab.textAlignment = NSTextAlignmentLeft;
        _priceLab.text = @"——";
        _priceLab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_priceLab];
    }
    return self;
}

- (void)setPlatFromPriceData:(HYProductSKUWebPriceArrayModel *)data
{
    _platFromLab.text = data.typeName;
    
    if (data.price.length > 0)
    {
        NSString *price = data.price;
        if (data.price.length > 4)
        {
           price = [data.price substringWithRange:NSMakeRange(0, 4)];
        }
       _priceLab.text = [NSString stringWithFormat:@"￥%@/点击查看",price];
    }
    else
    {
       _priceLab.text = @"点击查看";
    }
}

@end
