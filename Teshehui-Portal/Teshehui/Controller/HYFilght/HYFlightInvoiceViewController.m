//
//  HYFlightInvoiceViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightInvoiceViewController.h"
#import "HYBaseLineCell.h"

@interface HYFlightInvoiceViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HYFlightInvoiceViewController

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
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStyleGrouped];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.sectionFooterHeight = 10;
    tableview.sectionHeaderHeight = 0;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 60.0f;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *passengerCellId = @"passengerCellId";
    HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:passengerCellId];
    if (cell == nil)
    {
        cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:passengerCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = @"报销凭证配送";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
