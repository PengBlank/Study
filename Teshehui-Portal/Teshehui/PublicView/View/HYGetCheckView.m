//
//  HYGetCheckView.m
//  Teshehui
//
//  Created by ichina on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetCheckView.h"

@implementation HYGetCheckView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame
                      authcode:NO];
}

- (id)initWithFrame:(CGRect)frame authcode:(BOOL)authcode
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.textColor = [UIColor darkTextColor];
        [self addSubview:_nameLab];
        
        _textField = [[UITextField alloc]initWithFrame:CGRectZero];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.textColor = [UIColor darkTextColor];
        _textField.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
        [self addSubview:_textField];
        
        if (authcode)
        {
            _sendCheck = [UIButton buttonWithType:UIButtonTypeCustom];
//            [_sendCheck setBackgroundImage:[UIImage imageNamed:@"person_buttom_orange2_normal"]
//                                  forState:UIControlStateNormal];
//            [_sendCheck setBackgroundImage:[UIImage imageNamed:@"person_buttom_orange2_press"]
//                                  forState:UIControlStateHighlighted];
            [_sendCheck setBackgroundColor:[UIColor colorWithRed:223/255.0f green:58/255.0f blue:60/255.0f alpha:1.0f]];
            [_sendCheck setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];
            [self addSubview:_sendCheck];
        }
    }
    
    return self;
}

@end
