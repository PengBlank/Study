//
//  HYHotelCitySelectViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelCitySelectViewController.h"
#import "HYHotelCityInfo.h"
#import "SearchCoreManager.h"
#import "HYBaseLineCell.h"
#import "HYSectionIndexView.h"
#import "HYHotelCityListRequest.h"

@interface HYHotelCitySelectViewController ()
{
    HYSectionIndexView *_indexView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchDisplayController *searchController;

@property (nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic, strong) NSMutableArray *cityKeys;
@property (nonatomic, strong) NSMutableDictionary *cityList;  //以字母为key值
@property (nonatomic, strong) NSMutableDictionary *cityIdDic;  //以城市id为key值

@property (nonatomic, strong) HYHotelCityListRequest *updateRequest;

@end

@implementation HYHotelCitySelectViewController

- (void)dealloc
{
    [_indexView dismiss];
    _indexView = nil;
    [_updateRequest cancel];
}

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
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    rect.origin.y += 44;
    rect.size.height -= 44;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:rect
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.backgroundView = nil;
    [self.view addSubview:tableview];
	self.tableView = tableview;
    
    UISearchBar *searchPhoneNumber = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 44)];
	searchPhoneNumber.delegate = self;
    
    [self.view addSubview:searchPhoneNumber];
//    self.tableView.tableHeaderView = searchPhoneNumber;
	searchPhoneNumber.keyboardType = UIKeyboardTypeDefault;
	searchPhoneNumber.autocorrectionType = UITextAutocorrectionTypeDefault;
	searchPhoneNumber.autocapitalizationType = UITextAutocapitalizationTypeNone;   //对文本对象自动大小写
    searchPhoneNumber.placeholder = @"请输入城市名";
    
	UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchPhoneNumber contentsController:self];
	searchController.delegate = self;
	searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
	self.searchController = searchController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"选择城市";
    
    _indexView = [[HYSectionIndexView alloc] initWithDefault];
    
    [self loadCityData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //重置，释放内存
    [[SearchCoreManager share] Reset];
    [_indexView dismiss];
    [HYLoadHubView dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (!self.view.window)
    {
        [_tableView removeFromSuperview];
        _tableView = nil;
        
        [_indexView dismiss];
        _indexView = nil;
        
        self.view = nil;
    }
}

- (void)loadCityData
{
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    NSDictionary *defaultValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @-1, @"hotelCityVersion",
                                   nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
    NSInteger version = [[NSUserDefaults standardUserDefaults] integerForKey:@"hotelCityVersion"];
    self.updateRequest = [[HYHotelCityListRequest alloc] init];
    self.updateRequest.dataVersion = version;
    
    [self.updateRequest sendReuqest:^(id result, NSError *error)
    {
        if (!error && [result isKindOfClass:[CQBaseResponse class]])
        {
            NSDictionary *dic = [[(CQBaseResponse *)result jsonDic] objectForKey:@"data"];
            NSArray *list = [dic objectForKey:@"provinceList"];
            if (list.count > 0)
            {
                NSNumber *newV = [dic objectForKey:@"version"];
                [[NSUserDefaults standardUserDefaults] setObject:newV forKey:@"hotelCityVersion"];
                
                NSString* string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString* fileName = [string  stringByAppendingPathComponent:@"hotel_city.plist"];
                [list writeToFile:fileName atomically:NO];
            }
        }
        [b_self didUpdatedCityData];
    }];
}

- (void)didUpdatedCityData
{
    NSArray *array = [HYHotelCityInfo getAllAttCityInfo];
    
    [[SearchCoreManager share] Reset];
    [HYLoadHubView dismiss];
    if ([array count] > 0)
    {
        NSMutableArray *muKeys = [[NSMutableArray alloc] init];
        NSMutableDictionary *muDicy = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *muIdDic = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *allCitys = [array mutableCopy];
        
        [allCitys sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *key1 = [(HYHotelCityInfo *)obj1 pinyinIndex];
            NSString *key2 = [(HYHotelCityInfo *)obj2 pinyinIndex];
            return [key1 compare:key2];
        }];
        
        NSMutableArray *hotCity = [[NSMutableArray alloc] init];
        
        for (HYHotelCityInfo *obj in allCitys)
        {
            NSInteger cityId = [obj.cityId integerValue];
            NSNumber *idKey = [NSNumber numberWithInteger:cityId];
            
            [[SearchCoreManager share] AddContact:idKey
                                             name:obj.cityName
                                            phone:nil];
            
            [muIdDic setObject:obj forKey:idKey];
            
            //热门城市
            if (obj.hot > 0)
            {
                [hotCity addObject:obj];
            }
            
            NSString *key = obj.pinyinIndex;
            if (key)
            {
                if (![muKeys containsObject:key])
                {
                    NSMutableArray *array = [NSMutableArray arrayWithObject:obj];
                    [muDicy setObject:array forKey:key];
                    [muKeys addObject:key];
                }
                else
                {
                    NSMutableArray *array = [muDicy objectForKey:key];
                    [array addObject:obj];
                    [muDicy setObject:array forKey:key];
                }
            }
        }
        
        if ([hotCity count] > 0)
        {
            [hotCity sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                HYHotelCityInfo *city1 = (HYHotelCityInfo *)obj1;
                HYHotelCityInfo *city2 = (HYHotelCityInfo *)obj2;
                return city1.hot < city2.hot;
            }];
            
            NSString *hotKey = @"热门";
            [muKeys insertObject:hotKey atIndex:0];
            [muDicy setObject:hotCity forKey:hotKey];
        }
        
        self.cityKeys = muKeys;
        self.cityList = muDicy;
        self.cityIdDic = muIdDic;
        
        [self.tableView reloadData];
    }
}

- (void)filterWithSearchString:(NSString *)str
{
    if (str.length > 0)
    {
        NSMutableArray *cityIds = [[NSMutableArray alloc] init];
        
        //搜索
        [[SearchCoreManager share] Search:str
                              searchArray:nil
                                nameMatch:cityIds
                               phoneMatch:nil];
        
        //取出城市信息
        NSMutableArray *citys = [[NSMutableArray alloc] init];
        for (NSNumber *key in cityIds)
        {
            HYHotelCityInfo *city = [self.cityIdDic objectForKey:key];
            [citys addObject:city];
        }
        self.searchResults = citys;
        
        [self.searchController.searchResultsTableView setContentOffset:CGPointZero];
    }
}

#pragma mark -
#pragma mark UISearchDisplayController/UISearchBarDelegate Delegate Methods
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
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

#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    if (aTableView == self.searchDisplayController.searchResultsTableView)
    {
        return 1;
    }
    else
    {
        return [self.cityKeys count];
    }
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (aTableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResults count];
    }
    else
    {
        NSString *key = [self.cityKeys objectAtIndex:section];
        NSArray *citys = [self.cityList objectForKey:key];
        return [citys count];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return nil;
    }
    else
    {
        return self.cityKeys;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat heigth = 25.0;
    if (tableView == self.searchController.searchResultsTableView)
    {
        heigth = 0.0f;
    }
    
    return heigth;
}

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
    if (tableView == self.searchController.searchResultsTableView)
    {
        return 0;
    }
    else
    {
        [_indexView setText:title];
        [_indexView show];
        return index;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < [self.cityKeys count])
    {
        NSString *title = [self.cityKeys objectAtIndex:section];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFScalePoint(320), 24)];
        bgView.backgroundColor = [UIColor colorWithRed:247.0/255.0
                                                 green:247.0/255.0
                                                  blue:247.0/255.0
                                                 alpha:1.0f];
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(12, 2, 40, 20)];
        titleLb.backgroundColor = [UIColor clearColor];
        titleLb.font = [UIFont systemFontOfSize:15];
        titleLb.textColor = [UIColor grayColor];
        titleLb.text = title;
        
        [bgView addSubview:titleLb];
        return bgView;
    }
    
    return nil;
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

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    if (tableView == self.searchController.searchResultsTableView)
    {
        if (indexPath.row < [self.searchResults count])
        {
            HYHotelCityInfo *city = [self.searchResults objectAtIndex:indexPath.row];
            cell.textLabel.text = city.cityName;
        }
    }
    else
    {
        if (indexPath.section < [self.cityKeys count])
        {
            NSString *key = [self.cityKeys objectAtIndex:indexPath.section];
            NSArray *citys = [self.cityList objectForKey:key];
            HYHotelCityInfo *city = [citys objectAtIndex:indexPath.row];
            cell.textLabel.text = city.cityName;
        }
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HYHotelCityInfo *city = nil;
    if (tableView == self.searchController.searchResultsTableView)
    {
        if (indexPath.row < [self.searchResults count])
        {
            city = [self.searchResults objectAtIndex:indexPath.row];
        }
    }
    else
    {
        if (indexPath.section < [self.cityKeys count])
        {
            NSString *key = [self.cityKeys objectAtIndex:indexPath.section];
            NSArray *citys = [self.cityList objectForKey:key];
            city = [citys objectAtIndex:indexPath.row];
        }
    }
    
    
    if (city)
    {
        if ([self.delegate respondsToSelector:@selector(didSelectCity:)])
        {
            [self.delegate didSelectCity:city];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_indexView dismiss];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_indexView dismiss];
}

@end
