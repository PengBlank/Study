//
//  HYRedpacketNullView.m
//  Teshehui
//
//  Created by HYZB on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRedpacketNullView.h"
#import "UIImage+Addition.h"

@implementation HYRedpacketNullView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:TFRectMake(67, 10, 149, 158)];
        imageview.image = [UIImage imageNamed:@"t_jilu_duang"];
        [self addSubview:imageview];
        
        _descLab = [[UILabel alloc] initWithFrame:CGRectMake(0, TFScalePoint(170), TFScalePoint(280), TFScalePoint(40))];
        _descLab.textColor = [UIColor grayColor];
        _descLab.backgroundColor = [UIColor clearColor];
        _descLab.textAlignment = NSTextAlignmentCenter;
        _descLab.lineBreakMode = NSLineBreakByCharWrapping;
        _descLab.numberOfLines = 0;
        _descLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:_descLab];
    }
    
    return self;
}

@end
