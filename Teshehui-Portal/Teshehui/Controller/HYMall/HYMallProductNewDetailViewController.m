//
//  HYMallProductNewDetailViewController.m
//  Teshehui
//
//  Created by Kris on 16/3/28.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallProductNewDetailViewController.h"

@interface HYMallProductNewDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) HYMallGoodsDetail *goodsDetail;
@property (nonatomic, strong) UIWebView *detailWeb;
@property (nonatomic, strong) UIButton *scrollToTopBtn;  //滑动到顶部

@end

@implementation HYMallProductNewDetailViewController

- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 108;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailWeb = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _detailWeb.scalesPageToFit = YES;
    _detailWeb.backgroundColor = [UIColor clearColor];
    _detailWeb.scrollView.delegate = self;
    if (_goodsDetail.productDescription.length > 0)
    {
        [self.detailWeb loadHTMLString:_goodsDetail.productDescription
                               baseURL:nil];
    }
    [self.view addSubview:_detailWeb];
}

- (void)setGoodsDetail:(HYMallGoodsDetail *)goodsDetail
{
    _goodsDetail = goodsDetail;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.scrollToTopBtn setHidden:(scrollView.contentOffset.y < 10)];
}

#pragma mark private methods
- (void)scrollViewToTopEvent:(id)sender
{
    [_detailWeb.scrollView setContentOffset:CGPointZero
                                   animated:YES];
    [self.scrollToTopBtn setHidden:YES];
}

#pragma mark setter/getter
- (UIButton *)scrollToTopBtn
{
    if (!_scrollToTopBtn)
    {
        _scrollToTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scrollToTopBtn.frame = CGRectMake(CGRectGetMaxX(self.detailWeb.frame)-58,
                                           CGRectGetHeight(self.detailWeb.frame)-58,
                                           50,
                                           50);
        [_scrollToTopBtn setImage:[UIImage imageNamed:@"icon_returnUp"]
                         forState:UIControlStateNormal];
        [_scrollToTopBtn addTarget:self
                            action:@selector(scrollViewToTopEvent:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_scrollToTopBtn];
        [self.view bringSubviewToFront:_scrollToTopBtn];
    }
    
    return _scrollToTopBtn;
}

@end
