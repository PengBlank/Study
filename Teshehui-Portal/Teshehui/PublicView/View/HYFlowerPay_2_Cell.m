//
//  HYFlowerPay_2_Cell.m
//  Teshehui
//
//  Created by ichina on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerPay_2_Cell.h"

@implementation HYFlowerPay_2_Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 280, 20)];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_nameLab];

    }
    return self;
}

-(void)setList:(NSString *)payType
{
    _nameLab.text = [NSString stringWithFormat:@"使用%@支付",payType];
}
@end
