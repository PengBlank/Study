//
//  HYHotelPriceConditionView.m
//  Teshehui
//
//  Created by RayXiang on 14-11-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelPriceConditionView.h"

@interface HYHotelPriceConditionView ()

@property (nonatomic, strong) NSArray *priceBtn;
@property (nonatomic, strong) NSArray *levelBtn;

@property (nonatomic, assign) NSInteger priceSelected;
@property (nonatomic, strong) NSMutableSet *levelSelected;

//数据
@property (nonatomic, assign) NSInteger prePriceSelected;

@end

@implementation HYHotelPriceConditionView

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    frame = CGRectMake(0, bounds.size.height, CGRectGetWidth(bounds), frame.size.height);
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        _backgroundView = [[UIView alloc] initWithFrame:bounds];
        _backgroundView.backgroundColor = [UIColor clearColor];
        _backgroundView.alpha = .5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap:)];
        [_backgroundView addGestureRecognizer:tap];
        
        /*界面元系*/
        UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 15)];
        priceLab.text = @"价格(单选)";
        priceLab.font = [UIFont systemFontOfSize:14.0];
        priceLab.backgroundColor = [UIColor clearColor];
        [self addSubview:priceLab];
        
        UIImage *img = [UIImage imageNamed:@"icon_list8"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7) resizingMode:UIImageResizingModeStretch];
        UIImage *imgh = [UIImage imageNamed:@"icon_list7"];
        imgh = [imgh resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7) resizingMode:UIImageResizingModeStretch];
        
        //按钮
        //不限
        NSMutableArray *priceBtns = [NSMutableArray array];
        CGFloat width = (CGRectGetWidth(self.frame) - 20 - 15) / 4;
        CGFloat x = 10;
        CGFloat y = CGRectGetMaxY(priceLab.frame)+5;
        for (NSInteger i = 0; i < 7; i++)
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, 35)];
            button.backgroundColor = [UIColor whiteColor];
            [button setTitle:[HYHotelPrice priceDescWithLevel:i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:77/255.0 green:208/255.0 blue:246/255.0 alpha:1] forState:UIControlStateSelected];
            [button setBackgroundImage:img forState:UIControlStateNormal];
            [button setBackgroundImage:imgh forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [self addSubview:button];
            [priceBtns addObject:button];
            
            if (i % 4 == 3)
            {
                x = 10;
                y += 35 + 5;
            }
            else
            {
                x += width + 5;
            }
        }
        self.priceBtn = priceBtns;
        
        //星级
        NSMutableArray *levelBtns = [NSMutableArray array];
        UILabel *levelLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY([[priceBtns lastObject] frame])+20, width, 15)];
        levelLab.text = @"星级(复选)";
        levelLab.font = [UIFont systemFontOfSize:15.0];
        levelLab.backgroundColor = [UIColor clearColor];
        [self addSubview:levelLab];
        
        width = (CGRectGetWidth(self.frame) - 20 - 2) / 3;
        x = 10;
        y = CGRectGetMaxY(levelLab.frame) + 10;
        NSArray *titles = @[@"不限",
                           @"二星及以下/经济",
                           @"三星/舒适",
                           @"四星/高档",
                           @"五星/豪华"];
        for (NSInteger i = 0; i < 5; i++)
        {
            UIButton* button = [[UIButton alloc] initWithFrame:
                      CGRectMake(x,
                                 y,
                                 width,
                                 35)];
            button.backgroundColor = [UIColor whiteColor];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:77/255.0 green:208/255.0 blue:246/255.0 alpha:1] forState:UIControlStateSelected];
            [button setBackgroundImage:img forState:UIControlStateNormal];
            [button setBackgroundImage:imgh forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [self addSubview:button];
            [levelBtns addObject:button];
            
            if (i % 3 == 2)
            {
                x = 10;
                y += 35 + 5;
            }
            else
            {
                x += width + 5;
            }
        }
        
        UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY([[levelBtns lastObject] frame])+20, CGRectGetWidth(self.frame)-30, 44)];
        UIImage *bg = [UIImage imageNamed:@"person_buttom_orange1_normal.png"];
        bg = [bg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        [submit setBackgroundImage:bg forState:UIControlStateNormal];
        [submit setTitle:@"确定" forState:UIControlStateNormal];
        submit.titleLabel.textColor = [UIColor whiteColor];
        submit.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [submit addTarget:self
                   action:@selector(submitAction:)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:submit];
        
        //默认选中0，加事件处理
        self.levelBtn = [NSArray arrayWithArray:levelBtns];
        _priceSelected = -1;
        self.priceSelected = 0;
        for (UIButton *pbtn in self.priceBtn)
        {
            [pbtn addTarget:self action:@selector(priceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        //默认选中0
        for (UIButton *lbtn in self.levelBtn)
        {
            [lbtn addTarget:self action:@selector(levelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self levelBtnAction:[_levelBtn objectAtIndex:0]];
        
    }
    return self;
}

- (void)setCondition:(HYHotelCondition *)condition
{
    _condition = condition;
    _prePriceSelected = _condition.hotelPrice.priceLevel;
    
    NSMutableArray *hotelstars = _condition.hotelStars;
    if (hotelstars.count > 0)
    {
        for (HYHotelStar *hotelstar in hotelstars)
        {
            UIButton *btn = [_levelBtn objectAtIndex:hotelstar.index];
            [_levelSelected addObject:btn];
        }
        for (UIButton *btn in _levelBtn)
        {
            if ([_levelSelected containsObject:btn])
            {
                [self configurBtnSelected:btn];
            }
            else
            {
                [self configurBtnNormal:btn];
            }
        }
    }
    
    [self setPriceSelected:_prePriceSelected];
}

//- (void)reloadWithCondition
//{
//    NSArray *priceSelect = [_condition selectStatesFor:HotelConditionPrice];
//    if (!priceSelect || priceSelect.count == 0) {
//        priceSelect = [priceSelect arrayByAddingObject:@0];
//    }
//    for (int i = 0; i < _priceBtn.count; i++)
//    {
//        UIButton *priceBtn = [_priceBtn objectAtIndex:i];
//        if ([priceSelect containsObject:[NSNumber numberWithInteger:i]])
//        {
//            [self configurBtnSelected:priceBtn];
//        }
//        else
//        {
//            [self configurBtnNormal:priceBtn];
//        }
//    }
//    
//    NSArray *starSelect = [_condition selectStatesFor:HotelConditionStar];
//    if (!starSelect || starSelect.count == 0) {
//        starSelect = [starSelect arrayByAddingObject:@0];
//    }
//    for (int i = 0; i < _levelBtn.count; i++)
//    {
//        UIButton *priceBtn = [_levelBtn objectAtIndex:i];
//        if ([starSelect containsObject:[NSNumber numberWithInteger:i]])
//        {
//            [self configurBtnSelected:priceBtn];
//        }
//        else
//        {
//            [self configurBtnNormal:priceBtn];
//        }
//    }
//}

/**
 *  @brief  点按周围取消
 *
 *  @param tap
 */
- (void)bgTap:(UITapGestureRecognizer *)tap
{
    [self dismissWithAnimation:YES];
}

/**
 *  @brief  提交
 *
 *  @param btn
 */
- (void)submitAction:(UIButton *)btn
{
    _condition.hotelPrice = [HYHotelPrice hotelPriceWithPriceLevel:_priceSelected];
    NSMutableArray *hotelStars = [NSMutableArray array];
    for (UIButton *btn in _levelSelected)
    {
        NSInteger index = [_levelBtn indexOfObject:btn];
        [hotelStars addObject:[HYHotelStar hotelStarWithIndex:index]];
    }
    _condition.hotelStars = hotelStars;
    
    if ([self.delegate respondsToSelector:@selector(hotelConditionChanged:)])
    {
        [self.delegate hotelConditionChanged:_condition];
    }
    [self dismissWithAnimation:YES];
}

/**
 *  @brief  价格按钮事件
 *
 *  @param btn
 */
- (void)priceBtnAction:(UIButton *)btn
{
    NSInteger idx = [_priceBtn indexOfObject:btn];
    [self setPriceSelected:idx];
}

/**
 *  @brief  设价格按钮逻辑，单选按钮
 *
 *  @param priceSelected
 */
- (void)setPriceSelected:(NSInteger)priceSelected
{
    if (_priceSelected != priceSelected)
    {
        if (_priceSelected >= 0 && _priceSelected < _priceBtn.count)
        {
            UIButton *btn = [_priceBtn objectAtIndex:_priceSelected];
            [self configurBtnNormal:btn];
        }
        _priceSelected = priceSelected;
        if (priceSelected >= 0 && priceSelected < _priceBtn.count)
        {
            UIButton *btn = [_priceBtn objectAtIndex:_priceSelected];
            [self configurBtnSelected:btn];
        }
    }
}

/**
 *  @brief  星级按钮事件
 *
 *  @param btn
 */
- (void)levelBtnAction:(UIButton *)btn
{
    NSInteger idx = [_levelBtn indexOfObject:btn];
    if (!_levelSelected) {
        _levelSelected = [[NSMutableSet alloc] init];
    }
    if (idx == 0)
    {
        for (UIButton *levelbtn in _levelSelected)
        {
            [self configurBtnNormal:levelbtn];
        }
        [_levelSelected removeAllObjects];
        UIButton *btn = [_levelBtn objectAtIndex:0];
        [self configurBtnSelected:btn];
    }
    else
    {
        if ([_levelSelected containsObject:btn])
        {
            [_levelSelected removeObject:btn];
        }
        else
        {
            [_levelSelected addObject:btn];
        }
        for (UIButton *btn in _levelBtn)
        {
            if ([_levelSelected containsObject:btn])
            {
                [self configurBtnSelected:btn];
            }
            else
            {
                [self configurBtnNormal:btn];
            }
        }
    }
}

/**
 *  @brief  选中或普通情况的按钮
 *
 *  @param btn
 */
- (void)configurBtnSelected:(UIButton *)btn
{
//    btn.backgroundColor = [UIColor colorWithRed:0 green:196/255.0 blue:236/255.0 alpha:1];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.selected = YES;
}

- (void)configurBtnNormal:(UIButton *)btn
{
//    btn.backgroundColor = [UIColor whiteColor];
//    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.selected = NO;
}



- (void)showWithAnimation:(BOOL)animation
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:_backgroundView];
    [window addSubview:self];
    
    if (animation) {
        [UIView beginAnimations:@"bg" context:nil];
    }
    
    _backgroundView.backgroundColor = [UIColor blackColor];
    
    if (animation) {
        [UIView commitAnimations];
    }
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGPoint point = CGPointMake(CGRectGetMidX(frame), CGRectGetHeight(frame)-CGRectGetMidY(self.bounds));
    if (animation)
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.center = point;
                         }];
    }
    else
    {
        self.center = point;
    }
}

- (void)dismissWithAnimation:(BOOL)animation
{
    if ([self superview])
    {
        if (animation)
        {
            [UIView animateWithDuration:.3 animations:^
            {
                _backgroundView.backgroundColor = [UIColor clearColor];
            } completion:^(BOOL finished) {
                [_backgroundView removeFromSuperview];
            }];
        }
        else
        {
            [_backgroundView removeFromSuperview];
        }
        
        CGRect frame = [[UIScreen mainScreen] bounds];
        CGPoint point = CGPointMake(CGRectGetMidX(frame), frame.size.height+self.frame.size.height/2);
        
        if (animation)
        {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.center = point;
                             } completion:^(BOOL finished) {
                                 [self removeFromSuperview];
                             }];
        }
        else
        {
            [self removeFromSuperview];
        }
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
