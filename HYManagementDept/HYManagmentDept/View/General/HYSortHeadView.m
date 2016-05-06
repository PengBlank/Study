//
//  HYSortHeadView.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-14.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYSortHeadView.h"

#define HeadLabelFont [UIFont boldSystemFontOfSize:20]
#define HeadLabelFontPhone [UIFont boldSystemFontOfSize:14]
#define HeadFieldFont [UIFont systemFontOfSize:18.0]
#define HeadFieldFontPhone [UIFont systemFontOfSize:14]

static UIImage *btnImgN;
static UIImage *btnImgH;

@implementation HYSortHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        BOOL ispad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        UIFont *headLabelFont = ispad ? HeadLabelFont : HeadLabelFontPhone;
        UIFont *headFieldFont = ispad ? HeadFieldFont : HeadFieldFontPhone;
        _fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 50, 30)];
        _fromLabel.font = headLabelFont;
        _fromLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_fromLabel];
        
        _fromField = [[UITextField alloc] initWithFrame:CGRectZero];
        _fromField.font = headFieldFont;
        _fromField.borderStyle = UITextBorderStyleLine;
        _fromField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:_fromField];
        
        _toLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _toLabel.font = headLabelFont;
        _toLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_toLabel];
        
        _toField = [[UITextField alloc] initWithFrame:CGRectZero];
        _toField.font = headFieldFont;
        _toField.borderStyle = UITextBorderStyleLine;
        _toField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:_toField];
        
        if (!btnImgN) {
            btnImgN = [UIImage imageNamed:@"btn_head_n.png"];
            if ([btnImgN respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
                [btnImgN resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
            } else {
                [btnImgN resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            }
        }
        if (!btnImgH) {
            btnImgH = [UIImage imageNamed:@"btn_head_h.png"];
            if ([btnImgH respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
                [btnImgH resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
            } else {
                [btnImgH resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            }
        }
        
        _queryBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_queryBtn setBackgroundImage:btnImgN forState:UIControlStateNormal];
        [_queryBtn setBackgroundImage:btnImgH forState:UIControlStateHighlighted];
        [_queryBtn setTitle:@"查询" forState:UIControlStateNormal];
        [_queryBtn addTarget:self action:@selector(queryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _queryBtn.titleLabel.font = headLabelFont;
        [self addSubview:_queryBtn];
        
        _allBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_allBtn setBackgroundImage:btnImgN forState:UIControlStateNormal];
        [_allBtn setBackgroundImage:btnImgH forState:UIControlStateHighlighted];
        [_allBtn setTitle:@"全部" forState:UIControlStateNormal];
        [_allBtn addTarget:self action:@selector(allBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _allBtn.titleLabel.font = headLabelFont;
        [self addSubview:_allBtn];
        
        //_fromFieldWidth = 138;
    }
    return self;
}

- (void)setDelegate:(id<HYSortHeadViewDelegate>)delegate
{
    if (delegate) {
        _delegate = delegate;
        _fromField.delegate = delegate;
        _toField.delegate = delegate;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame;
    NSString *str = _fromLabel.text;
    CGSize size = [str sizeWithFont:_fromLabel.font];
    
    BOOL ispad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    
    CGFloat xoffset;
    CGFloat yoffset;
    CGFloat fieldWidth;
    CGFloat labelSpace;
    CGFloat btnSpace;
    CGFloat btnWidth;
    
    if (ispad)
    {
        xoffset = 12;
        yoffset = 13;
        fieldWidth = 138;
        labelSpace = 10;
        btnSpace = 20;
        btnWidth = 105;
    }
    else
    {
        xoffset = 0;
        yoffset = 5;
        fieldWidth = 138;
        labelSpace = 5;
        btnSpace = 10;
        btnWidth = 50;
    }
    
    frame = CGRectMake(xoffset, yoffset, size.width, 30);
    if (!ispad)
    {
        frame.size.width = 0;
    }
    _fromLabel.frame = frame;
    
    frame.origin.x = CGRectGetMaxX(frame);
    if (ispad)
    {
        frame.origin.x += labelSpace;
    }
    if (_fromFieldWidth != 0)
    {
        frame.size.width = _fromFieldWidth;
    }
    else
    {
        frame.size.width = fieldWidth;
    }
    
    _fromField.frame = frame;
    
    //tolabel有值的时候才显示后面
    size = [_toLabel.text sizeWithFont:_toLabel.font];
    if (size.width > 0)
    {
        if (!ispad)
        {
            frame.origin.x = CGRectGetMaxX(frame) + labelSpace;
            frame.size.width = size.width;
            _toLabel.frame = frame;
        }
        
        frame.origin.x = CGRectGetMaxX(frame) + labelSpace;
        if (_toFieldWidth != 0)
        {
            frame.size.width = _toFieldWidth;
        }
        else
        {
            frame.size.width = fieldWidth;
        }
        
        _toField.frame = frame;
    }
    
    frame.origin.x = CGRectGetMaxX(frame) + btnSpace;
    frame.size.width = btnWidth;
    _queryBtn.frame = frame;
    
    frame.origin.x = CGRectGetMaxX(frame) + labelSpace;
    _allBtn.frame = frame;
    
}

- (void)queryBtnClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(headViewDidClickedQueryBtn:)]) {
        [self.delegate headViewDidClickedQueryBtn:self];
    }
}

- (void)allBtnClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(headViewDidClickedAllBtn:)]) {
        [self.delegate headViewDidClickedAllBtn:self];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(c);
    
    CGContextSetStrokeColorWithColor(c, [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1].CGColor);
    CGContextSetLineWidth(c, 1.0);
    
    CGContextMoveToPoint(c, 0, CGRectGetHeight(rect));
    CGContextAddLineToPoint(c, CGRectGetMaxX(self.frame), CGRectGetHeight(rect));
    
    CGContextStrokePath(c);
    
    UIGraphicsPopContext();
}


@end
