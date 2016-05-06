//
//  HYExpensiveResultView.m
//  Teshehui
//
//  Created by apple on 15/4/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYExpensiveResultView.h"
#import "UIImage+Addition.h"

@interface HYExpensiveResultView ()
@property (nonatomic, weak) IBOutlet UIImageView *alertBackground;
@property (nonatomic, weak) IBOutlet UIImageView *icon;
@property (nonatomic, weak) IBOutlet UILabel *resultLab;
@property (nonatomic, weak) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UIView *alertView;

//@property (nonatomic, weak) IBOutlet UILabel *descLab;

@end

@implementation HYExpensiveResultView

+ (instancetype)instance
{
    UINib *nib = [UINib nibWithNibName:@"HYExpensiveResultView" bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    if (views.count > 0)
    {
        return [views objectAtIndex:0];
    }
    return nil;
}

- (void)awakeFromNib
{
//    UIImage *bg = [[UIImage imageNamed:@"g_alertbg"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(7, 6, 37, 6)];
//    self.alertBackground.image = bg;
    self.alertBackground.backgroundColor = [UIColor whiteColor];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self dismiss];
}

- (void)setSuccess:(BOOL)success
{
    _success = success;
    UIImage *icon = nil;
    NSString *result = nil;
//    NSString *desc = nil;
    if (success)
    {
        icon = [UIImage imageNamed:@"g_success_ok"];
        result = @"提交成功";
//        desc = @"可通过订单查询申赔进度及详情";
    }
    else
    {
        icon = [UIImage imageNamed:@"g_success_no"];
        result = @"提交失败";
//        desc = @"请重新上传";
    }
    self.icon.image = icon;
    self.resultLab.text = result;
//    self.descLab.text = desc;
}

- (void)setDesc:(NSString *)desc
{
    _desc = desc;
    _descLab.text = desc;
}

- (void)show
{
    [self showWithCallback:nil];
}

- (void)showWithCallback:(void (^)(void))callback
{
    if (callback)
    {
        self.dismissCallback = callback;
    }
    else
    {
        self.dismissCallback = nil;
    }
    if (!self.superview)
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.frame = window.bounds;
        [window addSubview:self];
    }
}

- (void)dismiss
{
    if (self.dismissCallback)
    {
        self.dismissCallback();
    }
    [self removeFromSuperview];
}

- (void)showWithDuration:(CGFloat)duration
       completionHanlder:(ShowCompletionHandler) completion
{
    if (completion)
    {
        self.showCompletionHandler = completion;
    }
    else
    {
        self.showCompletionHandler = nil;
    }
    if (!self.superview)
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.frame = window.bounds;
        [window addSubview:self];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                  (int64_t)(duration * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
         if (_showCompletionHandler)
         {
             _showCompletionHandler();
         }
         [self removeFromSuperview];
    });
}

@end
