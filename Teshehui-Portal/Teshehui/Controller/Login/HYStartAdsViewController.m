//
//  HYStartAdsViewController.m
//  Teshehui
//
//  Created by Kris on 16/1/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYStartAdsViewController.h"
#import "HYStartAdsView.h"
#import "HYStartAdsDataController.h"
#import "HYStartAdsViewModel.h"
#import "HYAppDelegate.h"

@interface HYStartAdsViewController ()
<HYStartAdsViewDelegate>

@property (nonatomic, strong) HYStartAdsView *contenview;
@property (nonatomic, strong) HYTabbarViewController *baseContenviewController;
@property (nonatomic, strong) HYStartAdsDataController *dataController;

@end

@implementation HYStartAdsViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:ScreenRect];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.contenview = [[HYStartAdsView alloc]init];
    self.contenview.adsViewdelegate = self;
    [self.view addSubview:self.contenview];
    
    self.dataController = [[HYStartAdsDataController alloc]init];
    [self fetchData];
}

#pragma mark HYStartAdsViewDelegate
- (void)skipBtnClick
{
    [self loadHomeView];
    if (self.startAdsCallback) {
        self.startAdsCallback(YES);
    }
}
- (void)timeEnding
{
    [self loadHomeView];
    if (self.startAdsCallback) {
        self.startAdsCallback(NO);
    }
}

#pragma mark private methods
- (void)loadHomeView
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.view.alpha = 0.0;
                     }completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
}

- (void)fetchData
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:kStartAdsItem];
    HYMallHomeItem *item = [[HYMallHomeItem alloc]initWithDictionary:dict error:nil];
    if (item)
    {
        NSArray *dataList = @[item];
        [self renderSubjectViewWithData:dataList];
        //    [self.dataController fetchStartAdsDataWithCallback:^(NSArray *dataList) {
        //        [self renderSubjectViewWithData:dataList];
        //    }];
    }
}

- (void)renderSubjectViewWithData:(NSArray *)dataList
{
    HYStartAdsViewModel *viewModel = [HYStartAdsViewModel viewModelWithSubjects:dataList];
    viewModel.adSecs = 3;
    
    [self.contenview bindDataWithViewModel:viewModel];
}

@end
