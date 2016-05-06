//
//  HYMeiWeiQiQiViewController.m
//  Teshehui
//
//  Created by HYZB on 15/12/25.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMeiWeiQiQiViewController.h"

@interface HYMeiWeiQiQiViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) BOOL webViewIsLoading;
@property (nonatomic, strong) NSTimer *progressTimer;

@end

@implementation HYMeiWeiQiQiViewController

- (void)dealloc
{
    [self.progressView removeFromSuperview];
}

#pragma mark - Initializers
- (id)init {
    
    return [self initWithConfiguration];
}

- (id)initWithConfiguration {
    self = [super init];
    if(self) {
        
        self.meiWeiQiQiWebView = [[UIWebView alloc] init];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.meiWeiQiQiWebView) {
        
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.size.height -= 64;
        [self.view addSubview:self.meiWeiQiQiWebView];
        [self.meiWeiQiQiWebView setFrame:frame];
        self.meiWeiQiQiWebView.scalesPageToFit =YES;
        self.meiWeiQiQiWebView.delegate =self;
    }
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView setProgressTintColor:[UIColor redColor]];
    [self.progressView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height-self.progressView.frame.size.height, self.view.frame.size.width, self.progressView.frame.size.height)];
    [self.progressView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar addSubview:self.progressView];
}


#pragma mark - Public Interface

- (void)loadURL:(NSURL *)URL {
    
    if(self.meiWeiQiQiWebView) {
        [self.meiWeiQiQiWebView loadRequest:[NSURLRequest requestWithURL:URL]];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.webViewIsLoading = YES;
    [self ProgressViewStartLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.webViewIsLoading = NO;
    [self ProgressViewStopLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    self.webViewIsLoading = NO;
    [self ProgressViewStopLoading];
}

#pragma mark - ProgressView
- (void)ProgressViewStartLoading
{
    [self.progressView setProgress:0.0f animated:NO];
    [self.progressView setAlpha:1.0f];
    
    if(!self.progressTimer) {

        self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(progressTimerDidFire) userInfo:nil repeats:YES];
    }
}

- (void)ProgressViewStopLoading
{
    if(self.progressTimer) {
        [self.progressTimer invalidate];
    }
    
    if(self.progressView) {
        [self.progressView setProgress:1.0f animated:YES];
        [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.progressView setProgress:0.0f animated:NO];
        }];
    }
}

- (void)progressTimerDidFire
{
    CGFloat increment = 0.5/(self.progressView.progress + 0.2);
    if([self.meiWeiQiQiWebView isLoading]) {
        
        CGFloat progress = (self.progressView.progress < 0.85f) ? self.progressView.progress + increment : self.progressView.progress + 0.0005;
        if(self.progressView.progress < 0.95) {
            [self.progressView setProgress:progress animated:YES];
        }
    }
}

@end
