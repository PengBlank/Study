//
//  HYPickerToolView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYPickerToolView.h"

@interface HYPickerToolView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL isShow;

@end

@implementation HYPickerToolView

- (id)initWithFrame:(CGRect)frame
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    frame = CGRectMake(0, bounds.size.height, bounds.size.width, bounds.size.height-64);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
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
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done", nil)
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(editDone:)];
        NSArray *barItems = [NSArray arrayWithObjects:cancel,flexibleSpace, done , nil];
        
        [pickerToolbar setItems:barItems animated:YES];
        [self addSubview:pickerToolbar];
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
		_pickerView.frame = CGRectMake(0, frame.size.height-216, bounds.size.width, 216);
		_pickerView.showsSelectionIndicator = YES;
		_pickerView.delegate = self;
		_pickerView.dataSource = self;
		[self addSubview:_pickerView];
        
        self.currentIndex = 0;
        _pType = HotelRoomCount;
        self.dataSouce = @[@"1间", @"2间", @"3间", @"4间", @"5间", @"6间", @"7间", @"8间"];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setDataSouce:(NSArray *)dataSouce
{
    if (dataSouce != _dataSouce)
    {
        _dataSouce = dataSouce;
        [self.pickerView reloadAllComponents];
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

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (_currentIndex != currentIndex)
    {
        _currentIndex = currentIndex;
        if (_currentIndex < self.dataSouce.count)
        {
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
        }
    }
}

#pragma mark -
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [self.dataSouce count];;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
	return [self.dataSouce objectAtIndex:row];
}

#pragma mark -
#pragma mark UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if (row < [self.dataSouce count])
    {
        [self.dataSouce objectAtIndex:row];
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
    self.currentIndex = [self.pickerView selectedRowInComponent:0];
    
    if (self.didSelectItem)
    {
        self.didSelectItem(_currentIndex);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectComplete:)])
    {
        [self.delegate selectComplete:self];
    }
    
    [self dismissWithAnimation:YES];
}

- (void)showWithAnimation:(BOOL)animation
{
    if (!self.isShow)
    {
        self.isShow = YES;
        
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
    }
}

- (void)dismissWithAnimation:(BOOL)animation
{
    if (self.isShow)
    {
        self.isShow = NO;
        
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
}

@end
