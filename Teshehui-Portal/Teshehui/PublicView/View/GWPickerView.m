//
//  GWPickerView.m
//  Teshehui
//
//  Created by Kris on 15/11/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "GWPickerView.h"
#import "HYCardType.h"
#import "HYPolicyType.h"


@interface GWPickerView ()
<UIPickerViewDelegate,
UIPickerViewDataSource
>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, copy) NSString *pickResult;
@property (nonatomic, copy) NSString *pickIdCode;
@property (nonatomic, copy) NSString *pickInsuranceCode;

@end

@implementation GWPickerView

- (id)initWithFrame:(CGRect)frame
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    frame = CGRectMake(0, bounds.size.height, CGRectGetWidth(bounds), bounds.size.height-64);
    self = [super initWithFrame:frame];
    if (self)
    {
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
        
    }
    return self;
}

#pragma mark - pickerview
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataList.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSString *title = nil;

    if (row < _dataList.count)
    {
        title = _dataList[row];
    }

    return title;
}

#pragma mark getter and setter
-(NSMutableArray *)dataList
{
    if (!_dataList)
    {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

-(void)setIdList:(NSMutableArray *)idList
{
    _idList = idList;
    
    [self clearData];
    for (HYCardType *obj in _idList)
    {
        [self.dataList addObject:obj.certifacateName];
    }
    [_pickerView reloadAllComponents];
}

-(void)setInsuranceList:(NSMutableArray *)insuranceList
{
    _insuranceList = insuranceList;
    
    [self clearData];
    for (HYPolicyType *obj in _insuranceList)
    {
        [self.dataList addObject:obj.insuranceTypeName];
    }
    [_pickerView reloadAllComponents];
}

#pragma mark -
#pragma mark UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if (row < _dataList.count)
    {
        HYCardType *cardType = nil;
        HYPolicyType *policyType = nil;
        
        _pickResult = _dataList[row];
        
        if (row < _idList.count)
        {
            cardType = _idList[row];
            _pickIdCode = cardType.certifacateCode;
        }
        if (row < _insuranceList.count)
        {
            policyType = _insuranceList[row];
            _pickInsuranceCode = policyType.insuranceTypeCode;
            _pickinsuranceProvision = policyType.insuranceProvision;
        }
    }
}

#pragma mark private methods
- (void)clearData
{
    [_dataList removeAllObjects];
}


- (void)cancel:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pickerCancel)])
    {
        [self.delegate pickerCancel];
    }
    [self dismissWithAnimation:YES];
}

- (void)editDone:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(selectComplete: forIndexPath:)])
    {
        [self.delegate selectComplete:self forIndexPath:_indexPath];
    }
    //每次确定后清楚之前的临时数据
    [_idList removeAllObjects];
    [_insuranceList removeAllObjects];
    
    [self dismissWithAnimation:YES];
}

- (void)showWithAnimation:(BOOL)animation
{
    [self pickerView:_pickerView didSelectRow:0 inComponent:0];
    [_pickerView selectRow:0 inComponent:0 animated:YES];
    
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
    
    if (_dataList.count > 0)
    {
        _pickResult = _dataList[0];
    }
    
    [_pickerView reloadAllComponents];
    

}

- (void)dismissWithAnimation:(BOOL)animation
{

    if ([self superview])
    {
        [self clearData];
        
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
