//
//  HYFolwerBigTypeCell.m
//  Teshehui
//
//  Created by ichina on 14-2-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFolwerBigTypeCell.h"

@implementation HYFolwerBigTypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        _NameLab = [[UILabel alloc]initWithFrame:CGRectMake(70, 0,180,50)];
        _NameLab.backgroundColor = [UIColor clearColor];
        _NameLab.textColor = [UIColor darkTextColor];
        _NameLab.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:_NameLab];
        
        UIImageView* RightVC = [[UIImageView alloc]initWithFrame:CGRectMake(250,18, 12,12)];
        RightVC.backgroundColor = [UIColor clearColor];
        RightVC.image = [UIImage imageNamed:@"icon_class_right"];
        [self.contentView addSubview:RightVC];
    }
    return self;
}

- (void)setCellData:(HYFlowerTypeInfo *)data
{
    self.NameLab.text = data.categoryName;
}

@end
