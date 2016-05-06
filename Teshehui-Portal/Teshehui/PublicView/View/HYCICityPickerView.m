//
//  HYCICityPickerView.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCICityPickerView.h"
#import "HYCIGetCityListReq.h"
#import "HYCIGetCityListResp.h"

@interface HYCICityPickerView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) HYCIGetCityListReq *cityRequest;
@property (nonatomic, strong) NSArray *provinceArray;
@property (nonatomic, strong) NSArray *cityArray;
@property (nonatomic, strong) NSArray *areaArray;
@end

@implementation HYCICityPickerView

- (void)dealloc
{
    [_cityRequest cancel];
}

- (id)initWithFrame:(CGRect)frame
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    frame = CGRectMake(0, bounds.size.height, CGRectGetWidth(bounds), bounds.size.height-64);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        CGRect toolbarFrame = CGRectMake(0, frame.size.height-260, CGRectGetWidth(bounds), 44);
        UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
        pickerToolbar.barStyle = UIBarStyleDefault;
        [pickerToolbar sizeToFit];
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"cancel", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(cancel:)];
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil
                                                                                       action:nil];
        //@"修改"
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done", nil)
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(editDone:)];
        NSArray *barItems = [NSArray arrayWithObjects:cancel,flexibleSpace, done , nil];
        
        [pickerToolbar setItems:barItems animated:YES];
        [self addSubview:pickerToolbar];
        
        self.titleLabel.text = @"选择城市";
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.frame = CGRectMake(0, frame.size.height-216, CGRectGetWidth(bounds), 216);
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self addSubview:_pickerView];
    }
    return self;
}

- (void)loadCityInfo
{
    if (_cityRequest)
    {
        [_cityRequest cancel];
    }
    _cityRequest = [[HYCIGetCityListReq alloc] init];
    HYCIGetCityListParam *param = [[HYCIGetCityListParam alloc] init];
    if (self.cityInfo)
    {
        param.parentId = self.cityInfo.cId;
    }
    else if (self.provinceInfo)
    {
        param.parentId = self.provinceInfo.cId;
    }
    _cityRequest.reqParam = param;
    
    __weak typeof(self) b_self = self;
    [HYLoadHubView show];
    [_cityRequest sendReuqest:^(id result, NSError *error)
    {
        [b_self updateWithResponse:result error:error];
    }];
}

- (void)updateWithResponse:(HYCIGetCityListResp *)response error:(NSError *)error
{
    [HYLoadHubView dismiss];
    if (response.status == 200)
    {
        if (self.cityInfo)
        {
            self.areaArray = response.cityList;
            self.areaInfo = self.areaArray.count > 0 ? self.areaArray[0] : nil;
            
            [self.pickerView reloadComponent:2];
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
        }
        else if (self.provinceInfo)
        {
            self.cityArray = response.cityList;
            self.cityInfo = self.cityArray.count > 0 ? self.cityArray[0] : nil;
            [self loadCityInfo];
            
            [self.pickerView reloadComponent:1];
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
        }
        else if (response.cityList.count > 0)
        {
            self.provinceArray = response.cityList;
            self.provinceInfo = [self.provinceArray objectAtIndex:0];
            [self loadCityInfo];
            
            [self.pickerView reloadComponent:0];
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
        }
        else
        {
            //报错
        }
    }
    else
    {
        
    }
}

#pragma mark -
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return self.provinceArray.count;
            break;
        }
        case 1:
        {
            return self.cityArray.count;
            break;
        }
        case 2:
        {
            return self.areaArray.count;
            break;
        }
        default:
            return 0;
            break;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSString *address = nil;
    switch (component) {
        case 0:
        {
            if (row < _provinceArray.count)
            {
                HYCICityInfo *province = [_provinceArray objectAtIndex:row];
                address = province.regionName;
            }
            break;
        }
        case 1:
        {
            if (row < _cityArray.count)
            {
                HYCICityInfo *province = [_cityArray objectAtIndex:row];
                address = province.regionName;
            }
            break;
        }
        case 2:
        {
            if (row < _areaArray.count)
            {
                HYCICityInfo *province = [_areaArray objectAtIndex:row];
                address = province.regionName;
            }
            break;
        }
        default:
            break;
    }
    
    return address;
}

#pragma mark -
#pragma mark UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            if (row < _provinceArray.count)
            {
                self.provinceInfo = [_provinceArray objectAtIndex:row];
                self.areaArray = nil;
                self.cityArray = nil;
                self.areaInfo = nil;
                self.cityInfo = nil;
                [self.pickerView reloadComponent:0];
                [self loadCityInfo];
            }
            break;
        }
        case 1:
        {
            if (row < _cityArray.count)
            {
                self.cityInfo = [_cityArray objectAtIndex:row];
                self.areaArray = nil;
                self.areaInfo = nil;
                [self.pickerView reloadComponent:1];
                [self loadCityInfo];
            }
            break;
        }
        case 2:
        {
            if (row < _areaArray.count)
            {
                self.areaInfo = [_areaArray objectAtIndex:row];
                [self.pickerView reloadComponent:2];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark private methods
- (void)cancel:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerCancel)])
    {
        [self.delegate pickerCancel];
    }
    [self dismissWithAnimation:YES];
}

- (void)editDone:(id)sender
{
//    if (!self.areaInfo)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"还未加载完成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectComplete:)])
    {
        [self.delegate selectComplete:self];
    }
    [self dismissWithAnimation:YES];
}

- (void)showWithAnimation:(BOOL)animation
{
    if (![self superview]) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
    }
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGPoint point = CGPointMake(CGRectGetMidX(frame), (frame.size.height+64)/2);
    if (animation)
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.center = point;
                         }];
    }
    else
    {
        self.center = point;
    }
    [_pickerView reloadAllComponents];
    
    [self loadCityInfo];
}

- (void)dismissWithAnimation:(BOOL)animation
{
    if (_cityRequest)
    {
        [_cityRequest cancel];
        _cityRequest = nil;
    }
    
    if ([self superview])
    {
        CGRect frame = [[UIScreen mainScreen] bounds];
        CGPoint point = CGPointMake(CGRectGetMidX(frame), frame.size.height+self.frame.size.height/2);
        
        if (animation)
        {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.center = point;
                             } completion:^(BOOL finished) {
                                 [self removeFromSuperview];
                             }];
        }
        else
        {
            [self removeFromSuperview];
        }
    }
}

@end
