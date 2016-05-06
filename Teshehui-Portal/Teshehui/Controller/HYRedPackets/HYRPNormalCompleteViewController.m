//
//  HYRPNormalCompleteViewController.m
//  Teshehui
//
//  Created by apple on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRPNormalCompleteViewController.h"
#import "UIImage+Addition.h"
#import "UIView+ScreenTransform.h"
#import "HYRedpacketsHomeViewController.h"

@interface HYRPNormalCompleteViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIButton *completeBtn;
@property (nonatomic, weak) IBOutlet UILabel *nameLab;

@end

@implementation HYRPNormalCompleteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    if (frame.size.height <= 480)
    {
        _scrollView.contentSize = CGSizeMake(frame.size.width, 504);
    }
    
    self.title = @"给朋友发红包";
    UIImage *btn = [[UIImage imageNamed:@"redpacket_send_btn.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 24, 0, 24)];
    [self.completeBtn setBackgroundImage:btn forState:UIControlStateNormal];
    
    [self.scrollView transformSubviewFrame:NO];
    
    //给XX的红包已经准备好
    self.nameLab.text = [NSString stringWithFormat:@"给%@的红包已经成功发送", self.name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)completeAction:(id)sender
{
    UIViewController *root = nil;
    for (UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[HYRedpacketsHomeViewController class]])
        {
            root = vc;
        }
    }
    [self.navigationController popToViewController:root animated:YES];
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
