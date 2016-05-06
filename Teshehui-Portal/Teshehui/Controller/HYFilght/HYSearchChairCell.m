//
//  HYSearchChairCell.m
//  Teshehui
//
//  Created by Kris on 15/9/21.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYSearchChairCell.h"

@interface HYSearchChairCell ()
{
    UIImageView *_chairImgView;
    
    UILabel *_chairLab;
}

@end

@implementation HYSearchChairCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIImage *image = [UIImage imageNamed:@"fightSearch_chair"];
        _chairImgView = [[UIImageView alloc]initWithImage:image];
        _chairImgView.frame = TFRectMake(15, 5, 12, 12);
        [self.contentView addSubview:_chairImgView];
        
        _chairLab = [UILabel new];
        _chairLab.frame = TFRectMake(30, 5, 50, 10);
        _chairLab.text = @"选择舱位";
        _chairLab.font = [UIFont systemFontOfSize:TFScalePoint(11)];
        _chairLab.textColor = [UIColor grayColor];
        [self.contentView addSubview:_chairLab];
        
        _mainTextLab = [UILabel new];
        _mainTextLab.frame =TFRectMake(15, 40, 120, 18);
        [self.contentView addSubview:_mainTextLab];
        
    }
    return self;
}

@end
