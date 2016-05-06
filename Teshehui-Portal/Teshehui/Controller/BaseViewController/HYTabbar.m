//
//  HYTabbar.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-31.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYTabbar.h"
#import "HYTabbarItem.h"

@interface HYTabbar ()
{
    NSInteger _currentIndex;
}

@property (nonatomic, strong) NSArray *items;

@end


@implementation HYTabbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _currentIndex = -1;

        [self setUserInteractionEnabled:NO];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if ([self.items count] > 0)
    {
        CGFloat widthPerItem = rect.size.width / (CGFloat)[[self items] count];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(context);
        
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
                                                TFScalePoint((kTabBarHeight-image.size.height)/2.0f-6));
            
            [image drawAtPoint:imagePosition blendMode:kCGBlendModeNormal alpha:1.0f];
            [titleColor set];
            
            [text drawInRect:CGRectMake(widthPerItem*index, imagePosition.y+image.size.height+4, widthPerItem, 14.0f)
                    withFont:[UIFont systemFontOfSize:12.0f]
               lineBreakMode:NSLineBreakByTruncatingTail
                   alignment:NSTextAlignmentCenter];
        }
        
        UIGraphicsPopContext();
    }
}

- (void)setIsSubTabbar:(BOOL)isSubTabbar
{
    if (isSubTabbar != _isSubTabbar)
    {
        _isSubTabbar = isSubTabbar;
        
        [self setUserInteractionEnabled:isSubTabbar];
    }
}

- (NSInteger)currentIndex
{
    return _currentIndex;
}

- (void)setSelectedItemIndex:(NSInteger)index hasEvent:(BOOL)hasEvent
{
    if (index != _currentIndex)
    {
        _currentIndex = index;
        
        if (hasEvent)
        {
            [self sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        
        [self setNeedsDisplay];
    }
}

#pragma mark publice methods
- (void)setItems:(NSArray *)items
{
    if (items != _items)
    {
        _items = items;
        [self setNeedsDisplay];
    }
}

- (void)cleanSelectStaus
{
    _currentIndex = -1;
    [self setNeedsDisplay];
}

- (void)setSelectedItemIndex:(NSInteger)index
{
    [self setSelectedItemIndex:index hasEvent:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [super touchesEnded:touches withEvent:event];
    
    if (self.isSubTabbar)
    {
        CGPoint location = [[touches anyObject] locationInView:self];
        CGRect frame = [self frame];
        CGFloat widthPerItem = frame.size.width / (CGFloat)[[self items] count];
        NSUInteger itemIndex = floor(location.x / widthPerItem);
        
        if(![self.items count])
            return;
        itemIndex += 2;
        [self setSelectedItemIndex:itemIndex hasEvent:YES];
    }
}

@end
