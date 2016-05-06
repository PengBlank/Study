//
//  HYEarnCashTicketButton.m
//  Teshehui
//
//  Created by HYZB on 16/4/11.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYEarnCashTicketButton.h"

@implementation HYEarnCashTicketButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *iconImgV = [[UIImageView alloc] init];
        [self addSubview:iconImgV];
        
        _descLab = [[UILabel alloc] init];
        _descLab.font = [UIFont systemFontOfSize:15];
        _descLab.textAlignment = NSTextAlignmentCenter;
        _descLab.textColor = [UIColor whiteColor];
        _descLab.backgroundColor = [UIColor colorWithWhite:0.2
                                                     alpha:0.6];
        _descLab.clipsToBounds = YES;
        [iconImgV addSubview:_descLab];
        
        _iconImgV = iconImgV;
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.textColor = [UIColor darkGrayColor];
        [self addSubview:titleLab];
        _titleLab = titleLab;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat iconAndTitleSpace = 15;
    CGFloat titleHeight = 20;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height - (iconAndTitleSpace+titleHeight);
    _iconImgV.frame = CGRectMake(0, 0, width, height);
    _descLab.frame = CGRectMake(0, 0, width, height);
    _descLab.layer.cornerRadius = width/2;
    _titleLab.frame = CGRectMake(0, CGRectGetMaxY(_iconImgV.frame)+iconAndTitleSpace, width, titleHeight);
}

#pragma mark setter/getter
- (void)setType:(HYBusinessType *)type
{
    if (type != _type)
    {
        _type = type;
        
        [self setEnabled:[type.isBusinessTypeOpen boolValue]];
        if (![type.isBusinessTypeOpen boolValue])
        {
            [_descLab setHidden:NO];
            _descLab.text = @"开发中";
        }
        else
        {
            [_descLab setHidden:YES];
        }
    }
}
@end
