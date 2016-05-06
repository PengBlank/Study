//
//  HYAdressPick.m
//  Teshehui
//
//  Created by ichina on 14-3-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAdressPick.h"
#import "HYGetMslselectionRequest.h"
#import "HYGetMslselectionResponse.h"

@interface HYAdressPick ()
{
    NSInteger _pIndex;
    NSInteger _cIndex;
    NSInteger _rIndex;
    
    HYGetMslselectionRequest* _GetMslselectionRequest;
    
    UIBarButtonItem *_done;
}

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic,strong) NSMutableArray* proArray;
@property (nonatomic,strong) NSMutableArray* cityArray;
@property (nonatomic, strong) NSMutableArray *regionArray;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation HYAdressPick

- (id)initWithFrame:(CGRect)frame
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    frame = CGRectMake(0, bounds.size.height, bounds.size.width, bounds.size.height-64);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
      
        _isLoading = NO;
        
        _pIndex = 0;
        _cIndex = 0;
        _rIndex = 0;
        
        CGRect toolbarFrame = CGRectMake(0, frame.size.height-260, bounds.size.width, 44);
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
        _done = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done", nil)
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(editDone:)];
        NSArray *barItems = [NSArray arrayWithObjects:cancel,flexibleSpace, _done , nil];
        
        [pickerToolbar setItems:barItems animated:YES];
        [self addSubview:pickerToolbar];
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
		_pickerView.frame = CGRectMake(0, frame.size.height-216, bounds.size.width, 216);
		_pickerView.showsSelectionIndicator = YES;
		_pickerView.delegate = self;
		_pickerView.dataSource = self;
		[self addSubview:_pickerView];
        
        _proArray = [[NSMutableArray alloc]initWithCapacity:0];
        _cityArray = [[NSMutableArray alloc]initWithCapacity:0];
        _regionArray = [NSMutableArray array];
    }
    return self;
}


-(void)dealloc
{
    [_GetMslselectionRequest cancel];
    _GetMslselectionRequest = nil;
}

- (void)setDataSouceWithRow:(NSInteger)row
{
    [_pickerView setUserInteractionEnabled:NO];
    
    if (!_isLoading)
    {
        _GetMslselectionRequest = [[HYGetMslselectionRequest alloc] init];
        
        if (row == 2 && _cityInfo)
        {
            _GetMslselectionRequest.pid = _cityInfo.region_id;
        }
        else if (row == 1 && _proInfo)
        {
            _GetMslselectionRequest.pid = _proInfo.region_id;
        }
        else if (row == 0)
        {
            _GetMslselectionRequest.pid = @"0";
        }
        else
        {
            return;
        }
        
        _isLoading = YES;
        _done.enabled = !_isLoading;
        __weak typeof(self) b_self = self;
        
        [_GetMslselectionRequest sendReuqest:^(id result, NSError *error)
         {
             __strong typeof(b_self) strongSelf = b_self;
             if (result && [result isKindOfClass:[HYGetMslselectionResponse class]])
             {
                 HYGetMslselectionResponse *response = (HYGetMslselectionResponse *)result;
                 if (response.status == 200)
                 {
                     if (row == 2)
                     {
                         [b_self.regionArray removeAllObjects];
                         [b_self.regionArray addObjectsFromArray:response.selectionArray];
                         HYMslselectionInfo* info = (b_self.regionArray.count>_rIndex)?[b_self.regionArray objectAtIndex:_rIndex]:nil;
                         b_self.regionInfo = info;
                         [b_self.pickerView reloadComponent:2];
                         [b_self.pickerView setUserInteractionEnabled:YES];
                         [strongSelf->_pickerView selectRow:0 inComponent:2 animated:NO];
                         [b_self pickerView:b_self.pickerView didSelectRow:0 inComponent:2];
                         
                         strongSelf->_isLoading = NO;
                         strongSelf->_done.enabled = !strongSelf->_isLoading;
                     }
                     else if (row == 1)
                     {
                         [b_self.cityArray removeAllObjects];
                         [b_self.cityArray addObjectsFromArray:response.selectionArray];
                         HYMslselectionInfo* info = (b_self.cityArray.count>_cIndex)?[b_self.cityArray objectAtIndex:_cIndex]:nil;
                         b_self.cityInfo = info;
                         
                         [b_self.pickerView reloadComponent:1];
                         [b_self.pickerView setUserInteractionEnabled:YES];
                         [strongSelf->_pickerView selectRow:0 inComponent:1 animated:NO];
                         [b_self pickerView:b_self.pickerView didSelectRow:0 inComponent:1];
                         
                         strongSelf->_isLoading = NO;
                         [b_self setDataSouceWithRow:2];
                     }
                     else if (row == 0)
                     {
                         [b_self.proArray removeAllObjects];
                         [b_self.proArray addObjectsFromArray:response.selectionArray];
                         HYMslselectionInfo* info = (b_self.proArray.count>_pIndex)?[b_self.proArray objectAtIndex:_pIndex]:nil;
                         b_self.proInfo = info;
                         [b_self.pickerView reloadComponent:0];
                         [b_self.pickerView setUserInteractionEnabled:YES];
                         [strongSelf->_pickerView selectRow:0 inComponent:0 animated:NO];
                         [b_self pickerView:b_self.pickerView didSelectRow:0 inComponent:0];
       
                         strongSelf->_isLoading = NO;
                         [b_self setDataSouceWithRow:1];
                     }
                 }
             }
         }];
    }
    
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
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-120)/2,
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
    NSInteger count = 1;
	switch (component) {
        case 0:
        {
            count = _proArray.count;
            break;
        }
        case 1:
        {
            count = _cityArray.count;
            break;
        }
        case 2:
            count = _regionArray.count;
            break;
        default:
            break;
    }
    
    return count>0 ? count : 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
	switch (component) {
        case 0:
        {
            if ([_proArray count] > row)
            {
                _pIndex = row;
                _cIndex = 0;
                _rIndex = 0;
                
                HYMslselectionInfo* info = [_proArray objectAtIndex:row];
                return info.region_name;
            }
            
            break;
        }
        case 1:
        {
            if ([_cityArray count] > row)
            {
                _cIndex = row;
                _rIndex = 0;
                HYMslselectionInfo* info = [_cityArray objectAtIndex:row];
                return info.region_name;
            }
            
            break;
        }
        case 2:
        {
            if ([_regionArray count] > row)
            {
                _rIndex = row;
                HYMslselectionInfo* info = [_regionArray objectAtIndex:row];
                return info.region_name;
            }
            break;
        }
        default:
            break;
    }
    
    return nil;
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
            if (row < [_proArray count])
            {
                HYMslselectionInfo* info = [_proArray objectAtIndex:row];
                _proInfo = info;
                
                
                _cityInfo = nil;
                [_cityArray removeAllObjects];
                _regionInfo = nil;
                [_regionArray removeAllObjects];
                
                [self.pickerView reloadComponent:1];
                [self.pickerView reloadComponent:2];
                [self setDataSouceWithRow:1];
            }
            break;
        }
        case 1:
        {
            if (row < [_cityArray count])
            {
                HYMslselectionInfo* info = [_cityArray objectAtIndex:row];
                _cityInfo = info;
                
                _regionInfo = nil;
                [_regionArray removeAllObjects];
                [self.pickerView reloadComponent:2];
                [self setDataSouceWithRow:2];
            }
            break;
        }
        case 2:
        {
            if (row < [_regionArray count])
            {
                HYMslselectionInfo* info = [_regionArray objectAtIndex:row];
                _regionInfo = info;
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
    CGPoint point = CGPointMake(frame.size.width/2, (frame.size.height+64)/2);
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

    self.proInfo = nil;
    self.cityInfo = nil;
    self.regionInfo = nil;
//    _cIndex = 0;
//    _pIndex = 0;
//    _rIndex = 0;
//    [_proArray removeAllObjects];
//    [_cityArray removeAllObjects];
//    [_regionArray removeAllObjects];

    [_pickerView reloadAllComponents];
    [self setDataSouceWithRow:0];
}

- (void)dismissWithAnimation:(BOOL)animation
{
    if ([self superview])
    {
        CGRect frame = [[UIScreen mainScreen] bounds];
        CGPoint point = CGPointMake(frame.size.width/2, frame.size.height+self.frame.size.height/2);
        
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
