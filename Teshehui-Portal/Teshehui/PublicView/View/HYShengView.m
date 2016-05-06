//
//  HYShengView.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYShengView.h"
#import "UIImage+Addition.h"

static NSMutableDictionary *__shengImageCache = nil;

@implementation HYShengView

//left -> 57:72, 29:72
//right-> 52:41,


- (instancetype)initWithDirection:(HYShengDirection)direction height:(CGFloat)height
{
    if (self=  [super init])
    {
        UIImage *sheng = nil;
        _direction = direction;
        
        _height = height;
        self.frame = CGRectMake(0, 0, 0, height);
        
        if (direction == HYShengRight)
        {
            sheng = [UIImage imageNamed:@"icon_sheng2"];
            CGFloat widthSclaed = height / sheng.size.height * sheng.size.width;
            sheng = [sheng imageWithSize:CGSizeMake(widthSclaed, height)];
            _left = 57/72.0 * height;
            _right = 29/72.0 * height;
            sheng = [sheng resizableImageWithCapInsets:UIEdgeInsetsMake(0, _left, 0, _right) resizingMode:UIImageResizingModeStretch];
        }
        else
        {
            sheng = [UIImage imageNamed:@"sheng_sheng"];
            CGFloat widthSclaed = height / sheng.size.height * sheng.size.width;
            sheng = [sheng imageWithSize:CGSizeMake(widthSclaed, height)];
            _left = 54/41.0 * height;
            _right = 1 / 41.0 * height;
            sheng = [sheng resizableImageWithCapInsets:UIEdgeInsetsMake(0, _left, 0, _right) resizingMode:UIImageResizingModeStretch];
        }
        _shengView = [[UIImageView alloc] initWithImage:sheng];
        _shengView.frame = self.bounds;
        [self addSubview:_shengView];
        
        _shengLab = [[UILabel alloc] initWithFrame:self.bounds];
        _shengLab.backgroundColor = [UIColor clearColor];
        _shengLab.textColor = [UIColor colorWithRed:1/255.0 green:123/255.0 blue:225/255.0 alpha:1];
        _shengLab.font = [UIFont boldSystemFontOfSize:_height*0.6];
        [self addSubview:_shengLab];
    }
    return self;
}

- (void)setPoint:(CGPoint)point maxWidth:(CGFloat)width
{
    _maxWidth = width;
    CGRect frame;
    if (_direction == HYShengRight)
    {
        frame = CGRectMake(point.x, point.y, _left+_right, _height);
    }
    else
    {
        frame = CGRectMake(point.x-_left-_right, point.y, _left+_right, _height);
    }
    self.frame = frame;
}


- (void)setSheng:(NSString *)sheng
{
    if (_sheng != sheng)
    {
        _sheng = sheng;
        CGSize size = [_sheng sizeWithAttributes:@{NSFontAttributeName: _shengLab.font}];
        size.width = MIN(size.width, _maxWidth-_left-_right);
        if (_direction == HYShengRight)
        {
            _shengView.frame = CGRectMake(0, 0, size.width+_left+_right, _height);
            _shengLab.frame = CGRectMake(_left, 0, size.width, _height);
        }
        else
        {
            _shengView.frame = CGRectMake(CGRectGetMaxX(self.bounds)-size.width-_left-_right, 0, size.width+_left+_right, _height);
            _shengLab.frame = CGRectMake(CGRectGetMinX(_shengView.frame)+_left, 0, size.width, _height);
        }
        _shengLab.text = _sheng;
    }
}

//- (NSMutableDictionary *)cache
//{
//    if (!__shengImageCache)
//    {
//        __shengImageCache = [NSMutableDictionary dictionary];
//    }
//    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
