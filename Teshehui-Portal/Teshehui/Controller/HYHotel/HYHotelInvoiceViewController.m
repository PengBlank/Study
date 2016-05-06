//
//  HYHotelInvoiceViewController.m
//  Teshehui
//
//  Created by apple on 15/3/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYHotelInvoiceViewController.h"
#import "HYHotelInvoiceNeedCell.h"
#import "HYHotelInvoiceTextCell.h"
#import "HYHotelInvoiceCell.h"
#import "HYInvoiceTitlesViewController.h"
#import "HYPickerToolView.h"
#import "HYDeliveryAddressViewController.h"
#import "HYUserInfo.h"
#import "HYHotelInvoiceMethodRequest.h"
#import "HYHotelInvoiceMethodResponse.h"
#import "HYHotelInvoiceMethod.h"

@interface HYHotelInvoiceViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
HYPickerToolViewDelegate,
DeliverAdreeDelegate,
UITextFieldDelegate,
UIAlertViewDelegate
>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) HYPickerToolView *descPicker;
@property (nonatomic, assign) BOOL isEdit;

//数据部分

//配送方式
@property (nonatomic, strong) HYHotelInvoiceMethodRequest *methodRequest;
@property (nonatomic, strong) NSArray *invoiceMethods;
@property (nonatomic, strong) HYPickerToolView *methodPicker;

@end

@implementation HYHotelInvoiceViewController

- (void)dealloc
{
    [_methodRequest cancel];
    _methodRequest = nil;
    [HYLoadHubView dismiss];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.needInvoice = NO;
        self.isEdit = NO;
    }
    return self;
}

- (void)loadView
{
    NSArray *views = [[UINib nibWithNibName:self.nibName bundle:self.nibBundle] instantiateWithOwner:self options:nil];
    self.view = [views objectAtIndex:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发票";
    self.view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                                green:237.0f/255.0f
                                                 blue:237.0f/255.0f
                                                alpha:1.0];
    
    if (!_invoiceModel)
    {
        _invoiceModel = [[HYHotelInvoiceModel alloc] init];
//        _invoiceModel.invoice_phone = [HYUserInfo getUserInfo].phoneMob;
    }
    
    //table
    //self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    //self.tableView.delegate = self;
    //self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HYHotelInvoiceNeedCell" bundle:nil] forCellReuseIdentifier:@"needCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYHotelInvoiceCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYHotelInvoiceTextCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    
    //尾部，发票声明
    self.tableView.tableFooterView = [self getTableFooter];
    
    //nav
    UIButton *fillBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    [fillBtn setTitle:@"完成" forState:UIControlStateNormal];
    [fillBtn setTitleColor:self.navBarTitleColor forState:UIControlStateNormal];
    [fillBtn addTarget:self action:@selector(invoiceInfoComplete) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fillItem = [[UIBarButtonItem alloc] initWithCustomView:fillBtn];
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0 && [UIDevice currentDevice].systemVersion.floatValue >= 7.0)
    {
        UIBarButtonItem *off = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        off.width = - 12;
        self.navigationItem.rightBarButtonItems = @[off, fillItem];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = fillItem;
    }
    
    [self getInvoiceMethods];
}

- (UIView *)getTableFooter
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100)];
    footer.backgroundColor = [UIColor clearColor];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, CGRectGetWidth(footer.frame)-30, 100)];
    lab.numberOfLines = 0;
    lab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lab.font = [UIFont systemFontOfSize:12.0];
    lab.text = @"发票由携程提供，金额不包括优惠券或礼品卡支付的部分。将在您退房后5-10个工作日内以快递方式送达";
    [lab sizeToFit];
    [footer addSubview:lab];
    return footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - datas

- (void)getInvoiceMethods
{
    [HYLoadHubView show];
    _methodRequest = [[HYHotelInvoiceMethodRequest alloc] init];
    __weak typeof(self) b_self = self;
    [_methodRequest sendReuqest:^(id result, NSError *error)
    {
        [b_self updateWithMethodResponse:result error:error];
    }];
}

- (void)updateWithMethodResponse:(HYHotelInvoiceMethodResponse *)rs error:(NSError *)error
{
    [HYLoadHubView dismiss];
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag = 1002;
        [alert show];
    }
    else
    {
        self.invoiceMethods = rs.shipMethods;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1002)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)invoiceInfoComplete
{
    if (_needInvoice)
    {
        NSString *error = [_invoiceModel completeValidate];
        if (error)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
    }
    if (self.invoiceCallback)
    {
        self.invoiceCallback(_needInvoice ? _invoiceModel : nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return _needInvoice ? 4 : 0;
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        HYHotelInvoiceNeedCell *needCell = [tableView dequeueReusableCellWithIdentifier:@"needCell"];
        needCell.needSwitch.on = self.needInvoice;
        [needCell.needSwitch addTarget:self action:@selector(needSwitchAction:) forControlEvents:UIControlEventValueChanged];
        return needCell;
    }
    else
    {
        /*
        if (indexPath.row == 3)
        {
            HYHotelInvoiceTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
            cell.field.delegate = self;
            cell.field.text = _invoiceModel.invoice_phone;
            return cell;
        }
         */
            HYHotelInvoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self configureCell:cell withIndexPath:indexPath];
            return cell;
        
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            HYInvoiceTitlesViewController *titles = [[HYInvoiceTitlesViewController alloc] init];
            titles.titlesAction = HYInvoiceTitlesSelect;
            titles.selectedTitle = _invoiceModel.invoice_title;
            titles.navbarTheme = self.navbarTheme;
            titles.invoiceTitlesCallback = ^(NSString *title)
            {
                _invoiceModel.invoice_title = title;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:titles animated:YES];
        }
        else if (indexPath.row == 1)
        {
            [self.descPicker showWithAnimation:YES];
        }
        else if (indexPath.row == 2)
        {
            HYDeliveryAddressViewController* addAdress = [[HYDeliveryAddressViewController alloc]init];
            addAdress.navbarTheme = self.navbarTheme;
            addAdress.type = 1;
            addAdress.delegate = self;
            [self.navigationController pushViewController:addAdress animated:YES];
        }
        else if (indexPath.row == 3)
        {
            [self.methodPicker showWithAnimation:YES];
        }
    }
}

- (void)configureCell:(HYHotelInvoiceCell *)cell withIndexPath:(NSIndexPath *)path
{
    NSString *desc = nil;
    NSString *title = nil;
    UIColor *descColor = nil;
    if (path.row == 0)
    {
        title = @"发票抬头";
        desc = _invoiceModel.invoice_title ? _invoiceModel.invoice_title : @"选择发票抬头";
        descColor = _invoiceModel.invoice_title ? [UIColor blackColor] : [UIColor grayColor];
    }
    else if (path.row == 1)
    {
        title = @"发票明细";
        desc = _invoiceModel.invoice_description ? _invoiceModel.invoice_description : @"选择发票明细";
        descColor = _invoiceModel.invoice_description ? [UIColor blackColor] : [UIColor grayColor];
    }
    else if (path.row == 2)
    {
        title = @"收件人地址";
        desc = _invoiceModel.invoice_address ? _invoiceModel.invoice_address : @"请选择发票收件人地址";
        descColor = _invoiceModel.invoice_address ? [UIColor blackColor] : [UIColor grayColor];
    }
    else if (path.row == 3)
    {
        title = @"配送方式";
        desc = _invoiceModel.method.shippingDisplay;
        descColor = _invoiceModel.method ? [UIColor blackColor] : [UIColor grayColor];
    }
    
    cell.nameLab.text = title;
    cell.descLab.text = desc;
    cell.descLab.textColor = descColor;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return _needInvoice ? 10 : 0;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    v.image = [[UIImage imageNamed:@"ticket_bg_gray_g5"] stretchableImageWithLeftCapWidth:2
                                                                             topCapHeight:4];
    
    return v;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow -1)
    {
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.isEdit = YES;
    [self.tableView setContentOffset:CGPointMake(0, 100) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.isEdit = NO;
    _invoiceModel.invoice_phone = textField.text;
}

#pragma mark - Actions
- (void)needSwitchAction:(UISwitch *)aSwitch
{
    self.needInvoice = aSwitch.on;
    [self.tableView reloadData];
}

#pragma mark - setter/getter
- (HYPickerToolView *)descPicker
{
    if (!_descPicker)
    {
        _descPicker = [[HYPickerToolView alloc] init];
        _descPicker.title = @"发票明细";
        _descPicker.dataSouce = @[@"代订房费", @"代订住宿费"];
        _descPicker.delegate = self;
    }
    return _descPicker;
}

- (HYPickerToolView *)methodPicker
{
    if (!_methodPicker)
    {
        _methodPicker = [[HYPickerToolView alloc] init];
        _methodPicker.title = @"配送方式";
        _methodPicker.delegate = self;
    }
    
    NSMutableArray *display = [NSMutableArray array];
    for (HYHotelInvoiceMethod *method in _invoiceMethods)
    {
        [display addObject:method.shippingDisplay];
    }
    _methodPicker.dataSouce = display;
    
    return _methodPicker;
}

- (void)selectComplete:(HYPickerToolView *)pickerView
{
    if (pickerView == _descPicker)
    {
        NSString *desc = [_descPicker.dataSouce objectAtIndex:_descPicker.currentIndex];
        self.invoiceModel.invoice_description = desc;
        [self.tableView reloadData];
    }
    if (pickerView == _methodPicker)
    {
        HYHotelInvoiceMethod *method = [_invoiceMethods objectAtIndex:pickerView.currentIndex];
        self.invoiceModel.method = method;
        [self.tableView reloadData];
    }
}

- (void)getAdress:(HYAddressInfo*)info
{
    if (info)
    {
        _invoiceModel.invoice_person_name = info.consignee;
        _invoiceModel.invoice_address = info.addressDetail;
        _invoiceModel.invoice_address_id = info.addr_id;
        [self.tableView reloadData];
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
