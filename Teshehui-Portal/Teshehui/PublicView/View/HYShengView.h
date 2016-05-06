//
//  HYShengView.h
//  Teshehui
//
//  Created by 成才 向 on 15/9/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HYShengLeft = 0,
    HYShengRight
}HYShengDirection;

@interface HYShengView : UIView
{
    UIImageView *_shengView;
    UILabel *_shengLab;
    CGFloat _left;
    CGFloat _right;
    CGFloat _maxWidth;
    CGFloat _height;
    HYShengDirection _direction;
}

- (instancetype)initWithDirection:(HYShengDirection)direction height:(CGFloat)height;

- (void)setPoint:(CGPoint)point maxWidth:(CGFloat)width;
//- (void)setPoint:(CGPoint)point height:(CGFloat)height maxWidth:(CGFloat)width;

//@property (nonatomic, assign) CGPoint point;
//@property (nonatomic, assign) CGFloat maxWidth;
//@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSString *sheng;

@end
