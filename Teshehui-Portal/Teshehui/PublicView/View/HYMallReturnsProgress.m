//
//  HYMallReturnsProgress.m
//  SEFilterControl_Sample
//
//  Created by HYZB on 14-9-19.
//  Copyright (c) 2014年 Shady Elyaski. All rights reserved.
//

#import "HYMallReturnsProgress.h"

#define LEFT_OFFSET 25
#define RIGHT_OFFSET 25
#define TITLE_SELECTED_DISTANCE 5
#define TITLE_FADE_ALPHA .5f
#define TITLE_FONT [UIFont fontWithName:@"Optima" size:14]
#define TITLE_SHADOW_COLOR [UIColor lightGrayColor]
#define TITLE_COLOR [UIColor blackColor]


@interface HYMallReturnsProgress ()

@property (nonatomic, strong) NSArray *stepTitles;  //步骤名称
@property (nonatomic, assign) NSInteger stepsTotal;  //总步骤

@end

@implementation HYMallReturnsProgress

-(id) initWithFrame:(CGRect) frame stepTitles:(NSArray *) stepTitles
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.stepTitles = stepTitles;
        self.stepsTotal = [stepTitles count];
        self.backgroundColor = [UIColor clearColor];
        self.progressBgColor = [UIColor colorWithRed:230.0/255.0
                                               green:230.0/255.0
                                                blue:230.0/255.0
                                               alpha:1.0];
        self.progressColor = [UIColor colorWithRed:167.0/255.0
                                             green:0
                                              blue:0
                                             alpha:1.0];
        self.titleSelectColor = [UIColor colorWithRed:167.0/255.0
                                                green:0
                                                 blue:0
                                                alpha:1.0];
        
        self.titleNormalColor = [UIColor colorWithRed:230.0/255.0
                                                green:230.0/255.0
                                                 blue:230.0/255.0
                                                alpha:1.0];
        return self;
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef shadowColor = [UIColor colorWithRed:0 green:0
                                              blue:0 alpha:.9f].CGColor;
    
    
    //Fill Main Path
    CGRect fillRect = CGRectMake(LEFT_OFFSET, (rect.size.height-8-25)/2, rect.size.width-RIGHT_OFFSET-LEFT_OFFSET, 8);
    CGContextSetFillColorWithColor(context, self.progressBgColor.CGColor);
    CGContextFillRect(context, fillRect);
    
    if (self.currStep > 0)
    {
        CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
        CGRect pRect = fillRect;
        pRect.size.width = (fillRect.size.width/(self.stepsTotal-1))*(self.currStep-1);
        CGContextFillRect(context, pRect);
    }
    
    CGContextSaveGState(context);
    
    //Draw Black Top Shadow
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1.f), 2.f, shadowColor);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0
                                                               blue:0 alpha:.6f].CGColor);
    CGContextSetLineWidth(context, .5f);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, LEFT_OFFSET, (rect.size.height-8-25)/2);
    CGContextAddLineToPoint(context, rect.size.width-RIGHT_OFFSET, (rect.size.height-8-25)/2);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    
    //Draw White Bottom Shadow
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:1 green:1
                                                               blue:1 alpha:1.f].CGColor);
    CGContextSetLineWidth(context, .4f);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, LEFT_OFFSET, (rect.size.height-8-25)/2+8);
    CGContextAddLineToPoint(context, rect.size.width-RIGHT_OFFSET, (rect.size.height-8-25)/2+8);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
    
    // draw point
    CGFloat width = 15;
    CGFloat step = (fillRect.size.width/(self.stepsTotal-1));
    
    CGFloat orig_x = 0;
    CGFloat orig_y = (rect.size.height-width-25)/2;
    int i;
    for (i = 1; i <= self.stepsTotal; i++)
    {
        orig_x = step*(i-1)-width/2+LEFT_OFFSET;
        //Draw Selection Circles
        if (i <= self.currStep)
        {
            CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
        }
        else
        {
            CGContextSetFillColorWithColor(context, self.progressBgColor.CGColor);
        }
        
        CGContextFillEllipseInRect(context, CGRectMake(orig_x, orig_y, width, width));
        
        //Draw White Bottom Shadow
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:1 green:1
                                                                   blue:1 alpha:.4f].CGColor);
        CGContextSetLineWidth(context, .8f);
        CGContextAddArc(context, orig_x+width/2, orig_y+width/2,width/2 ,24*M_PI/180,156*M_PI/180,0);
        CGContextDrawPath(context,kCGPathStroke);
        
        //Draw Black Top Shadow
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0
                                                                   blue:0 alpha:.2f].CGColor);
        
        CGContextAddArc(context,orig_x+width/2, orig_y+width/2, width/2-0.5,(i==self.stepsTotal-1?28:-20)*M_PI/180,(i==0?-208:-160)*M_PI/180,1);
        CGContextSetLineWidth(context, 1.f);
        CGContextDrawPath(context,kCGPathStroke);
        
        //step title
        NSString *desc = [NSString stringWithFormat:@"%d", i];
        if (i <= self.currStep)
        {
            [[UIColor whiteColor] set];
            
        }
        else
        {
            [[UIColor colorWithWhite:0.2 alpha:1.0] set];
        }
        
        [desc drawInRect:CGRectMake(orig_x+3.5, orig_y-0.5, 15, 15)
                withFont:[UIFont systemFontOfSize:12]];
        
        NSString *title = [self.stepTitles objectAtIndex:(i-1)];
        
        if (i <= self.currStep)
        {
            [self.titleSelectColor set];
        }
        else
        {
            [self.titleNormalColor set];
        }
        
        [title drawInRect:CGRectMake(orig_x-20+width/2, orig_y+27, 44, 14)
                 withFont:[UIFont systemFontOfSize:10]];
    }
}

@end
