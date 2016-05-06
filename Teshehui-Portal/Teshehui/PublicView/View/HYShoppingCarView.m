//
//  HYBuyCarView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYShoppingCarView.h"
#import "HYGetCartGoodsAmountRequest.h"

@implementation HYShoppingCarView

+ (HYShoppingCarView *)sharedView
{
    static dispatch_once_t once;
    static HYShoppingCarView *sharedView;
    dispatch_once(&once, ^ { sharedView = [[HYShoppingCarView alloc] initWithDefualt]; });
    return sharedView;
}

- (id)initWithDefualt
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.x = 5;
    frame.origin.y = (frame.size.height-TFScalePoint(90));
    frame.size.width = 50;
    frame.size.height = 40;
    self = [super initWithFrame:frame];
    if (self)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 5, 35, 35);
        [btn setImage:[UIImage imageNamed:@"shopping_car"] forState:UIControlStateNormal];
        [btn addTarget:self
                action:@selector(checkBuyCarEvent:)
      forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        _quantityLab = [[UILabel alloc] initWithFrame:CGRectMake(26, 0, 16, 16)];
        _quantityLab.backgroundColor = [UIColor redColor];
        _quantityLab.layer.cornerRadius = 8;
        _quantityLab.layer.masksToBounds = YES;
        _quantityLab.textColor = [UIColor whiteColor];
        _quantityLab.textAlignment = NSTextAlignmentCenter;
        _quantityLab.font = [UIFont systemFontOfSize:14];
        [_quantityLab setHidden:YES];
        [self addSubview:_quantityLab];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
#pragma mark setter/getter
- (void)setQuantity:(NSInteger)quantity
{
    if (_quantity != quantity)
    {
        _quantity = quantity;
        [_quantityLab setHidden:(quantity == 0)];
        
        if (quantity > 0)
        {
            _quantityLab.text = [NSString stringWithFormat:@"%ld", quantity];
        }
    }
}

#pragma mark private methods
- (void)checkBuyCarEvent:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didCheckBuyCarList)])
    {
        [self.delegate didCheckBuyCarList];
    }
}

- (void)updateQuantity
{
    BOOL islogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (islogin)
    {
        __weak typeof(self) b_self = self;
        HYGetCartGoodsAmountRequest *req = [[HYGetCartGoodsAmountRequest alloc] init];
        [req sendReuqest:^(id result, NSError *error) {
            if (!error && [result isKindOfClass:[HYGetCartGoodsAmountResponse class]])
            {
                HYGetCartGoodsAmountResponse *response = (HYGetCartGoodsAmountResponse *)result;
                [b_self setQuantity:response.amount];
            }
        }];
    }
}

#pragma mark public methods
+ (void)showWithDelegate:(id<HYBuyCarViewDelegate>)delegate
{
    if (delegate)
    {
        HYShoppingCarView *view = [HYShoppingCarView sharedView];
        view.delegate = delegate;
        [view updateQuantity];
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (!view.superview)
        {
            [window addSubview:view];
        }
        
        [window bringSubviewToFront:view];
    }
}

+ (void)dismiss
{
    HYShoppingCarView *view = [HYShoppingCarView sharedView];
    if (view.superview)
    {
        [view removeFromSuperview];
    }
}

@end
