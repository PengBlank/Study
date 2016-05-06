//
//  HYNormalLeakViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYNormalLeakViewController.h"
#import "HYTabbarViewController.h"
#import "HYAppDelegate.h"
#import "ConfirmPayViewController.h"
#import "BusinessRootCtrl.h"
//#import "BusinessMapViewController.h"
@interface HYNormalLeakViewController ()

@end

@implementation HYNormalLeakViewController

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:247/255.0 blue:251/255.0 alpha:1];
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scroll];
    
    UIImage *img = [UIImage imageNamed:@"lack_points"];
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
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-40, 1000)];
    content.font = [UIFont systemFontOfSize:15.0];
    content.backgroundColor = [UIColor clearColor];
    content.textColor = [UIColor colorWithWhite:.63 alpha:1];
    content.numberOfLines = 0;
    content.text = @"TT教你几招怎么能买到您心水的东东哦：\n"
    "1、购买送现金券，购买机票、酒店、鲜花、团购、保险即可获得等额现金券，买多少送多少。\n"
    "2、商品点赞送现金券，点一个赞送1现金券。\n"
    "3、分享赚现金券，邀请一个小伙伴成功注册后即可获得100现金劵，分享多多，赚的多多。\n"
    "亲亲，你学会了吗？";
    [content sizeToFit];
    content.frame = CGRectMake(frame.size.width/2-content.frame.size.width/2,
                               CGRectGetMaxY(title.frame)+ 25,
                               content.frame.size.width,
                               content.frame.size.height);
    [scroll addSubview:content];
    
    //底部, 如果屏幕太长, 保证底部按钮附于底部
    //如果是4S,则直接接于文字底部并延长界面
    CGFloat footHeight = 150;
    CGFloat footOffset = CGRectGetMaxY(content.frame) + 20;
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
    [right addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    [right setTitle:@"去赚现金券" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [foot addSubview:right];
    
    [scroll setContentSize:CGSizeMake(frame.size.width, CGRectGetMaxY(foot.frame))];
}

- (void)viewDidLoad {
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
    
    
    NSArray *vcs = self.navigationController.viewControllers;
    if ([vcs count])
    {
        UIViewController *vc = [vcs objectAtIndex:0];
        if ([vc isKindOfClass:[BusinessRootCtrl class]])
        {
            HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.baseContentView setCurrentSelectIndex:2];
            [self dismissViewControllerAnimated:YES
                                     completion:nil];
        }
//        else if ([vc isKindOfClass:[BusinessMapViewController class]]){
//            self.navigationController.navigationBarHidden = NO;
//            BusinessMapViewController *tmpCtrl = (BusinessMapViewController *)vc;
//            tmpCtrl.isNormalLeakViewController = YES;
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
        else
        {
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController popToRootViewControllerAnimated:YES];
            HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.baseContentView setCurrentSelectIndex:2];
        }
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
