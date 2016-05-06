//
//  HYEmployeesOrderViewController.m
//  Teshehui
//
//  Created by HYZB on 14-7-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYEmployeesOrderViewController.h"
#import "HMSegmentedControl.h"
#import "HYEmployeeFilghtOrderView.h"
#import "HYEmployeeFlowersOrderView.h"
#import "HYEmployeeHotelOrderView.h"

@interface HYEmployeesOrderViewController ()
{
    HMSegmentedControl *_segmentedControl;
}

@property (nonatomic, strong) HYEmployeeFilghtOrderView *flightOrderView;
@property (nonatomic, strong) HYEmployeeFlowersOrderView *flowersOrderView;
@property (nonatomic, strong) HYEmployeeHotelOrderView *hotelOrderView;

@end

@implementation HYEmployeesOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    if (!_segmentedControl)
    {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"机票", @"酒店", @"鲜花"]];
        [_segmentedControl setFrame:CGRectMake(0, 0, frame.size.width, 40)];
        [_segmentedControl addTarget:self
                              action:@selector(segmentedControlChangedValue:)
                    forControlEvents:UIControlEventValueChanged];
        [_segmentedControl setTag:1];
        _segmentedControl.selectionIndicatorColor = [UIColor redColor];
        _segmentedControl.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                                            green:237.0f/255.0f
                                                             blue:237.0f/255.0f
                                                            alpha:1.0];
        _segmentedControl.selectionIndicatorMode = HMSelectionIndicatorFillsSegment;
        _segmentedControl.selectionIndicatorHeight = 4;
        [self.view addSubview:_segmentedControl];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"%@的订单", self.employee.real_name];
    
    [self segmentedControlChangedValue:_segmentedControl];
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
#pragma mark - setter/getter
- (HYEmployeeFilghtOrderView *)flightOrderView
{
    if (!_flightOrderView)
    {
        CGRect frame = [[UIScreen mainScreen] bounds];
        frame.origin.y = 40;
        frame.size.height -= 104;
        _flightOrderView = [[HYEmployeeFilghtOrderView alloc] initWithFrame:frame];
        _flightOrderView.employee = self.employee;
        [_flightOrderView relaodData];
    }
    
    return _flightOrderView;
}

- (HYEmployeeFlowersOrderView *)flowersOrderView
{
    if (!_flowersOrderView)
    {
        CGRect frame = [[UIScreen mainScreen] bounds];
        frame.origin.y = 40;
        frame.size.height -= 104;
        _flowersOrderView = [[HYEmployeeFlowersOrderView alloc] initWithFrame:frame];
        _flowersOrderView.employee = self.employee;
        [_flowersOrderView relaodData];
    }
    
    return _flowersOrderView;
}

- (HYEmployeeHotelOrderView *)hotelOrderView
{
    if (!_hotelOrderView)
    {
        CGRect frame = [[UIScreen mainScreen] bounds];
        frame.origin.y = 40;
        frame.size.height -= 104;
        _hotelOrderView = [[HYEmployeeHotelOrderView alloc] initWithFrame:frame];
        _hotelOrderView.employee = self.employee;
        [_hotelOrderView relaodData];
    }
    
    return _hotelOrderView;
}

#pragma mark - private methods
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl
{
    switch (segmentedControl.selectedIndex)
    {
        case 0:
            [self.view addSubview:self.flightOrderView];
            [_flowersOrderView removeFromSuperview];
            [_hotelOrderView removeFromSuperview];
            break;
        case 1:
            [self.view addSubview:self.hotelOrderView];
            [_flightOrderView removeFromSuperview];
            [_flowersOrderView removeFromSuperview];
            break;
        case 2:
            [self.view addSubview:self.flowersOrderView];
            [_flightOrderView removeFromSuperview];
            [_hotelOrderView removeFromSuperview];
            break;
        default:
            break;
    }
}

@end
