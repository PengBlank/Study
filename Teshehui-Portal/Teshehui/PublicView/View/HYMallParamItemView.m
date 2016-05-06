//
//  HYMallParamItemView.m
//  Teshehui
//
//  Created by HYZB on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallParamItemView.h"

@interface HYMallParamItemView ()
{
    UILabel *_titleLab;
    UIImageView *_statusView;
}

@property (nonatomic, assign) CGSize itemSize;

@end

@implementation HYMallParamItemView

- (id)initWithFrameAndGoodsParamDescription:(CGRect)frame
                                       desc:(NSString *)desc
                                       font:(UIFont *)font
{    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _statusView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _statusView.image = [[UIImage imageNamed:@"goods_parma_bg_normal"] stretchableImageWithLeftCapWidth:4
                                                                                               topCapHeight:8];
        [self addSubview:_statusView];
        
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _titleLab.font = font;
        _titleLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _titleLab.text = desc;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark setter/getter
- (void)setIsSelected:(BOOL)isSelected
{
    if (isSelected != _isSelected)
    {
        _isSelected = isSelected;
        
        NSString *imageName = isSelected ? @"goods_parma_bg_select" : @"goods_parma_bg_normal";
        [_statusView setImage:[[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:4
                                                                                  topCapHeight:8]];
    }
}

@end
