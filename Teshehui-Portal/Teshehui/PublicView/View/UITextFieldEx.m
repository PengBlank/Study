//
//  UITextFieldEx.m
//  Sunight2.0
//
//  Created by Xiang Chengcai on 13-5-27.
//  Copyright (c) 2013年 Xiang Chengcai. All rights reserved.
//

#import "UITextFieldEx.h"

@implementation UITextFieldEx

@synthesize leftPadding = _leftPadding;
@synthesize rightPadding = _rightPadding;
@synthesize topPadding = _topPadding;
@synthesize bottomPadding = _bottomPadding;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect leftRect = [self leftViewRectForBounds:bounds];
    return CGRectMake(CGRectGetWidth(leftRect) + bounds.origin.x + _leftPadding,
                      bounds.origin.y + _topPadding,
                      bounds.size.width - CGRectGetWidth(leftRect) - _rightPadding - _leftPadding, bounds.size.height - _bottomPadding);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (void)setIsActive:(BOOL)isActive
{
    if (isActive)
    {
        self.layer.borderColor = [UIColor colorWithRed:255/255.0
                                                 green:152/255.0
                                                  blue:156/255.0
                                                 alpha:1].CGColor;
        self.layer.borderWidth = 1.;
    }
    else
    {
        self.layer.borderColor = [UIColor colorWithWhite:.91 alpha:1].CGColor;
        self.layer.borderWidth = 1.;
    }
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
