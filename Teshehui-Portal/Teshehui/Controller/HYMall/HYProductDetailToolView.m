//
//  HYProductDetailToolView.m
//  Teshehui
//
//  Created by HYZB on 15/8/17.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYProductDetailToolView.h"
#import "UIImage+Addition.h"

@interface HYProductDetailToolView ()
{
    UIButton *_buyNowBtn;
    UIButton *_assistantBtn;
    UIButton *_addShoppingCarBtn;
    UIButton *_collectBtn;
    UIButton *_checkStoreBtn;
}

@end

@implementation HYProductDetailToolView

- (UIButton *)addBtn
{
    return _buyNowBtn;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                            0,
                                                                            frame.size.width,
                                                                            frame.size.height)];
        bgView.image = [UIImage imageNamed:@"store_bg_tab"];
        [self addSubview:bgView];
        
        _assistantBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_assistantBtn setImage:[UIImage imageWithNamedAutoLayout:@"productDetail_assistant"]
                        forState:UIControlStateNormal];
        [_assistantBtn setTitleColor:[UIColor colorWithWhite:0.4
                                                        alpha:1.0]
                             forState:UIControlStateNormal];
        [_assistantBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_assistantBtn setTitle:@"小秘书" forState:UIControlStateNormal];
        [_assistantBtn setFrame:CGRectMake(0, 0, 72, 44)];
        [_assistantBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 20, 20, 24)];
        [_assistantBtn setTitleEdgeInsets:UIEdgeInsetsMake(26, -20, 4, 12)];
        [_assistantBtn addTarget:self
                           action:@selector(assistantEvent:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_assistantBtn];
        
        _checkStoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkStoreBtn setImage:[UIImage imageWithNamedAutoLayout:@"check_merchant_normal"]
                        forState:UIControlStateNormal];
        [_checkStoreBtn setTitleColor:[UIColor colorWithWhite:0.4
                                                        alpha:1.0]
                             forState:UIControlStateNormal];
        [_checkStoreBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_checkStoreBtn setTitle:@"进店" forState:UIControlStateNormal];
        [_checkStoreBtn setFrame:CGRectMake(TFScalePoint(45), 0, 72, 44)];
        [_checkStoreBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 20, 20, 24)];
        [_checkStoreBtn setTitleEdgeInsets:UIEdgeInsetsMake(26, -20, 4, 12)];
        
        [_checkStoreBtn addTarget:self
                           action:@selector(checkStoreEvent:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_checkStoreBtn];
        
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectBtn setImage:[UIImage imageWithNamedAutoLayout:@"favorite_norml"]
                     forState:UIControlStateNormal];
        [_collectBtn setImage:[UIImage imageWithNamedAutoLayout:@"favorite_select"]
                     forState:UIControlStateDisabled];
        [_collectBtn setTitleColor:[UIColor colorWithWhite:0.4
                                                     alpha:1.0]
                          forState:UIControlStateNormal];
        [_collectBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectBtn setTitle:@"已收藏" forState:UIControlStateDisabled];
        [_collectBtn setFrame:CGRectMake(TFScalePoint(90), 0, 72, 44)];
        [_collectBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 20, 20, 24)];
        [_collectBtn setTitleEdgeInsets:UIEdgeInsetsMake(26, -22, 4, 12)];
        
        [_collectBtn addTarget:self
                        action:@selector(collectEvent:)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_collectBtn];
        
        _buyNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyNowBtn setFrame:TFRectMakeFixWidth(144, 0, 88, 44)];
        [_buyNowBtn setBackgroundColor:[UIColor colorWithRed:235.0/255.0
                                                       green:155.0/255.0
                                                        blue:40.0/255.0
                                                       alpha:1.0]];
        [_buyNowBtn setTitle:@"加入购物车"
                    forState:UIControlStateNormal];
        [_buyNowBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_buyNowBtn addTarget:self
                       action:@selector(addToShoppingCarEvent:)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_buyNowBtn];
        
        _addShoppingCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addShoppingCarBtn setFrame:TFRectMakeFixWidth(232, 0, 88, 44)];
        [_addShoppingCarBtn setTitle:@"立即购买"
                            forState:UIControlStateNormal];
        [_addShoppingCarBtn setBackgroundColor:[UIColor colorWithRed:216.0/255.0
                                                       green:42.0/255.0
                                                        blue:46.0/255.0
                                                       alpha:1.0]];
        [_addShoppingCarBtn setTitleColor:[UIColor whiteColor]
                                 forState:UIControlStateNormal];
        [_addShoppingCarBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_addShoppingCarBtn addTarget:self
                               action:@selector(buyNowEvent:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addShoppingCarBtn];
    }
    return self;
}

#pragma mark - setter/Getter
- (void)setIsCollect:(BOOL)isCollect
{
    if (isCollect != _isCollect)
    {
        _isCollect = isCollect;
        if (isCollect) {
            _collectBtn.enabled = NO;
        }
    }
}

- (void)setIsCanBuy:(BOOL)isCanBuy
{
    if (isCanBuy != _isCanBuy)
    {
        _isCanBuy = isCanBuy;
        [_addShoppingCarBtn setEnabled:isCanBuy];
    }
}

#pragma mark private methods
- (void)addToShoppingCarEvent:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(addToShoppingCar)])
    {
        [self.delegate addToShoppingCar];
    }
}

- (void)checkStoreEvent:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(checkMoreProductWithStore)])
    {
        [self.delegate checkMoreProductWithStore];
    }
}

- (void)collectEvent:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(collectProduct)])
    {
        [self.delegate collectProduct];
    }
}

- (void)buyNowEvent:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(buyNow)])
    {
        [self.delegate buyNow];
    }
}

- (void)assistantEvent:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(setupHuanXin)])
    {
        [self.delegate setupHuanXin];
    }
}

@end
