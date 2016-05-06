//
//  HYProductFilterView.m
//  Teshehui
//
//  Created by HYZB on 14-9-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYProductSortView.h"
#import "UIImage+Tint.h"

@interface HYProductSortView ()
{
    UIButton *_priceSortBtn;
    UIButton *_salesSortBtn;
    UIButton *_timeSortBtn;

}

@end

@implementation HYProductSortView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        if (_needRelayout)
        {
            UIButton *priceSortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_priceSortBtn setFrame:TFRectMakeFixWidth(0, 0, 80, 34)];
            [priceSortBtn setTitle:@"价格" forState:UIControlStateNormal];
            [priceSortBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0]
                               forState:UIControlStateNormal];
            [priceSortBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [priceSortBtn setImage:[UIImage imageNamed:@"licon_list_downcheck"]
                          forState:UIControlStateNormal];
            [priceSortBtn setImage:[UIImage imageNamed:@"licon_list_upcheck"]
                          forState:UIControlStateSelected];
            UIImage *tint = [[UIImage imageNamed:@"licon_list_upcheck"] imageWithTintColor:[UIColor blueColor]];
            [priceSortBtn setImage:tint forState:UIControlStateHighlighted];
            [priceSortBtn addTarget:self
                             action:@selector(productSort:)
                   forControlEvents:UIControlEventTouchUpInside];
            [priceSortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, TFScalePoint(20), 0, TFScalePoint(40))];
            [priceSortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, TFScalePoint(60), 0, TFScalePoint(20))];
            priceSortBtn.tag = 10;
            _priceSortBtn = priceSortBtn;
            [self addSubview:priceSortBtn];
            
            UIButton *salesSortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_salesSortBtn setFrame:TFRectMakeFixWidth(82, 0, 80, 34)];
            [salesSortBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0]
                               forState:UIControlStateNormal];
            [salesSortBtn setTitle:@"销量" forState:UIControlStateNormal];
            [salesSortBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [salesSortBtn setImage:[UIImage imageNamed:@"licon_list_downcheck"]
                          forState:UIControlStateNormal];
            [salesSortBtn setImage:[UIImage imageNamed:@"licon_list_upcheck"]
                          forState:UIControlStateSelected];
            [salesSortBtn addTarget:self
                             action:@selector(productSort:)
                   forControlEvents:UIControlEventTouchUpInside];
            [salesSortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, TFScalePoint(20), 0, TFScalePoint(40))];
            [salesSortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, TFScalePoint(60), 0, TFScalePoint(20))];
            salesSortBtn.tag = 11;
            _salesSortBtn = salesSortBtn;
 
            [self addSubview:salesSortBtn];
            
            UIButton *timeSortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_timeSortBtn setFrame:TFRectMakeFixWidth(164, 0, 80, 34)];
            [timeSortBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0]
                              forState:UIControlStateNormal];
            [timeSortBtn setTitle:@"上架时间" forState:UIControlStateNormal];
            [timeSortBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [timeSortBtn setImage:[UIImage imageNamed:@"licon_list_downcheck"]
                         forState:UIControlStateNormal];
            [timeSortBtn setImage:[UIImage imageNamed:@"licon_list_upcheck"]
                         forState:UIControlStateSelected];
            [timeSortBtn addTarget:self
                            action:@selector(productSort:)
                  forControlEvents:UIControlEventTouchUpInside];
            [timeSortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, TFScalePoint(12), 0, TFScalePoint(20))];
            [timeSortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, TFScalePoint(80), 0, TFScalePoint(12))];
            timeSortBtn.tag = 12;
            _timeSortBtn = timeSortBtn;

            [self addSubview:timeSortBtn];
        }
        else
        {
            UIButton *priceSortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [priceSortBtn setFrame:TFRectMakeFixWidth(0, 0, 106, 34)];
            [priceSortBtn setTitle:@"价格" forState:UIControlStateNormal];
            [priceSortBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0]
                               forState:UIControlStateNormal];
            [priceSortBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [priceSortBtn setImage:[UIImage imageNamed:@"licon_list_downcheck"]
                          forState:UIControlStateNormal];
            [priceSortBtn setImage:[UIImage imageNamed:@"licon_list_upcheck"]
                          forState:UIControlStateSelected];
            UIImage *tint = [[UIImage imageNamed:@"licon_list_upcheck"] imageWithTintColor:[UIColor blueColor]];
            [priceSortBtn setImage:tint forState:UIControlStateHighlighted];
            [priceSortBtn addTarget:self
                             action:@selector(productSort:)
                   forControlEvents:UIControlEventTouchUpInside];
            [priceSortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, TFScalePoint(20), 0, TFScalePoint(40))];
            [priceSortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, TFScalePoint(60), 0, TFScalePoint(20))];
            priceSortBtn.tag = 10;
            _priceSortBtn = priceSortBtn;
            [self addSubview:priceSortBtn];
            
            UIButton *salesSortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [salesSortBtn setFrame:TFRectMakeFixWidth(108, 0, 106, 34)];
            [salesSortBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0]
                               forState:UIControlStateNormal];
            [salesSortBtn setTitle:@"销量" forState:UIControlStateNormal];
            [salesSortBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [salesSortBtn setImage:[UIImage imageNamed:@"licon_list_downcheck"]
                          forState:UIControlStateNormal];
            [salesSortBtn setImage:[UIImage imageNamed:@"licon_list_upcheck"]
                          forState:UIControlStateSelected];
            [salesSortBtn addTarget:self
                             action:@selector(productSort:)
                   forControlEvents:UIControlEventTouchUpInside];
            [salesSortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, TFScalePoint(20), 0, TFScalePoint(40))];
            [salesSortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, TFScalePoint(60), 0, TFScalePoint(20))];
            salesSortBtn.tag = 11;
            _salesSortBtn = salesSortBtn;
            [self addSubview:salesSortBtn];
            
            UIButton *timeSortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [timeSortBtn setFrame:TFRectMakeFixWidth(214, 0, 106, 34)];
            [timeSortBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0]
                              forState:UIControlStateNormal];
            [timeSortBtn setTitle:@"上架时间" forState:UIControlStateNormal];
            [timeSortBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [timeSortBtn setImage:[UIImage imageNamed:@"licon_list_downcheck"]
                         forState:UIControlStateNormal];
            [timeSortBtn setImage:[UIImage imageNamed:@"licon_list_upcheck"]
                         forState:UIControlStateSelected];
            [timeSortBtn addTarget:self
                            action:@selector(productSort:)
                  forControlEvents:UIControlEventTouchUpInside];
            [timeSortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, TFScalePoint(12), 0, TFScalePoint(20))];
            [timeSortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, TFScalePoint(80), 0, TFScalePoint(12))];
            timeSortBtn.tag = 12;
            _timeSortBtn = timeSortBtn;
            [self addSubview:timeSortBtn];
        }
  
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:205.0/255.0 alpha:1.0].CGColor);
    if (_needRelayout)
    {
        CGContextMoveToPoint(context, TFScalePoint(81), 2);
        CGContextAddLineToPoint(context, TFScalePoint(81), rect.size.height - 2);
        
        CGContextMoveToPoint(context, TFScalePoint(162), 2);
        CGContextAddLineToPoint(context, TFScalePoint(162), rect.size.height - 2);
        
        CGContextMoveToPoint(context, TFScalePoint(243), 2);
        CGContextAddLineToPoint(context, TFScalePoint(243), rect.size.height - 2);
        
        CGContextMoveToPoint(context, 0, rect.size.height-0.5*0.5);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height-0.5*0.5);
    }
    else
    {
        CGContextMoveToPoint(context, TFScalePoint(107), 2);
        CGContextAddLineToPoint(context, TFScalePoint(107), rect.size.height - 2);
        
        CGContextMoveToPoint(context, TFScalePoint(213), 2);
        CGContextAddLineToPoint(context, TFScalePoint(213), rect.size.height - 2);
        
        CGContextMoveToPoint(context, 0, rect.size.height-0.5*0.5);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height-0.5*0.5);
    }


    if (self.showTopLine)
    {
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, rect.size.width, 0);
    }
    
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}

#pragma mark - private methods
- (void)productSort:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    NSArray *imgNames = @[@[@"licon_list_downcheck", @"licon_list_upcheck"],
                          @[@"licon_list_downcheck", @"licon_list_upcheck"],
                          @[@"licon_list_downcheck", @"licon_list_upcheck"]];
    for (NSInteger i = 0; i < 3; i ++)
    {
        UIButton *conditionBtn = (UIButton *)[self viewWithTag:i+10];
        UIImage *normal = [UIImage imageNamed:imgNames[i][0]];
        UIImage *select = [UIImage imageNamed:imgNames[i][1]];
        if (btn == conditionBtn)
        {
            normal = [normal imageWithTintColor:[UIColor redColor]];
            select = [select imageWithTintColor:[UIColor redColor]];
            [conditionBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [conditionBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [conditionBtn setImage:normal forState:UIControlStateNormal];
            [conditionBtn setImage:select forState:UIControlStateSelected];
        }
        else
        {
            [conditionBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
            [conditionBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateSelected];
            [conditionBtn setImage:normal forState:UIControlStateNormal];
            [conditionBtn setImage:select forState:UIControlStateSelected];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(didSortWithType:ascend:)])
    {
        ProductSortType type = (int)(btn.tag-9);
        BOOL ascend = btn.selected;
        
        [self.delegate didSortWithType:type ascend:ascend];
    }
}

#pragma mark public methods
//- (void)relayoutBtn
//{
//}

#pragma mark setter & getter
-(void)setNeedRelayout:(BOOL)needRelayout
{
    _needRelayout = needRelayout;
    
    _needRelayout = YES;
    
    [_priceSortBtn setFrame:TFRectMakeFixWidth(0, 3, 100, 34)];
    [_salesSortBtn setFrame:TFRectMakeFixWidth(75, 3, 100, 34)];
    [_timeSortBtn setFrame:TFRectMakeFixWidth(150, 3, 100, 34)];
    
    [self setNeedsDisplay];
}

-(void)setShaiXuanBtn:(UIButton *)shaiXuanBtn
{
    if (shaiXuanBtn != _shaiXuanBtn)
    {
        [_shaiXuanBtn removeFromSuperview];
        
        _shaiXuanBtn = shaiXuanBtn;
        
        _shaiXuanBtn.frame = TFRectMakeFixWidth(220, 8 , 100, 34);
        [_shaiXuanBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [_shaiXuanBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 30, 10, 0)];
        [self addSubview:_shaiXuanBtn];
    }
}
@end
