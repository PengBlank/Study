//
//  HYUpgradeAlertView.m
//  Teshehui
//
//  Created by 成才 向 on 16/1/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYUpgradeAlertView.h"
#import "HYUserService.h"
#import "HYPaymentViewController.h"
#import "HYSiRedPacketsViewController.h"
#import "HYUpdateToOfficialUserViewController.h"

@interface HYUpgradeAlertView ()



@end

@implementation HYUpgradeAlertView

- (HYUserService *)userService
{
    if (!_userService) {
        _userService = [[HYUserService alloc] init];
    }
    return _userService;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 4.0;
        self.backgroundColor = [UIColor whiteColor];
        self.popDirection = CCPopoverFromCenter;
        
        NSString *show = @"激活会员将赠送您一年的保险，最高价值210万。您是否需要？";
        NSMutableAttributedString *shows = [[NSMutableAttributedString alloc] initWithString:show];
        [shows setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:230/255.0 green:0 blue:0 alpha:1]} range:NSMakeRange(18, 4)];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, frame.size.width-30, 300)];
        title.font = [UIFont systemFontOfSize:16.0];
        title.textColor = [UIColor blackColor];
//        title.text = [NSString stringWithFormat:@"激活会员将送你210.是否需要？"];
        [title setAttributedText:shows];
        title.numberOfLines = 0;
        [self addSubview:title];
        [title sizeToFit];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame) + 15, frame.size.width, 0.5)];
        line1.backgroundColor = [UIColor blackColor];
        [self addSubview:line1];
        
        CGFloat btnHeight = 45;
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2, CGRectGetMinY(line1.frame), 0.5, btnHeight)];
        line2.backgroundColor = [UIColor blackColor];
        [self addSubview:line2];
        
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(line1.frame), frame.size.width/2, btnHeight)];
        [btn1 setTitle:@"直接激活" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn1.tag = 1;
        [self addSubview:btn1];
        
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2, CGRectGetMinY(line1.frame), frame.size.width/2, btnHeight)];
        [btn2 setTitle:@"需要保险" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor colorWithRed:230/255.0 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont systemFontOfSize:16.0];
        btn2.tag = 2;
        [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn2];
        
        self.frame = CGRectMake(0, 0, frame.size.width, CGRectGetMaxY(line2.frame));
    }
    return self;
}

- (void)btnAction:(UIButton *)btn
{
    if (self.handler)
    {
        self.handler(btn.tag - 1);
    }
    [self dismissWithAnimation:YES];
}

- (void)setControllerHandler:(void (^)(HYUpdateToOfficialUserViewController *, HYPaymentViewController *))controllerHandler
{
    _controllerHandler = controllerHandler;
    WS(weakSelf);
    self.handler = ^(NSInteger idx){
        if (idx == 0)
        {
            [HYLoadHubView show];
            [weakSelf.userService upgradeWithNoPolicy:^(HYUserUpgradeResponse *response)
             {
                 [HYLoadHubView dismiss];
                 if (response.status == 200)
                 {
                     HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
                     payVC.amountMoney = response.orderAmount;
                     payVC.orderID = response.orderId;
                     payVC.orderCode = response.orderNumber;
                     payVC.type = Pay_Upgrad;
                     payVC.productDesc = [NSString stringWithFormat:@"【特奢汇】在线购卡: %@", response.orderNumber]; //商品描述
                     
                     payVC.paymentCallback = ^(HYPaymentViewController *payvc, id data)
                     {
                         [payvc.navigationController popToRootViewControllerAnimated:YES];
                         
                         HYSiRedPacketsViewController *vc = [[HYSiRedPacketsViewController alloc]initWithNibName:@"HYSiRedPacketsViewController" bundle:nil];
                         vc.cashCard = @"1000";
                         [payvc presentViewController:vc animated:YES completion:nil];
                     };
                     
                     controllerHandler(nil, payVC);
                 }
             }];
        }
        else if (idx == 1)
        {
            //升级会员
            HYUpdateToOfficialUserViewController *vc = [HYUpdateToOfficialUserViewController new];
            //            HYMemberUpgradeViewController *vc = [[HYMemberUpgradeViewController alloc] init];
            vc.title = @"升级";
            controllerHandler(vc, nil);
        }
    };
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
