//
//  HYBaseHeaderView.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-29.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseHeaderView.h"
#import "HYStrokeField.h"
#import "HYSelectField.h"

static UIImage *btnImgN;
static UIImage *btnImgH;

@implementation HYBaseHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UILabel *)getKeyLabel;
{
    UILabel *keyLab = [[UILabel alloc] initWithFrame:CGRectZero];
    keyLab.backgroundColor = [UIColor clearColor];
    keyLab.font = [UIFont systemFontOfSize:16.0];
    keyLab.textAlignment = NSTextAlignmentCenter;
    
    return keyLab;
}

- (HYStrokeField *)getField
{
    HYStrokeField *fromField = [[HYStrokeField alloc] initWithFrame:CGRectZero];
    fromField.font = [UIFont systemFontOfSize:16.0];
    fromField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return fromField;
}

- (HYSelectField *)getDateField
{
    HYSelectField *fromField = [[HYSelectField alloc] initWithFrame:CGRectZero];
    fromField.font = [UIFont systemFontOfSize:16.0];
    fromField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return fromField;
}

- (void)configureBtn:(UIButton *)btn
{
    if (!btnImgN) {
        btnImgN = [UIImage imageNamed:@"orderlist_btn"];
        btnImgN = [btnImgN stretchableImageWithLeftCapWidth:5 topCapHeight:5];
//        if ([btnImgN respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
//            [btnImgN resizableImageWithCapInsets:UIEdgeInsetsMake(5, 4, 5, 4) resizingMode:UIImageResizingModeStretch];
//        } else {
//            [btnImgN resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
//        }
    }
    if (!btnImgH) {
        btnImgH = [UIImage imageNamed:@"orderlist_btn"];
        if ([btnImgH respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
            [btnImgH resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
        } else {
            [btnImgH resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
        }
    }
    
    [btn setBackgroundImage:btnImgN forState:UIControlStateNormal];
    //[btn setBackgroundImage:btnImgH forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
}

- (void)configureSelectBtn:(UIButton *)btn
{
    [btn setTitle:@"-请选择-" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_select.png"] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    CGFloat x = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 20 : 10;
//    CGContextRef c = UIGraphicsGetCurrentContext();
//    UIGraphicsPushContext(c);
//    
//    CGContextSetStrokeColorWithColor(c, [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1].CGColor);
//    CGContextSetLineWidth(c, 1.0);
//    
//    CGContextMoveToPoint(c, x, CGRectGetHeight(rect));
//    CGContextAddLineToPoint(c, CGRectGetMaxX(self.frame)- 2*x, CGRectGetHeight(rect));
//    
//    CGContextStrokePath(c);
//    
//    UIGraphicsPopContext();
//}

@end
