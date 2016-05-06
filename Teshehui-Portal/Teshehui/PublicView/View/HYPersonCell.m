//
//  HYPersonCell.m
//  Teshehui
//
//  Created by ichina on 14-3-3.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYPersonCell.h"

@implementation HYPersonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.font = [UIFont systemFontOfSize:16.0f];
        self.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0f];
        
        _NameLab = [[UILabel alloc]initWithFrame:CGRectMake(25,5,80, 40)];
        _NameLab.backgroundColor = [UIColor clearColor];
        _NameLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0f];
        _NameLab.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:_NameLab];
        
        _VauleLab = [[UITextField alloc]initWithFrame:CGRectMake(110,5,200, 40)];
        _VauleLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0f];
        _VauleLab.backgroundColor = [UIColor clearColor];
        _VauleLab.font = [UIFont systemFontOfSize:16.0f];
        _VauleLab.userInteractionEnabled = NO;
        _VauleLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_VauleLab];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x += 13;
    self.textLabel.frame = frame;
    
    _NameLab.frame = CGRectMake(25, 0, 80, self.frame.size.height);
    _VauleLab.frame = CGRectMake(CGRectGetMaxX(_NameLab.frame), 0, self.frame.size.width-CGRectGetMaxX(_NameLab.frame)-15, self.frame.size.height);
}

@end
