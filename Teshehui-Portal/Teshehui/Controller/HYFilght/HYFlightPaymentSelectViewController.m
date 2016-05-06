//
//  HYFlightPaymentSelectViewController.m
//  Teshehui
//
//  Created by HYZB on 14-8-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightPaymentSelectViewController.h"
#import "HYBaseLineCell.h"
#import "HYFlightCreditCardPayViewController.h"
#import "HYFlightWapPayViewController.h"

#import "HYPassengers.h"
#import "HYUserInfo.h"

#import "HYFlightOrderRequest.h"

@interface HYFlightPaymentSelectViewController ()<HYFlightWapPayViewControllerDelegate>
{
    HYFlightOrderRequest *_orderReq;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYFlightOrder *order;

@end

@implementation HYFlightPaymentSelectViewController

- (void)dealloc
{
    [_orderReq cancel];
    _orderReq = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    UILabel* nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10,0,50, 44)];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.textColor = [UIColor darkTextColor];
    nameLab.font = [UIFont systemFontOfSize:18.0f];
    nameLab.text = @"金额:";
    [self.view addSubview:nameLab];
    
    UILabel* moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(60,0,240,44)];
    moneyLab.backgroundColor = [UIColor clearColor];
    moneyLab.textColor = [UIColor colorWithRed:1.0f green:0.49f blue:0.075 alpha:1.0f];
    moneyLab.font = [UIFont systemFontOfSize:18.0f];
    moneyLab.text = [NSString stringWithFormat:@"¥%.02f",self.totalPrice];
    [self.view addSubview:moneyLab];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 1.0)];
    lineView.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                topCapHeight:0];
    [self.view addSubview:lineView];
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, frame.origin.y+44, frame.size.width, frame.size.height - 108)
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.scrollEnabled = NO;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.sectionFooterHeight = 0;
    tableview.sectionHeaderHeight = 45;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付方式";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - private methods

- (void)wapPayment
{
    //防止在wap支付异常的时候重复下单
    if (self.order)
    {
        HYFlightWapPayViewController *vc = [[HYFlightWapPayViewController alloc] init];
        vc.orderNO = self.order.orderCode;
        vc.delegate = self;
        vc.navbarTheme = self.navbarTheme;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
    else
    {
        [self orderFlight];
    }
}

- (void)orderFlight
{
    if (!self.order)
    {
        if (_orderReq)
        {
            [_orderReq cancel];
            _orderReq = nil;
        }
        
        [HYLoadHubView show];
        
        _orderReq = [[HYFlightOrderRequest alloc] init];
        
        HYUserInfo *user = [HYUserInfo getUserInfo];
        _orderReq.user_id = user.userId;
        _orderReq.contactPhone = self.phoneNumber;
        _orderReq.guestItems = self.passengers;
        _orderReq.cabin = self.cabin;
        _orderReq.flight = self.flight;
        
        if (self.spendPattern == Enterprise_SP)
        {
            _orderReq.isEnterprise = user.enterpriseId;
        }
        
        if (self.invoiceAdds)
        {
            _orderReq.isNeenJourney = YES;
            _orderReq.userAddressId = self.invoiceAdds.addr_id;
        }
        
        __weak typeof(self) b_self = self;
        [_orderReq sendReuqest:^(id result, NSError *error) {
            
            [HYLoadHubView dismiss];
            
            HYFlightOrder *order = nil;
            if ([result isKindOfClass:[HYFlightOrderResponse class]])
            {
                HYFlightOrderResponse *rs = (HYFlightOrderResponse *)result;
                order = rs.filghtOrder;
            }
            
            [b_self orderFlightResult:order error:error];
        }];
    }
    else
    {
        [self wapPayment];
    }
}


- (void)orderFlightResult:(HYFlightOrder *)order error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    if (!error && [order.orderCode length] > 0)
    {
        self.order = order;
        [self wapPayment];
    }
    else
    {
        NSString *msg = error.domain;
        if (!msg)
        {
            msg = @"机票下单失败, 建议您重新选择航班";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

#pragma mark - HYFlightWapPayViewControllerDelegate
- (void)didPaymentResult:(BOOL)succ
{
    if (succ)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;
    
    return height;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
    if(indexPath.row == totalRow -1){
        //this is the last row in section.
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *hotelNameCell = @"hotelNameCell";
    HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:hotelNameCell];
    if (cell == nil)
    {
        cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:hotelNameCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    if (indexPath.row == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"person_icon_t3"];
        cell.textLabel.text = @"信用卡支付";
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"ctrip_icon"];
        cell.textLabel.text = @"携程支付";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)  //信用卡
    {
        HYFlightCreditCardPayViewController *vc = [[HYFlightCreditCardPayViewController alloc] init];
        vc.cabin = self.cabin;
        vc.flight = self.flight;
        vc.passengers = self.passengers;
        vc.invoiceAdds = self.invoiceAdds;
        vc.spendPattern = self.spendPattern;
        vc.phoneNumber = self.phoneNumber;
        vc.totalPrice = self.totalPrice;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
    else  // wap 在线
    {
        //先下订单，然后支付
        [self wapPayment];
    }
}


@end
