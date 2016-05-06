//
//  RKPageContentViewController.m
//  Kuke
//
//  Created by 成才 向 on 15/10/28.
//  Copyright © 2015年 RK. All rights reserved.
//

#import "RKPageContentViewController.h"

@interface RKPageContentViewController ()

@end

@implementation RKPageContentViewController

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    self.view.frame = parent.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.viewDidLoadCallback) {
        self.viewDidLoadCallback();
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.viewWillAppearCallback) {
        self.viewWillAppearCallback();
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.viewWillDisapearCallback) {
        self.viewWillDisapearCallback();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
