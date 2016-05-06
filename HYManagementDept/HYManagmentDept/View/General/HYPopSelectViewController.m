//
//  HYPopSelectViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-16.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPopSelectViewController.h"

#define kPopTableRowHeight 44

@interface HYPopSelectViewController ()

@end

@implementation HYPopSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectedIdx = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.navigationController)
    {
        UIBarButtonItem *cancelItem;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [btn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cancelItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = cancelItem;
        BOOL onPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        float titleFontSize = onPad ? 22.0 : 16.0;
        UIImage *navB;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
        {
            navB = [UIImage imageNamed:@"nav_128"];
        }
        else
        {
            navB = [UIImage imageNamed:@"nav_88"];
        }
        [self.navigationController.navigationBar setBackgroundImage:navB forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeFont: [UIFont boldSystemFontOfSize:titleFontSize], UITextAttributeTextColor:[UIColor whiteColor]}];
    }
    
    if ([self respondsToSelector:@selector(preferredContentSize)])
    {
        self.preferredContentSize = CGSizeMake(320, 5 * kPopTableRowHeight);
    }
    else {
        self.contentSizeForViewInPopover = CGSizeMake(320, 5 * kPopTableRowHeight);
    }
    UITableView* table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIView *clear = [[UIView alloc] init];
    clear.backgroundColor = [UIColor clearColor];
    table.tableFooterView = clear;
    [self.view addSubview:table];
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPopTableRowHeight;
}

-(UITableViewCell*)tableView:(UITableView *)tableView
       cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    if (indexPath.row == _selectedIdx) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(popSelectView:didSelectIndex:andGetString:)]) {
        [self.delegate popSelectView:self didSelectIndex:indexPath.row andGetString:[self.dataArray objectAtIndex:indexPath.row]];
    }
    
    if (self.presentingViewController || self.navigationController.presentingViewController)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)cancelAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cancelSelectPop:)])
    {
        [self.delegate cancelSelectPop:self];
    }
    if (self.navigationController)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
