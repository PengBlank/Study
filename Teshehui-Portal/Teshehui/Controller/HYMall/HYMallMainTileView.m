//
//  HYMallMainTileView.m
//  Teshehui
//
//  Created by HYZB on 15/7/16.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallMainTileView.h"

@implementation HYMallMainTileView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1,
                                                                   1,
                                                                   frame.size.width-2,
                                                                   frame.size.height-36)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        _descLab = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                             frame.size.height-36,
                                                             frame.size.width,
                                                             16)];
        _descLab.backgroundColor = [UIColor clearColor];
        _descLab.font = [UIFont systemFontOfSize:12];
        _descLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        _descLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_descLab];
        
        
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                              frame.size.height-20,
                                                              frame.size.width,
                                                              16)];
        _priceLab.backgroundColor = [UIColor clearColor];
        _priceLab.font = [UIFont systemFontOfSize:12];
        _priceLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        _priceLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_priceLab];
    }
    
    return self;
}

@end
