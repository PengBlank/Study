//
//  HYMallFullOrderToolView.m
//  Teshehui
//
//  Created by HYZB on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallFullOrderToolView.h"

@interface HYMallFullOrderToolView ()
{
    UILabel *_priceLab;
    UILabel *_pointLab;
    UILabel *_expressLab;
}
@end

@implementation HYMallFullOrderToolView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                               green:237.0f/255.0f
                                                blue:240.0f/255.0f
                                               alpha:1.0f];
        //顶部横线
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        line.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                   topCapHeight:0];
        [self addSubview:line];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneBtn setFrame:CGRectMake(frame.size.width-160, 0, 160, 44)];
        [doneBtn setBackgroundColor:[UIColor redColor]];
        [doneBtn setTitle:@"确认" forState:UIControlStateNormal];
        [doneBtn addTarget:self
                    action:@selector(commitOrder:)
          forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:doneBtn];
        
        //合计
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 42, 24)];
        t.backgroundColor = [UIColor clearColor];
        t.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        t.font = [UIFont systemFontOfSize:18.0];
        t.text = @"合计";
        [self addSubview:t];
        
        _expressLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 32, 42, 10)];
        _expressLab.backgroundColor = [UIColor clearColor];
        _expressLab.font = [UIFont systemFontOfSize:10.0];
        _expressLab.text = @"(含运费)";
        [_expressLab setHidden:YES];
        [self addSubview:_expressLab];
        
        //¥
        UILabel *u = [[UILabel alloc] initWithFrame:CGRectMake(52, 12, 10, 10)];
        u.backgroundColor = [UIColor clearColor];
        u.font = [UIFont systemFontOfSize:12.0];
        u.textColor = [UIColor redColor];
        u.text = @"¥";
        [self addSubview:u];
        
        //128900.00
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(62, 6, 100, 20)];
        _priceLab.backgroundColor = [UIColor clearColor];
        _priceLab.textColor = [UIColor redColor];
        _priceLab.font = [UIFont boldSystemFontOfSize:18.0];
        [self addSubview:_priceLab];
        
        //消费现金券
        _pointLab = [[UILabel alloc] initWithFrame:CGRectMake(52, 28, 110, 14)];
        _pointLab.backgroundColor = [UIColor clearColor];
        _pointLab.textColor = [UIColor orangeColor];
        _pointLab.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:_pointLab];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - private methods
- (void)commitOrder:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didCommitOrder)])
    {
        [self.delegate didCommitOrder];
    }
}

#pragma mark setter/getter
- (void)setHasExpress:(BOOL)hasExpress
{
    if (hasExpress != _hasExpress)
    {
        _hasExpress = hasExpress;
        [_expressLab setHidden:!hasExpress];
    }
}

- (void)setPrice:(NSString *)price
{
    if (price != _price)
    {
        _price = price;
        _priceLab.text = price;
    }
}

- (void)setPoint:(NSInteger)point
{
    if (point != _point)
    {
        _point = point;
        _pointLab.text = [NSString stringWithFormat:@"消费现金券：%ld", point];
    }
}

@end
