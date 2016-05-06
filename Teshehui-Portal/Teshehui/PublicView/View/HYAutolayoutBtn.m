//
//  HYAutolayoutBtn.m
//  Teshehui
//
//  Created by HYZB on 15/6/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYAutolayoutBtn.h"

@interface HYAutolayoutBtn ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectImage;
@property (nonatomic, copy) NSString *title;
@end

@implementation HYAutolayoutBtn

- (id)initWithTitle:(NSString *)title image:(UIImage *)image
{
    return [self initWithTitle:title
                         image:image
                 selectedImage:nil];
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    self = [super init];
    if (self)
    {
        self.title = title;
        self.image = image;
        self.selectImage = selectedImage;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.text = self.title;
    _imageView.image = self.image;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
//    if (self.selectImage)
//    {
//        _imageView.image = self.selectImage;
//    }
    
    [self sendActionsForControlEvents:UIControlEventTouchDown];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [super touchesEnded:touches withEvent:event];
//    _imageView.image = self.image;
    
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark setter/getter
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

@end
