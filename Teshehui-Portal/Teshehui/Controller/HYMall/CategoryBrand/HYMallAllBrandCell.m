//
//  HYMallAllBrandCell.m
//  Teshehui
//
//  Created by Kris on 16/3/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallAllBrandCell.h"

@interface HYMallAllBrandCell ()

@property (nonatomic, strong) HYMallAllBrandModel *data;

@end

@implementation HYMallAllBrandCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.textLabel.textColor = [UIColor darkGrayColor];
    }
    return self;
}

-(void)setData:(HYMallAllBrandModel *)data
{
    _data = data;
    
    if (_data.brandName.length > 0)
    {
        self.textLabel.text = _data.brandName;
    }
}

@end
