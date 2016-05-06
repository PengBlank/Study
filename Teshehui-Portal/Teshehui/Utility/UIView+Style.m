//
//  UIView+Coners.m
//  hpiWeibo
//
//  Created by 成才 向 on 12-8-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIView+Style.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Style) 

-(void)addCorner:(CGFloat)corner
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = corner;
}

-(void)addBorder:(CGFloat)borderWidth borderColor:(UIColor*)borderColor
{   

    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

-(void)addShadow:(CGSize)offsetSize 
{
    self.layer.masksToBounds	= NO;
    self.layer.shadowOffset	= offsetSize; 
	self.layer.shadowRadius	= 10;
	self.layer.shadowOpacity = 0.4;
}

-(void)addGrident:(NSArray*)colors
{
    CAGradientLayer* cagradientLayrer = [[CAGradientLayer alloc] init];
    NSMutableArray* cagradientColors = [[NSMutableArray alloc] init]; 
    for (UIColor* color in colors) 
    {
        [cagradientColors addObject:(id)(color.CGColor)];
    }
    cagradientLayrer.colors = cagradientColors;
    cagradientLayrer.frame = self.layer.bounds;
    [self.layer insertSublayer:cagradientLayrer atIndex:0];
    [self setNeedsDisplay];
}

@end
