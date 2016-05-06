//
//  CQSegmentControl.m
//  Teshehui
//
//  Created by ChengQian on 13-10-28.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQSegmentControl.h"
#import "CQSegmentItem.h"
#import "UIColor+hexColor.h"

@interface CQSegmentControl ()
{
    NSInteger _touchIndex;
}

@property (nonatomic, strong) NSMutableArray *segmentItems;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation CQSegmentControl

- (void)dealloc
{
    _target = nil;
    _action = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [self initWithFrame:frame];
    
    if (self)
    {
        _touchIndex = -1;
        _currentIndex = -1;
        _segmentItems = [[NSMutableArray alloc] init];
        if ([items count] > 0)
        {
            [_segmentItems addObjectsFromArray:items];
        }
        _textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
    
	CGRect frame = [self frame];
    
	CGFloat widthPerItem = frame.size.width / (CGFloat)[self.segmentItems count];
	CGFloat x = 0.0f;
	CGFloat y = 8.0f;
    
    if (self.bgImage)
    {
        [self.bgImage drawInRect:rect];
    }
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    

	UIGraphicsPushContext(context);
    
	//draw items
    for (int i=0; i<[self.segmentItems count]; i++)
    {
        UIImage *image = nil;
        NSString *text = nil;

        id obj = [self.segmentItems objectAtIndex:i];
        
        if ([obj isKindOfClass:[CQSegmentItem class]])
        {
            CQSegmentItem *barItem = (CQSegmentItem *)obj;
            image = barItem.normalImage;
            text = barItem.title;
            CGSize imageSize = [image size];
            
            //竖向绘制
            if (barItem.dicection == Vertical)
            {
                //在颜色上，如果showSelectStatus为yes则赋selectColor和normalColor
                //否则全赋黑色
                if (self.showSelectStatus)
                {
                    if (i == _touchIndex)
                    {
                        image = barItem.hightlightImage;
                        imageSize = [image size];
                    }
                    
                    if (i == _touchIndex)
                        [[UIColor colorWithHexColor:_selectColor alpha:1.0] set];
                    else
                        [[UIColor colorWithHexColor:_normalColor alpha:1.0] set];
                }
                else
                {
                    [_textColor set];
                }
                CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
                
                if (image)
                {
                    
                     CGPoint imagePosition = CGPointMake(x + (widthPerItem - image.size.width)/2.0f, (rect.size.height - imageSize.height - y) / 2.0f );
                    [image drawAtPoint:imagePosition blendMode:kCGBlendModeNormal alpha:1.0f];
                }
                
                //text是确定有的
                [text drawInRect:CGRectMake(x, rect.size.height - 14.0f, widthPerItem, 14.0f)
//                        withFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f]
                        withFont:[UIFont systemFontOfSize:10]
                   lineBreakMode:NSLineBreakByTruncatingTail
                       alignment:NSTextAlignmentCenter];
                x += widthPerItem;
            }
            //横向绘制
            else
            {
                /**
                 *  这里有重复代码
                 */
                if (self.showSelectStatus)
                {
                    if (i == _touchIndex)
                    {
                        image = barItem.hightlightImage;
                        imageSize = [image size];
                    }
                    
                    if (i == _touchIndex)
                        [[UIColor colorWithHexColor:_selectColor alpha:1.0] set];
                    else
                        [[UIColor colorWithHexColor:_normalColor alpha:1.0] set];
                }
                else
                {
                    [_textColor set];
                }
                
                CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
                
                if (image)
                {
                    CGPoint imagePosition = CGPointMake(x + (widthPerItem - image.size.width)/2.0f, (rect.size.height - imageSize.height) / 2.0f );
                    [image drawAtPoint:imagePosition blendMode:kCGBlendModeNormal alpha:1.0f];
                }
                
                [text drawInRect:CGRectMake(x-image.size.width-10, (rect.size.height - 14.0f)/2, widthPerItem, 14.0f)
                        withFont:[UIFont systemFontOfSize:14.0f]
                   lineBreakMode:NSLineBreakByTruncatingTail
                       alignment:NSTextAlignmentCenter];
                
                x += widthPerItem;
            }
        }
    }
    
	UIGraphicsPopContext();
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    CGPoint location = [[touches anyObject] locationInView:self];
    CGRect frame = [self frame];
    
    //计算触点序号
    CGFloat widthPerItem = frame.size.width / (CGFloat)[self.segmentItems count];
    NSUInteger itemIndex = floor(location.x / widthPerItem);
    
    //点击序号与已有序号不同则开始更新绘图
    if (itemIndex != _touchIndex)
    {
        _touchIndex = itemIndex;
        [self setNeedsDisplay];
    }
}

//在这个界面，手指移动时cancelled被调用
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    _touchIndex = -1;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    CGPoint location = [[touches anyObject] locationInView:self];
    CGRect frame = [self frame];
    CGFloat widthPerItem = frame.size.width / (CGFloat)[self.segmentItems count];
    NSUInteger itemIndex = floor(location.x / widthPerItem);    
    [self setSelectedItemIndex:itemIndex];
}

- (void)addEventforSelectChangeTarget:(id)target
                               action:(SEL)action
{
    self.action = action;
    self.target = target;
}

- (void)setSelectedItemIndex:(NSUInteger)index
{
    if (index != _currentIndex)
    {
        _currentIndex = index;
        _touchIndex = index;
        [self setNeedsDisplay];
        
        if ([self.target respondsToSelector:self.action])
        {
            [self.target performSelector:self.action
                              withObject:self
                              afterDelay:0.0f];
        }
    }
    //隐含 index == _currentIndex
    //支持第二次点击
    else if (self.supportDouble)
    {
        id obj = [self.segmentItems objectAtIndex:index];
        
        if ([obj isKindOfClass:[CQSegmentItem class]])
        {
            //二次点击，交换hightLightImage 和doubleImage
            CQSegmentItem *barItem = (CQSegmentItem *)obj;
            UIImage *image = barItem.hightlightImage;
            barItem.hightlightImage = barItem.doubleImage;
            barItem.doubleImage = image;
        }
        [self setNeedsDisplay];
        
        if ([self.target respondsToSelector:self.action])
        {
            [self.target performSelector:self.action
                              withObject:self
                              afterDelay:0.0f];
        }
    }
}

- (void)cancelSelcteStatus
{
    _touchIndex = -1;
    _currentIndex = -1;
    [self setNeedsDisplay];
}

@end
