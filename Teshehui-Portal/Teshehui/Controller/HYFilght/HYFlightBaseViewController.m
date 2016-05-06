//
//  HYFlightBaseViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYFlightBaseViewController.h"

@interface HYFlightBaseViewController ()

@end

@implementation HYFlightBaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.navbarTheme = HYNavigationBarThemeBlue;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
