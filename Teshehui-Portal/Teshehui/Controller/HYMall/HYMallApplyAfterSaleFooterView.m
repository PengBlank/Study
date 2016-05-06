//
//  HYMallApplyAfterSaleFooterView.m
//  Teshehui
//
//  Created by Kris on 15/10/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallApplyAfterSaleFooterView.h"
#import "HYAdressPick.h"
#import "HYMallAfterSaleInfo.h"

@interface HYMallApplyAfterSaleFooterView()
<UITextFieldDelegate,
HYAdressDelegate>
{
    HYMslselectionInfo* _proInfo;
    HYMslselectionInfo* _cityInfo;
    HYMslselectionInfo *_regionInfo;
}

@property (weak, nonatomic) IBOutlet UITextField *addressPeppleField;
@property (weak, nonatomic) IBOutlet UITextField *addressMobilePhoneField;
@property (weak, nonatomic) IBOutlet UITextField *addressDetailField;
@property (weak, nonatomic) IBOutlet UITextField *addressDetailSecondField;
@property (nonatomic, strong) HYAdressPick *pickerView;

@end

@implementation HYMallApplyAfterSaleFooterView

- (void)setIsChange:(BOOL)isChange
{
    _isChange = isChange;
}

- (void)setSaleInfo:(HYMallAfterSaleInfo *)saleInfo
{
    _saleInfo = saleInfo;
    _addressInfo.provinceName = saleInfo.contactProvinceName;
    _addressInfo.provinceId = saleInfo.contactProvinceCode;
    _addressInfo.cityName = saleInfo.contactCityName;
    _addressInfo.cityId = saleInfo.contactCityCode;
    _addressInfo.areaName = saleInfo.contactRegionName;
    _addressInfo.areaId = saleInfo.contactRegionCode;
    
    
    _addressDetailField.text = _addressInfo.fullRegion;
    _addressDetailSecondField.text = saleInfo.contactAddress;
    _addressPeppleField.text = saleInfo.contactName;
    _addressMobilePhoneField.text = saleInfo.contactMobile;
}

-(void)dealloc
{
    [self.pickerView dismissWithAnimation:YES];
}

- (instancetype)initMyNib
{
    NSArray *subViews = [[NSBundle mainBundle]
                         loadNibNamed:@"HYMallApplyAfterSaleFooterView" owner:nil options:nil];
    if (subViews.count > 0)
    {
        return subViews[0];
    }
    else
    {
        return nil;
    }
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.addressInfo = [[HYAddressInfo alloc] init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    //seperator
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_addressPeppleField.frame)+5, ScreenRect.size.width, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:.91 alpha:1.0f];
    _addressPeppleField.delegate = self;
    _addressPeppleField.returnKeyType = UIReturnKeyDone;
    _addressPeppleField.tag = ReceiverTextFied;
    [self addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_addressMobilePhoneField.frame)+5, ScreenRect.size.width, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:.91 alpha:1.0f];
    _addressMobilePhoneField.delegate = self;
    _addressMobilePhoneField.returnKeyType = UIReturnKeyDone;
    _addressMobilePhoneField.tag = MobileTextFied;
    [self addSubview:line2];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_addressDetailField.frame)+5, ScreenRect.size.width, 1)];
    line3.backgroundColor = [UIColor colorWithWhite:.91 alpha:1.0f];
    _addressDetailField.delegate = self;
    _addressDetailField.returnKeyType = UIReturnKeyDone;
    _addressDetailField.tag = AddressRegion;
    [self addSubview:line3];
    
    _pickerView = [[HYAdressPick alloc] initWithFrame:TFRectMakeFixWidth(0, 0, 320, 260)];
    _pickerView.delegate = self;
    _pickerView.title = @"选择配送区域";
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_addressDetailSecondField.frame)+5, ScreenRect.size.width, 1)];
    line4.backgroundColor = [UIColor colorWithWhite:.91 alpha:1.0f];
    _addressDetailSecondField.delegate = self;
    _addressDetailSecondField.returnKeyType = UIReturnKeyDone;
    _addressDetailSecondField.tag = AddressDetailTextField;
    [self addSubview:line4];
    
}

#pragma mark textfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(beginContentOffSet)])
    {
        [self.delegate beginContentOffSet];
    }
    if (_addressDetailField == textField)
    {
        [self endEditing:YES];
        [_pickerView showWithAnimation:YES];
        return NO;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _addressDetailField)
    {
        if ([self.delegate respondsToSelector:@selector(informationOfReceiver:fromTextFieldTag:withObject:)])
        {
            [self.delegate informationOfReceiver:(textField.text)
                                fromTextFieldTag:(textField.tag)
                                      withObject:_addressInfo];
        }
    }else
    {
        if ([self.delegate respondsToSelector:@selector(informationOfReceiver:fromTextFieldTag:withObject:)])
        {
            [self.delegate informationOfReceiver:(textField.text)
                                fromTextFieldTag:(textField.tag)
                                      withObject:nil];
        }
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    
    return YES;
}

#pragma mark HYAdressDelegate
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
    //当用户选择了地址之后，就将原来的城市ID清空
    _addressInfo.city = nil;
    _addressInfo.province = nil;
    _addressInfo.region = nil;
    
    _addressDetailField.text = [_addressInfo fullRegion];
    [self textFieldDidEndEditing:_addressDetailField];
}

#pragma mark gesture
- (void)tapAction
{
    [self endEditing:YES];
}

-(void)setAddressInfo:(HYAddressInfo *)addressInfo
{
    _addressInfo = addressInfo;
    
    if (_addressInfo.realName)
    {
        _addressPeppleField.text = _addressInfo.realName;
    }
    else
    {
        _addressPeppleField.text = _addressInfo.name;
    }
    
    _addressMobilePhoneField.text = _addressInfo.mobile;
    _addressDetailField.text = [_addressInfo fullRegion];
    _addressDetailSecondField.text = _addressInfo.address;
}
@end
