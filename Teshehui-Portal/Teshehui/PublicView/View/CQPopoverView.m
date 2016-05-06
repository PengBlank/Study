//
//  CQPopoverView.m
//  Putao
//
//  Created by ChengQian on 12-10-19.
//  Copyright (c) 2012年 so.putao. All rights reserved.
//

#import "CQPopoverView.h"

@interface CQPopoverView ()
{
    NSInteger _preIndex;
}
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) UIImageView *backgroundView;
@property (nonatomic, retain) UIImageView *selectImageView;

@property (nonatomic, strong) CAAnimation *dimingAnimation;
@property (nonatomic, strong) CAAnimation *showMenuAnimation;
@property (nonatomic, strong) CAAnimation *dismissMenuAnimation;
@property (nonatomic, strong) CAAnimation *lightingAnimation;

- (void)selectItem:(id)sender;
- (void)dismiss;

@end


@implementation CQPopoverView

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    PTRelease(_items);
    PTRelease(_backgroundView);
    PTRelease(_selectImageView);
    [super dealloc];
#endif
}

- (id)initWithPoint:(CGPoint)point
            bgImage:(UIImage *)bgImage
        popoverItem:(NSArray *)items
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _preIndex = -1;
        
        _backgroundView = [[UIImageView alloc] initWithImage:bgImage];
        CGFloat height = 0.0;
        CGFloat width = 0.0;

        for (CQPopoverItem *item in items)
        {
            item.frame = CGRectMake(item.frame.origin.x,
                                    height,
                                    item.frame.size.width,
                                    item.frame.size.height);
            height+= item.frame.size.height;
            width = item.frame.size.width;
            
            [item addTarget:self
                     action:@selector(selectItem:)
           forControlEvents:UIControlEventTouchUpInside];
            
            [_backgroundView addSubview:item];
        }
        
        CGRect conFrame = CGRectMake(point.x, point.y, width, height+7);
        _backgroundView.userInteractionEnabled = YES;
        _backgroundView.frame = conFrame;
        [self addSubview:_backgroundView];
        
        //retain items
        self.items = [NSMutableArray arrayWithArray:items];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mrak setter/getter
- (UIImageView *)selectImageView
{
    if (!_selectImageView)
    {
        _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _backgroundView.frame.size.width, 40)];
        _selectImageView.image = self.selectImage;
        [_backgroundView insertSubview:_selectImageView atIndex:0];
    }
    
    return _selectImageView;
}

#pragma mark getter
- (CAAnimation *)dimingAnimation
{
    if (_dimingAnimation == nil) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        opacityAnimation.fromValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        opacityAnimation.toValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor];
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeBoth];
        _dimingAnimation = opacityAnimation;
    }
    return _dimingAnimation;
}

- (CAAnimation *)lightingAnimation
{
    if (_lightingAnimation == nil ) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        opacityAnimation.fromValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor];
        opacityAnimation.toValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeBoth];
        _lightingAnimation = opacityAnimation;
    }
    return _lightingAnimation;
}

- (CAAnimation *)showMenuAnimation
{
    if (_showMenuAnimation == nil) {
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D t = CATransform3DIdentity;
        t.m34 = 1 / -500.0f;
        CATransform3D from = CATransform3DRotate(t, -30.0f * M_PI / 180.0f, 1, 0, 0);
        CATransform3D to = CATransform3DIdentity;
        [rotateAnimation setFromValue:[NSValue valueWithCATransform3D:from]];
        [rotateAnimation setToValue:[NSValue valueWithCATransform3D:to]];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [scaleAnimation setFromValue:@0.9];
        [scaleAnimation setToValue:@1.0];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        [positionAnimation setFromValue:[NSNumber numberWithFloat:50.0]];
        [positionAnimation setToValue:[NSNumber numberWithFloat:0.0]];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:@0.0];
        [opacityAnimation setToValue:@1.0];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        [group setAnimations:@[rotateAnimation, scaleAnimation, opacityAnimation, positionAnimation]];
        [group setRemovedOnCompletion:NO];
        [group setFillMode:kCAFillModeBoth];
        _showMenuAnimation = group;
    }
    return _showMenuAnimation;
}

- (CAAnimation *)dismissMenuAnimation
{
    if (_dismissMenuAnimation == nil) {
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D t = CATransform3DIdentity;
        t.m34 = 1 / -500.0f;
        CATransform3D from = CATransform3DIdentity;
        CATransform3D to = CATransform3DRotate(t, -30.0f * M_PI / 180.0f, 1, 0, 0);
        [rotateAnimation setFromValue:[NSValue valueWithCATransform3D:from]];
        [rotateAnimation setToValue:[NSValue valueWithCATransform3D:to]];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [scaleAnimation setFromValue:@1.0];
        [scaleAnimation setToValue:@0.9];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        [positionAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
        [positionAnimation setToValue:[NSNumber numberWithFloat:50.0]];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:@1.0];
        [opacityAnimation setToValue:@0.0];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        [group setAnimations:@[rotateAnimation, scaleAnimation, opacityAnimation, positionAnimation]];
        [group setRemovedOnCompletion:NO];
        [group setFillMode:kCAFillModeBoth];
        _dismissMenuAnimation = group;
    }
    return _dismissMenuAnimation;
}

#pragma mark- public

- (void)setCurrentSelectItem:(NSInteger)itemTag
{
    _preIndex = itemTag;
    for (CQPopoverItem *item in self.items)
    {
        if (item.tag == itemTag)
        {
            [item setSelected:YES];
            self.selectImageView.center = item.center;
            break;
        }
    }
}

- (void)addItemWithView:(CQPopoverItem *)item
{
    CGFloat y = _backgroundView.frame.origin.y + _backgroundView.frame.size.height+2;
    CGFloat height = _backgroundView.frame.size.height + item.frame.size.height+4;
    item.frame = CGRectMake(4, y, item.frame.size.width, item.frame.size.height);
    
    _backgroundView.frame = CGRectMake(_backgroundView.frame.origin.x,
                            _backgroundView.frame.origin.y,
                            _backgroundView.frame.size.width,
                            height);
    
    [_backgroundView addSubview:item];
}

- (void)showWithAnimation:(BOOL)animation
{
    if (![self superview]) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
    }
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.2];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [self.layer addAnimation:self.dimingAnimation forKey:@"diming"];
    [_backgroundView.layer addAnimation:self.showMenuAnimation forKey:@"showMenu"];
    [CATransaction commit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark private
- (void)selectItem:(id)sender
{
    CQPopoverItem *item = (CQPopoverItem *)sender;
    
    //更新之前的
    if (_preIndex >= 0)
    {
        for (CQPopoverItem *item in self.items)
        {
            if (item.tag == _preIndex)
            {
                [item setSelected:NO];
                break;
            }
        }
    }
    _preIndex = item.tag;
    //更新当前的
    [item setSelected:YES];
    
    if (self.selectImage)
    {
        self.selectImageView.center = item.center;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverDidSelectItem:)])
    {
        [self.delegate popoverDidSelectItem:item];
    }
    
    [self dismiss];
}

- (void)dismiss
{
    if ([self superview])
    {
        if ([self.delegate respondsToSelector:@selector(popoverDidHidden)])
        {
            [self.delegate popoverDidHidden];
        }
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [CATransaction setCompletionBlock:^{
            [self removeFromSuperview];
        }];
        [self.layer addAnimation:self.lightingAnimation forKey:@"lighting"];
        [_backgroundView.layer addAnimation:self.dismissMenuAnimation forKey:@"dismissMenu"];
        [CATransaction commit];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    DebugNSLog(@"touch");

    [self dismiss];
}

@end
