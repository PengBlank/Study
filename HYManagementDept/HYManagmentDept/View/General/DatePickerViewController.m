//
//  DatePickerViewController.m
//  DaXueBao
//
//  Created by Ray on 14-4-13.
//  Copyright (c) 2014年 souvi. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

- (void)dealloc
{
    DebugNSLog(@"date picker is released");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    _maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _maskView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_maskView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_maskView addGestureRecognizer:tap];
    
    _pickerWrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 216+44)];
    _pickerWrapper.backgroundColor = [UIColor clearColor];
    
    
    [_pickerWrapper addSubview:self.datePicker];
    
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
    UIBarButtonItem *clearItem;
    clearItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStyleDone target:self action:@selector(clearItemAction:)];
    UIBarButtonItem *doneItem;
    doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneBtnClicked:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    _toolBar.items = [NSArray arrayWithObjects:clearItem ,space, doneItem, nil];
    [_pickerWrapper addSubview:_toolBar];
    
    [self.view addSubview:_pickerWrapper];
    
    _pickerWrapper.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 44+ 216);
    [UIView animateWithDuration:.3 animations:^
    {
        _pickerWrapper.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-44-216, CGRectGetWidth(self.view.frame), 44+216);
        _maskView.backgroundColor = [UIColor darkGrayColor];
        _maskView.alpha = .7;
    }];
}

- (void)clearItemAction:(UIBarButtonItem *)item
{
    if (self.completionHandler) {
        self.completionHandler(nil);
    }
    [self hide];
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker)
    {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(self.view.frame), 216)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    return _datePicker;
}

- (void)doneBtnClicked:(UIBarButtonItem *)item
{
    if (self.completionHandler) {
        self.completionHandler(_datePicker.date);
    }
    [self hide];
}

- (void)hide
{
    [UIView animateWithDuration:.3 animations:^{
        _pickerWrapper.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 44+216);
        _maskView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation UIViewController (DatePickerViewController)

- (void)showDatePickerViewController:(DatePickerViewController *)picker
{
    UIViewController *p = self;
    if (self.navigationController)
    {
        p = self.navigationController;
    }
    
    [p addChildViewController:picker];
    [p.view addSubview:picker.view];
    
    picker.view.frame = p.view.bounds;
}

- (void)showDatePickerViewController:(DatePickerViewController *)picker withCompletionHandler:(void (^)(NSDate *))handler
{
    picker.completionHandler = handler;
    [self showDatePickerViewController:picker];
}

@end
