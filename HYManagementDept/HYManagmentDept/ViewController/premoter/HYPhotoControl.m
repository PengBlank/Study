//
//  HYPhotoControl.m
//  Teshehui
//
//  Created by RayXiang on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYPhotoControl.h"
#import <objc/message.h>

@interface HYPhotoControl ()

@property (nonatomic, weak) id touchTarget;
@property (nonatomic, weak) id deleteTarget;
@property (nonatomic, strong) NSString *touchAction;
@property (nonatomic, strong) NSString *deleteAction;

@property (nonatomic, strong) UIImageView *contentView;
@property (nonatomic, strong) UIImageView *deleteView;

@end

@implementation HYPhotoControl

- (void)addTargetForTouchAction:(id)target action:(SEL)action
{
    self.touchTarget = target;
    self.touchAction = NSStringFromSelector(action);
}

- (void)addTargetForDeleteAction:(id)target action:(SEL)action
{
    self.deleteTarget = target;
    self.deleteAction = NSStringFromSelector(action);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentView = [[UIImageView alloc] init];
        self.contentView.userInteractionEnabled = YES;
        _contentView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_contentView];
        
        self.deleteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_delete"]];
        self.deleteView.userInteractionEnabled = YES;
        _deleteView.contentMode = UIViewContentModeCenter;
        self.deleteView.hidden = YES;
        [self addSubview:_deleteView];
        //self.normalImage = [UIImage imageNamed:@"comment_img.png"];
        self.enable = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    self.contentView = [[UIImageView alloc] init];
    self.contentView.userInteractionEnabled = YES;
    [self addSubview:_contentView];
    
    self.deleteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_delete"]];
    self.deleteView.userInteractionEnabled = YES;
    _deleteView.contentMode = UIViewContentModeCenter;
    self.deleteView.hidden = YES;
    //self.normalImage = [UIImage imageNamed:@"comment_img.png"];
    [self addSubview:_deleteView];
    
    self.enable = YES;
}

- (void)setNormalImage:(UIImage *)normalImage
{
    _normalImage = normalImage;
    _contentView.image = normalImage;
}

- (void)setPhoto:(UIImage *)photo
{
    if (photo)
    {
        _photo = photo;
        _contentView.image = photo;
        _deleteView.hidden = NO;
        _contentView.userInteractionEnabled = NO;
    }
    else
    {
        _photo = nil;
        _contentView.image = _normalImage;
        _deleteView.hidden = YES;
        _contentView.userInteractionEnabled = YES;
    }
}

- (void)setEnable:(BOOL)enable
{
    if (_enable != enable) {
        _enable = enable;
        self.userInteractionEnabled = enable;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = CGRectGetWidth(self.frame) - 10;
    _contentView.frame = CGRectMake(0, 10, w, w);
    
    w -= 10;
    _deleteView.frame = CGRectMake(w, 0, 20, 20);
}

#pragma mark - Touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (touch.view == _contentView)
    {
        objc_msgSend(self.touchTarget, NSSelectorFromString(_touchAction), self);
//        [self.touchTarget performSelector:NSSelectorFromString(_touchAction)
//                               withObject:self];
    }
    if (touch.view == _deleteView) {
        objc_msgSend(self.deleteTarget, NSSelectorFromString(_deleteAction), self);
//        [self.deleteTarget performSelector:NSSelectorFromString(_deleteAction)
//                                withObject:self];
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
