//
//  HYTaxiDestinationCell.m
//  Teshehui
//
//  Created by Kris on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiDestinationCell.h"

@interface HYTaxiDestinationCell ()

@end

@implementation HYTaxiDestinationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _inputTextField = [[UITextField alloc]init];
        _inputTextField.frame = TFRectMake(32, 5, 250, 40);
        _inputTextField.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_inputTextField];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.imageView.frame;
    frame.origin.y += 5;
    self.imageView.frame = frame;
}

@end
