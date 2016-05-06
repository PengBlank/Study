//
//  HYInvoiceTitlesViewController.m
//  Teshehui
//
//  Created by apple on 15/3/5.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYInvoiceTitlesViewController.h"
#import "HYBaseLineCell.h"
#import "HYPassengerListCell.h"
#import "HYInvoiceTitleAddViewController.h"

@interface HYInvoiceTitlesViewController ()
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *invoiceTitles;

@end

@implementation HYInvoiceTitlesViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.titlesAction = HYInvoiceTitlesSelect;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                           green:237.0f/255.0f
                                            blue:237.0f/255.0f
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.sectionFooterHeight = 10;
    tableview.sectionHeaderHeight = 0;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.titlesAction == HYInvoiceTitlesSelect)
    {
        self.title = @"选择常用发票抬头";
    }
    else if (self.titlesAction == HYInvoiceTitlesView)
    {
        self.title = @"常用发票抬头";
    }
    
    [self loadInvoiceTitles];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (void)loadInvoiceTitles
{
    self.invoiceTitles = [[NSUserDefaults standardUserDefaults] arrayForKey:@"kInvoiceTitles"];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return ([self.passengers count]+1);
    return self.invoiceTitles.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *AddPassengerCellId = @"AddPassengerCellId";
        HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:AddPassengerCellId];
        if (cell == nil)
        {
            cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:AddPassengerCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
            cell.separatorLeftInset = 0;
            
            UIImage *arrIcon = [UIImage imageNamed:@"ico_arrow_list"];
            UIImageView *arrView1 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenRect.size.width-20, 14.5, 10, 15)];
            arrView1.image = arrIcon;
            [cell.contentView addSubview:arrView1];
        }
        
        cell.textLabel.text = @"新增常用发票抬头";
        return cell;
    }
    else
    {
        static NSString *passengerCellId = @"passengerCellId";
        HYPassengerListCell *cell = [tableView dequeueReusableCellWithIdentifier:passengerCellId];
        if (cell == nil)
        {
            cell = [[HYPassengerListCell alloc]initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:passengerCellId];
            [cell.eidtBtn addTarget:self
                             action:@selector(editEvent:)
                   forControlEvents:UIControlEventTouchUpInside];
            
            [cell setShowCheckBox:self.titlesAction == HYInvoiceTitlesSelect];
        }
        
        NSInteger index = indexPath.row-1;
        if (index < _invoiceTitles.count)
        {
            cell.textLabel.text = [_invoiceTitles objectAtIndex:index];
            if ([_selectedTitle isEqualToString:[_invoiceTitles objectAtIndex:index]])
            {
                cell.isCheck = YES;
            }
            else
            {
                cell.isCheck = NO;
            }
            cell.eidtBtn.tag = index;
        }
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        HYInvoiceTitleAddViewController *add = [[HYInvoiceTitleAddViewController alloc] init];
        add.titleAction = HYInvoiceTitleAdd;
        add.navbarTheme = self.navbarTheme;
        add.invoiceAddCallback = ^(NSString *newTitle){
            [self loadInvoiceTitles];
        };
        [self.navigationController pushViewController:add animated:YES];
    }
    else
    {
        NSInteger index = indexPath.row-1;
        if (index < _invoiceTitles.count)
        {
            NSString *title = [_invoiceTitles objectAtIndex:index];
            if (self.invoiceTitlesCallback)
            {
                self.invoiceTitlesCallback(title);
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow -1)
    {
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (void)editEvent:(UIButton *)sender
{
    NSInteger index = sender.tag;
    if (index < _invoiceTitles.count)
    {
        NSString *title = [_invoiceTitles objectAtIndex:index];
        HYInvoiceTitleAddViewController *add = [[HYInvoiceTitleAddViewController alloc] init];
        add.invoiceTitle = title;
        add.titleAction = HYInvoiceTitleEdit;
        add.invoiceAddCallback = ^(NSString *newTitle){
            [self loadInvoiceTitles];
        };
        [self.navigationController pushViewController:add animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
