//
//  HYExperienceLeakViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYExperienceLeakViewController.h"
#import "MDHTMLLabel.h"
#import "HYUpdateToOfficialUserViewController.h"
#import "HYShareGetPointViewController.h"
#import "HYUpgradeAlertView.h"
#import "HYPaymentViewController.h"

@interface HYExperienceLeakViewController ()
<MDHTMLLabelDelegate>
@end

@implementation HYExperienceLeakViewController

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:247/255.0 blue:251/255.0 alpha:1];
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scroll];
    
    UIImage *img = [UIImage imageNamed:@"vipUpgrade_img"];
    UIImageView *imgv = [[UIImageView alloc] initWithImage:img];
    imgv.center = CGPointMake(frame.size.width/2, img.size.height/2 + 40);
    [scroll addSubview:imgv];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 45)];
    title.text = @"亲, 您的现金券不足";
    title.font = [UIFont systemFontOfSize:22];
    [title sizeToFit];
    title.frame = CGRectMake(frame.size.width/2-title.frame.size.width/2,
                             CGRectGetMaxY(imgv.frame) + 10,
                             title.frame.size.width,
                             title.frame.size.height);
    title.textColor = [UIColor blackColor];
    [scroll addSubview:title];
    
    MDHTMLLabel *content1 = [[MDHTMLLabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-40, 1000)];
    content1.font = [UIFont systemFontOfSize:15.0];
    content1.backgroundColor = [UIColor clearColor];
    content1.textColor = [UIColor colorWithWhite:.63 alpha:1];
    content1.numberOfLines = 0;
    content1.linkAttributes = @{NSForegroundColorAttributeName: [UIColor redColor],
                                NSUnderlineStyleAttributeName: [NSNumber numberWithBool:YES]};
    content1.delegate = self;
    content1.htmlText = @"您现在还是会员，：\n"
    "★ 升级成付费会员即可获得<font color=\"#FF0000\">1000</font>现金劵。\n"
    "★ 分享赚现金券，邀请一个小伙伴成功注册后即可 获得100现金劵，分享多多，赚的多多。"
    "<a href='share'>立即分享</a>";
    [content1 sizeToFit];
    content1.frame = CGRectMake(20,
                               CGRectGetMaxY(title.frame)+ 25,
                               content1.frame.size.width,
                               content1.frame.size.height);
    [scroll addSubview:content1];
    
    UILabel *content2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-40, 1000)];
    content2.font = [UIFont systemFontOfSize:15.0];
    content2.backgroundColor = [UIColor clearColor];
    content2.textColor = [UIColor colorWithWhite:.63 alpha:1];
    content2.numberOfLines = 0;
    content2.text = @"成为付费会员您还能：\n"
    "1、购买送现金券，购买机票、酒店、鲜花、团购、保险即可获得等额现金券，买多少送多少。\n"
    "2、商品点赞送现金券，点一个赞送1现金券。\n";
    [content2 sizeToFit];
    content2.frame = CGRectMake(20,
                                CGRectGetMaxY(content1.frame)+ 20,
                                content2.frame.size.width,
                                content2.frame.size.height);
    [scroll addSubview:content2];
    
    //底部, 如果屏幕太长, 保证底部按钮附于底部
    //如果是4S,则直接接于文字底部并延长界面
    CGFloat footHeight = 150;
    CGFloat footOffset = CGRectGetMaxY(content2.frame) + 20;
    UIImage *chip = [UIImage imageNamed:@"vipUpgrade_img_wave"];
    CGFloat exheight = frame.size.height - footOffset - (footHeight + chip.size.height);
    if (exheight > 0)
    {
        footOffset = footOffset + exheight;
    }
    UIImageView *wave = [[UIImageView alloc] initWithFrame:CGRectMake(0, footOffset, frame.size.width, chip.size.height)];
    chip = [chip resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    [wave setImage:chip];
    [scroll addSubview:wave];
    
    UIView *foot = [[UIView alloc] initWithFrame:
                    CGRectMake(0, CGRectGetMaxY(wave.frame), frame.size.width, footHeight)];
    foot.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:foot];
    //button
    CGFloat buttonWidth = (frame.size.width - 20*3) / 2;
    CGFloat buttonHeight = 50;
    UIImage *normal = [UIImage imageNamed:@"vipUpgrade_img_btn1"];
    normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    UIImage *red = [UIImage imageNamed:@"vipUpgrade_img_btn2"];
    red = [red resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(frame.size.width/4-buttonWidth/2,
                             footHeight/2 - buttonHeight/2,
                             buttonWidth,
                             buttonHeight)];
    [left setBackgroundImage:normal forState:UIControlStateNormal];
    [left setTitle:@"取消" forState:UIControlStateNormal];
    [left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:left];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:CGRectMake(frame.size.width/4*3 - buttonWidth/2,
                               footHeight/2 - buttonHeight/2,
                               buttonWidth,
                               buttonHeight)];
    [right setBackgroundImage:red forState:UIControlStateNormal];
    [right setTitle:@"立即升级" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:right];
    
    [scroll setContentSize:CGSizeMake(frame.size.width, CGRectGetMaxY(foot.frame))];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)cancelAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goAction:(UIButton *)btn
{
    HYUpgradeAlertView *alert = [[HYUpgradeAlertView alloc] initWithFrame:CGRectMake(0, 0, 240, 100)];
    [alert showWithAnimation:YES];
    alert.controllerHandler = ^(HYUpdateToOfficialUserViewController *update, HYPaymentViewController *payment)
    {
        if (update)
        {
            [self pushViewControllerThenRemoveSelf:update];
        }
        else if (payment)
        {
            payment.navbarTheme = self.navbarTheme;
            [self pushViewControllerThenRemoveSelf:payment];
            payment.paymentCallback = ^(HYPaymentViewController *payvc, id data)
            {
                [payvc.navigationController popViewControllerAnimated:YES];
                
                HYSiRedPacketsViewController *vc = [[HYSiRedPacketsViewController alloc]initWithNibName:@"HYSiRedPacketsViewController" bundle:nil];
                vc.cashCard = @"1000";
                [self presentViewController:vc animated:YES completion:nil];
            };
        }
    };
}

- (void)pushViewControllerThenRemoveSelf:(UIViewController *)controller
{
    [self.navigationController pushViewController:controller animated:YES];
    NSMutableArray *mTemp = [self.navigationController.viewControllers mutableCopy];
    [mTemp removeObject:self];
    self.navigationController.viewControllers = [mTemp copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL*)URL
{
    if ([[URL absoluteString] isEqualToString:@"share"]) {
        HYShareGetPointViewController *share = [[HYShareGetPointViewController alloc] initWithNibName:@"HYShareGetPointViewController" bundle:nil];
        [self.navigationController pushViewController:share animated:YES];
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
