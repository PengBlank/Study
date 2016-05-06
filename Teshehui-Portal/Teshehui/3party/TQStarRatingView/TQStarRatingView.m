//
//  TQStarRatingView.m
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import "TQStarRatingView.h"
#import "UIView+GetImage.h"

@interface TQStarRatingView ()

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@end

@implementation TQStarRatingView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithStar:[UIImage imageNamed:@"star_list_n"]
                hilightedStar:[UIImage imageNamed:@"star_list_h"]
                 numberOfStar:5
            spaceOfStar:1];
}

- (instancetype)initWithStar:(UIImage *)star hilightedStar:(UIImage *)hStar numberOfStar:(NSInteger)number spaceOfStar:(CGFloat)space
{
    if (self = [super initWithFrame:CGRectZero])
    {
        _starImage = star;
        _starHilightedImage = hStar;
        _numberOfStar = number;
        _space = space;
        _fraction = NO;
        
        [self buildBackground];
        [self buildForeground];
    }
    return self;
}

- (void)buildBackground
{
    if (_starBackgroundView) {
        [_starBackgroundView removeFromSuperview];
    }
    self.starBackgroundView = [self buidlStarViewWithImage:_starImage];
    [self insertSubview:_starBackgroundView atIndex:0];
}

- (void)buildForeground
{
    if (_starForegroundView) {
        [_starForegroundView removeFromSuperview];
    }
    UIView *foreground = [self buidlStarViewWithImage:_starHilightedImage];
    UIView *foregroundWrapper = [[UIView alloc] initWithFrame:foreground.bounds];
    [foregroundWrapper addSubview:foreground];
    foregroundWrapper.clipsToBounds = YES;
    self.starForegroundView = foregroundWrapper;
    
    
    [self addSubview:_starForegroundView];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.starBackgroundView.frame = self.bounds;
    self.starForegroundView.frame = self.bounds;
    for (UIView *vi in _starForegroundView.subviews) {
        vi.frame = self.bounds;
    }
    
    CGFloat rating = _rating;
    _rating = 0;
    [self setRating:rating];
}

- (void)setStarImage:(UIImage *)starImage
{
    if (_starImage != starImage)
    {
        _starImage = starImage;
        [self buildBackground];
    }
}

- (void)setSpace:(CGFloat)space
{
    if (_space != space)
    {
        [self buildBackground];
        [self buildForeground];
    }
}

- (void)setStarHilightedImage:(UIImage *)starHilightedImage
{
    if (_starHilightedImage != starHilightedImage)
    {
        _starHilightedImage = starHilightedImage;
        [self buildForeground];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point))
    {
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //__weak TQStarRatingView * weekSelf = self;
    [self changeStarForegroundViewWithPoint:point];
    
//    [UIView transitionWithView:self.starForegroundView
//                      duration:0.2
//                       options:UIViewAnimationOptionCurveEaseInOut
//                    animations:^
//     {
//         [weekSelf changeStarForegroundViewWithPoint:point];
//     }
//                    completion:^(BOOL finished)
//     {
//    
//     }];
}

- (UIView *)buidlStarViewWithImage:(UIImage *)img
{
    CGFloat width = img.size.width*_numberOfStar + (_numberOfStar-1)*_space;
    CGRect frame = CGRectMake(0, 0, width, img.size.height);
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    CGFloat x = 0;
    for (int i = 0; i < self.numberOfStar; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
        imageView.frame = CGRectMake(x, 0, img.size.width, img.size.height);
        [view addSubview:imageView];
        
        x += self.space + img.size.width;
    }
    UIImage *image = [view getImage];
    UIImageView *ret = [[UIImageView alloc] initWithImage:image];
    return ret;
}


- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    CGPoint p = point;
    
    if (p.x < 0)
    {
        p.x = 0;
    }
    else if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }
    
    CGFloat rating = p.x * _numberOfStar / CGRectGetWidth(self.frame);
    [self setRating:rating];
}

- (void)setRating:(CGFloat)rating
{
    if (!_fraction) {
        NSInteger zhen = rating / 1;
        CGFloat yu = rating - zhen;
        rating = yu > .2 ? zhen + 1 : zhen;
    }
    
    if (_rating != rating)
    {
        _rating = rating;
        CGFloat x = rating / (CGFloat)_numberOfStar;
        x = x * CGRectGetWidth(self.frame);
        self.starForegroundView.frame = CGRectMake(0, 0, x, self.frame.size.height);
    }
}

- (void)setEnable:(BOOL)enable
{
    self.userInteractionEnabled = enable;
}

@end
