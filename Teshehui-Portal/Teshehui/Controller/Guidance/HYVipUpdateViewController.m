//
//  HYVipUpdateViewController.m
//  Teshehui
//
//  Created by Kris on 15/9/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYVipUpdateViewController.h"
#import "HYUpdateToOfficialUserViewController.h"
#import "HYUpgradeAlertView.h"

@interface HYVipUpdateViewController ()

@property (weak, nonatomic) IBOutlet UIButton *continueBuyingBtn;
@property (weak, nonatomic) IBOutlet UIButton *upgradeBtn;
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation HYVipUpdateViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //这里面控件还木有实例化
        self.canContinue = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"会员";
//    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:1.0 alpha:1.0];
    _tips.font = [UIFont systemFontOfSize:TFScalePoint(19.0f)];
    _content.font = [UIFont systemFontOfSize:TFScalePoint(17.0f)];
    
    [_continueBuyingBtn setBackgroundImage:[[UIImage imageNamed:@"vipUpgrade_img_btn1.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:10] forState:UIControlStateNormal];
    if (!_canContinue)
    {
        [_continueBuyingBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
    [_upgradeBtn setBackgroundImage:[[UIImage imageNamed:@"vipUpgrade_img_btn2.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:10] forState:UIControlStateNormal];
    
//    [_checkBoxBtn setImage:[UIImage imageNamed:@"vipUpgrade_img_check_on"] forState:UIControlStateNormal];
//    [_checkBoxBtn setImage:[UIImage imageNamed:@"vipUpgrade_img_check"] forState:UIControlStateSelected];
//    [_checkBoxBtn setTitle:@"我已知道,以后不再提示" forState:UIControlStateNormal];
//    _checkBoxBtn.titleLabel.font = [UIFont systemFontOfSize:TFScalePoint(13.5f)];
//    _checkBoxBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    
//    //如果选择了不显示，则不显示
//    if (_checkBoxBtn.selected)
//    {
//        [self updateTipsShowStatus];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)upgrade:(UIButton *)sender
{
    HYUpgradeAlertView *alert = [[HYUpgradeAlertView alloc] initWithFrame:CGRectMake(0, 0, 240, 100)];
    [alert showWithAnimation:YES];
    alert.controllerHandler = ^(HYUpdateToOfficialUserViewController *update, HYPaymentViewController *payment)
    {
        if (update)
        {
            [self.navigationController pushViewController:update animated:YES];
            [self removeSelfFromNav];
        }
        else if (payment)
        {
            payment.navbarTheme = self.navbarTheme;
            [self.navigationController pushViewController:payment animated:YES];
            [self removeSelfFromNav];
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

- (void)removeSelfFromNav
{
    NSMutableArray *mTemp = [self.navigationController.viewControllers mutableCopy];
    [mTemp removeObject:self];
    self.navigationController.viewControllers = [mTemp copy];
}

- (IBAction)continueBuying:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectContinue:)])
    {
        [self.delegate didSelectContinue:self];
    }
    
    if (_continueBuyingBtn)
    {
        /*
         *直接修改堆栈的层次
         */
        NSMutableArray *mTemp = [self.navigationController.viewControllers mutableCopy];
        [mTemp removeObject:self];
        self.navigationController.viewControllers = [mTemp copy];
        
        /*
         [self.navigationController popViewControllerAnimated:NO];
         */
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

//- (IBAction)checkBox:(UIButton *)sender
//{
//    _checkBoxBtn.selected = !_checkBoxBtn.isSelected;
//    
//    //如果选择了不显示，则不显示
//    if (_checkBoxBtn.selected)
//    {
//        [self updateTipsShowStatus];
//    }
//}

#pragma mark private methods
- (void)updateTipsShowStatus
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    switch (self.curType)
    {
        case AirTickets:
            [def setBool:YES forKey:@"tips_airTikcets"];
            break;
        case Hotel:
            [def setBool:YES forKey:@"tips_hotel"];
            break;
        case CarInsurance:
            [def setBool:YES forKey:@"tips_carIndsurance"];
            break;
        default:
            break;
    }
    
    [def synchronize];
}

#pragma mark pulice methods
+ (BOOL)isShowWithBusnessType:(BusinessType)type
{
    BOOL isShow = NO;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    switch (type)
    {
        case AirTickets:
            isShow = [def boolForKey:@"tips_airTikcets"];
            break;
        case Hotel:
            isShow = [def boolForKey:@"tips_hotel"];
            break;
        case CarInsurance:
            isShow = [def boolForKey:@"tips_carIndsurance"];
            break;
        default:
            break;
    }
    
    return isShow;
}

@end
