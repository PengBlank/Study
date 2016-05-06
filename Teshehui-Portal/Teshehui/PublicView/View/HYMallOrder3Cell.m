//
//  HYMallOrder3Cell.m
//  Teshehui
//
//  Created by ichina on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrder3Cell.h"

@implementation HYMallOrder3Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _NameLab = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 200,20)];
        _NameLab.text = @"查看商品清单";
        _NameLab.backgroundColor = [UIColor clearColor];
        _NameLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_NameLab];
        
        UIImage *arrIcon = [UIImage imageNamed:@"icon_arrow"];
        UIImageView *arrView1 = [[UIImageView alloc] initWithFrame:CGRectMake(278, 15, 10, 10)];
        arrView1.image = arrIcon;
        [self.contentView addSubview:arrView1];
    }
    return self;
}


@end
