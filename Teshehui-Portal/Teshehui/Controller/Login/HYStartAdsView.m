//
//  HYStartAdsView.m
//  Teshehui
//
//  Created by Kris on 16/1/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYStartAdsView.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "Masonry.h"
#import "HYTabbarViewController.h"

@interface HYStartAdsView ()

@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) HYStartAdsViewModel *viewModel;

@end

@implementation HYStartAdsView

-(instancetype)init
{
    if (self = [super init])
    {
        self.frame = ScreenRect;
        self.userInteractionEnabled = YES;
        
        //跳过按钮
        UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [skipBtn addTarget:self.adsViewdelegate action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        skipBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        skipBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [skipBtn setBackgroundImage:[[UIImage imageNamed:@"ads_Skip"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [skipBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 0)];
        skipBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [skipBtn setBackgroundColor:[UIColor clearColor]];
        [self addSubview:skipBtn];
        WS(weakSelf);
        [skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf).with.offset(-15);
            make.top.equalTo(weakSelf).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(80, 40));
        }];
        self.skipBtn = skipBtn;
    }
    return self;
}

-(void)bindDataWithViewModel:(HYStartAdsViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    
    [self showAdsImageWithUrl];
    //添加点击事件
    [self setupTapEvent];

    //开始计时
    [self startCountingSecs];
}

#pragma mark Gesture
- (void)tapToUrl
{
    if (self.viewModel.item)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kHomeRouteNotification"
                                                            object:self.viewModel.item];
        [self closeAds];
    }
}

#pragma mark private methods
- (void)startCountingSecs
{
    WS(weakSelf);
    __block NSTimeInterval period = _viewModel.adSecs; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        //在这里执行事件
        if (period >= 1)
        {
            [weakSelf updateSecsWithSecs:period];
        }
        
        if (0 == period)
        {
            dispatch_cancel(weakSelf.timer);
            [weakSelf closeAds];
        }
        --period;
    });
    
    dispatch_resume(_timer);
}

- (void)setupTapEvent
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToUrl)];
    [self addGestureRecognizer:tap];
}

- (void)showAdsImageWithUrl
{
    UIImage *cache = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:kAdsImage];
    
    //有缓存优先显示缓存
    if (cache)
    {
        self.image = cache;
    }
    //没缓存就不显示，下载图片下次显示
    /*
    else
    {
        //图片缓存到磁盘
        [[SDWebImageManager sharedManager]downloadImageWithURL:url options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [[SDImageCache sharedImageCache]storeImage:image forKey:kAdsImage toDisk:YES];
        }];
    }
    */
}

- (void)updateSecsWithSecs:(CGFloat)period
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.skipBtn setTitle:[NSString stringWithFormat:@"跳过 %.0fs",period] forState:UIControlStateNormal];
    });
}

-(void)closeAds
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.adsViewdelegate performSelector:@selector(timeEnding)];
    });
}

@end
