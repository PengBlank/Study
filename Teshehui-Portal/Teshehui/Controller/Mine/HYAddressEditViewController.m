//
//  HYSetAdressView.m
//  Teshehui
//
//  Created by ichina on 14-3-6.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAddressEditViewController.h"
#import "HYInputCell.h"
#import "HYAdressPick.h"
#import "HYUpdateAddressRequest.h"
#import "HYUpdateAdressResponse.h"
#import "HYLoadHubView.h"
#import "HYUserInfo.h"
#import "HYAddAdressRequest.h"
#import "HYAddAdressResponse.h"
#import "NSString+Addition.h"
#import "METoast.h"

@interface HYAddressEditViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate,
UITextFieldDelegate,
HYAdressDelegate
>
{
    HYMslselectionInfo* _proInfo;
    HYMslselectionInfo* _cityInfo;
    HYMslselectionInfo *_regionInfo;
    HYAddAdressRequest* _ddAdressRequest;
    HYUpdateAddressRequest* _updateAdressReq;
}

@property(nonatomic, strong) UITableView* tableview;
@property(nonatomic, strong) HYAdressPick* pickerView;

@end

@implementation HYAddressEditViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.addressInfo = [[HYAddressInfo alloc] init];
    }
    return self;
}

- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title =  (_type == HYAddressManageAdd) ? @"添加收货地址":@"编辑收货地址";
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
    
    
//    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 54)];
//    foot.backgroundColor = [UIColor clearColor];
    
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(TFScalePoint(270), 12, 30, 30);
//    nextBtn.frame = TFRectMakeFixWidth(80,10, 160, 40);
//    [nextBtn setBackgroundImage:[UIImage imageNamed:@"person_buttom_orange2_normal"] forState:UIControlStateNormal];
//    [nextBtn setBackgroundImage:[UIImage imageNamed:@"person_buttom_orange2_press"] forState:UIControlStateHighlighted];
    [nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [nextBtn setTitle:@"保存" forState:UIControlStateNormal];
//    [nextBtn setTitle:(_type == HYAddressManageAdd)?@"添加":@"保存" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [nextBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextBtn];
//    [foot addSubview:nextBtn];
//    self.tableview.tableFooterView = foot;

    _pickerView = [[HYAdressPick alloc] initWithFrame:TFRectMakeFixWidth(0, 0, 320, 260)];
    _pickerView.delegate = self;
    _pickerView.title = @"选择配送区域";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTapAction:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)editTapAction:(UITapGestureRecognizer *)tap
{
    [self.view endEditing: YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYInputCell* cell = [[HYInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HYInputCell"];
    cell.nameLab.frame = CGRectMake(14, 0,80, 50);
    cell.nameLab.font = [UIFont systemFontOfSize:16.0f];
    cell.nameLab.textColor = [UIColor darkGrayColor];
    cell.textField.frame = CGRectMake(CGRectGetMaxX(cell.nameLab.frame), 0, CGRectGetWidth(self.view.frame)-CGRectGetMaxX(cell.nameLab.frame)-25, 50);
    cell.textField.font = [UIFont systemFontOfSize:16.0f];
    cell.textLab.textAlignment = NSTextAlignmentRight;
    cell.textLab.frame = CGRectMake(CGRectGetMaxX(cell.nameLab.frame), 0,CGRectGetWidth(self.view.frame)-CGRectGetMaxX(cell.nameLab.frame)-25, 50);
    cell.textLab.font = [UIFont systemFontOfSize:16.0f];
    cell.textField.tag = indexPath.row+1;
    cell.textField.delegate = self;
    cell.textField.clearButtonMode =  UITextFieldViewModeWhileEditing;
    cell.textField.textAlignment = NSTextAlignmentRight;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.nameLab.text = @"收货人";
            cell.textField.placeholder = @"请输入收货人";
            cell.textField.text = _addressInfo.consignee;
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            cell.textField.returnKeyType = UIReturnKeyNext;
            break;
        }
        case 1:
        {
            cell.nameLab.text = @"手机号码";
            cell.textField.placeholder = @"请输入手机号码";
            cell.textField.text = _addressInfo.phoneMobile;
            cell.textField.keyboardType = UIKeyboardTypePhonePad;
            cell.textField.returnKeyType = UIReturnKeyDone;
            break;
        }
        case 2:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.nameLab.text = @"配送区域";
            cell.textField.placeholder = @"请选择配送区域";
            cell.textField.enabled = NO;
            if ([_addressInfo fullRegion].length > 0)
            {
                cell.textField.hidden = YES;
                cell.textLab.hidden = NO;
                cell.textLab.text = [_addressInfo fullRegion];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 3:
        {
            cell.nameLab.text = @"详细地址";
            cell.textField.text = _addressInfo.address;
            cell.textField.placeholder = @"请输入详细地址";
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            cell.textField.returnKeyType = UIReturnKeyNext;
            break;
        }
        case 4:
        {
            cell.nameLab.text = @"设为默认";
            cell.setDefaultBtn.hidden = NO;
            cell.textField.hidden = YES;
            cell.setDefaultBtn.frame = CGRectMake(TFScalePoint(280), 12, 20, 20);
            if (!self.addressInfo.isDefault)
            {
                [cell.setDefaultBtn setBackgroundImage:[UIImage imageNamed:@"iocn_address_noseclect"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.setDefaultBtn setBackgroundImage:[UIImage imageNamed:@"iocn_address_seclect"] forState:UIControlStateNormal];
            }
            [cell.setDefaultBtn addTarget:self action:@selector(setDefaultAction:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
        default:
            break;
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        [_pickerView showWithAnimation:YES];
//        [self.view endEditing:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        scrollView.bouncesZoom = NO;
        [self.view endEditing:YES];
    }
}

-(void)commitAction:(UIButton*)sender
{
    [self.view endEditing:YES];
    
    NSString *err = [_addressInfo checkValid];
    if (err)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:err delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if ([_addressInfo.phoneMobile checkPhoneNumberValid])
        {
            
            if (_type == HYAddressManageAdd)
            {
                if (!_ddAdressRequest)
                {
                    _ddAdressRequest = [[HYAddAdressRequest alloc] init];
                }
                
                HYUserInfo* userInfo = [HYUserInfo getUserInfo];
                if (userInfo.userId)
                {
                    _ddAdressRequest.userId = userInfo.userId;
                }
                _ddAdressRequest.consignee = _addressInfo.consignee;
                _ddAdressRequest.region_id = _addressInfo.areaId;
                _ddAdressRequest.region_name = _addressInfo.areaName;
                _ddAdressRequest.address = _addressInfo.address;
                _ddAdressRequest.zipcode = @"";
                _ddAdressRequest.phone_tel = @"";
                _ddAdressRequest.phone_mob = _addressInfo.phoneMobile;
                _ddAdressRequest.isDefault = _addressInfo.isDefault;
                
                [HYLoadHubView show];
                __weak typeof(self) b_self = self;
                [_ddAdressRequest sendReuqest:^(id result, NSError *error) {
                    [HYLoadHubView dismiss];
                    if (result && [result isKindOfClass:[HYAddAdressResponse class]])
                    {
                        HYAddAdressResponse *response = (HYAddAdressResponse *)result;
                        if (response.status == 200) {
                            
                            b_self.addressInfo = response.adressInfo;
                            [METoast toastWithMessage:@"成功添加收货地址"];
                            [b_self.navigationController popViewControllerAnimated:YES];
                        }
                        else
                        {
                            if (response.message) {
                                [METoast toastWithMessage:response.message];
                            }
                        }
                    }
                }];
            }
            else
            {
                if (!_updateAdressReq)
                {
                    _updateAdressReq = [[HYUpdateAddressRequest alloc] init];
                }
                
                _updateAdressReq.addressInfo = self.addressInfo;
                
                [HYLoadHubView show];
                __weak typeof(self) b_self = self;
                [_updateAdressReq sendReuqest:^(id result, NSError *error)
                 {
                     [HYLoadHubView dismiss];
                     if (result && [result isKindOfClass:[HYUpdateAdressResponse class]])
                     {
                         HYUpdateAdressResponse *response = (HYUpdateAdressResponse *)result;
                         if (response.status == 200)
                         {
                             [METoast toastWithMessage:@"成功编辑收货地址"];
                             [b_self.navigationController popViewControllerAnimated:YES];
                         }
                         else
                         {
                             if (response.message) {
                                 [METoast toastWithMessage:response.message];
                             }
                         }
                     }
                     
                 }];
            }
        }
        else
        {
            [METoast toastWithMessage:@"手机号码不正确"];
        }
        
        
    }

}

//- (void)updateAdress
//{
//    if (!_updateAdressReq)
//    {
//        _updateAdressReq = [[HYUpdateAddressRequest alloc] init];
//    }
//    
//    _updateAdressReq.addressInfo = self.addressInfo;
//    
//    [HYLoadHubView show];
//    __weak typeof(self) b_self = self;
//    [_updateAdressReq sendReuqest:^(id result, NSError *error)
//     {
//         [HYLoadHubView dismiss];
//         if (result && [result isKindOfClass:[HYUpdateAdressResponse class]])
//         {
//             HYUpdateAdressResponse *response = (HYUpdateAdressResponse *)result;
//             if (response.status == 200)
//             {
//                 [METoast toastWithMessage:@"成功添加收货地址"];
////                 [b_self.delegate performSelector:@selector(getDefaultAddress)];
//                 [b_self.navigationController popViewControllerAnimated:YES];
//             }
//             else
//             {
//                 if (response.message) {
//                     [METoast toastWithMessage:response.message];
//                 }
//             }
//         }
//         
//     }];
//}

- (void)setDefaultAction:(UIButton *)btn
{
    // 添加收货地址时，所有必填信息填写完成且保存后设为默认才生效
//    if (_addressInfo.consignee.length>0 && _addressInfo.phoneMobile.length>0 && _addressInfo.areaName.length>0 && _addressInfo.addressDetail.length>0)
//    {
//        if (!self.addressInfo.isDefault)
//        {
//            [btn setBackgroundImage:[UIImage imageNamed:@"iocn_address_seclect"]
//                           forState:UIControlStateNormal];
//            self.addressInfo.isDefault = YES;
//        }
//    }
    switch (self.type) {
        case HYAddressManageAdd:
            
            if (!self.addressInfo.isDefault)
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"iocn_address_seclect"]
                               forState:UIControlStateNormal];
                self.addressInfo.isDefault = YES;
            }
            else
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"iocn_address_noseclect"]
                               forState:UIControlStateNormal];
                self.addressInfo.isDefault = NO;
            }
            break;
        case HYAddressManageEdit:
            
            if (!self.addressInfo.isDefault)
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"iocn_address_seclect"]
                               forState:UIControlStateNormal];
                self.addressInfo.isDefault = YES;
            }
            break;
        default:
            break;
    }
}

//#pragma mark - HYInputCellDelegate
//- (void)setDefaultAction
//{
//    
//}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1) {
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
        HYInputCell* cell = [self.tableview cellForRowAtIndexPath:path];
        [cell.textField becomeFirstResponder];
    }
    if (textField.tag == 4) {
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:3 inSection:0];
        HYInputCell* cell = [self.tableview cellForRowAtIndexPath:path];
        [cell.textField resignFirstResponder];
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint size = CGPointZero;
    switch (textField.tag) {
        case 2:
        {
            size = CGPointMake(0, 0);
            break;
        }
        case 3:
        {
            size = CGPointMake(0,20);
            break;
        }
        case 4:
        {
            size = CGPointMake(0,100);
            break;
        }
        default:
            break;
    }
    [_tableview setContentOffset:size animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
        {
            _addressInfo.consignee = textField.text;
            break;
        }
        case 2:
        {
            _addressInfo.phoneMobile = textField.text;
            break;
        }
        case 4:
        {
            _addressInfo.address = textField.text;
            break;
        }
        default:
            break;
    }
}

- (void)selectComplete:(HYAdressPick *)pickerView
{
    _proInfo = pickerView.proInfo;
    _cityInfo = pickerView.cityInfo;
    _regionInfo = pickerView.regionInfo;
    _addressInfo.provinceName = _proInfo.region_name;
    _addressInfo.provinceId = _proInfo.region_id;
    _addressInfo.cityName = _cityInfo.region_name;
    _addressInfo.cityId = _cityInfo.region_id;
    _addressInfo.areaName = _regionInfo.region_name;
    _addressInfo.areaId = _regionInfo.region_id;
    [self.tableview reloadData];
}

-(void)dealloc
{
    [_pickerView dismissWithAnimation:YES];
    [_updateAdressReq cancel];
    _updateAdressReq = nil;
    [_ddAdressRequest cancel];
    _ddAdressRequest = nil;
    [HYLoadHubView dismiss];
}
@end
