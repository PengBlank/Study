//
//  HYGridRowView.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-14.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYGridRowView.h"
#include "HYStyleConst.h"


@implementation HYGridRowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.columnWidthFixed = NO;
        } else {
            self.columnWidthFixed = YES;
        }
        self.topLineBold = NO;
        self.bottomLineBold = NO;
    }
    return self;
}

- (UILabel *)labelAtIndex:(NSInteger)idx
{
    if (idx < _columnWidths.count && idx >= 0) {
        return [_labels objectAtIndex:idx];
    }
    return nil;
}

- (void)setContents:(NSArray *)contents
{
    if (_contents != contents)
    {
        _contents = contents;
        //[self setNeedsDisplay];
    }
    /*
    [contents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx < _columnWidths.count) {
            if ([obj isKindOfClass:[NSString class]]) {
                UILabel *label = [_labels objectAtIndex:idx];
                label.text = (NSString *)obj;
            } else if ([obj respondsToSelector:@selector(stringValue)]) {
                UILabel *label = [_labels objectAtIndex:idx];
                label.text = [obj stringValue];
            }
        }
    }];*/
}

- (void)addContent:(NSString *)content
{
    if (!_contents || _contents.count >= _columnWidths.count)
    {
        _contents = [NSArray array];
    }
    if (!content) {
        content = @"";
    }
    _contents = [_contents arrayByAddingObject:content];
    //[self setNeedsDisplay];
}

- (void)setContent:(NSString *)content atIndex:(NSInteger)idx
{
    if (!_contents) {
        _contents = [NSArray array];
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:_contents];
    if (idx >= array.count)
    {
        for (NSInteger i = 0; i < idx-array.count; i++) {
            [array addObject:@""];
        }
    }
    [array replaceObjectAtIndex:idx withObject:content];
    _contents = [NSArray arrayWithArray:array];
    //[self setNeedsDisplay];
}

- (void)setColumnWidths:(NSArray *)columnWidths
{
    if (_columnWidths != columnWidths) {
        _columnWidths = columnWidths;
        __block CGFloat totalWidth = 0;
        //NSMutableArray *labels = [NSMutableArray array];
        [_columnWidths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            totalWidth += [obj floatValue];
        }];
        _totalWidth = totalWidth;
        _contents = nil;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

//绘制最下面的一根横线
- (void)drawRect:(CGRect)rect
{
    //[super drawRect:rect];
    CGContextRef context=UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGMutablePathRef path = CGPathCreateMutable();
    //CGContextSetShouldAntialias(context, NO);
    //左右两根边界线
    CGContextSetLineWidth(context, 4);
    CGContextSetStrokeColorWithColor(context, kGridFrameColor.CGColor);
    CGContextMoveToPoint(context, 0, 0);
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGContextAddLineToPoint(context, 0, CGRectGetHeight(rect));
    CGContextMoveToPoint(context, CGRectGetWidth(rect), 0);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGContextStrokePath(context);
    
    CGContextSetFont(context, (CGFontRef)_defaultFont);
    //中间分隔线
    float target = 0;
    float origin = 0;
    CGContextSetLineWidth(context, 1);
    for (int i = 0; i<self.columnWidths.count; i++)
    {
        float width = [[self.columnWidths objectAtIndex:i] floatValue];
        if (_columnWidthFixed)
        {
            target = origin + width;
        }
        else
        {
            width = CGRectGetWidth(rect) * width / _totalWidth;
            target = origin + (int)width + 0.5;
        }
        CGPathMoveToPoint(path, NULL, target, 0);
        CGPathAddLineToPoint(path, NULL, target, rect.size.height);
        
        UIColor *textColor = [UIColor blackColor];
        if ([_actionColums containsObject:@(i)])
        {
            if (_delegate)
            {
                NSInteger idx = [_actionColums indexOfObject:@(i)];
                UIButton *btn = (UIButton *)[self viewWithTag:(1022 + idx)];
                btn.frame = CGRectMake(origin, 0, width, CGRectGetHeight(self.frame));
            }
            textColor = self.actionColor;
        }
        
        NSString *content = _contents.count > i ? _contents[i]:nil;
        if (![content isKindOfClass:[NSString class]])
        {
            content = [NSString stringWithFormat:@"%@", content];
        }
        if ([content isKindOfClass:[NSString class]])
        {
            CGRect contentRect = CGRectMake(origin + 3,
                                            0,
                                            width - 6,
                                            CGRectGetHeight(rect));
            CGSize size = [content sizeWithFont:_defaultFont constrainedToSize:contentRect.size];
            CGFloat y = CGRectGetMidY(contentRect) - size.height/2;
            
            if ([UIDevice currentDevice].systemVersion.floatValue > 7.0)
            {
                NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                /// Set line break mode
                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                /// Set text alignment
                paragraphStyle.alignment = NSTextAlignmentCenter;
                [content drawInRect:CGRectMake(origin + 3,
                                               y,
                                               width - 6,
                                               size.height)
                     withAttributes:@{NSFontAttributeName:_defaultFont,
                                      NSParagraphStyleAttributeName: paragraphStyle,
                                      NSForegroundColorAttributeName: textColor}];
            }
            else
            {
                CGContextSetFillColorWithColor(context, textColor.CGColor);
                [content drawInRect:CGRectMake(origin + 3,
                                               y,
                                               width - 6,
                                               size.height)
                           withFont:_defaultFont
                      lineBreakMode:NSLineBreakByWordWrapping
                          alignment:NSTextAlignmentCenter];
            }

        }
        
        origin = target + 0.5;
    }
    
    [kGridFrameColor setStroke];
//    CGPathAddRect(path, NULL, rect);
    //CGContextStrokePath(context);
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
    
    //上方下方横线
    //上方
//    CGContextSetLineWidth(context, _topLineBold ? 3 : 1);
//    CGContextMoveToPoint(context, 0, 0);
//    CGContextAddLineToPoint(context, CGRectGetWidth(rect), 0);
//    CGContextStrokePath(context);
    //下方
    CGContextSetLineWidth(context, _bottomLineBold ? 3 : 1);
    CGContextMoveToPoint(context, 0, CGRectGetHeight(rect));
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

- (UIFont *)defaultFont
{
    if (!_defaultFont) {
        _defaultFont = [UIFont systemFontOfSize:14.0];
    }
    return _defaultFont;
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//    if (self.delegate &&
//        [self.delegate respondsToSelector:@selector(gridRowView:atIndexPath:didClickColumn:)] &&
//        _indexPath&&
//        _actionColumn != -1)
//    {
//        CGRect rect = CGRectMake(_action_start,
//                                  0,
//                                  _action_end-_action_start,
//                                  CGRectGetHeight(self.frame));
//        UITouch *touch = [touches anyObject];
//        if (CGRectContainsPoint(rect, [touch locationInView:self]))
//        {
//            [self.delegate gridRowView:self atIndexPath:_indexPath didClickColumn:_actionColumn];
//        }
//        else if (_actionColumn2 != -1)
//        {
//            rect = CGRectMake(_action_start,
//                              0,
//                              _action_end-_action_start,
//                              CGRectGetHeight(self.frame));
//        }
//        
//        if (_actionColumn2 != -1)
//        {
//            
//        }
//    }
//}

- (UIColor *)actionColor
{
    if (!_actionColor) {
        _actionColor = [UIColor colorWithRed:182/255.0 green:38/255.0 blue:38/255.0 alpha:1];
    }
    return _actionColor;
}

- (void)setActionColums:(NSArray *)actionColums
{
    if (_actionColums != actionColums)
    {
        if (_actionColums.count > 0)
        {
            for (int i = 0; i < _actionColums.count; i++)
            {
                UIView *exist = [self viewWithTag:(1022+i)];
                if (exist) {
                    [exist removeFromSuperview];
                }
            }
        }
        
        _actionColums = actionColums;
        
        if (_delegate != nil)
        {
            for (int i = 0; i < _actionColums.count; i++)
            {
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
                btn.backgroundColor = [UIColor clearColor];
                btn.tag = 1022 + i;
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
            }
        }
    }
}

- (void)btnAction:(UIButton *)btn
{
    NSInteger idx = btn.tag - 1022;
    if (idx < _actionColums.count)
    {
        NSInteger column = [[_actionColums objectAtIndex:idx] integerValue];
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(gridRowView:atIndexPath:didClickColumn:)])
        {
            [self.delegate gridRowView:self atIndexPath:_indexPath didClickColumn:column];
        }
    }
    
//    NSLog(@"actioned...");
}

- (void)setDelegate:(id<HYGridRowViewDelegate>)delegate
{
    if (_delegate != delegate)
    {
        _delegate = delegate;
        if (_actionColums.count > 0)
        {
            for (int i = 0; i < _actionColums.count; i++)
            {
                UIButton *exist = (UIButton*)[self viewWithTag:(1022+i)];
                exist.enabled = _delegate != nil;
            }
        }
    }
}
//
//- (void)addActionBtns
//{
//    if (_delegate && _actionColums.count) {
//        <#statements#>
//    }
//}

@end
