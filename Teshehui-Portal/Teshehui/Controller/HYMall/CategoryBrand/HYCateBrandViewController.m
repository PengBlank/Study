//
//  HYCateBrandViewController.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/21.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYCateBrandViewController.h"
#import "HYMallCateViewController.h"
#import "HYMallBrandViewController.h"
#import "HYHYMallOrderListFilterView.h"
#import "HYMallSearchViewController.h"

@interface HYCateBrandViewController ()

@property (nonatomic, strong) HYHYMallOrderListFilterView *filter;
@property (nonatomic, strong) UIBarButtonItem *searchItemBar;

@end

@implementation HYCateBrandViewController

- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    /// 组装子视图
    self.pageContent = CGRectMake(0, 0, rect.size.width, rect.size.height);
    NSMutableArray *controllers = [NSMutableArray array];
    HYMallCateViewController *cate = [[HYMallCateViewController alloc] init];
    HYMallBrandViewController *brand = [[HYMallBrandViewController alloc] init];
    [controllers addObject:brand];
    [controllers addObject:cate];
    self.contentControllers = controllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.filter = [[HYHYMallOrderListFilterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 35)];
    self.filter.showSpecLine = NO;
    self.filter.conditions = @[@"品牌", @"分类"];
    self.filter.backgroundColor = [UIColor clearColor];
    [self.filter addTarget:self
                    action:@selector(filterAction)
          forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.filter;
    
    self.navigationItem.rightBarButtonItem = self.searchItemBar;
}

- (void)filterAction
{
    self.currentIdx = self.filter.currentIndex;
}

- (void)didShowControllerAtIndex:(NSInteger)idx
{
    self.filter.currentIndex = self.currentIdx;
}

- (UIBarButtonItem *)searchItemBar
{
    if (!_searchItemBar)
    {
        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        searchButton.frame = CGRectMake(0, 0, 48, 30);
        UIImage *back_n = [UIImage imageNamed:@"cate_brand_search"];
        
        [searchButton setImage:back_n forState:UIControlStateNormal];
        [searchButton addTarget:self
                         action:@selector(searchItemAction:)
               forControlEvents:UIControlEventTouchUpInside];
        [searchButton setTitleColor:[UIColor grayColor]
                           forState:UIControlStateNormal];
        
        _searchItemBar = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    }
    return _searchItemBar;
}

- (void)searchItemAction:(id)sender
{
    //搜索输入框
    [MobClick event:@"v430_shangcheng_shouye_feileitubiao_jishu"];
    
    HYMallSearchViewController *search = [[HYMallSearchViewController alloc] initWithNibName:@"HYMallSearchViewController"
                                                                                      bundle:nil];
    search.searchKeyWord = @"搜索全部商品";
    [self.navigationController pushViewController:search animated:YES];
}

@end
