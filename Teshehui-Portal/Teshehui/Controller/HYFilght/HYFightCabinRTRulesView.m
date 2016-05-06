//
//  HYFightCabinRTRules.m
//  Teshehui
//
//  Created by HYZB on 14-8-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFightCabinRTRulesView.h"
#import "HYFlightSKU.h"
#import <QuartzCore/QuartzCore.h>

#define titleLabelFont [UIFont boldSystemFontOfSize:15.0]
#define contentLabelFont [UIFont systemFontOfSize:13.0]

@interface HYFightCabinRTRulesView ()
{
    UIView *_contentView;
    UIScrollView *_scrollView;
}

@property (nonatomic, strong) CAAnimation *dimingAnimation;
@property (nonatomic, strong) CAAnimation *showMenuAnimation;
@property (nonatomic, strong) CAAnimation *dismissMenuAnimation;
@property (nonatomic, strong) CAAnimation *lightingAnimation;

@property (nonatomic, strong) HYFlightSKU *cabin;
@end

@implementation HYFightCabinRTRulesView

- (id)initWithCabinRTRules:(HYFlightSKU *)cabin
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:bounds];
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        // Initialization code
//        [UIApplication sharedApplication].statusBarHidden = YES;
        self.cabin = cabin;
        
        CGFloat scrollHeight = [self calculateContentHeight];
        
//        CGFloat maxHeight = bounds.size.height - 48 - 20;
        CGFloat bottomHeight = 70.0;
//        CGFloat contentHeight = MIN((scrollHeight+bottomHeight+10), maxHeight);
        CGFloat contentHeight = [UIScreen mainScreen].bounds.size.height;
        
        //创建contentView
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFScalePoint(320), contentHeight)];
        _contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8];
        _contentView.layer.cornerRadius = 4.0;
        [self addSubview:_contentView];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, TFScalePoint(300), contentHeight-bottomHeight-10)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentSize = CGSizeMake(TFScalePoint(300), scrollHeight);
        _scrollView.bounces = NO;
        [_contentView addSubview:_scrollView];
        
        [self addLabels];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:
                             CGRectMake(0,
                                        CGRectGetMaxY(_scrollView.frame),
                                        TFScalePoint(320), 1)];
        line.image = [UIImage imageNamed:@"hotel_line_grgy_buttom.png"];
        line.hidden = YES;
        [_contentView addSubview:line];
        
//        CGFloat x = 300 - 18 - 5;
//        y = 5;
        UIImageView *closeBtn = [[UIImageView alloc] initWithFrame:TFRectMake(302, 30, 18, 18)];
        closeBtn.image = [UIImage imageNamed:@"btn_closeicon"];
        [_contentView addSubview:closeBtn];
        
//        NSString *cabinName = _cabin.expandedResponse.cabinName;
//        cabinName = [cabinName stringByAppendingFormat:@"¥%0.0f", _cabin.price.floatValue];
//        UIFont *font1 = [UIFont systemFontOfSize:18.0];
//        CGSize size = [cabinName sizeWithFont:font1
//                            constrainedToSize:CGSizeMake(TFScalePoint(80), 30) lineBreakMode:NSLineBreakByTruncatingTail];
//        CGFloat h = CGRectGetHeight(_contentView.frame) - CGRectGetMaxY(line.frame);
//        UILabel *cabinLabel = [[UILabel alloc] initWithFrame:
//                               CGRectMake(10,
//                                          CGRectGetMaxY(line.frame) + (h - size.height)/2,
//                                          size.width,
//                                          size.height)];
//        cabinLabel.text = cabinName;
//        cabinLabel.textColor = [UIColor whiteColor];
//        cabinLabel.backgroundColor = [UIColor clearColor];
//        cabinLabel.font = font1;
        //the white view of the bottom
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = [UIColor whiteColor];
        bottomView.frame = CGRectMake(TFScalePoint(0),
                                      CGRectGetMaxY(line.frame),
                                      TFScalePoint(320),
                                      70);
        [_contentView addSubview:bottomView];
        
        //底部的总额
        UILabel *totalFeeLabel = [UILabel new];
        totalFeeLabel.text = @"总额:";
        totalFeeLabel.textColor = [UIColor grayColor];
        totalFeeLabel.frame = CGRectMake(10,
                                         25,
                                         70,
                                         20);
        totalFeeLabel.font = [UIFont systemFontOfSize:13];
        [bottomView addSubview:totalFeeLabel];
        
        //现金
        UILabel *cashLabel = [UILabel new];
        cashLabel.text = [NSString stringWithFormat:@"¥%0.2f", _cabin.price.floatValue];
        cashLabel.textColor = [UIColor redColor];
        cashLabel.frame = CGRectMake(55, CGRectGetMinY(totalFeeLabel.frame)-20, 100, 20);
        [bottomView addSubview:cashLabel];
        
        //总现金券
        UILabel *quanLabel = [UILabel new];
        quanLabel.text = [NSString stringWithFormat:@"现金券:%0.0f", _cabin.points.floatValue];
        quanLabel.textColor = [UIColor orangeColor];
        quanLabel.frame = CGRectMake(55, CGRectGetMinY(totalFeeLabel.frame) + 20, 100, 20);
        quanLabel.font = [UIFont systemFontOfSize:13];
        [bottomView addSubview:quanLabel];
        
        // 返现
        UILabel *returnAmount = [[UILabel alloc] initWithFrame:CGRectMake(55, CGRectGetMinY(totalFeeLabel.frame), 100, 20)];
        int i = [_cabin.returnAmount intValue];
        if (_cabin.returnAmount && i != 0) {
            
            returnAmount.hidden = NO;
            returnAmount.text = [NSString stringWithFormat:@"返现:¥%@", _cabin.returnAmount];
        } else {
            
            returnAmount.hidden = YES;
            quanLabel.frame = returnAmount.frame;
        }
        returnAmount.textColor = [UIColor orangeColor];
        returnAmount.font = [UIFont systemFontOfSize:13];
        [bottomView addSubview:returnAmount];
        
 /*
        if (_cabin.expandedResponse.discount.floatValue < 10)
        {
            NSNumber *nDisc = [NSNumber numberWithFloat:_cabin.expandedResponse.discount.floatValue];
            NSString *discount = [NSString stringWithFormat:@"%@折", nDisc];
            CGFloat space = 5;
            CGFloat off = 220 - size.width - space;
            if (off > 0)
            {
                UIFont *font = [UIFont systemFontOfSize:12.0];
                CGSize size = [discount sizeWithFont:font
                                   constrainedToSize:CGSizeMake(TFScalePoint(off), font.lineHeight)];
                if (size.width <= off) {
                    CGFloat desc = font1.descender - font.descender;
                    UILabel *discountLabel = [[UILabel alloc] initWithFrame:
                                              CGRectMake(CGRectGetMaxX(cabinLabel.frame) + space,
                                                         CGRectGetMaxY(cabinLabel.frame)-size.height + desc,
                                                         size.width,
                                                         size.height)];
                    discountLabel.font = font;
                    discountLabel.text = discount;
                    discountLabel.backgroundColor = [UIColor clearColor];
                    discountLabel.textColor = [UIColor whiteColor];
                    [_contentView addSubview:discountLabel];
                }
            }
        }
  */
        
        UIImage *btnBg = [UIImage imageNamed:@"person_buttom_orange1_normal.png"];
        if ([btnBg respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
            btnBg = [btnBg resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)
                                          resizingMode:UIImageResizingModeStretch];
        } else {
            btnBg = [btnBg resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        }
        UIButton *buyBtn = [[UIButton alloc] initWithFrame:
                            CGRectMake(TFScalePoint(240),
                                       CGRectGetMaxY(line.frame),
                                       TFScalePoint(80),
                                       70)];
        [buyBtn setBackgroundImage:btnBg forState:UIControlStateNormal];
        buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        NSString *buyT = [NSString stringWithFormat:@"立即预定"];
        [buyBtn setTitle:buyT forState:UIControlStateNormal];
        [buyBtn addTarget:self
                   action:@selector(buyAction:)
         forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:buyBtn];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (CGFloat)calculateContentHeight
{
    if (_cabin)
    {
        CGFloat scrollHeight = 0;
        NSString *changeTitle = @"退改签说明";
        NSString *refunTitle = @"退票说明";
        NSString *otherTitle = @"其他";
        if (_cabin.expandedResponse.alertedRule.length > 0)
        {
            CGSize size = [changeTitle sizeWithFont:titleLabelFont
                                  constrainedToSize:CGSizeMake(TFScalePoint(280), 300)];
            scrollHeight += size.height;
            scrollHeight += 10;
            
            size = [_cabin.expandedResponse.alertedRule sizeWithFont:contentLabelFont
                                  constrainedToSize:CGSizeMake(TFScalePoint(280), 1000)];
            scrollHeight += size.height;
            
            scrollHeight += 10;
        }
        if (_cabin.expandedResponse.refundRule.length > 0)
        {
            //第二行起与前一部分的距离
            scrollHeight += 10;
            
            CGSize size = [refunTitle sizeWithFont:titleLabelFont
                                 constrainedToSize:CGSizeMake(TFScalePoint(280), 300)];
            scrollHeight += size.height;
            scrollHeight += 10;
            
            size = [_cabin.expandedResponse.refundRule sizeWithFont:contentLabelFont
                                  constrainedToSize:CGSizeMake(TFScalePoint(280), 1000)];
            scrollHeight += size.height;
            
            scrollHeight += 10;
        }
        
        if (_cabin.expandedResponse.otherRule.length > 0)
        {
            //第二行起与前一部分的距离
            scrollHeight += 10;
            
            CGSize size = [otherTitle sizeWithFont:titleLabelFont
                                 constrainedToSize:CGSizeMake(TFScalePoint(280), 300)];
            scrollHeight += size.height;
            scrollHeight += 10;
            
            size = [_cabin.expandedResponse.otherRule sizeWithFont:contentLabelFont
                                 constrainedToSize:CGSizeMake(TFScalePoint(280), 1000)];
            scrollHeight += size.height;
            
            scrollHeight += 10;
        }
        return scrollHeight;
    }
    return 0;
}

- (void)addLabels
{
    if (!_scrollView) {
        return;
    }
    
    //购票说明
    NSString *topTitle = @"购票说明";
    
    UILabel *topTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 70, 20)];
    topTitleLabel.text = topTitle;
    topTitleLabel.backgroundColor = [UIColor clearColor];
    topTitleLabel.textColor = [UIColor whiteColor];
    topTitleLabel.font = titleLabelFont;
    [_scrollView addSubview:topTitleLabel];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 48, TFScalePoint(280), 1)];
    line.image = [UIImage imageNamed:@"hotel_line_grgy_buttom.png"];
    [_scrollView addSubview:line];
    
    
    NSArray *titles = [self titleAndContents];
    
    CGFloat y = 60;
    for (NSUInteger i = 0; i < titles.count; i++)
    {
        //如果不是第一块，起始位置应该是分隔线向下偏移10
        if (i != 0) {
            y += 10;
        }
        
        NSString *title = [titles objectAtIndex:i][@"title"];
        NSString *content = [titles objectAtIndex:i][@"content"];
        
        CGSize size = [title sizeWithFont:titleLabelFont
                             constrainedToSize:CGSizeMake(TFScalePoint(280), 300)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, size.width, size.height)];
        titleLabel.text = title;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = titleLabelFont;
        [_scrollView addSubview:titleLabel];
        
        y += size.height + 20;  //10是标题到内容的距离
        
        size = [content sizeWithFont:contentLabelFont
                   constrainedToSize:CGSizeMake(TFScalePoint(280), 1000)];
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, size.width, size.height)];
        contentLabel.numberOfLines = 0;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = contentLabelFont;
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.text = content;
        [_scrollView addSubview:contentLabel];
        
        y += size.height + 10;
        
        //横线
        if (i < titles.count - 1) {
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, y, TFScalePoint(280), 1)];
            line.image = [UIImage imageNamed:@"hotel_line_grgy_buttom.png"];
            [_scrollView addSubview:line];
        }
    }
}

- (NSArray *)contents
{
    NSMutableArray *contents = [NSMutableArray array];
    if (_cabin.expandedResponse.alertedRule.length > 0) {
        [contents addObject:_cabin.expandedResponse.alertedRule];
    }
    if (_cabin.expandedResponse.refundRule.length > 0) {
        [contents addObject:_cabin.expandedResponse.refundRule];
    }
    if (_cabin.expandedResponse.otherRule.length > 0) {
        [contents addObject:_cabin.expandedResponse.otherRule];
    }
    return contents;
}

- (NSArray *)titleAndContents
{
    NSMutableArray *titles = [NSMutableArray array];
    
    if (_cabin.expandedResponse.refundRule.length > 0)
    {
        [titles addObject:@{@"title": @"退改签说明",
                            @"content": _cabin.expandedResponse.refundRule}];
    }
    
    if (_cabin.expandedResponse.alertedRule.length > 0)
    {
        [titles addObject:@{@"title": @"改签规则",
                            @"content": _cabin.expandedResponse.alertedRule}];
    }
    
    if (_cabin.expandedResponse.otherRule.length > 0)
    {
        [titles addObject:@{@"title": @"其他",
                            @"content": _cabin.expandedResponse.otherRule}];
    }
    return titles;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    [self dismiss];
}

- (void)buyAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(rulesViewDidClickBuyWithCabins:)])
    {
        [self.delegate rulesViewDidClickBuyWithCabins:_cabin];
    }
    [self dismiss];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)showWithAnimation:(BOOL)animation
{
    if (![self superview]) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
    }
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.2];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [self.layer addAnimation:self.dimingAnimation forKey:@"diming"];
    [_contentView.layer addAnimation:self.showMenuAnimation forKey:@"showMenu"];
    [CATransaction commit];
}

- (void)dismiss
{
    if ([self superview])
    {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [CATransaction setCompletionBlock:^{
            [self removeFromSuperview];
        }];
        [self.layer addAnimation:self.lightingAnimation forKey:@"lighting"];
        [_contentView.layer addAnimation:self.dismissMenuAnimation forKey:@"dismissMenu"];
        [CATransaction commit];
        [self removeFromSuperview];
    }
}

#pragma mark getter
- (CAAnimation *)dimingAnimation
{
    if (_dimingAnimation == nil) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        opacityAnimation.fromValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        opacityAnimation.toValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor];
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeBoth];
        _dimingAnimation = opacityAnimation;
    }
    return _dimingAnimation;
}

- (CAAnimation *)lightingAnimation
{
    if (_lightingAnimation == nil ) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        opacityAnimation.fromValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor];
        opacityAnimation.toValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeBoth];
        _lightingAnimation = opacityAnimation;
    }
    return _lightingAnimation;
}

- (CAAnimation *)showMenuAnimation
{
    if (_showMenuAnimation == nil) {
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D t = CATransform3DIdentity;
        t.m34 = 1 / -500.0f;
        CATransform3D from = CATransform3DRotate(t, -30.0f * M_PI / 180.0f, 1, 0, 0);
        CATransform3D to = CATransform3DIdentity;
        [rotateAnimation setFromValue:[NSValue valueWithCATransform3D:from]];
        [rotateAnimation setToValue:[NSValue valueWithCATransform3D:to]];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [scaleAnimation setFromValue:@0.9];
        [scaleAnimation setToValue:@1.0];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        [positionAnimation setFromValue:[NSNumber numberWithFloat:50.0]];
        [positionAnimation setToValue:[NSNumber numberWithFloat:0.0]];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:@0.0];
        [opacityAnimation setToValue:@1.0];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        [group setAnimations:@[rotateAnimation, scaleAnimation, opacityAnimation, positionAnimation]];
        [group setRemovedOnCompletion:NO];
        [group setFillMode:kCAFillModeBoth];
        _showMenuAnimation = group;
    }
    return _showMenuAnimation;
}

- (CAAnimation *)dismissMenuAnimation
{
    if (_dismissMenuAnimation == nil) {
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D t = CATransform3DIdentity;
        t.m34 = 1 / -500.0f;
        CATransform3D from = CATransform3DIdentity;
        CATransform3D to = CATransform3DRotate(t, -30.0f * M_PI / 180.0f, 1, 0, 0);
        [rotateAnimation setFromValue:[NSValue valueWithCATransform3D:from]];
        [rotateAnimation setToValue:[NSValue valueWithCATransform3D:to]];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [scaleAnimation setFromValue:@1.0];
        [scaleAnimation setToValue:@0.9];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        [positionAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
        [positionAnimation setToValue:[NSNumber numberWithFloat:50.0]];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:@1.0];
        [opacityAnimation setToValue:@0.0];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        [group setAnimations:@[rotateAnimation, scaleAnimation, opacityAnimation, positionAnimation]];
        [group setRemovedOnCompletion:NO];
        [group setFillMode:kCAFillModeBoth];
        _dismissMenuAnimation = group;
    }
    return _dismissMenuAnimation;
}

@end
