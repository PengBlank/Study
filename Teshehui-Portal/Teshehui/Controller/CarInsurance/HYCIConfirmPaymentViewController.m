//
//  HYCIConfirmPaymentViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/16.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIConfirmPaymentViewController.h"
#import "HYCITableViewConfirmExpandCell.h"
#import "HYCIPaymentInfoCell.h"
#import "HYCIGetPaymentURLRequest.h"
#import "HYCIGetPaymentURLResponse.h"
#import "HYCIPaymentViewController.h"

@interface HYCIConfirmPaymentViewController ()
<UITableViewDataSource,
UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HYCIGetPaymentURLRequest *paymentRequest;

@end

@implementation HYCIConfirmPaymentViewController

- (void)dealloc
{
    [_paymentRequest cancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    
    self.view.backgroundColor = [UIColor colorWithWhite:.97 alpha:1];
    CGRect frame = self.view.bounds;
    frame.size.height -= 64;
    
    
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [self tableFooterView];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCITableViewConfirmExpandCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"expandCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCIPaymentInfoCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"paymentInfoCell"];
    [self.view addSubview:self.tableView];
}

- (UIView *)tableFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            CGRectGetWidth(self.view.bounds),
                                                            100)];
    view.backgroundColor = [UIColor colorWithWhite:.97 alpha:1];
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:
                        CGRectMake(15, 5, CGRectGetWidth(self.view.bounds)-30, 40)];
    infoLab.numberOfLines = 0;
    infoLab.font = [UIFont systemFontOfSize:13.0];
    infoLab.textColor = [UIColor colorWithWhite:.83 alpha:1];
    infoLab.backgroundColor = [UIColor clearColor];
//    infoLab.text = @"一定要输入有效邮箱哦！方便接收电子保单、礼品等信息哦！";
    [view addSubview:infoLab];
    
    UIImage *submit = [UIImage imageNamed:@"ci_btn_on"];
    submit = [submit stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:
                         CGRectMake(CGRectGetMidX(self.view.bounds)-85, 50, 170, 35)];
    
    [nextBtn setBackgroundImage:submit forState:UIControlStateNormal];
    [nextBtn setTitle:@"支付" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self
                action:@selector(nextAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:nextBtn];
    return view;
}

- (void)nextAction:(UIButton *)btn
{
    [self getPaymentURL];
}

#pragma mark - private
- (void)getPaymentURL
{
    if (!_paymentRequest)
    {
        _paymentRequest = [[HYCIGetPaymentURLRequest alloc] init];
    }
    [_paymentRequest cancel];
    _paymentRequest.sessionid = self.sessionid;
    _paymentRequest.insuredName = self.order.insuredInfo.name;
    _paymentRequest.policyNo = self.order.insuranceInfo.bizPolicyNo;
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_paymentRequest sendReuqest:^(HYCIGetPaymentURLResponse* result, NSError *error)
     {
         if (!error)
         {
             HYCIPaymentViewController *payment = [[HYCIPaymentViewController alloc] init];
             payment.paymentURL = result.paymentURL;
             payment.pageFrom = b_self.pageFrom;
             [b_self.navigationController pushViewController:payment animated:YES];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
             [alert show];
         }
     }];
}

#pragma mark - tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:
                      CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 5)];
    UIImageView *_lineView = [[UIImageView alloc] initWithFrame:
                              CGRectMake(0, CGRectGetMaxY(header.bounds)-1, CGRectGetWidth(header.frame), 1.0)];
    _lineView.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
    [header addSubview:_lineView];
    return header;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 44 : 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        HYCITableViewConfirmExpandCell *expandCell = [tableView dequeueReusableCellWithIdentifier:@"expandCell"];
        expandCell.nameLab.text = @"订单信息";
        expandCell.indicator.hidden = YES;
        return expandCell;
    }
    else if (indexPath.row == 1)
    {
        HYCIPaymentInfoCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"paymentInfoCell"];
        detailCell.orderNoLabel.text = self.order.orderCode;
        detailCell.productLabel.text = @"阳光车险";
        detailCell.orderAmountLabel.text = [NSString stringWithFormat:@"%.2f元", self.order.orderTotalAmount.floatValue];
        detailCell.orderPointLabel.text = [NSString stringWithFormat:@"%ld现金券", self.order.points.integerValue];
        return detailCell;
    }
    
    return nil;
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
