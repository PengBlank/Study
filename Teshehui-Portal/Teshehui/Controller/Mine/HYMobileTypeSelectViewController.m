//
//  HYMobileTypeSelectViewController.m
//  Teshehui
//
//  Created by HYZB on 14-10-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMobileTypeSelectViewController.h"
#import "HYBaseLineCell.h"

@interface HYMobileTypeSelectViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *typeInfo;

@end

@implementation HYMobileTypeSelectViewController

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *v= [[UIView alloc] initWithFrame:CGRectZero];
    tableview.tableHeaderView = v;
    tableview.rowHeight = 44.0f;
    [self.view addSubview:tableview];
    self.tableView = tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"标签";
    
    self.typeInfo = @[@"手机", @"工作", @"住宅", @"传真", @"其他"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - private methods


#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.typeInfo count];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
    if(indexPath.row == totalRow -1){
        //this is the last row in section.
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *orderSummaryCellId = @"orderSummaryCellId";
    HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:orderSummaryCellId];
    if (cell == nil)
    {
        cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleValue1
                                    reuseIdentifier:orderSummaryCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    if (indexPath.row < [self.typeInfo count])
    {
        NSString *name = [self.typeInfo objectAtIndex:indexPath.row];
        cell.textLabel.text = name;
    }
    
    if ((indexPath.row+1) == self.telNumber.type)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(didSelectMobileType)])
    {
        self.telNumber.type = indexPath.row+1;
        [self.delegate didSelectMobileType];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
