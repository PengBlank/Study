//
//  PrepaySuccessViewController.m
//  Teshehui
//
//  Created by macmini5 on 16/3/3.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "PrepaySuccessViewController.h"
#import "PostCommentViewController.h"
#import "PrepayViewController.h"
#import "DefineConfig.h"            // 宏
#import "UIView+Common.h"
#import "UIColor+expanded.h"
#import "Masonry.h"
#import "HYNavigationController.h"

@interface PrepaySuccessViewController ()

@property (nonatomic, strong) UIButton *bottomBtn;          // 底部按钮
@property (nonatomic, strong) UIImageView *iconImageView;   // 图标
@property (nonatomic, strong) UILabel *resultLabel;         // 结果label 充值成功
@property (nonatomic, strong) UILabel *merNameLabel;        // 商家名字
@property (nonatomic, strong) UILabel *moneyLabel;          // 金额
@property (nonatomic, strong) UILabel *giveMoneyLabel;      // 赠送金额


@end

@implementation PrepaySuccessViewController

- (void)viewWillAppear:(BOOL)animated
{
    //取消侧滑退出
    HYNavigationController *nav = (HYNavigationController *)self.navigationController;
    if (nav && [nav isKindOfClass:[HYNavigationController class]])
    {
        [nav setEnableSwip:NO];
    }
}
// 返回按钮
- (void)backToRootViewController:(id)sender
{
    //恢复侧滑退出
    HYNavigationController *nav = (HYNavigationController *)self.navigationController;
    if (nav && [nav isKindOfClass:[HYNavigationController class]])
    {
        [nav setEnableSwip:YES];
    }
    switch (self.comeType) {
        case 0:
        {// 扫码
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 1:
        {// 商家
            UIViewController *vc = self.navigationController.viewControllers[1];
            [self.navigationController popToViewController:vc animated:YES];
        }
            break;
        case 2:
        {// 我的
            UIViewController *vc = self.navigationController.viewControllers[1];
            [self.navigationController popToViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _successType == 0 ? @"付款结果" : @"充值结果";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f1f1f1"]];
    
    if(self.successType == 3)
    {
        self.title = @"付款结果";
        [self payFail];
    }else
    {
        [self createUI];
        [self constraintUI];
    }
}
// 付款失败的UI
- (void)payFail
{
    // 按钮
    self.bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomBtn setFrame:CGRectMake(0, self.view.frame.size.height-49-64, self.view.frame.size.width, 49)];
    [self.bottomBtn setTitle:@"去充值" forState:UIControlStateNormal];
    [self.bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.bottomBtn setBackgroundColor:[UIColor colorWithHexString:@"0xb80000"]];
    [self.bottomBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.bottomBtn];
    // 图标
    self.iconImageView = [[UIImageView alloc] init];
    [self.iconImageView setClipsToBounds:YES];
    [self.iconImageView setImage:[UIImage imageNamed:@"failure"]];
    [self.view addSubview:self.iconImageView];
    // 结果
    self.resultLabel = [[UILabel alloc] init];
    [self.resultLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [self.resultLabel setFont:[UIFont systemFontOfSize:23]];
    [self.resultLabel setText:@"支付失败!"];
    [self.view addSubview:self.resultLabel];
    // 提示
    UILabel *label1 = [[UILabel alloc] init];
    [label1 setText:@"实体店余额不足"];
    [label1 setTextColor:[UIColor colorWithHexString:@"333333"]];
    [label1 setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:label1];
    // 剩余
    UILabel *label2 = [[UILabel alloc] init];
    [label2 setText:[NSString stringWithFormat:@"实体店余额剩余%@元",self.remindMoney]];
    [label2 setTextColor:[UIColor colorWithHexString:@"333333"]];
    [label2 setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:label2];
    
    WS(weakSelf);
    // 图标
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(76);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(@70);
        make.height.mas_equalTo(@70);
    }];
    // 结果
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.top.mas_equalTo(weakSelf.iconImageView.mas_bottom).with.offset(15);
    }];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.resultLabel.mas_bottom).with.offset(17);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label1.mas_bottom).with.offset(10);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
}

// 付款、充值成功的UI
- (void)createUI
{
    // 按钮
    self.bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomBtn setFrame:CGRectMake(0, self.view.frame.size.height-49-64, self.view.frame.size.width, 49)];
    [self.bottomBtn setTitle:_successType == 0 ? @"去评价" : @"确认" forState:UIControlStateNormal];
    [self.bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.bottomBtn setBackgroundColor:[UIColor colorWithHexString:@"0xb80000"]];
    [self.bottomBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.bottomBtn];
    // 图标
    self.iconImageView = [[UIImageView alloc] init];
    [self.iconImageView setClipsToBounds:YES];
    [self.iconImageView setImage:[UIImage imageNamed:@"successful"]];
    [self.view addSubview:self.iconImageView];
    // 结果
    self.resultLabel = [[UILabel alloc] init];
    [self.resultLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [self.resultLabel setFont:[UIFont systemFontOfSize:23]];
    [self.resultLabel setText:_successType == 0 ?@"付款成功!":@"充值成功!"]; 
    [self.view addSubview:self.resultLabel];
    // 店名
    self.merNameLabel = [[UILabel alloc] init];
    [self.merNameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [self.merNameLabel setFont:[UIFont systemFontOfSize:20]];
    [self.merNameLabel setLineBreakMode:NSLineBreakByTruncatingTail]; // 省略
    [self.merNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.merNameLabel setText:self.orderInfo.MerchantsName ? : self.merName];
    [self.view addSubview:self.merNameLabel];
    
    // 充值金额

    NSString *moneyStr;
    if (_successType == 0) {
        moneyStr = [NSString stringWithFormat:@"付款¥%@",self.orderInfo.Amount ? : self.money];
    } else {
        moneyStr = [NSString stringWithFormat:@"充值¥%@",self.money];
    }
    
    NSInteger msLength = moneyStr.length-2;
    NSRange msRange = NSMakeRange(2, msLength);
    
    NSMutableAttributedString *moneyAtt = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [moneyAtt addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"00b99b"] range:msRange];
    [moneyAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:msRange];
    
    self.moneyLabel = [[UILabel alloc] init];
    [self.moneyLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [self.moneyLabel setFont:[UIFont systemFontOfSize:15]];
    [self.moneyLabel setAttributedText:moneyAtt];
    [self.view addSubview:self.moneyLabel];
    
    if (_successType == 0){  //当为付款时，不需要显示下面的
        return;
    }
    
    // 现金券
    NSString *gmStr = [NSString stringWithFormat:@"送%@元(抵扣%@现金券)",self.coupon,self.coupon];
    if (self.businessType == 1)
    {// 桌球商家
        gmStr = [NSString stringWithFormat:@"送%@元",self.coupon];
    }
    
    self.giveMoneyLabel = [[UILabel alloc] init];
    [self.giveMoneyLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [self.giveMoneyLabel setFont:[UIFont systemFontOfSize:15]];
    [self.giveMoneyLabel setText:gmStr];
    [self.view addSubview:self.giveMoneyLabel];
    
    
}
- (void)constraintUI
{
    WS(weakSelf);
    // 图标
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(76);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(@70);
        make.height.mas_equalTo(@70);
    }];
    // 结果
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.top.mas_equalTo(weakSelf.iconImageView.mas_bottom).with.offset(15);
    }];
    // 商家
    [self.merNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(8);
        make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(-8);
        make.top.mas_equalTo(weakSelf.resultLabel.mas_bottom).with.offset(20);
    }];
    // 金额
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.top.mas_equalTo(weakSelf.merNameLabel.mas_bottom).with.offset(6);
    }];
    
    if (_successType == 0){
        return;
    }
    // 赠送金额
    [self.giveMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.top.mas_equalTo(weakSelf.moneyLabel.mas_bottom);//.with.offset(-4);
    }];

}

- (void)buttonClick
{
    //恢复侧滑退出
    HYNavigationController *nav = (HYNavigationController *)self.navigationController;
    if (nav && [nav isKindOfClass:[HYNavigationController class]])
    {
        [nav setEnableSwip:YES];
    }
    
    if (_successType == 0){
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *timeStr = [formatter stringFromDate:[NSDate date]];
        
        PostCommentViewController *tmpCtrl = [[PostCommentViewController alloc] init];
        tmpCtrl.MerId = self.orderInfo.MerchantId ? : self.merId;
        tmpCtrl.MerName = self.orderInfo.MerchantsName ? : self.merName;
        tmpCtrl.money = self.orderInfo.Amount ? : self.money;
        tmpCtrl.coupon = @"0";
        tmpCtrl.orderDate = self.orderInfo.CreateOn ? : timeStr;
        tmpCtrl.orderId = self.orderInfo.O2O_Order_Number ? : self.o2o_trade_no;
        tmpCtrl.orderType = self.orderInfo.OrderType.integerValue ? : 1;
        tmpCtrl.payPush = YES;
        [self.navigationController pushViewController:tmpCtrl animated:YES];

    } else if(_successType == 1){
        switch (self.comeType) {
            case 0:
            {// 扫码
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
                break;
            case 1:
            {// 商家
                UIViewController *vc = self.navigationController.viewControllers[1];
                [self.navigationController popToViewController:vc animated:YES];
            }
                break;
            case 2:
            {// 我的
                UIViewController *vc = self.navigationController.viewControllers[1];
                [self.navigationController popToViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }else
    {
        // 付款失败  去充值
        PrepayViewController *vc = [[PrepayViewController alloc] init];
        vc.merId = self.merId;
        vc.comeType = 1;
        [self.navigationController pushViewController:vc animated:YES];
    
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
   DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
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
