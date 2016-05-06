//
//  RKBasePageViewController.m
//  Kuke
//
//  Created by 成才 向 on 15/10/28.
//  Copyright © 2015年 RK. All rights reserved.
//

#import "RKBasePageViewController.h"

@interface RKBasePageViewController ()

@end

@implementation RKBasePageViewController

- (UIPageViewController *)pageController
{
    if (!_pageController) {
        UIPageViewController *page = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                     navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                   options:nil];
        page.dataSource = self;
        page.delegate = self;
        [self addChildViewController:page];
        [self.view addSubview:page.view];
        _pageController = page;
    }
    return _pageController;
}

- (void)setPageContent:(CGRect)pageContent
{
    _pageContent = pageContent;
    self.pageController.view.frame = pageContent;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        
    }
    return self;
}

- (void)contentControllerAtIndexDidLoad:(NSInteger)idx
{
    
}

- (void)contentControllerAtIndexWillAppear:(NSInteger)idx
{
    
}

- (void)contentControllerAtIndexWillDisappear:(NSInteger)idx
{
    
}

- (void)didShowControllerAtIndex:(NSInteger)idx
{
    
}

- (void)setCurrentIdx:(NSInteger)currentIdx
{
    if (_currentIdx != currentIdx) {
        if (currentIdx >= 0 && currentIdx < self.contentControllers.count)
        {
            UIPageViewControllerNavigationDirection direction = currentIdx > _currentIdx ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
            RKPageContentViewController *show = [self.contentControllers objectAtIndex:currentIdx];
            [self.pageController setViewControllers:@[show]
                                          direction:direction
                                           animated:YES
                                         completion:nil];
            [self pageViewController:self.pageController viewControllerBeforeViewController:show];
            [self pageViewController:self.pageController viewControllerAfterViewController:show];
            _currentIdx = currentIdx;
        }
    }
}

- (void)setContentControllers:(NSArray<RKPageContentViewController *> *)contentControllers
{
    if (_contentControllers != contentControllers)
    {
        _contentControllers = contentControllers;
        if (contentControllers == nil || contentControllers.count == 0)
        {
            [self.pageController setViewControllers:[NSArray arrayWithObject:[[UIViewController alloc] init]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
        }
        else
        {
            for (NSInteger i = 0; i < contentControllers.count; i++) {
                __weak typeof(self) weakSelf = self;
                RKPageContentViewController *content = [contentControllers objectAtIndex:i];
                if (!content.viewDidLoadCallback) {
                    content.viewDidLoadCallback = ^{
                        [weakSelf contentControllerAtIndexDidLoad:i];
                    };
                }
                if (!content.viewWillAppearCallback) {
                    content.viewWillAppearCallback = ^{
                        [weakSelf contentControllerAtIndexWillAppear:i];
                    };
                }
                if (!content.viewWillDisapearCallback) {
                    content.viewWillDisapearCallback = ^{
                        [weakSelf contentControllerAtIndexWillDisappear:i];
                    };
                }
            }
            RKPageContentViewController *show = [contentControllers objectAtIndex:0];
            [self.pageController setViewControllers:@[show]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
            [self pageViewController:self.pageController viewControllerBeforeViewController:show];
            [self pageViewController:self.pageController viewControllerAfterViewController:show];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(RKPageContentViewController *)viewController
{
    NSInteger idx = [self.contentControllers indexOfObject:viewController];
    if (idx != NSNotFound && idx != 0) {
        return [self.contentControllers objectAtIndex:idx-1];
    }
    return nil;
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(RKPageContentViewController *)viewController
{
    NSInteger idx = [self.contentControllers indexOfObject:viewController];
    if (idx != NSNotFound && idx < self.contentControllers.count-1) {
        return [self.contentControllers objectAtIndex:idx+1];
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        UIViewController *show = [self.pageController.viewControllers objectAtIndex:0];
        NSInteger idx = [self.contentControllers indexOfObject:show];
        if (idx != NSNotFound) {
            _currentIdx = idx;
            [self didShowControllerAtIndex:idx];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
