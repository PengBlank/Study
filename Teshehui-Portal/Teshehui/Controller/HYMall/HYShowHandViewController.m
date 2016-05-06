//
//  HYShowHandViewController.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/4.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYShowHandViewController.h"

@interface HYShowHandViewController ()
@end

@implementation HYShowHandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = self.shareItemBar;
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
