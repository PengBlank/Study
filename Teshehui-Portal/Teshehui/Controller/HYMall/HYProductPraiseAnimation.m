//
//  HYProductPraiseAnimation.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/12.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYProductPraiseAnimation.h"
#import "NSBKeyframeAnimation.h"

@implementation HYProductPraiseAnimation

+ (void)showAnimationWithPoints:(NSInteger)points callback:(void (^)(void))callback
{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //掉金币动画
    CGFloat coin_size = TFScalePoint(147);
    CGFloat height = TFScalePoint(151);
    NSString *coin_img_name = @"praise_animation2";
    UIImage *coin_img = [UIImage imageNamed:coin_img_name];
    UIImageView *coin_v = [[UIImageView alloc] initWithImage:coin_img];
    coin_v.frame = CGRectMake(TFScalePoint(60), -height, coin_size, height);
    [window addSubview:coin_v];
    //CGFloat hit_point = 300;
    
    // 59, 44
    UIImageView *coin_label = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"praise_point"]];
    coin_label.hidden = YES;
    [window addSubview:coin_label];
    
    NSBKeyframeAnimationFunction c = NSBKeyframeAnimationFunctionEaseOutBounce;
    float startValue = coin_v.center.y;
    float endValue = 0;
    if (CGRectGetHeight([UIScreen mainScreen].bounds) > 480)
    {
        endValue = TFScalePoint(300);
    }
    else
    {
        endValue = 350;
    }
    NSBKeyframeAnimation *animation = [NSBKeyframeAnimation animationWithKeyPath:@"position.y"
                                                                        duration:1.5
                                                                      startValue:startValue
                                                                        endValue:endValue
                                                                        function:c];
    __weak typeof(coin_v) weakcoinv = coin_v;
    animation.completionBlock = ^(BOOL finished)
    {
        weakcoinv.animationImages = @[[UIImage imageNamed:@"praise_animation1"],
                                      [UIImage imageNamed:@"praise_animation2"],
                                      [UIImage imageNamed:@"praise_animation3"]];
        weakcoinv.animationDuration = .3;
        [weakcoinv startAnimating];
        
        //显示文字
        coin_label.frame = CGRectMake(TFScalePoint(180), weakcoinv.center.y, TFScalePoint(59), TFScalePoint(44));
        coin_label.transform = CGAffineTransformMakeScale(.7, .7);
        coin_label.alpha = .0;
        coin_label.hidden = NO;
        [UIView animateWithDuration:1.0 animations:^
        {
            coin_label.transform = CGAffineTransformIdentity;
            coin_label.alpha = 1;
            CGRect frame = coin_label.frame;
            frame.origin.y -= TFScalePoint(20);
            coin_label.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
        
        //消失
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakcoinv removeFromSuperview];
            [coin_label removeFromSuperview];
        });
    };
    
    [coin_v.layer setValue:@(endValue) forKeyPath:@"position.y"];
    [coin_v.layer addAnimation:animation forKey:@"position.y"];
    
    //阴影 63, 13
    UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"praise_shadow"]];
    shadow.frame = CGRectMake(CGRectGetMidX(coin_v.frame)- TFScalePoint(63)/2, endValue + height/2 + 10, TFScalePoint(63), TFScalePoint(13));
    shadow.transform = CGAffineTransformMakeScale(.2, .2);
    [window addSubview:shadow];
    [UIView animateWithDuration:.5 animations:^
    {
        shadow.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished)
    {
        double delayInSeconds = 2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [shadow removeFromSuperview];
        });
    }];
}

+ (CATransform3D)CATransform3DMakePerspective:(CGPoint)center disZ:(float)disZ
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

+ (CATransform3D)CATransform3DPerspect:(CATransform3D)t center:(CGPoint)center disZ:(float)disZ
{
    return CATransform3DConcat(t, [self CATransform3DMakePerspective:center disZ:disZ]);
}

@end
