//
//  BaseCell.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "BaseCell.h"
#import "UIColor+expanded.h"
#import "DefineConfig.h"


#define kDefault_DrawLineHeight1x   1.0f
#define kDefault_DrawLineHeight2x   0.5f
#define kDefault_DrawLineColor      UIColorFromRGB(207,200,188)
#define kSegLineColor               UIColorFromRGB(215,215,215)
//分组表格表头x
#define kGroupTableXSpace           15.0f
//分组表格Top
#define kGroupTableYSpace           35.0f
//分组表格表头表内容间隔
#define kGroupTableHeadSpace        8.0f
//cell高度
#define kGroupTableCellHeight       44.0f

@implementation BaseCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - draw line

- (void)displayTopLine:(BOOL)isShow
{
    [self.topLineLayer removeFromSuperlayer];
    
    if(isShow)
    {
        if(self.topLineLayer == nil){
            self.topLineLayer = [[CALayer alloc] init];
            self.topLineLayer.backgroundColor = [UIColor colorWithHexString:@"0xe5e5e5"].CGColor;
            self.topLineLayer.borderWidth = 0.0f;
        }
        self.topLineLayer.frame = CGRectMake(0, 0, kScreen_Width, kDefault_DrawLineHeight2x);
        
        [self.layer addSublayer:self.topLineLayer];
        
    }else{
        [self.topLineLayer removeFromSuperlayer];
    }
    
    [self.layer setNeedsDisplay];
}

- (void)displayBottomLine:(BOOL)isShow isLast:(BOOL)isLast
{
    [self displayBottomLine:isShow isLast:isLast drawShadow:NO];
}

- (void)displayBottomLine:(BOOL)isShow distance:(CGFloat)distance isLast:(BOOL)isLast{
    
    [self displayBottomLine:isShow distance:distance isLast:isLast drawShadow:NO];
}

- (void)displayBottomLine:(BOOL)isShow distance:(CGFloat)distance isLast:(BOOL)isLast drawShadow:(BOOL)drawShadow{
    
    isShow = YES;
    
    [self.bottomLineLayer removeFromSuperlayer];
    [self.shadowLayer removeFromSuperlayer];
    
    if(isShow)
    {
        if(self.bottomLineLayer == nil){
            self.bottomLineLayer = [[CALayer alloc] init];
            self.bottomLineLayer.backgroundColor = [UIColor colorWithHexString:@"0xe5e5e5"].CGColor;
            self.bottomLineLayer.borderWidth = 0.0f;
        }
        
        float x = ((IOS7_OR_LATER && !isLast) ? distance : 0);
        self.bottomLineLayer.frame = CGRectMake(x, self.bounds.size.height - kDefault_DrawLineHeight2x, kScreen_Width - x-2, kDefault_DrawLineHeight2x);
        
        
        [self.layer addSublayer:self.bottomLineLayer];
        
    }else
    {
        if(drawShadow){
            
            [self.shadowLayer removeFromSuperlayer];
            
            if(self.shadowLayer == nil){
                CAGradientLayer *shadow = [CAGradientLayer layer];
                [shadow setStartPoint:CGPointMake(0.5, 0.0)];
                [shadow setEndPoint:CGPointMake(0.5, 1.0)];
                shadow.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 1);
                UIColor *color = [UIColor colorWithRed:1.0f green:1.0 blue:1.0 alpha:0.6];
                shadow.colors = [NSArray arrayWithObjects:(id)[color CGColor], (id)[[UIColor clearColor] CGColor], nil];
                self.shadowLayer = shadow;
            }
            
            [self.layer insertSublayer:self.shadowLayer atIndex:0];
        }
    }
    
    [self.layer setNeedsDisplay];
    
    
}

- (void)displayBottomLine:(BOOL)isShow isLast:(BOOL)isLast drawShadow:(BOOL)drawShadow
{
    //#warning 所有表格底部加投影
    //    if(isLast && drawShadow)
    //        isShow = NO;
    isShow = YES;
    
    [self.bottomLineLayer removeFromSuperlayer];
    [self.shadowLayer removeFromSuperlayer];
    
    if(isShow)
    {
        if(self.bottomLineLayer == nil){
            self.bottomLineLayer = [[CALayer alloc] init];
            self.bottomLineLayer.backgroundColor = [UIColor colorWithHexString:@"0xe5e5e5"].CGColor;
            self.bottomLineLayer.borderWidth = 0.0f;
        }
        
        float x = ((IOS7_OR_LATER && !isLast) ? kGroupTableXSpace : 0);
        self.bottomLineLayer.frame = CGRectMake(x, self.bounds.size.height - kDefault_DrawLineHeight2x, kScreen_Width - x-2, kDefault_DrawLineHeight2x);
        
        
        [self.layer addSublayer:self.bottomLineLayer];
        
    }else
    {
        if(drawShadow){
            
            [self.shadowLayer removeFromSuperlayer];
            
            if(self.shadowLayer == nil){
                CAGradientLayer *shadow = [CAGradientLayer layer];
                [shadow setStartPoint:CGPointMake(0.5, 0.0)];
                [shadow setEndPoint:CGPointMake(0.5, 1.0)];
                shadow.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 1);
                UIColor *color = [UIColor colorWithRed:1.0f green:1.0 blue:1.0 alpha:0.6];
                shadow.colors = [NSArray arrayWithObjects:(id)[color CGColor], (id)[[UIColor clearColor] CGColor], nil];
                self.shadowLayer = shadow;
            }
            
            [self.layer insertSublayer:self.shadowLayer atIndex:0];
        }
    }
    
    [self.layer setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
