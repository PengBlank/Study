//
//  HYMakeWishPoolDeclareView.m
//  Teshehui
//
//  Created by HYZB on 16/3/30.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMakeWishPoolDeclareView.h"

@interface HYMakeWishPoolDeclareView ()

@property (nonatomic, strong) UIWebView *webV;
@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIView *rightLineView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *titleView;

@end

@implementation HYMakeWishPoolDeclareView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor colorWithRed:244/255.0f green:245/255.0f blue:246/255.0f alpha:1.0f];
    
    UIView *titleView = [[UIView alloc] init];
    _titleView = titleView;
//    titleView.backgroundColor = [UIColor redColor];
    [self addSubview:titleView];
    
    UIView *leftLineView = [[UIView alloc] init];
    _leftLineView = leftLineView;
    leftLineView.backgroundColor = [UIColor colorWithRed:156/255.0f green:158/255.0f blue:159/255.0f alpha:1.0f];
    [titleView addSubview:leftLineView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textColor = [UIColor colorWithRed:86/255.0f green:88/255.0f blue:89/255.0f alpha:1.0f];
    titleLab.backgroundColor = [UIColor clearColor];
    _titleLab = titleLab;
    titleLab.text = @"帮我买规则";
    [titleView addSubview:titleLab];
    
    UIView *rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor = [UIColor colorWithRed:156/255.0f green:158/255.0f blue:159/255.0f alpha:1.0f];
    _rightLineView = rightLineView;
     [titleView addSubview:rightLineView];
    
    UIWebView *webV = [[UIWebView alloc] init];
    webV.backgroundColor = [UIColor clearColor];
    [webV setOpaque:NO];
    _webV = webV;
    [self addSubview:_webV];
}

- (void)layoutSubviews
{
    _titleView.frame = CGRectMake(TFScalePoint(40), 10, TFScalePoint(240), 20);
    
    _leftLineView.frame = CGRectMake(0, 10, TFScalePoint(60), 2);
    
    _titleLab.frame = CGRectMake(CGRectGetMaxX(_leftLineView.frame)+TFScalePoint(20), 0, TFScalePoint(80), 20);
    
    _rightLineView.frame = CGRectMake(CGRectGetMaxX(_titleLab.frame)+TFScalePoint(20), 10, TFScalePoint(60), 2);
    
    _webV.frame = CGRectMake(0, 30, self.frame.size.width, self.frame.size.height-30);
}

- (void)setB5m_tips:(NSString *)b5m_tips
{
    _b5m_tips = b5m_tips;
    [_webV loadHTMLString:b5m_tips baseURL:nil];
}

@end
