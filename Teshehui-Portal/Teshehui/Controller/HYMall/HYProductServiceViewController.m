//
//  HYProductServiceViewController.m
//  Teshehui
//
//  Created by Kris on 15/7/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYProductServiceViewController.h"
#import "HYHYMallOrderListFilterView.h"
#import "HYExpensiveExplainRequest.h"
#import "METoast.h"
#import "SDWebImageDownloader.h"
#import "UIImageView+WebCache.h"
#import "HYExpensiveExplainView.h"

@interface HYProductServiceViewController ()
{
    UIScrollView *_scrollView;
    UIImageView *_content;
    NSMutableDictionary *_urlCache;
}
@property (nonatomic, strong) HYHYMallOrderListFilterView *filterView;
@property (nonatomic, strong) HYExpensiveExplainRequest *expensiveRequest;
@property (nonatomic, assign) NSInteger filterType;

@end



@implementation HYProductServiceViewController

- (void)dealloc
{
    [_expensiveRequest cancel];
    _expensiveRequest = nil;
    [HYLoadHubView dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *web = [[UIWebView alloc]init];
    if (self.webUrl)
    {
        NSURL *url = [NSURL URLWithString:self.webUrl];
        NSURLRequest *req = [[NSURLRequest alloc]initWithURL:url];
        [web loadRequest:req];
    }
    web.frame = self.view.frame;
    [self.view addSubview:web];
//    _urlCache = [NSMutableDictionary dictionary];
//    [self sendRequestWithKey:@"guarantee"];
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                           green:237.0f/255.0f
                                            blue:237.0f/255.0f
                                           alpha:1.0];
    self.view = view;
    
//    _filterView = [[HYHYMallOrderListFilterView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 34)];
//    if (self.showGuijiupei)
//    {
//        _filterView.conditions = @[@"正品保障", @"假1赔13",@"闪电退",@"贵就赔"];
//    }else
//    {
//        _filterView.conditions = @[@"正品保障", @"假1赔13",@"闪电退"];
//    }
//    
//    _filterView.userInteractionEnabled = YES;
//    [_filterView addTarget:self
//                    action:@selector(filterOrder:)
//          forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:_filterView];
//    
//    frame.size.height -= 34;
//    frame.origin.y = 34;
//    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
//    [self.view addSubview:_scrollView];
//    _content = [[UIImageView alloc] initWithFrame:frame];
//    [_scrollView addSubview:_content];
}

#pragma mark -private methods
- (void)filterOrder:(id)sender
{
    if ([sender isKindOfClass:[HYHYMallOrderListFilterView class]])
    {
        HYHYMallOrderListFilterView *filter = (HYHYMallOrderListFilterView *)sender;
        NSString *key = nil;
        switch (filter.currentIndex)
        {
            case 0: //正品保障
                _filterType = filter.currentIndex;
                key = @"guarantee";
                break;
            case 1: //假1赔13
                _filterType = filter.currentIndex;
                key = @"fake";
                break;
            case 2: //闪电退
                _filterType = filter.currentIndex;
                key = @"lightning";
                break;
            case 3: //贵就赔
                _filterType = filter.currentIndex;
                key = @"guijiupei";
                break;
            default:
                break;
        }
        
        if (key)
        {
            NSString *url = [_urlCache objectForKey:key];
            if (url)
            {
                [self loadImageWithURL:url];
            }
            else
            {
                [self sendRequestWithKey:key];
            }
        }
    }
}

//获取url
- (void)sendRequestWithKey:(NSString *)key
{
    
    if (_expensiveRequest)
    {
        [_expensiveRequest cancel];
    }
    
    self.expensiveRequest = [[HYExpensiveExplainRequest alloc] init];
    self.expensiveRequest.img_key = key;
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [self.expensiveRequest sendReuqest:^(HYExpensiveExplainResponse* result, NSError *error)
     {
         if ([result status] == 200)
         {
             if (result.expensiveInfo.img_key1.length > 0)
             {
                 [b_self cacheURL:result.expensiveInfo.img_key1 withKey:key];
                 [b_self loadImageWithURL:result.expensiveInfo.img_key1];
             }
             else
             {
                 [HYLoadHubView dismiss];
                 [METoast toastWithMessage:@"获取商品服务信息失败，请稍后再试"];
             }
         }
     }];
}

//缓存图片url
- (void)cacheURL:(NSString *)url withKey:(NSString *)key
{
    [_urlCache setObject:url forKey:key];
}

//加载图片
- (void)loadImageWithURL:(NSString *)urlstring
{
    if (_content.image)
    {
        _content.image = nil;
    }
    
    NSURL *url = [NSURL URLWithString:urlstring];
    __weak typeof(self) b_self = self;
    [[SDWebImageManager sharedManager] downloadImageWithURL:url
                                                    options:0
                                                   progress:nil
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         [HYLoadHubView dismiss];
         if (image)
         {
             [b_self showWithImage:image];
         }
         else
         {
             [METoast toastWithMessage:@"获取商品服务信息失败，请稍后再试"];
         }
     }];
}

//缩放以全屏显示图片
- (void)showWithImage:(UIImage *)img
{
    if (img)
    {
        CGFloat imageW = img.size.width;
        CGFloat imageH = img.size.height;
        CGFloat ratio = imageH / imageW;
        CGFloat H = self.view.frame.size.width * ratio;
        CGFloat W = self.view.frame.size.width;
        
        _content.frame = CGRectMake(0, 0, W, H);
        _content.image = img;
        
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake(W, H);
    }
}


@end
