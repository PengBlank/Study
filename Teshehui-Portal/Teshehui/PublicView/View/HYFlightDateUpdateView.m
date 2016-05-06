//
//  HYFlightDateUpdateView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightDateUpdateView.h"

@interface HYFlightDateUpdateView ()

@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation HYFlightDateUpdateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        /**
         *  按钮铺于底部，图标与文字放在self上
         */
        
        self.backgroundColor = [UIColor whiteColor];
        UIImage *selectBg = [[UIImage imageNamed:@"btn_flightnavigation_pressed"] stretchableImageWithLeftCapWidth:20
                                                                                                      topCapHeight:0];
        
        UIButton *pDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pDateBtn.frame = TFRectMakeFixWidth(0, 2, 105, 38);
        [pDateBtn setBackgroundImage:selectBg
                                forState:UIControlStateHighlighted];
        [pDateBtn addTarget:self
                         action:@selector(preDateEvent:)
               forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pDateBtn];

        
        UIButton *nDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nDateBtn.frame = TFRectMakeFixWidth(215, 2, 105, 38);
        [nDateBtn setBackgroundImage:selectBg
                                forState:UIControlStateHighlighted];
        [nDateBtn addTarget:self
                         action:@selector(nextDateEvent:)
               forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nDateBtn];
        
        UIImageView *lIcon = [[UIImageView alloc] initWithFrame:TFRectMakeFixWidth(10, 12, 10, 15)];
        lIcon.image = [UIImage imageNamed:@"ico_arrow_l"];
        [self addSubview:lIcon];
        
        UIImageView *rIcon = [[UIImageView alloc] initWithFrame:TFRectMakeFixWidth(300, 12, 10, 15)];
        rIcon.image = [UIImage imageNamed:@"ico_arrow_r"];
        [self addSubview:rIcon];
        
        UIImage *line = [[UIImage imageNamed:@"Line_InCell"] stretchableImageWithLeftCapWidth:0
                                                                                 topCapHeight:4];
        UIImageView *lline = [[UIImageView alloc] initWithFrame:TFRectMakeFixWidth(106, 0, 1, 40)];
        lline.image = line;
        [self addSubview:lline];
        
        UIImageView *rline = [[UIImageView alloc] initWithFrame:TFRectMakeFixWidth(214, 0, 1, 40)];
        rline.image = line;
        [self addSubview:rline];
        
        UILabel *pDayLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(30, 11, 46, 18)];
        pDayLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [pDayLab setFont:[UIFont systemFontOfSize:15]];
        pDayLab.backgroundColor = [UIColor clearColor];
        pDayLab.textAlignment = NSTextAlignmentCenter;
        pDayLab.text = NSLocalizedString(@"前一天", nil);
        [self addSubview:pDayLab];
        
        UILabel *nDayLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(244, 11, 46, 18)];
        nDayLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [nDayLab setFont:[UIFont systemFontOfSize:15]];
        nDayLab.backgroundColor = [UIColor clearColor];
        nDayLab.textAlignment = NSTextAlignmentCenter;
        nDayLab.text = NSLocalizedString(@"后一天", nil);
        [self addSubview:nDayLab];
        
        _dateLabel = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(106, 11, 108, 18)];
        _dateLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_dateLabel setFont:[UIFont systemFontOfSize:16]];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dateLabel];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    //画出底部横线
    CGFloat lineWidth = 0.25f;
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(context, 0, 40-lineWidth * 0.25f);
    CGContextAddLineToPoint(context, rect.size.width, 40-lineWidth * 0.25f);
    CGContextStrokePath(context);
}

#pragma mark private methods
- (void)preDateEvent:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(searchLastDayFlight)])
    {
        [self.delegate searchLastDayFlight];
    }
}

- (void)nextDateEvent:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(searchNextDayFlight)])
    {
        [self.delegate searchNextDayFlight];
    }
}

@end
