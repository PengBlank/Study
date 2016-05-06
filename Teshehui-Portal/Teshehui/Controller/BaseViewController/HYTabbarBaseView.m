//
//  HYTabbarBaseView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-31.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYTabbarBaseView.h"
#import "UIImage+Addition.h"

@interface HYTabbarBaseView()
{
    NSInteger _currentIndex;
    NSInteger _subCurrentIndex;
    NSInteger _hasNewIndex;
    BOOL _isShowSubTabbar;
}

@property (nonatomic, strong) NSArray *items;

@end

@implementation HYTabbarBaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isShowSubTabbar = NO;
        _currentIndex = 0;
        _subCurrentIndex = -1;
        _hasNewIndex = -1;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if ([self.items count] > 0)
    {
        CGFloat widthPerItem = self.frame.size.width/[self.items count];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(context);

        if (self.backgroudImage)
        {
            [self.backgroudImage drawInRect:TFRectMake(0, 0, 320, kTabBarHeight)];
        }
        
        for (int index=0; index<[self.items count]; index++)
        {
            HYTabbarItem *item1 = [self.items objectAtIndex:index];
            
            UIColor *titleColor = self.normalColor;
            
            NSString *text = [item1 title];
            UIImage *image = item1.normalImage;
            
            if (_currentIndex == item1.index)
            {
                image = item1.selectImage;
                titleColor = self.selectedColor;
            }
            
            CGPoint imagePosition = CGPointMake(widthPerItem*index + (widthPerItem-image.size.width)/2.0f,
                                                (rect.size.height-image.size.height)/2.0f - TFScalePoint(8));
            /// 这里适配春节风格，图片跟字整 个是一张图片的时候，需要将图片居中显示
            if (!item1.title) {
                imagePosition.y = 0;
            }
            
            [image drawAtPoint:imagePosition blendMode:kCGBlendModeNormal alpha:1.0f];
            [titleColor set];
            
            [text drawInRect:CGRectMake(widthPerItem*index, imagePosition.y+image.size.height+4, widthPerItem, 14.0f)
                    withFont:[UIFont systemFontOfSize:12.0f]
               lineBreakMode:NSLineBreakByTruncatingTail
                   alignment:NSTextAlignmentCenter];
            
            if (item1.hasNew)
            {
                UIImage *redPoint = [UIImage imageWithNamedAutoLayout:@"h_icon3"];
                imagePosition = CGPointMake(widthPerItem*index + (widthPerItem-redPoint.size.width)/2.0f+14,
                                            TFScalePoint((kTabBarHeight-redPoint.size.height)/2.0f-6)-10);
                [redPoint drawAtPoint:imagePosition blendMode:kCGBlendModeNormal alpha:1.0f];
            }
        }
        
        UIGraphicsPopContext();
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGRect frame = [self frame];
    CGFloat widthPerItem = frame.size.width / (CGFloat)[[self items] count];
    NSUInteger itemIndex = fabs(floor((location.x-5) / widthPerItem));
    
    if(![self.items count])
        return;
        
    //双击
    if (_currentIndex==0 && [touch tapCount] == 2)
    {
        [self doubleClickItemIndex:itemIndex];
    }
    else
    {
        [self setSelectedItemIndex:itemIndex sendChangeEvent:YES];
    }
}

- (void)doubleClickItemIndex:(NSInteger)index
{
    if (index == 0)
    {
        HYTabbarItem *item = [self.items objectAtIndex:index];
        [self.delegate updateWithDoubleClick:item];
    }
}

- (void)setSelectedItemIndex:(NSUInteger)index sendChangeEvent:(BOOL)sendEvent
{
    if (index != _currentIndex && index<[self.items count])
    {
        _currentIndex = index;
        
       [self setNeedsDisplay];
        
        if (sendEvent)
        {
            if ([self.delegate respondsToSelector:@selector(didChangeTabbarItem:)])
            {
                HYTabbarItem *item = [self.items objectAtIndex:index];
                [self.delegate didChangeTabbarItem:item];
            }
        }
    }
}

#pragma mark publice methods
- (void)setSelectedItemIndex:(NSInteger)index
{    
    [self setSelectedItemIndex:index sendChangeEvent:NO];
}

- (void)setItems:(NSArray *)items
{
    if (items != _items)
    {
        _items = items;
        [self setNeedsDisplay];
    }
}

@end
