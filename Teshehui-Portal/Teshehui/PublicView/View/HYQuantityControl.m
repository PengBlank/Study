//
//  HYQuantityControl.m
//  Teshehui
//
//  Created by HYZB on 15/9/1.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYQuantityControl.h"

@interface HYQuantityControl ()
{
    CGFloat _btnWidth;
    NSInteger _index;
    
    BOOL _addBtnEnabled;
    BOOL _minusBtnEnabled;
}

//@property (nonatomic, assign) NSUInteger quantity;
@property (nonatomic, strong) UIImage *addImage;
@property (nonatomic, strong) UIImage *addDisabledImage;
@property (nonatomic, strong) UIImage *minusImage;
@property (nonatomic, strong) UIImage *minusDisabledImage;
@property (nonatomic, strong) UIImage *bgImage;

@end

@implementation HYQuantityControl

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initData];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _btnWidth = frame.size.height;
        [self initData];
    }
    
    return self;
}

- (void)initData
{
    self.backgroundColor = [UIColor whiteColor];
    
    _addBtnEnabled = YES;
    _minusBtnEnabled = YES;
    self.minQuantity = 1;
    self.quantity = 1;
    self.addImage = [UIImage imageNamed:@"icon_add_quantity"];
    self.addDisabledImage = [UIImage imageNamed:@"icon_add_quantity_disabled"];
    self.minusImage = [UIImage imageNamed:@"icon_cut"];
    self.minusDisabledImage = [UIImage imageNamed:@"icon_cut_disabled"];;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2.0; //圆角
    self.layer.borderWidth = 1.0;//边框
    self.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
}

#pragma mark setter/getter
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _btnWidth = frame.size.height;
    [self setNeedsDisplay];
}

- (void)setQuantity:(NSUInteger)quantity
{
    if (quantity != _quantity)
    {
        _quantity = quantity;
        [self setNeedsDisplay];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
//    [self.bgImage drawInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIGraphicsPushContext(context);
    
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, 0.5*0.5);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.2 alpha:1.0].CGColor);
    
    CGContextMoveToPoint(context, _btnWidth, 0);
    CGContextAddLineToPoint(context, _btnWidth, rect.size.height);
    
    CGContextMoveToPoint(context, rect.size.width-_btnWidth, 0);
    CGContextAddLineToPoint(context, rect.size.width-_btnWidth, rect.size.height);
    
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    NSString *text = [NSString stringWithFormat:@"%d", (int)self.quantity];
    [text drawInRect:CGRectMake(_btnWidth+2, rect.size.height/2-8, rect.size.width-_btnWidth*2-4, 12.0f)
            withFont:[UIFont systemFontOfSize:14.0f]
       lineBreakMode:NSLineBreakByTruncatingTail
           alignment:NSTextAlignmentCenter];
    
    
    UIGraphicsPopContext();
    
    if (self.quantity<=self.minQuantity || !_minusBtnEnabled)
    {
        [self.minusDisabledImage drawAtPoint:CGPointMake((_btnWidth-self.minusDisabledImage.size.width)/2,
                                                 (rect.size.height-self.minusDisabledImage.size.height)/2)];
    }
    else
    {
        [self.minusImage drawAtPoint:CGPointMake((_btnWidth-self.minusImage.size.width)/2,
                                                 (rect.size.height-self.minusImage.size.height)/2)];
    }
    
    if (_addBtnEnabled)
    {
        [self.addImage drawAtPoint:CGPointMake(rect.size.width-_btnWidth/2-self.addImage.size.width/2,
                                               (rect.size.height-self.addImage.size.height)/2)];
    }
    else
    {
        [self.addDisabledImage drawAtPoint:CGPointMake(rect.size.width-_btnWidth/2-self.addDisabledImage.size.width/2,
                                               (rect.size.height-self.addDisabledImage.size.height)/2)];
    }
}

#pragma mark Touch Tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    
    CGPoint lastPoint = [touch locationInView:self];
    if (_minusBtnEnabled &&(lastPoint.x<=_btnWidth  && self.quantity>self.minQuantity))
    {
        _index = -1;
    }
    else if (_addBtnEnabled && (lastPoint.x >= (self.frame.size.width-_btnWidth)))
    {
        _index = 1;
    }
    else
    {
        _index = 0;
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    
    CGPoint lastPoint = [touch locationInView:self];
    if (_minusBtnEnabled && (_index<0 && lastPoint.x<=_btnWidth && self.quantity>self.minQuantity))
    {
        [self sendMinusEvent];
    }
    else if (_addBtnEnabled && (1==_index && lastPoint.x>=(self.frame.size.width-_btnWidth)))
    {
        [self sendAddEvent];
    }
    else
    {
        [self cancelTouch];
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
    
    [self cancelTouch];
}

- (void)cancelTouch
{
    _index = 0;
    [self sendActionsForControlEvents:UIControlEventTouchCancel];
    [self setNeedsDisplay];
}

- (void)sendAddEvent
{
    self.quantity++;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
}

- (void)sendMinusEvent
{
    self.quantity--;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
}

- (void)setEnabledAdd:(BOOL)enabled
{
    if (enabled != _addBtnEnabled)
    {
        _addBtnEnabled = enabled;
        [self setNeedsDisplay];
    }
}

- (void)setEnabledMinus:(BOOL)enabled
{
    if (enabled != _minusBtnEnabled)
    {
        _minusBtnEnabled = enabled;
        [self setNeedsDisplay];
    }
}

@end
