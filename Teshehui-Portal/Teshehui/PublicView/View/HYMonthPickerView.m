//
//  HYMonthPickerView.m
//  Teshehui
//
//  Created by HYZB on 14-8-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMonthPickerView.h"

@interface HYMonthPickerView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HYMonthPickerView

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
        
        _pickerView = [[SRMonthPicker alloc] initWithFrame:CGRectMake(0, frame.size.height-216, bounds.size.width, 216)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.maximumYear = @2100;
        _pickerView.minimumYear = @1900;
        _pickerView.yearFirst = NO;
		[self addSubview:_pickerView];
        
    }
    return self;
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
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100,
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


#pragma mark private methods
- (void)cancel:(id)sender
{
    [self dismissWithAnimation:YES];
}

- (void)editDone:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectDate:)])
    {
        [self.delegate didSelectDate:self.pickerView.date];
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
