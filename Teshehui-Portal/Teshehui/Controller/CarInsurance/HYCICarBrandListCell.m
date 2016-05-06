//
//  HYCICarBrandListCell.m
//  Teshehui
//
//  Created by HYZB on 15/7/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCICarBrandListCell.h"

@implementation HYCICarBrandListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.textLabel.font = [UIFont systemFontOfSize:15.0];
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 3;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(16, 2, CGRectGetWidth(self.frame)-16, 40);
}


- (void)setTypeInfo:(HYCICarBrandInfo *)typeInfo
{
    if (typeInfo != _typeInfo)
    {
        _typeInfo = typeInfo;
        
        self.textLabel.text = typeInfo.typeDescription;
    }
}

@end
