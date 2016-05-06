//
//  HYPicDetailCell.m
//  Teshehui
//
//  Created by ichina on 14-2-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFolwerPicDetailCell.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@implementation HYFolwerPicDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(14, 17.5, 15, 15)];
        _headImg.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_headImg];
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 17, 200,16)];
        _nameLab.textColor = [UIColor grayColor];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_nameLab];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
