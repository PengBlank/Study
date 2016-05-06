//
//  HYFlowerAdressPick.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-14.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerAddressPick.h"
#import "HYFlowerGetProAdressResquest.h"
#import "HYFlowerGetProAdressResponse.h"
#import "HYFlowerGetAreaResquest.h"
#import "HYFlowerGetAreaResponse.h"
#import "METoast.h"

@interface HYFlowerAddressPick ()
{
    HYFlowerGetProAdressResquest* _GetProAdressResquest;
    HYFlowerGetAreaResquest* _GetAreaResquest;
}

@property (nonatomic,assign) NSInteger type;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic,strong) NSMutableArray* proArray;
@property (nonatomic,strong) NSMutableArray* cityArray;
@property (nonatomic,strong) NSMutableArray* areaArray;

@end

@implementation HYFlowerAddressPick

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
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
		_pickerView.frame = CGRectMake(0, frame.size.height-216, CGRectGetWidth(bounds), 216);
		_pickerView.showsSelectionIndicator = YES;
		_pickerView.delegate = self;
		_pickerView.dataSource = self;
		[self addSubview:_pickerView];
        
        _proArray = [[NSMutableArray alloc]initWithCapacity:0];
        _cityArray = [[NSMutableArray alloc]initWithCapacity:0];
        _areaArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

-(void)dealloc
{
    [_GetProAdressResquest cancel];
    _GetProAdressResquest = nil;
    [_GetAreaResquest cancel];
    _GetAreaResquest = nil;
}

- (void)setDataSouce
{
    if (!_GetAreaResquest)
    {
        _GetAreaResquest = [[HYFlowerGetAreaResquest alloc] init];
    }
    else
    {
        [_GetAreaResquest cancel];
    }
    
    if (_type == 2) {
        _GetAreaResquest.ParentID = _proInfo.adressid;
    }else{
        _GetAreaResquest.ParentID = _cityInfo.adressid;
    }
    __weak typeof(self) b_self = self;
    [HYLoadHubView show];
    [_GetAreaResquest sendReuqest:^(id result, NSError *error)
    {
        [HYLoadHubView dismiss];
        
        if (result && [result isKindOfClass:[HYFlowerGetAreaResponse class]])
        {
            HYFlowerGetAreaResponse *response = (HYFlowerGetAreaResponse *)result;
            if (response.status == 200)
            {
                if (b_self.type == 2)
                {
                    b_self.type = 3;
                    [b_self.cityArray removeAllObjects];
                    [b_self.cityArray addObjectsFromArray:response.AreaList];
                    HYFlowerCityInfo* info = (b_self.cityArray.count>0)?[b_self.cityArray objectAtIndex:0]:nil;
                    _cityInfo = info;
                    [b_self setDataSouce];
                    [b_self.pickerView reloadComponent:1];
                    [b_self.pickerView selectRow:0 inComponent:1 animated:YES];
                }
                else
                {
                    [b_self.areaArray removeAllObjects];
                    [b_self.areaArray addObjectsFromArray:response.AreaList];
                    HYFlowerCityInfo* info = (b_self.areaArray.count>0)?[b_self.areaArray objectAtIndex:0]:nil;
                    _areaInfo = info;
                    [b_self.pickerView reloadComponent:2];
                    [b_self.pickerView selectRow:0 inComponent:2 animated:YES];
                }
            }
            else
            {
                [METoast toastWithMessage:@"配送区域加载出错"];
            }
        }
    }];
}

-(void)setProDate
{
    if (!_GetProAdressResquest)
    {
        _GetProAdressResquest = [[HYFlowerGetProAdressResquest alloc] init];
    }
    __weak typeof(self) b_self = self;
    [_GetProAdressResquest sendReuqest:^(id result, NSError *error) {
        if (result && [result isKindOfClass:[HYFlowerGetProAdressResponse class]])
        {
            HYFlowerGetProAdressResponse *response = (HYFlowerGetProAdressResponse *)result;
            if (response.status == 200) {
                 b_self.type = 2;
                [b_self.proArray removeAllObjects];
                [b_self.proArray addObjectsFromArray:response.ProList];
                HYFlowerCityInfo* info = (b_self.proArray.count > 0)?[b_self.proArray objectAtIndex:0]:nil;
                _proInfo = info;
                [_pickerView reloadComponent:0];
                [b_self setDataSouce];
            }
        }
    }];
}

- (void)setTitle:(NSString *)title
{
    if (_title != title)
    {
        _title = [title copy];
        
        self.titleLabel.text = title;
    }
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.bounds)-60,
                                                                self.frame.size.height-246,
                                                                120,
                                                                20)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
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
            return _proArray.count;
            break;
        }
        case 1:
        {
            return _cityArray.count;
            break;
        }
        case 2:
        {
            return _areaArray.count;
            break;
        }
        default:
            return 0;
            break;
    }
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
            if (row < [_proArray count])
            {
                HYFlowerCityInfo* info = [_proArray objectAtIndex:row];
                address = info.name;
            }
            break;
        }
        case 1:
        {
            if (row < [_cityArray count])
            {
                HYFlowerCityInfo* info = [_cityArray objectAtIndex:row];
                address = info.name;
            }
            break;
        }
        case 2:
        {
            if (row < [_areaArray count])
            {
                HYFlowerCityInfo* info = [_areaArray objectAtIndex:row];
                address = info.name;
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
            if (row < _proArray.count)
            {
                _type = 2;
                HYFlowerCityInfo* info = [_proArray objectAtIndex:row];
                _proInfo = info;
                [self setDataSouce];
            }
            break;
        }
        case 1:
        {
            if (row < _cityArray.count)
            {
                _type = 3;
                HYFlowerCityInfo* info = [_cityArray objectAtIndex:row];
                _cityInfo = info;
                [self setDataSouce];
            }
            break;
        }
        case 2:
        {
            if (row < _areaArray.count)
            {
                HYFlowerCityInfo* info = [_areaArray objectAtIndex:row];
                _areaInfo = info;
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
    _type = 1;
    [_proArray removeAllObjects];
    [_cityArray removeAllObjects];
    [_areaArray removeAllObjects];
    [_pickerView reloadAllComponents];
    [self setProDate];
}

- (void)dismissWithAnimation:(BOOL)animation
{
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
    _type = 1;
}


@end
