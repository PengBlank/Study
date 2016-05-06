//
//  HYGoodsRetVerifiedViewController.m
//  Teshehui
//
//  Created by RayXiang on 14-9-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodsRetVerifiedViewController.h"
#import "HYExpressSelectViewController.h"
#import "HYKeyboardHandler.h"
#import "HYOrderReturnSendedRequest.h"
#import "METoast.h"

@interface HYGoodsRetVerifiedViewController ()
<UITextFieldDelegate,
HYExpressSelectViewControllerDelegate,
HYKeyboardHandlerDelegate>

@property (nonatomic, strong) HYKeyboardHandler *boardHandler;
@property (nonatomic, strong) HYOrderReturnSendedRequest *request;

@property (nonatomic, strong) HYExpressInfo *expressInfo;
@property (nonatomic, strong) NSString *expressNum; //单号

@end

@implementation HYGoodsRetVerifiedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = self.tableView.frame;
    frame.size.height -= 44;
    self.tableView.frame = frame;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)-44, CGRectGetWidth(self.view.bounds), 44)];
    [self.view addSubview:footer];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:footer.bounds];
    bg.image = [UIImage imageNamed:@"g_ret_foot_bg.png"];
    [footer addSubview:bg];
    
    UIImage *apply = [UIImage imageNamed:@"g_ret_apply.png"];
    CGFloat x = CGRectGetMidX(footer.bounds) - apply.size.width/2;
    CGFloat y = CGRectGetMidY(footer.bounds) - apply.size.height/2;
    UIButton *applyBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, apply.size.width, apply.size.height)];
    [applyBtn setBackgroundImage:apply forState:UIControlStateNormal];
    [applyBtn addTarget:self action:@selector(applyAction:)
       forControlEvents:UIControlEventTouchUpInside];
    [applyBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [applyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [applyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [footer addSubview:applyBtn];
    
    [_tableView registerClass:[HYGoodsRetEntryCell class] forCellReuseIdentifier:@"entryCell"];
    
    self.boardHandler = [[HYKeyboardHandler alloc] initWithDelegate:self
                                                               view:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.boardHandler startListen];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.boardHandler stopListen];
}

#pragma mark - private
- (void)applyAction:(UIButton *)btn
{
    if (!self.expressInfo)
    {
        [METoast toastWithMessage:@"请选择快递公司"];
    }
    else if (!self.expressNum || [[self.expressNum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
             length] == 0)
    {
        [METoast toastWithMessage:@"请输入快递单号"];
    }
    else
    {
        [HYLoadHubView show];
        self.request = [[HYOrderReturnSendedRequest alloc] init];
        _request.express_company = self.expressInfo.expressId;
        _request.request_id = self.returnsInfo.refund_id;
        _request.invoice_no = self.expressNum;
        __weak HYGoodsRetVerifiedViewController *b_self = self;
        [self.request sendReuqest:^(id result, NSError *error)
        {
            [HYLoadHubView dismiss];
            HYOrderReturnSendedResponse *response = (HYOrderReturnSendedResponse *)result;
            if (response.status == 200)
            {
                [METoast toastWithMessage:@"快递信息已提交"];
                if (b_self.refundCallback)
                {
                    b_self.refundCallback(b_self.returnsInfo, HYRefund_BuyerSent);
                }
                [b_self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [METoast toastWithMessage:error.domain];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return [self progressCell];
    }
    if (indexPath.row == 1) {
        return (UITableViewCell *)[self statCell];
    }
    if (indexPath.row == 2) {
        return (UITableViewCell *)[self warningCellWithWarning:[self warning]];
    }
    if (indexPath.row == 3) {
        return [self infoCellWithInfo:@{@"商品返回方式": @"快递至卖家"}];
    }
    if (indexPath.row == 4) {
        return [self addressCell];
    }
    if (indexPath.row == 5) {
        return [self pressSelectCell];
    }
    if (indexPath.row == 6) {
        return [self pressCodeInputCell];
    }
    if (indexPath.row == 7) {
        return (UITableViewCell *)[self serviceTypeCell];
    }
    if (indexPath.row == 8) {
        return [self numCell];
    }
    if (indexPath.row == 9) {
        return (UITableViewCell *)[self detailCell];
    }
    if (indexPath.row == 10) {
        return (UITableViewCell *)[self photoCell];
    }
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 5)
    {
        HYExpressSelectViewController *vc = [[HYExpressSelectViewController alloc] init];
        vc.delegate = self;
        vc.showAllExpress = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didSelectExperss:(HYExpressInfo *)express
{
    self.expressInfo = express;
    [self.tableView reloadData];
}

- (HYGoodsRetGrayCell *)pressSelectCell
{
    HYGoodsRetGrayCell *grayCell = [_tableView dequeueReusableCellWithIdentifier:@"grayCell"];
    grayCell.selectable = YES;
    grayCell.nessary = NO;
    grayCell.keyLab.text = @"退/换货物流";
    if (self.expressInfo) {
        grayCell.valueLab.text = _expressInfo.expressName;
    }
    else
    {
        grayCell.valueLab.text = @"选择物流公司";
    }
    
    return grayCell;
}

- (HYGoodsRetEntryCell *)pressCodeInputCell
{
    HYGoodsRetEntryCell *entryCell = [_tableView dequeueReusableCellWithIdentifier:@"entryCell"];
    entryCell.keyLab.text = @"快递单号";
    entryCell.textField.placeholder = @"请输入退/换货快递单号";
    entryCell.textField.text = self.expressNum;
    entryCell.textField.delegate = self;
    return entryCell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.expressNum = textField.text;
}

- (NSString *)warning
{
    return @"卖家已同意退货，为避免退货流程失败，请尽快将坏旧商品快递至卖家，并填写相关物流配送信息。";
}

- (HYGoodsRetDetailCell *)addressCell
{
    HYGoodsRetDetailCell *detailCell = [self.tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    detailCell.keyLab.text = @"商品返回地址";
    
    NSString *content = [NSString stringWithFormat:@"收货人：%@ 电话：%@ \n 地址：%@", self.returnsInfo.return_to_name, self.returnsInfo.return_to_tel, self.returnsInfo.return_to];
    detailCell.detailContent = content;
    return detailCell;
}

#pragma mark - keyboard handler delegate

- (void)keyboardChangeFrame:(CGRect)kFrame
{
    
}
- (void)keyboardHide
{
    
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

@end
