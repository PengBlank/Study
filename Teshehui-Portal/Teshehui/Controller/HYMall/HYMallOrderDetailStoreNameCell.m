//
//  HYMallOrderDetailStoreNameCell.m
//  Teshehui
//
//  Created by Kris on 15/10/6.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallOrderDetailStoreNameCell.h"

@interface HYMallOrderDetailStoreNameCell ()
{
    UIImageView *_storeIcon;
}

@end

@implementation HYMallOrderDetailStoreNameCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        _storeIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mallOrder_shop"]];
        _storeIcon.frame = CGRectMake(10, 8, 18, 15);
        [self.contentView addSubview:_storeIcon];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(35, 10, 230, 10);
}

@end
