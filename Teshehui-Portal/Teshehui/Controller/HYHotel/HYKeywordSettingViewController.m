//
//  HYKeywordSettingViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


#import "HYKeywordSettingViewController.h"
#import "HYKeywordListViewController.h"
#import "HYBaseLineCell.h"

@interface HYKeywordSettingViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchDisplayController *searchController;

@end

@implementation HYKeywordSettingViewController

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
    view.backgroundColor = [UIColor colorWithRed:235.0f/255.0f
                                           green:235.0f/255.0f
                                            blue:235.0f/255.0f
                                           alpha:1.0f];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.sectionHeaderHeight = 0;
    tableview.sectionFooterHeight = 0;
    
    //line
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    tableview.tableHeaderView = headerView;
    
    [self.view addSubview:tableview];
    
    UISearchBar *searchPhoneNumber = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 44)];
    
	searchPhoneNumber.delegate = self;
    tableview.tableHeaderView = searchPhoneNumber;
	searchPhoneNumber.keyboardType = UIKeyboardTypeDefault;

	searchPhoneNumber.autocorrectionType = UITextAutocorrectionTypeDefault;
	searchPhoneNumber.autocapitalizationType = UITextAutocapitalizationTypeNone;   //对文本对象自动大小写
    
	UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchPhoneNumber contentsController:self];
	searchController.delegate = self;
	searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
	self.searchController = searchController;
    
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"keyword", nil);
    self.searchController.searchBar.text = self.condition.keyword;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)filterWithSearchString:(NSString *)str
{
    self.condition.keyword = str;
    self.condition.keyword = str;
}

#pragma mark -
#pragma mark UISearchDisplayController/UISearchBarDelegate Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
    if ([self.condition.keyword length] > 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller;
{
}

-(void)searchDisplayController:(UISearchDisplayController *)controller
 didShowSearchResultsTableView:(UITableView *)tableView
{
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //搜索
    [self filterWithSearchString:searchString];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    //    [self filterContentForSearchText:[self.searchController.searchBar text]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
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
    static NSString *searchnearID = @"searchnearID";
    HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:searchnearID];
    if (cell == nil)
    {
        cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:searchnearID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    if (indexPath.row == 0) //商区
    {
       [cell.textLabel setText:NSLocalizedString(@"business_areas", nil)];
    }
    else
    {
        [cell.textLabel setText:NSLocalizedString(@"administrative_area", nil)];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //必须有城市信息才可以选择商圈，否则不可以
    
    if (self.condition.cityInfo)
    {
        HYKeywordListViewController *vc = [[HYKeywordListViewController alloc] init];
        vc.condition = self.condition;
//        switch (indexPath.row)
//        {
//            case 0:
//                vc.condType = Business_Area;
//                break;
//            case 1:
//                vc.condType = Administrative_Area;
//                break;
//            default:
//                break;
//        }
        
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tips", nil)
                                                        message:NSLocalizedString(@"hotel_city_null", nil)
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"done", nil), nil];
        [alert show];
    }
}

@end
