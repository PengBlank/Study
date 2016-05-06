//
//  CQPopoverItem.m
//  Putao
//
//  Created by ChengQian on 12-10-19.
//  Copyright (c) 2012年 so.putao. All rights reserved.
//

#import "CQPopoverItem.h"

@interface CQPopoverItem ()

@property (nonatomic, retain) UILabel *titleLab;
@property (nonatomic, retain) UIImageView *imageView;


@property (nonatomic, retain) UIImage *normal;
@property (nonatomic, retain) UIImage *select;

@end

@implementation CQPopoverItem

@synthesize titleLab = _titleLab;
@synthesize imageView = _imageView;
@synthesize accessoryView = _accessoryView;


- (void)dealloc
{
#if ! __has_feature(objc_arc)
    PTRelease(_titleLab);
    PTRelease(_imageView);
    PTRelease(_accessoryView);
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
        normalImage:(UIImage *)normalImage
        selectImage:(UIImage *)selectImage
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.titleLab.text = title;
        self.normal = normalImage;
        self.select = selectImage;
        
        self.imageView.image = normalImage;   
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
              image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.titleLab.text = title;
        
        if (image)
        {
            self.imageView.image = image;
        }
    }
    
    return self;
}

//有时间可以重写draw方法，实现btn的几种状态
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
}
*/

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
#pragma mark- getter/setter

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        _titleLab.textColor = [UIColor whiteColor];
        _imageView.image = self.select;
    }
    else
    {
        _titleLab.textColor = [UIColor blackColor];
        _imageView.image = self.normal;
    }
}

- (NSString *)title
{
    return _titleLab.text;
}

- (UILabel *)titleLab
{
    if (nil == _titleLab)
    {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                              (self.frame.size.height-20)/2,
                                                              self.frame.size.width-10,
                                                              20)];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = [UIColor blackColor];
        [self addSubview:_titleLab];
    }
    
    return _titleLab;
}

- (UIImageView *)imageView
{
    if (nil == _imageView)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 13)];
        _imageView.center = CGPointMake(54, self.center.y);
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

- (void)setAccessoryView:(UIView *)accessoryView
{
    if (!_accessoryView)
    {
        [self addSubview:accessoryView];
#if ! __has_feature(objc_arc)
        _accessoryView = [accessoryView retain];
#else
        _accessoryView = accessoryView;
#endif
    }
    else
    {
        [_accessoryView removeFromSuperview];
#if ! __has_feature(objc_arc)
        [accessoryView retain];
        [_accessoryView release];
#endif
        _accessoryView = accessoryView;
        [self addSubview:accessoryView];
    }
}

@end
