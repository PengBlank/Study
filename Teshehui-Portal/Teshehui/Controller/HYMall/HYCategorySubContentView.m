//
//  HYCategorySubContentView.m
//  Teshehui
//
//  Created by apple on 15/1/19.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCategorySubContentView.h"
#import "HYMallCategoryInfo.h"
#import "HYCategorySubCell.h"

@interface HYCategorySubContentView ()
@end

@implementation HYCategorySubContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    CGPoint p = [tap locationInView:self];
    CGFloat width = (CGRectGetWidth(self.frame)-20) / 3;
    CGFloat height = 40;
    
    NSInteger col = p.x / (NSInteger)width;
    NSInteger row = p.y / (NSInteger)height;
    
    NSInteger idx = (row * 3) + col;
    if (idx < _items.count && idx >-1)
    {
        if (self.delegate) {
            [self.delegate contentViewDidSelectAtIndex:idx];
        }
    }
    DebugNSLog(@"idx:%ld", idx);
}

- (void)setItems:(NSArray *)items
{
    if (_items != items) {
        _items = items;
        [self setNeedsDisplay];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ct = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ct);
    
    CGContextSetLineWidth(ct, .5);
    
    NSInteger col = 3;
//    NSInteger row = _items.count / col + 1;
    CGFloat x = 10;
    CGFloat y = 0;
    CGFloat width = (CGRectGetWidth(self.frame)-2*x) / 3;
    CGFloat height = 40;
    
    [[UIColor blackColor] set];
    UIImage *frame = [UIImage imageNamed:@"cate_frame"];
    frame = [frame resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
    for (int i = 0; i < _items.count; i++)
    {
        [frame drawInRect:CGRectMake(x, y, width, height)];
        //frame drawInRect:CGRectMake(x, y, width, height) blendMode:<#(CGBlendMode)#> alpha:<#(CGFloat)#>
        //CGContextAddRect(ct, CGRectMake(x, y, width, height));
        HYMallCategoryInfo *cate = [_items objectAtIndex:i];
        CGSize size = [cate.cate_name sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(width, height)];
        CGFloat ty = (height - size.height) / 2;
        [cate.cate_name drawInRect:CGRectMake(x, y+ty, width, size.height) withFont:[UIFont systemFontOfSize:14.0] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        if (i % col == col - 1)
        {
            x = 10;
            y += height-1;
        }
        else
        {
            x += width-1;
        }
    }
    
    //[[UIColor colorWithWhite:0.91 alpha:1] set];
    //CGContextStrokePath(ct);
    
    UIGraphicsPopContext();
}


@end
