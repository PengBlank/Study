//
//  HYImageButton.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYImageButton.h"
#import "Masonry.h"

@interface HYImageButton ()
{
    UILabel *_label;
}

@end

@implementation HYImageButton

//- (void)updateConstraints
//{
//    
//    // Center image
//    if (self.type == ImageButtonTypeVerticle)
//    {
//        CGFloat h = [self titleLabel].frame.size.height + self.imageView.frame.size.height;
//        self.imageView.frame = CGRectMake(CGRectGetMidX(self.bounds)-CGRectGetMidX(self.imageView.bounds),
//                                          CGRectGetHeight(self.frame)/2 - h/2,
//                                          self.imageView.frame.size.width,
//                                          self.imageView.frame.size.height);
//        
//        //Center text
//        CGRect newFrame = [self titleLabel].frame;
//        newFrame.origin.x  = 0;
//        newFrame.origin.y = CGRectGetMaxY(self.imageView.frame) + _spaceInTestAndImage;
//        newFrame.size.width = self.frame.size.width;
//        
//        self.titleLabel.frame = newFrame;
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    else
//    {
//        CGRect frame = self.imageView.frame;
//        frame.origin = _imageOrigin;
//        self.imageView.frame = frame;
//        
//        frame = self.titleLabel.frame;
//        frame.origin = _titleOrigin;
//        CGSize tsize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(self.frame.size.width-_titleOrigin.x, self.frame.size.height - _titleOrigin.y)];
//        frame.size = tsize;
//        self.titleLabel.frame = frame;
//    }
//    [super updateConstraints];
//}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // Center image
    if (self.type == ImageButtonTypeVerticle)
    {
        CGFloat h = [self titleLabel].frame.size.height + self.imageView.frame.size.height;
        self.imageView.frame = CGRectMake(CGRectGetMidX(self.bounds)-CGRectGetMidX(self.imageView.bounds),
                                          CGRectGetHeight(self.frame)/2 - h/2,
                                          self.imageView.image.size.width,
                                          self.imageView.image.size.height);
        
        //Center text
        CGRect newFrame = [self titleLabel].frame;
        newFrame.origin.x  = 0;
        newFrame.origin.y = CGRectGetMaxY(self.imageView.frame) + _spaceInTestAndImage;
        newFrame.size.width = self.frame.size.width;
        
        self.titleLabel.frame = newFrame;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    else if (self.type == ImageButtonTypeTitleFirst)
    {
        CGRect titleFrame = self.titleLabel.frame;
        CGRect imageFrame = self.imageView.frame;
        CGFloat x = CGRectGetMidX(self.bounds) - CGRectGetWidth(titleFrame)/2 - CGRectGetWidth(imageFrame)/2 - self.spaceInTestAndImage;
        titleFrame.origin.x = x;
        self.titleLabel.frame = titleFrame;
        imageFrame.origin.x =  CGRectGetMaxX(titleFrame) + self.spaceInTestAndImage;
        self.imageView.frame = imageFrame;
    }
    else
    {
        CGRect frame = self.imageView.frame;
        frame.origin = _imageOrigin;
        self.imageView.frame = frame;
        
        frame = self.titleLabel.frame;
        frame.origin = _titleOrigin;
        CGSize tsize = [self.titleLabel.text sizeWithFont:self.titleLabel.font
                                        constrainedToSize:CGSizeMake(self.frame.size.width-_titleOrigin.x, self.frame.size.height - _titleOrigin.y)];
        frame.size = tsize;
        self.titleLabel.frame = frame;
    }
    
    if (_label)
    {
        _label.layer.cornerRadius = _label.frame.size.width/2;
    }
}

- (void)setLabelCount:(NSUInteger)count
{
    if (count > 0)
    {
        if (!_label)
        {
            _label = [[UILabel alloc] initWithFrame:CGRectZero];
        }
        _label.backgroundColor = [UIColor redColor];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:10.0];
        _label.layer.masksToBounds = YES;
        _label.text = [NSString stringWithFormat:@"%lu",(unsigned long)count];
        [self addSubview:_label];
        
        WS(weakSelf);
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.imageView.mas_right).offset(2);
            make.top.equalTo(weakSelf.imageView.mas_top);
            make.height.equalTo(@13);
            make.width.equalTo(@13);
        }];
    }
    else
    {
        _label.hidden = YES;
    }
}

@end
