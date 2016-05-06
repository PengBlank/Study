//
//  HYMallGoodSXCell.m
//  Teshehui
//
//  Created by ichina on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallGoodSXCell.h"

@implementation HYMallGoodSXCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(14, 17.5, 15, 15)];
        _headImg.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_headImg];
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 17, 200, 16)];
        _nameLab.textColor = [UIColor darkTextColor];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_nameLab];
    }
    return self;
}

@end
