//
//  HYProductDetailMoreNavView.m
//  Teshehui
//
//  Created by Kris on 16/4/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYProductDetailMoreNavView.h"
#import "Masonry.h"

@interface HYProductDetailMoreNavView ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
@property (nonatomic, copy) NSDictionary *dataDict;
@property (weak, nonatomic) IBOutlet UIView *btnBaseView;
@property (nonatomic, strong, nonnull) UIView *containView;

@end

@implementation HYProductDetailMoreNavView

- (void)dealloc
{
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupGesture];
    [self setupButtonData];
    
    [self setupButton];
    
    self.backgroundColor = [UIColor clearColor];
    self.btnBaseView.layer.cornerRadius = 8;
}

- (void)setupGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapAction)];
    tap.delegate = self;
    [self.containView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *swipe = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapAction)];
    swipe.delegate = self;
    [self.containView addGestureRecognizer:swipe];
}

- (void)setupButton
{
    @autoreleasepool {
        NSArray *title = @[@"分享",@"二维码",@"首页"];
        for (int index = 0; index < self.btns.count; ++index)
        {
            UIButton *btn = _btns[index];
            //round corner
            if (1 != index)
            {
               btn.layer.cornerRadius = 10;
            }
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 60);
            NSString *str = title[index];
            NSString *imgStr = self.dataDict[str];
            NSString *path = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle]resourcePath], imgStr];
            UIImage *img = [UIImage imageWithContentsOfFile:path];
            [btn setTitle:str forState:UIControlStateNormal];
            [btn setImage:img forState:UIControlStateNormal];
        }
    }
}

- (void)setupButtonData
{
    NSDictionary *dict = @{@"分享" : @"productDetail_share",
                           @"二维码": @"productDetal_QRCode",
                           @"首页": @"productDetail_home"};
    self.dataDict = dict;
}

#pragma mark gesture delegate
//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    CGPoint point = [gestureRecognizer locationInView:[[UIApplication sharedApplication] keyWindow]];
//    CGRect frame = self.window.frame;
//    if (CGRectContainsPoint(frame, point))
//    {
//        return NO;
//    }
//    return YES;
//}

#pragma mark HYXibViewAction protocol
-(void)performShowAboveView:(UIView *)view
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self.containView];
    [window addSubview:self];
    
    self.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1;
    }];
    
    //need to resize, dunno why
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(window.mas_top).with.offset(49);
        make.right.equalTo(window.mas_right).with.offset(-8);
        make.size.mas_equalTo(CGSizeMake(110, 142));
    }];
}

- (void)performTapAction
{
    [self removeFromSuperview];
    [self.containView removeFromSuperview];
//    __weak typeof(self) b_self = self;
//    [UIView animateWithDuration:.3 animations:^
//     {
//         b_self.alpha = 0;
//     } completion:^(BOOL finished)
//     {
//         [b_self removeFromSuperview];
//     }];
}

#pragma mark UI EVENTS
- (IBAction)firstBtnClick:(id)sender
{
    [self performTapAction];
    if ([self.delegate respondsToSelector:@selector(shareAction)])
    {
        [self.delegate performSelector:@selector(shareAction)];
    }
}

- (IBAction)secBtnClick:(id)sender
{
    [self performTapAction];
    if ([self.delegate respondsToSelector:@selector(qRAction)])
    {
        [self.delegate performSelector:@selector(qRAction)];
    }
}

- (IBAction)thirdBtnClick:(id)sender
{
    [self performTapAction];
    if (self.delegate.navigationController)
    {
        [self.delegate.navigationController popToRootViewControllerAnimated:NO];
    }
}

#pragma mark getter
- (UIView *)containView
{
    if (!_containView)
    {
        _containView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _containView.backgroundColor = [UIColor clearColor];
        [self setupGesture];
    }
    return _containView;
}

@end
