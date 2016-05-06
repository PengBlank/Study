//
//  HYAdressTableHeadView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-14.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAdressTableHeadViewCell.h"

@implementation HYAdressTableHeadViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _imageVC = [[UIImageView alloc]initWithFrame:CGRectMake(10,12, 18,18)];
        _imageVC.image = [UIImage imageNamed:@"icon_add"];
        [self addSubview:_imageVC];
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 0,240,40)];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.font = [UIFont systemFontOfSize:16.0f];
        _nameLab.textColor = [UIColor darkGrayColor];
        _nameLab.text = @"新增收货地址";
        [self addSubview:_nameLab];
        
    }
    return self;
}
@end
