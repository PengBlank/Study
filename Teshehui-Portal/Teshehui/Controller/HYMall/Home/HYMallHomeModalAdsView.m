//
//  HYMallHomeModalAdsView.m
//  Teshehui
//
//  Created by Kris on 16/1/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallHomeModalAdsView.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "HYTabbarViewController.h"
#import "HYAppDelegate.h"
#import "HYMallHomeViewController.h"

@interface HYMallHomeModalAdsView ()
<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageCtrl;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) HYMallHomeModalAdsViewModel *data;

@end

@implementation HYMallHomeModalAdsView

+ (instancetype)adsView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"HYMallHomeModalAdsView" owner:self options:nil]lastObject];
}

-(void)awakeFromNib
{
    _scrollView.delegate = self;
    
    _pageCtrl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageCtrl.pageIndicatorTintColor = [UIColor colorWithRed:189/255.0
                                                       green:189/255.0
                                                        blue:189/255.0 alpha:1.0];
    
    _baseView.layer.cornerRadius = 20;
    _scrollView.layer.cornerRadius = 20;
    _scrollView.backgroundColor = [UIColor clearColor];
    
    _baseView.backgroundColor = [UIColor clearColor];
}

- (void)show
{
    if (!self.superview)
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.frame = [UIScreen mainScreen].bounds;
        [window addSubview:self];
    }
    
    //关闭键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    __weak typeof(self) b_self = self;
    b_self.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        b_self.alpha = 1.0;
    }];
}

- (void)dismiss
{
    __weak typeof(self) b_self = self;
    [UIView animateWithDuration:.3 animations:^
     {
         b_self.alpha = 0;
     } completion:^(BOOL finished)
     {
         [b_self removeFromSuperview];
     }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _baseView.frame = CGRectMake(TFScalePoint(52), TFScalePoint(85), TFScalePoint(217), TFScalePoint(217) * 1.4);
    _scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(_baseView.frame), CGRectGetHeight(_baseView.frame));
    _pageCtrl.frame = CGRectMake(TFScalePoint(90), CGRectGetHeight(_baseView.frame)-30, TFScalePoint(35), 37);
    self.lineView.frame = CGRectMake(TFScalePoint(160), CGRectGetMaxY(_baseView.frame), 1, 40);
    _closeBtn.frame = CGRectMake(TFScalePoint(140), CGRectGetMaxY(self.lineView.frame), TFScalePoint(40), TFScalePoint(40));
}

#pragma mark private methods
- (void)setupScrollViewWithModel:(HYMallHomeModalAdsViewModel *)data
{
    //控制一天之内的显示次数
    //应该显示的次数
    NSUInteger maxNum = [[[NSUserDefaults standardUserDefaults]objectForKey:kAdsShowMaxNum]integerValue];
    //已经显示的次数
    NSUInteger hasShownTimes = [[[NSUserDefaults standardUserDefaults]objectForKey:kAdsHasShownTimes]integerValue];
    
    //判断是否应该显示
    self.hidden = !([self compareShownTimes:hasShownTimes withMaxShownTimes:maxNum]);
    if ([self compareShownTimes:hasShownTimes withMaxShownTimes:maxNum])
    {
        ++hasShownTimes;
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:hasShownTimes]
                                                 forKey:kAdsHasShownTimes];
        
        self.data = data;
        
        [self setupScrollSubViews];
    }
}

- (void)setupScrollSubViews
{
    _pageCtrl.numberOfPages = (_data.picUrls.count > 4 ? 4 : _data.picUrls.count);
    //添加图片
    CGFloat imageW = TFScalePoint(217);
    __block CGFloat imageH = imageW * 1.4;
    
    for (int index = 0; index < _data.picUrls.count && index < 4; index++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        
        //添加点击事件
        NSString *methodName = [NSString stringWithFormat:@"tapToChange%d",index];
        SEL sel = NSSelectorFromString(methodName);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:sel];
        [imageView addGestureRecognizer:tap];
        
        // 设置图片
        NSURL *url = _data.picUrls[index];
        
        if (url)
        {
            [imageView sd_setImageWithURL:url
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                    // 设置frame
                                    CGFloat imageX = index * imageW;
                                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                                    imageView.clipsToBounds = YES;
                                    imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
                                    
                                    [self.scrollView addSubview:imageView];
                                    
                                    //全部下载完成后显示
                                    BOOL canShow;
                                    if (_data.items.count > 4)
                                    {
                                        canShow = (3 == index);
                                    }
                                    else
                                    {
                                        canShow = (index == _data.items.count-1);
                                    }
                                    
                                    if (canShow)
                                    {
                                        //                                            DebugNSLog(@"%@",[NSThread currentThread]);
                                        [self show];
                                    }
                                }];
        }
    }
    // 3.设置滚动的内容尺寸
    _scrollView.contentSize = CGSizeMake(imageW * (_data.picUrls.count > 4 ? 4 : _data.picUrls.count), 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
}

- (BOOL)compareShownTimes:(NSUInteger )hasShownTimes withMaxShownTimes:(NSUInteger)maxNum
{
    if (!hasShownTimes)
    {
        //第一次显示的时间
        NSDate *dateOfSetting = [[NSDate alloc]init];
        [[NSUserDefaults standardUserDefaults]
         setValue:dateOfSetting forKey:kAdsDateOfSetting];
        
        hasShownTimes = 0;
        [[NSUserDefaults standardUserDefaults]
         setValue:[NSNumber numberWithInteger:hasShownTimes] forKey:kAdsHasShownTimes];
    }
    
    //判断是否经过一天
    //取现在的时间
    NSDate *now = [[NSDate alloc]init];
    //取出第一次显示的时间
    NSDate *before = [[NSUserDefaults standardUserDefaults]objectForKey:kAdsDateOfSetting];
    NSTimeInterval timeInterval = 24 * 60 * 60;
    NSDate *tomorrow = [before dateByAddingTimeInterval:timeInterval];
    //过了24个小时一个周期，就清空原来的显示次数
    if ([now isEqualToDate:tomorrow])
    {
        hasShownTimes = 0;
    }
    
    return hasShownTimes < maxNum;
}


#pragma mark Gesture
- (void)tapToChange0
{
    if (self.data.items.count > 0)
    {
        [self close:nil];
        [[HYTabbarViewController sharedTabbarController] setCurrentSelectIndex:0];
        [self.delegate checkBannerItem:self.data.items[0] withBoard:self.data.board];
    }
}

- (void)tapToChange1
{
    if (self.data.items.count > 1)
    {
        [self close:nil];
        [self close:nil];
        [[HYTabbarViewController sharedTabbarController] setCurrentSelectIndex:0];
        [self.delegate checkBannerItem:self.data.items[1] withBoard:self.data.board];
    }
}

- (void)tapToChange2
{
    if (self.data.items.count > 2)
    {
        [self close:nil];
        [self close:nil];
        [[HYTabbarViewController sharedTabbarController] setCurrentSelectIndex:0];
        [self.delegate checkBannerItem:self.data.items[2] withBoard:self.data.board];
    }
}

- (void)tapToChange3
{
    if (self.data.tapUrls[3])
    {
        [self close:nil];
        [self close:nil];
        [[HYTabbarViewController sharedTabbarController] setCurrentSelectIndex:0];
        [self.delegate checkBannerItem:self.data.items[3] withBoard:self.data.board];
    }
}

#pragma mark scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1.取出水平方向上滚动的距离
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 2.求出页码
    double pageDouble = offsetX / scrollView.frame.size.width;
    int pageInt = (int)(pageDouble + 0.5);
    self.pageCtrl.currentPage = pageInt;
}

#pragma mark IB
- (IBAction)close:(id)sender
{
    [self dismiss];
}
@end
