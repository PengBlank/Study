//
//  HYCIBaseInfoViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIBaseInfoViewController.h"
#import "HYCITableViewInputCell.h"
#import "HYCITableViewSelectCell.h"
#import "HYKeyboardHandler.h"
#import "HYCICityPickerView.h"

#import "HYCIQuoteViewController.h"
#import "HYCIFillCarInfoViewController.h"
#import "NSString+Addition.h"
#import "HYCIConfirmCodeViewController.h"
#import "HYCIConfirmPaymentViewController.h"
#import "HYCICarInfo.h"
#import "HYCIGetCarFillInfoListReq.h"

@interface HYCIBaseInfoViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
HYKeyboardHandlerDelegate,
HYCICityPickerViewDelegate>
{
    HYCIGetCarFillInfoListReq *_getFillInfoReq;
}
@property (nonatomic, strong) UITableView *tableView;

//城市名，由定位获得，定位失败则为"定位失败，请选择城市"
@property (nonatomic, strong) HYCICityPickerView *cityPicker;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) HYCICityInfo *cityInfo;

@property (nonatomic, strong) NSString *carNum;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *idNum;

@property (nonatomic, strong) HYKeyboardHandler *keyboardHandler;

@property (nonatomic, strong) HYCIOwnerInfo *getCarFillInfoParam;

@end

@implementation HYCIBaseInfoViewController

- (void)dealloc
{
    [_keyboardHandler stopListen];
    [_cityPicker dismissWithAnimation:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"基本信息";
    self.view.backgroundColor = [UIColor colorWithWhite:.97 alpha:1];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
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

- (UIView *)tableFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            CGRectGetWidth(self.view.bounds),
                                                            100)];
    view.backgroundColor = [UIColor colorWithWhite:.97 alpha:1];
//    UIImageView *_lineView = [[UIImageView alloc] initWithFrame:
//                              CGRectMake(0, 0, CGRectGetWidth(view.frame), 1.0)];
//    _lineView.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
//                                                                                 topCapHeight:0];
//    [view addSubview:_lineView];
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:
                        CGRectMake(15, 5, CGRectGetWidth(self.view.bounds)-30, 40)];
    infoLab.numberOfLines = 0;
    infoLab.font = [UIFont systemFontOfSize:13.0];
    infoLab.textColor = [UIColor colorWithWhite:.83 alpha:1];
    infoLab.backgroundColor = [UIColor clearColor];
    infoLab.text = @"一定要输入有效邮箱哦！方便接收电子保单、礼品等信息哦！";
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
//    HYCIConfirmPaymentViewController *paymebnt = [[HYCIConfirmPaymentViewController alloc] init];
//    [self.navigationController pushViewController:paymebnt animated:YES];
    
//    HYCIConfirmCodeViewController *code = [[HYCIConfirmCodeViewController alloc] init];
//    [self.navigationController pushViewController:code animated:YES];
//    return;
    
        
    [self.view endEditing:YES];
    
    NSString *errMessage = nil;
    if (!self.cityInfo)
    {
        errMessage = @"请选择城市";
    }
    else if (self.ownerName.length == 0)
    {
        errMessage = @"请输入车主姓名";
    }
    else if (self.phoneNum.length == 0 || ![self.phoneNum checkPhoneNumberValid])
    {
        errMessage = @"请输入正确的电话号码";
    }
    else if (self.idNum.length == 0 || ![NSString validateIDCardNumber:self.idNum])
    {
        errMessage = @"请输入正确的身份证号码";
    }
    else if (self.email.length == 0)
    {
        errMessage = @"请输入邮箱";
    }
    if (errMessage)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:errMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.getCarFillInfoParam = [[HYCIOwnerInfo alloc] init];
    _getCarFillInfoParam.cityId = self.cityInfo.cId;
    _getCarFillInfoParam.ownerName = self.ownerName;
    _getCarFillInfoParam.plateNumber = self.carNum;
    _getCarFillInfoParam.ownerMobilephone = self.phoneNum;
    _getCarFillInfoParam.email = self.email;
    _getCarFillInfoParam.ownerIdNo = self.idNum;
    _getCarFillInfoParam.isNewCar = self.carNum.length > 0? 0 : 1;
    
    [HYLoadHubView show];
    
    _getFillInfoReq = [[HYCIGetCarFillInfoListReq alloc] init];
    _getFillInfoReq.reqParam = self.getCarFillInfoParam;
    
    __weak typeof(self) bself = self;
    [_getFillInfoReq sendReuqest:^(id result, NSError *error) {
        
        [bself updateWithResponse:result error:error];
    }];
}

- (void)updateWithResponse:(HYCIGetCarFillInfoListResp *)response error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    if (!error)
    {
        NSArray * carInfoFillList = [(HYCIGetCarFillInfoListResp *)response carInfoShowList];
        NSArray * carInfoAllList = [(HYCIGetCarFillInfoListResp *)response carInfoAllList];
        NSString * infoKey = [(HYCIGetCarFillInfoListResp *)response infoKey];
        NSString *searchkey = response.vichelSearchKey;
        if (!infoKey)
        {
            infoKey = @"vehicleInfo";
        }
        NSString * sessionId = [(HYCIGetCarFillInfoListResp *)response sessionId];
        NSDictionary * packageTypeMap = [(HYCIGetCarFillInfoListResp *)response packageTypeMap];
        if (carInfoAllList.count == 1)
        {
            carInfoFillList = carInfoAllList;
        }
        for (HYCICarInfoFillType *type in carInfoAllList)
        {
            if ([type.name isEqualToString:@"ownerName"])
            {
                type.value = self.getCarFillInfoParam.ownerName;
            }
            else if ([type.name isEqualToString:@"ownerIdNo"])
            {
                type.value = self.getCarFillInfoParam.ownerIdNo;
            }
        }
#if TARGET_IPHONE_SIMULATOR
        for (HYCICarInfoFillType *filltype in carInfoAllList)
        {
            if ([filltype.name isEqualToString:@"vehicleFrameNo"])
            {
                filltype.value = @"LVVDA11A9AD201987";
            }
            else if ([filltype.name isEqualToString:@"engineNo"])
            {
                filltype.value = @"AFAE03346";
            }
            else if([filltype.name isEqualToString:@"seats"])
            {
                filltype.value = @"5";
            }
            else if ([filltype.name isEqualToString:@"specialCarFlag"])
            {
                filltype.value = @"1";
                
            }
            else if ([filltype.name isEqualToString:@"specialCarDate"])
            {
                filltype.value = @"2015-02-06";
            }
            else if ([filltype.name isEqualToString:@"firstRegisterDate"])
            {
                filltype.value = @"2010-12-08";
            }
        }
#endif
        
        HYCIFillCarInfoViewController *vc = [[HYCIFillCarInfoViewController alloc] init];
        vc.ownerInfo = self.getCarFillInfoParam;
        vc.carInfoAllList = carInfoAllList;
        vc.carInfoFillList = carInfoFillList;
        vc.infoKey = infoKey;
        vc.packageTypeMap = packageTypeMap;
        vc.sessionId = sessionId;
        vc.vichelSearchKey = searchkey;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag = 2333;
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private


#pragma mark - city picker
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
    }
}

#pragma mark - tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
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
        HYCITableViewSelectCell *cityCell = [tableView dequeueReusableCellWithIdentifier:@"selectCell"];
        cityCell.nameLab.text = @"投保城市";
        cityCell.contentLab.text = self.city;
        return cityCell;
    }
    else
    {
        HYCITableViewInputCell *inputCell = [tableView dequeueReusableCellWithIdentifier:@"inputCell"];
        inputCell.inputField.keyboardType = UIKeyboardTypeDefault;
        switch (indexPath.section)
        {
            case 1:
                inputCell.nameLab.text = @"车牌号:";
                inputCell.inputField.placeholder = @"请输入车牌号";
                inputCell.inputField.tag = 1;
                break;
            case 2:
                inputCell.nameLab.text = @"车主姓名:";
                inputCell.inputField.placeholder = @"请输入车主姓名";
                inputCell.inputField.tag = 2;
                break;
            case 3:
                inputCell.nameLab.text = @"联系人手机号:";
                inputCell.inputField.placeholder = @"请输入联系人手机号";
                inputCell.inputField.tag = 3;
                inputCell.inputField.keyboardType = UIKeyboardTypeNumberPad;
                break;
            case 4:
                inputCell.nameLab.text = @"身份证号码";
                inputCell.inputField.placeholder = @"请输入身份证号码";
                inputCell.inputField.tag = 4;
                break;
            case 5:
                inputCell.nameLab.text = @"邮箱:";
                inputCell.inputField.placeholder = @"请输入邮箱";
                inputCell.inputField.tag = 5;
                inputCell.inputField.keyboardType = UIKeyboardTypeEmailAddress;
                break;
            default:
                break;
        }
        inputCell.inputField.delegate = self;
        return inputCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //城市选择
    if (indexPath.section == 0)
    {
        [self.view endEditing:YES];
        [self.cityPicker showWithAnimation:YES];
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 1:
            self.carNum = textField.text;
            break;
        case 2:
            self.ownerName = textField.text;
            break;
        case 3:
            self.phoneNum = textField.text;
            break;
        case 4:
            self.idNum = textField.text;
            break;
        case 5:
            self.email = textField.text;
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

//- (void)keyboardHide
//{
//    CGRect frame = self.view.bounds;
//    frame.size.height -= 64;
//    self.tableView.frame = frame;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
