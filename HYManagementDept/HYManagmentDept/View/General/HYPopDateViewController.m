//
//  HYPopDateViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-14.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPopDateViewController.h"

@interface HYPopDateViewController ()

@end

@implementation HYPopDateViewController

@synthesize datePicker = datePicker;

- (UIDatePicker *)datePicker
{
    if (!datePicker)
    {
        datePicker = [[UIDatePicker alloc] initWithFrame:self.view.bounds];
        datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    }
    return datePicker;
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

    self.contentSizeForViewInPopover = CGSizeMake(320, 240);
    CGFloat version = [[UIDevice currentDevice] systemVersion].floatValue;
    if (version >= 8.0) {
        self.preferredContentSize = CGSizeMake(320, 180);
    }
    
    UIBarButtonItem *cancelItem;
    cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStyleDone target:self action:@selector(cancelItemAction)];

    UIBarButtonItem *doneItem;
    doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(doneItemAction)];
    //doneItem.title = @"确定";
    
    [self.navigationItem setLeftBarButtonItem:cancelItem animated:YES];
    [self.navigationItem setRightBarButtonItem:doneItem animated:YES];
//    self.navigationItem.leftBarButtonItem = cancelItem;
//    self.navigationItem.rightBarButtonItem = doneItem;
    
    [self.view addSubview:self.datePicker];
}

- (void)cancelItemAction
{
    if ([self.delegate respondsToSelector:@selector(popDateViewDidClickCancel)]) {
        [self.delegate popDateViewDidClickCancel];
    }
}

- (void)doneItemAction
{
    if ([self.delegate respondsToSelector:@selector(popDateViewDidGetDate:)]) {
        [self.delegate popDateViewDidGetDate:datePicker.date];
    }
    if ([self.delegate respondsToSelector:@selector(popDateViewDidGetDate:withTag:)]) {
        [self.delegate popDateViewDidGetDate:datePicker.date withTag:self.tag];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
