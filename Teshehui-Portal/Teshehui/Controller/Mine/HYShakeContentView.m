//
//  HYShakeContentView.m
//  Teshehui
//
//  Created by HYZB on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYShakeContentView.h"
#import "HYShakeViewModel.h"
#import "HYShakeCashItem.h"
#import "HYShakeActivityItem.h"
#import "HYShakeGoodsItem.h"
#import "HYShakeProductPOModel.h"


@interface HYShakeContentView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *cashView;
@property (nonatomic, strong) UIImageView *cashImg;
@property (nonatomic, strong) UILabel *declareLab;
@property (nonatomic, strong) UILabel *discLab;
@property (nonatomic, strong) UILabel *tokenDiscTitle;
@property (nonatomic, strong) UILabel *tokenDisc;

@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) UIImageView *activityImg;
@property (nonatomic, strong) UILabel *desc;

@property (nonatomic, strong) UIView *goodsView;
@property (nonatomic, strong) UIImageView *goodsImg;
@property (nonatomic, strong) UILabel *goodsName;
@property (nonatomic, strong) UILabel *goodsPrice;


@property (nonatomic, assign) ShakeType shakeType;

@end

@implementation HYShakeContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self createContent];
        self.hidden = YES;
    }
    return self;
}

- (void)createContent
{
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
    
    UIView *contentView = [[UIView alloc] initWithFrame:TFRectMake(40, 80, 240, 310)];
    contentView.layer.cornerRadius = 10;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    _contentView = contentView;
    
    CGFloat x = CGRectGetMinX(contentView.frame) + CGRectGetWidth(contentView.frame)/2 - 1;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(contentView.frame), 2, 40)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(CGRectGetMinX(lineView.frame)-19, CGRectGetMaxY(lineView.frame)-1, 40, 40);
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"ads_cancel"] forState:UIControlStateNormal];
    [self addSubview:cancelBtn];
    _cancelBtn = cancelBtn;
    
    HYShakeCashItem *cashItem = [[HYShakeCashItem alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    [contentView addSubview:cashItem];
    [cashItem.checkBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cashItem.showBtn addTarget:self action:@selector(showBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _cashItem = cashItem;
    
    HYShakeActivityItem *actItem = [[HYShakeActivityItem alloc] initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height)];
    [actItem.detailBtn addTarget:self action:@selector(activityDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:actItem];
    _actItem = actItem;

    HYShakeGoodsItem *goodsItem = [[HYShakeGoodsItem alloc] initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height)];
    [goodsItem.detailBtn addTarget:self action:@selector(goodsDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:goodsItem];
    _goodsItem = goodsItem;
}

- (void)goodsDetailBtnAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(goDetailView)])
    {
        [self.delegate goDetailView];
    }
}

- (void)activityDetailBtnAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(goActivityView)])
    {
        [self.delegate goActivityView];
    }
}

- (void)checkBtnAction:(UIButton *)btn
{
    if ([_shakeModel.shakeType integerValue] == kShakeTypeToken)
    {
        if (_shakeModel.isSign)
        {
            if ([self.delegate respondsToSelector:@selector(goSignInView)])
            {
                [self.delegate goSignInView];
            }
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(goTokenView)])
            {
                [self.delegate goTokenView];
            }
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(goBalanceView)])
        {
            [self.delegate goBalanceView];
        }
    }
}

- (void)showBtnAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(goShowView)])
    {
        [self.delegate goShowView];
    }
}

-(void)setShakeModel:(HYShakeViewModel *)shakeModel
{
    _shakeModel = shakeModel;
    _shakeType = [shakeModel.shakeType integerValue];
//    _shakeType = kShakeTypeCash;
    if (_shakeType == kShakeTypeGoods)
    {
        _goodsItem.hidden = NO;
        _actItem.hidden = YES;
        _cashItem.hidden = YES;
        
        _goodsItem.shakeModel = shakeModel;
        HYShakeProductPOModel *productModel = [[HYShakeProductPOModel alloc] initWithDictionary:shakeModel.productPO error:nil];
        
        _goodsItem.productModel = productModel;
    }
    else if (_shakeType == kShakeTypeActivity)
    {
        _actItem.hidden = NO;
        _cashItem.hidden = YES;
        _goodsItem.hidden = YES;
        _actItem.shakeModel = shakeModel;
    }
    else if (_shakeType == kShakeTypeToken || _shakeType == kShakeTypeCash)
    {
        _cashItem.hidden = NO;
        _actItem.hidden = YES;
        _goodsItem.hidden = YES;
        _cashItem.shakeModel = shakeModel;
    }
}


@end
