//
//  HYSignInRuleView.m
//  Teshehui
//
//  Created by HYZB on 16/3/25.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYSignInRuleView.h"

#define kLabelFont [UIFont systemFontOfSize:14];
#define kLabelTextColor [UIColor colorWithWhite:0.4 alpha:1.0f];

@interface HYSignInRuleView ()

@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *rightLineView;
@property (nonatomic, strong) UILabel *descOneLab;
@property (nonatomic, strong) UILabel *descTwoLab;
@property (nonatomic, strong) UILabel *descThreeLab;
@property (nonatomic, strong) UILabel *descFourLab;
@property (nonatomic, strong) UILabel *descFiveLab;

@end

@implementation HYSignInRuleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"shakeSignInRule" ofType:@"plist"];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        _leftLineView = [[UIView alloc] init];
        _leftLineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0f];
        [self addSubview:_leftLineView];
        
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = arr[0];
        _titleLab.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0f];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:13];
        _titleLab.layer.cornerRadius = 13.0f;
        _titleLab.clipsToBounds = YES;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
        
        _rightLineView = [[UIView alloc] init];
        _rightLineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0f];
        [self addSubview:_rightLineView];
        
        _descOneLab = [[UILabel alloc] init];
        _descOneLab.textColor = kLabelTextColor;
        _descOneLab.numberOfLines = 0;
        _descOneLab.font = kLabelFont;
        _descOneLab.text = arr[1];
        [self addSubview:_descOneLab];
        
        _descTwoLab = [[UILabel alloc] init];
        _descTwoLab.textColor = kLabelTextColor;
        _descTwoLab.numberOfLines = 0;
        _descTwoLab.font = kLabelFont;
        _descTwoLab.text = arr[2];
        [self addSubview:_descTwoLab];
        
        _descThreeLab = [[UILabel alloc] init];
        _descThreeLab.textColor = kLabelTextColor;
        _descThreeLab.numberOfLines = 0;
        _descThreeLab.font = kLabelFont;
        _descThreeLab.text = arr[3];
        [self addSubview:_descThreeLab];
        
//        _descFourLab = [[UILabel alloc] init];
//        _descFourLab.textColor = kLabelTextColor;
//        _descFourLab.numberOfLines = 0;
//        _descFourLab.font = kLabelFont;
//        _descFourLab.text = arr[4];
//        [self addSubview:_descFourLab];
//        
//        _descFiveLab = [[UILabel alloc] init];
//        _descFiveLab.textColor = kLabelTextColor;
//        _descFiveLab.numberOfLines = 0;
//        _descFiveLab.font = kLabelFont;
//        _descFiveLab.text = arr[5];
//        [self addSubview:_descFiveLab];
        self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0f];
    }
    return self;
}


- (void)layoutSubviews
{
    CGFloat x = TFScalePoint(20);
    
    _titleLab.frame = CGRectMake(self.center.x-50, 30, 100, 25);
    
    _leftLineView.frame = CGRectMake(x, 40, TFScalePoint(80), 2);
    
    _rightLineView.frame = CGRectMake(CGRectGetMaxX(_titleLab.frame)+15, 40, TFScalePoint(80), 2);
    
    CGFloat labelSpace = 5;
    _descOneLab.frame = CGRectMake(x, CGRectGetMaxY(_titleLab.frame)+15, TFScalePoint(280), 60);
    
    _descTwoLab.frame = CGRectMake(x, CGRectGetMaxY(_descOneLab.frame)+labelSpace, TFScalePoint(280), 40);
    
    _descThreeLab.frame = CGRectMake(x, CGRectGetMaxY(_descTwoLab.frame)+labelSpace, TFScalePoint(280), 20);
    
//    _descFourLab.frame = CGRectMake(x, CGRectGetMaxY(_descThreeLab.frame)+labelSpace, TFScalePoint(280), 60);
//    
//    _descFiveLab.frame = CGRectMake(x, CGRectGetMaxY(_descFourLab.frame)+labelSpace, TFScalePoint(280), 20);
}

@end
