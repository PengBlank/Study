//
//  HYFlightRefounView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightRefundView.h"

@interface HYFlightRefundView ()
{
    UILabel *_Label1;
    UILabel *_changeLab;
    
    UILabel *_refundLab;
    UILabel *_label2;
    UILabel *_remarkLab;
    UILabel *_label3;
}
@end

@implementation HYFlightRefundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 4,80, 18)];
        _Label1.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_Label1 setFont:[UIFont systemFontOfSize:12]];
        _Label1.backgroundColor = [UIColor clearColor];
        _Label1.text = @"更改条件:";
        [self addSubview:_Label1];
        
        _changeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _changeLab.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        [_changeLab setFont:[UIFont systemFontOfSize:12]];
        _changeLab.backgroundColor = [UIColor clearColor];
        _changeLab.lineBreakMode = NSLineBreakByCharWrapping;
        _changeLab.numberOfLines = 0;
        [self addSubview:_changeLab];
        
        _label2 = [[UILabel alloc] initWithFrame:CGRectZero];
        _label2.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_label2 setFont:[UIFont systemFontOfSize:12]];
        _label2.backgroundColor = [UIColor clearColor];
        _label2.text = @"退票条件:";
        [self addSubview:_label2];
        
        _refundLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _refundLab.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        [_refundLab setFont:[UIFont systemFontOfSize:12]];
        _refundLab.backgroundColor = [UIColor clearColor];
        _refundLab.lineBreakMode = NSLineBreakByCharWrapping;
        _refundLab.numberOfLines = 0;
        [self addSubview:_refundLab];
        
        _label3 = [[UILabel alloc] initWithFrame:CGRectZero];
        _label3.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_label3 setFont:[UIFont systemFontOfSize:12]];
        _label3.backgroundColor = [UIColor clearColor];
        _label3.text = @"备注:";
        [self addSubview:_label3];

        _remarkLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _remarkLab.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        [_remarkLab setFont:[UIFont systemFontOfSize:12]];
        _remarkLab.backgroundColor = [UIColor clearColor];
        _remarkLab.lineBreakMode = NSLineBreakByCharWrapping;
        _remarkLab.numberOfLines = 0;
        [self addSubview:_remarkLab];
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

- (void)setRules:(HYFlightRTRules *)rules
{
    if (rules != _rules)
    {
        _rules = rules;
        CGFloat orig_y = 0;
        
        BOOL hasChange = ([rules.Change length] > 0);
        [_changeLab setHidden:!hasChange];
        [_Label1 setHidden:!hasChange];
        
        if (hasChange)
        {
            _changeLab.frame = CGRectMake(0, 26, TFScalePoint(270), rules.changeHeight);
            _changeLab.text = rules.Change;
            
            orig_y += (rules.changeHeight+26);
        }
        
        
        BOOL hasRefund = ([rules.Refund length] > 0);
        [_label2 setHidden:!hasRefund];
        [_refundLab setHidden:!hasRefund];
        
        if (hasRefund)
        {
            _label2.frame = CGRectMake(0, orig_y+6, 270, 18);
            _refundLab.frame = CGRectMake(0, orig_y+26, TFScalePoint(270), rules.refundHeight);
            _refundLab.text = rules.Refund;
            
            orig_y += (rules.refundHeight+26);
        }
        
        BOOL hasRemark = ([rules.Remark length] > 0);
        [_label3 setHidden:!hasRemark];
        [_remarkLab setHidden:!hasRemark];
        
        if (hasRemark > 0)
        {
            _label3.frame = CGRectMake(0, orig_y+6, 270, 18);
            _remarkLab.frame = CGRectMake(0, orig_y+26, TFScalePoint(270), rules.remarkHeight);
            _remarkLab.text = rules.Remark;
        }
    }
}

@end
