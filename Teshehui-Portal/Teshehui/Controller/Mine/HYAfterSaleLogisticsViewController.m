//
//  HYAfterSaleLogisticsViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYAfterSaleLogisticsViewController.h"
#import "UIColor+hexColor.h"
#import "HYAfterSaleAddDeliveryRequest.h"
#import "UIAlertView+BlocksKit.h"
#import "HYPickerToolView.h"
#import "HYDeliverCompanyListRequest.h"
#import "HYCodeCheckViewController.h"

@interface HYAfterSaleLogisticsViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
HYPickerToolViewDelegate,
UITextFieldDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *codeField;
@property (nonatomic, strong) UITextField *feeField;

@property (nonatomic, strong) HYAfterSaleAddDeliveryRequest *addReqeust;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) HYPickerToolView *picker;

@property (nonatomic, strong) HYDeliverCompanyListRequest *companyListRequest;
@property (nonatomic, strong) NSArray<HYDeliverCompany *> *companyList;
@property (nonatomic, strong) HYDeliverCompany *selectCompany;
@property (nonatomic, strong) NSString *fee;

@end

@implementation HYAfterSaleLogisticsViewController

- (void)dealloc
{
    [_addReqeust cancel];
    [_companyListRequest cancel];
    [HYLoadHubView dismiss];
    
    if ([_picker isShow])
    {
        [_picker dismissWithAnimation:NO];
    }
    _picker = nil;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithHexColor:@"f5f5f5" alpha:1];
    self.view = view;
    
    //tableview
    frame.size.height -= 44;
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    tableview.rowHeight = 54;
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 50)];
    foot.backgroundColor = [UIColor clearColor];
    UILabel *footLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width-40, 50)];
    footLab.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
    footLab.numberOfLines = 0;
    footLab.font = [UIFont systemFontOfSize:14.0];
    footLab.text = @"请及时登记商品寄回的快递公司和快递单号, 如7天内未登记, 售后将自动失效";
    [foot addSubview:footLab];
    tableview.tableFooterView = foot;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"快递登记";
    // Do any additional setup after loading the view.
    UIButton *commit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [commit setTitle:@"提交" forState:UIControlStateNormal];
    [commit setTitleColor:[UIColor colorWithWhite:.63 alpha:1] forState:UIControlStateNormal];
    commit.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [commit addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commitItem = [[UIBarButtonItem alloc] initWithCustomView:commit];
    self.navigationItem.rightBarButtonItem = commitItem;
    
    [self loadCompanys];
}

- (void)commitAction:(UIButton *)btn
{
    if (!_isLoading)
    {
        [self.view endEditing:YES];
        NSString *no = _codeField.text;
        NSString *fee = _feeField.text;
        if (no.length == 0 || no == nil) {
            [[UIAlertView bk_alertViewWithTitle:@"请输入快递单号"] show];
            return;
        }
        if (!self.selectCompany) {
            [[UIAlertView bk_alertViewWithTitle:@"请选择快递公司"] show];
            return;
        }
        else if (fee == nil || fee.length == 0) {
            [[UIAlertView bk_alertViewWithTitle:@"请输入运费"] show];
            return;
        }
        
        if (!_addReqeust) {
            _addReqeust = [[HYAfterSaleAddDeliveryRequest alloc] init];
        }
        _addReqeust.returnFlowDetailId = self.saleInfo.useDetail.returnFlowDetailId;
        _addReqeust.deliveryName = self.selectCompany.deliveryName;
        _addReqeust.deliveryCode = self.selectCompany.deliveryCode;
        _addReqeust.deliveryNo = no;
        _addReqeust.freightFee = fee;
        _isLoading = YES;
        [HYLoadHubView show];
        __weak typeof(self) weakSelf = self;
        [_addReqeust sendReuqest:^(id result, NSError *error) {
            [weakSelf updateWithCommitResponse:result err:error];
        }];
    }
}

- (void)updateWithCommitResponse:(CQBaseResponse *)result err:(NSError *)err
{
    _isLoading = NO;
    [HYLoadHubView dismiss];
    if (result.status == 200) {
        if (self.callback) {
            self.callback();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [UIAlertView bk_alertViewWithTitle:err.domain];
    }
}

- (void)loadCompanys
{
    _companyListRequest = [[HYDeliverCompanyListRequest alloc] init];
    __weak typeof(self) weakSelf = self;
    [HYLoadHubView show];
    [_companyListRequest sendReuqest:^(id result, NSError *error) {
        [HYLoadHubView dismiss];
        if (result && [(CQBaseResponse*)result status] == 200)
        {
            HYDeliverCompanyResponse *rs = (HYDeliverCompanyResponse *)result;
            weakSelf.companyList = rs.companyList;
        }
        else
        {
            [UIAlertView bk_alertViewWithTitle:@"提示" message:[result rspDesc]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"company"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"company"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"快递公司:";
            cell.textLabel.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
        }
        cell.detailTextLabel.text = self.selectCompany.deliveryName;
        return cell;
    }
    else if (indexPath.row == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"code"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"code"];
            cell.textLabel.text = @"快递单号:";
            cell.textLabel.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
            UITextField *codeField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, self.view.frame.size.width-90-20-48, 54)];
            codeField.textAlignment = NSTextAlignmentRight;
            codeField.delegate = self;
            [cell.contentView addSubview:codeField];
            self.codeField = codeField;
            
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            backButton.frame = CGRectMake(cell.frame.size.width-48, 7, 48, 30);
            backButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            
            UIImage *back_n = [UIImage imageNamed:@"scanner_bar_icon"];
            [backButton setImage:back_n forState:UIControlStateNormal];
            
            [backButton addTarget:self
                           action:@selector(scannerQRCode:)
                 forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:backButton];
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fee"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fee"];
            cell.textLabel.text = @"运费:";
            cell.textLabel.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
            UITextField *codeField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, self.view.frame.size.width-90-20, 54)];
            codeField.textAlignment = NSTextAlignmentRight;
            codeField.delegate = self;
            codeField.keyboardType = UIKeyboardTypeDecimalPad;
            [cell.contentView addSubview:codeField];
            self.feeField = codeField;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.row == 0)
    {
        if (!_picker) {
            _picker = [[HYPickerToolView alloc] init];
        }
        NSMutableArray *names = [NSMutableArray array];
        for (HYDeliverCompany *company in self.companyList) {
            [names addObject:company.deliveryName];
        }
        _picker.dataSouce = names;
        _picker.title = @"选择快递公司";
        _picker.delegate = self;
        if (self.selectCompany) {
            _picker.currentIndex = [self.companyList indexOfObject:self.selectCompany];
        }
        [_picker showWithAnimation:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging) {
        [self.view endEditing:YES];
    }
}

- (void)selectComplete:(HYPickerToolView *)pickerView
{
    if (pickerView.currentIndex < self.companyList.count) {
        self.selectCompany = [self.companyList objectAtIndex:pickerView.currentIndex];
    }
    [self.tableView reloadData];
}

- (void)scannerQRCode:(UIButton *)btn
{
    HYCodeCheckViewController *code = [[HYCodeCheckViewController alloc] init];
    [self.navigationController pushViewController:code animated:YES];
    code.didGetCode = ^(NSString *code) {
        self.codeField.text = code;
    };
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
