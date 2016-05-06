//
//  HYMerchantCategoryCell.m
//  Teshehui
//
//  Created by Kris on 15/7/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMerchantCategoryCell.h"
#import "UIColor+hexColor.h"

@interface HYMerchantCategoryCell ()

@end

@implementation HYMerchantCategoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
//        CGRect bounds = self.contentView.bounds;
        UILabel *merchantCountLabel = [[UILabel alloc]initWithFrame:
                                  CGRectMake(180, 10, 20, 20)];
        merchantCountLabel.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:merchantCountLabel];
        self.merchantCountLabel = merchantCountLabel;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(10, 0,
                                      135,
                                      CGRectGetHeight(self.frame));
    self.merchantCountLabel.frame = CGRectMake(150, 0, 20, CGRectGetHeight(self.frame));
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected)
    {
        self.textLabel.textColor = [UIColor colorWithRed:170/255.0 green:40/255.0 blue:45/255.0 alpha:1.0];
        self.contentView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    }else
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.textLabel.textColor = [UIColor colorWithHexColor:@"666666" alpha:1.0];
    }
}
@end
