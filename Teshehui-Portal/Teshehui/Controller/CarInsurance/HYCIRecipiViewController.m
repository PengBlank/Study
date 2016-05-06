//
//  HYCIRecipiViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIRecipiViewController.h"
#import "HYCITableViewInputCell.h"
#import "HYCITableViewSelectCell.h"
#import "HYCICheckBoxCell.h"
#import "HYCIConfirmViewController.h"
#import "HYCIDeliverInfo.h"
#import "HYKeyboardHandler.h"
#import "HYCICityPickerView.h"
#import "NSDate+Addition.h"

@interface HYCIRecipiViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
HYKeyboardHandlerDelegate,
HYCICheckBoxCellDelegate,
HYCICityPickerViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HYCIDeliverInfo *deliverInfo;
@property (nonatomic, assign) BOOL insuredAddressIsSame;    //被保人同收件人

@property (nonatomic, strong) HYKeyboardHandler *keyboardHandler;

@property (nonatomic, strong) HYCICityPickerView *cityPicker;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) HYCICityInfo *cityInfo;

@end

@implementation HYCIRecipiViewController

- (void)dealloc
{
    [_keyboardHandler stopListen];
    [self.cityPicker dismissWithAnimation:YES];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.insuredAddressIsSame = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"收件人信息";
    self.view.backgroundColor = [UIColor colorWithWhite:.97 alpha:1];
    
    CGRect frame = self.view.bounds;
    frame.size.height -= 64;
    
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [self tableFooterView];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCITableViewInputCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"inputCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCITableViewSelectCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"selectCell"];
    [self.view addSubview:self.tableView];
    
    self.keyboardHandler = [[HYKeyboardHandler alloc] initWithDelegate:self
                                                                  view:self.view];
    [self.keyboardHandler startListen];
    
    self.cityPicker = [[HYCICityPickerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 260)];
    self.cityPicker.delegate = self;
    self.city = @"选择城市";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
- (HYCIDeliverInfo *)deliverInfo
{
    if (!_deliverInfo)
    {
        _deliverInfo = [[HYCIDeliverInfo alloc] init];
    }
    return _deliverInfo;
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
    infoLab.text = nil;
    [view addSubview:infoLab];
    
    UIImage *submit = [UIImage imageNamed:@"ci_btn_on"];
    submit = [submit stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:
                         CGRectMake(CGRectGetMidX(self.view.bounds)-85, 50, 170, 35)];
    
    [nextBtn setBackgroundImage:submit forState:UIControlStateNormal];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self
                action:@selector(nextAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:nextBtn];
    return view;
}

- (void)nextAction:(UIButton *)btn
{
    //验证
    [self.view endEditing:YES];
    
    if (1)
    {
        NSString *err = nil;
        if (self.deliverInfo.addressseeName.length == 0)
        {
            err = @"请输入收件人姓名";
        }
        else if (self.deliverInfo.addressseeMobilephone.length == 0)
        {
            err = @"请输入收件人电话";
        }
        else if (self.deliverInfo.addresseeDetails.length == 0)
        {
            err = @"请输入收件人详情地址";
        }
        else if (self.deliverInfo.insuredAddresseeDetails.length == 0&&
                 !self.insuredAddressIsSame)
        {
            err = @"请输入被保人身份证地址详情";
        }
        else if (!self.cityInfo)
        {
            err = @"请选择收件人地址";
        }
        if (err)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:err delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    else
    {
        NSString *json = @"{\"deliveryDate\":\"2015-07-25\",\"addressseeName\":\"测试\",\"addressseeMobilephone\":\"151322332\",\"addresseeProvince\":\"51\",\"addresseeCity\":\"5101\",\"addresseeTown\":\"510102\",\"addresseeDetails\":\"四川省 成都市 大安市\",\"insuredAddresseeDetails\":\"四川省 成都市 大安市\"}";
        self.deliverInfo = [[HYCIDeliverInfo alloc] initWithString:json error:nil];
    }
    
    //被保人身份证地址同收件人
    if (self.insuredAddressIsSame)
    {
        self.deliverInfo.insuredAddresseeDetails = self.deliverInfo.addresseeDetails;
    }
    
    //写死配送时间
    self.deliverInfo.deliveryDate = [[[NSDate date] dateByAddingTimeInterval:3*24*60*60] timeDescription];
    
    HYCIConfirmViewController *confirm = [[HYCIConfirmViewController alloc] init];
    confirm.deliverInfo = self.deliverInfo;
    confirm.totalAmount = self.totalAmount;
    confirm.points = self.points;
    confirm.insureDates = self.insureDates;
    confirm.commercialInsureInfos = self.commercialInsureInfos;
    confirm.forceInsureInfos = self.forceInsureInfos;
    confirm.ownerInfo = self.ownerInfo;
    confirm.carInfo = self.carInfo;
    confirm.sessionid = self.sessionid;
    [self.navigationController pushViewController:confirm animated:YES];
}

#pragma mark - tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.insuredAddressIsSame ? 5 : 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        HYCITableViewInputCell *inputCell = [tableView dequeueReusableCellWithIdentifier:@"inputCell"];
        inputCell.nameLab.text = @"收件人姓名:";
        inputCell.inputField.placeholder = @"请输入收件人姓名";
        inputCell.inputField.text = self.deliverInfo.addressseeName;
        inputCell.inputField.delegate = self;
        inputCell.inputField.tag = indexPath.section;
        return inputCell;
    }
    else if (indexPath.section == 1)
    {
        HYCITableViewInputCell *inputCell = [tableView dequeueReusableCellWithIdentifier:@"inputCell"];
        inputCell.nameLab.text = @"收件人电话:";
        inputCell.inputField.placeholder = @"请输入收件人电话";
        inputCell.inputField.text = self.deliverInfo.addressseeMobilephone;
        inputCell.inputField.delegate = self;
        inputCell.inputField.tag = indexPath.section;
        return inputCell;
    }
    else if (indexPath.section == 2)
    {
        HYCITableViewSelectCell *selectCell = [tableView dequeueReusableCellWithIdentifier:@"selectCell"];
        selectCell.nameLab.text = @"收件人地址:";
        selectCell.contentLab.text = self.city;
        
        return selectCell;
    }
    else if (indexPath.section == 3)
    {
        HYCITableViewInputCell *inputCell = [tableView dequeueReusableCellWithIdentifier:@"inputCell"];
        inputCell.nameLab.text = @"详细地址:";
        inputCell.inputField.placeholder = @"请输入详细地址";
        inputCell.inputField.text = self.deliverInfo.addresseeDetails;
        inputCell.inputField.delegate = self;
        inputCell.inputField.tag = indexPath.section;
        return inputCell;
    }
    else if (indexPath.section == 4)
    {
        HYCICheckBoxCell* cell = [tableView dequeueReusableCellWithIdentifier:@"checkBoxCell"];
        if (!cell)
        {
            cell = [[HYCICheckBoxCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:@"checkBoxCell"];
        }
        cell.textLabel.text = @"被保人身份证地址：";
        cell.detailTextLabel.text = @"同收件人";
        cell.isChecked = self.insuredAddressIsSame;
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.section == 5)
    {
        HYCITableViewInputCell *inputCell = [tableView dequeueReusableCellWithIdentifier:@"inputCell"];
        inputCell.nameLab.text = @"详细地址:";
        inputCell.inputField.placeholder = @"请输入详细地址";
        inputCell.inputField.text = self.deliverInfo.insuredAddresseeDetails;
        inputCell.inputField.delegate = self;
        inputCell.inputField.tag = indexPath.section;
        return inputCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        [self.view endEditing:YES];
        [self.cityPicker showWithAnimation:YES];
    }
}

//city picker
- (void)selectComplete:(HYCICityPickerView *)pickerView
{
    HYCICityInfo *province = pickerView.provinceInfo;
    HYCICityInfo *cityInfo = pickerView.cityInfo;
    HYCICityInfo *areay = pickerView.areaInfo;
    if (province && cityInfo)
    {
        NSString *detail = [NSString stringWithFormat:@"%@%@",
                            province.regionName,
                            cityInfo.regionName];
        if (areay)
        {
            detail = [detail stringByAppendingString:areay.regionName];
        }
        self.city = detail;
        self.cityInfo = areay ? areay : cityInfo;
        [self.tableView reloadData];
        
        self.deliverInfo.addresseeProvince = province.cId;
        self.deliverInfo.addresseeCity = cityInfo.cId;
        self.deliverInfo.addresseeTown = areay.cId;
    }
}


#pragma mark - scroll view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        [self.view endEditing:YES];
    }
}

#pragma mark - text field
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.keyboardHandler.inputView = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 0:
            self.deliverInfo.addressseeName = textField.text;
            break;
        case 1:
            self.deliverInfo.addressseeMobilephone = textField.text;
            break;
        case 3:
            self.deliverInfo.addresseeDetails = textField.text;
            break;
        case 5:
            self.deliverInfo.insuredAddresseeDetails = textField.text;
            break;
        default:
            break;
    }
}

#pragma mark - keyboard
- (void)inputView:(UIView *)inputView willCoveredWithOffset:(CGFloat)offset
{
    NSLog(@"输入框被盖住");
    CGPoint contentOffset = self.tableView.contentOffset;
    contentOffset.y += offset;
    [self.tableView setContentOffset:contentOffset animated:YES];
}

- (void)keyboardWillChangeFrame:(CGRect)kFrame
{
    
}

#pragma mark - check
- (void)checkBoxCellIsChecked:(HYCICheckBoxCell *)cell;
{
    self.insuredAddressIsSame = cell.isChecked;
    [self.tableView reloadData];
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
