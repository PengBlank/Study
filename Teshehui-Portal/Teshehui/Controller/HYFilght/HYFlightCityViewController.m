//
//  CQCitySelectViewController.m
//  Teshehui
//
//  Created by ChengQian on 13-10-28.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "HYFlightCityViewController.h"
#import "CQSwithControl.h"
#import "PTSearchBar.h"
#import "JSONKit_HY.h"
#import "SearchCoreManager.h"
#import "HYBaseLineCell.h"
#import "HYSectionIndexView.h"
#import "HYFlightCityVersionRequest.h"
#import "HYFlightCityListRequest.h"

@interface HYFlightCityViewController ()<UITextFieldDelegate>
{
    HYSectionIndexView *_indexView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchDisplayController *searchController;

@property (nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic, strong) NSMutableArray *cityKeys;
@property (nonatomic, strong) NSMutableDictionary *cityList;
@property (nonatomic, strong) NSMutableDictionary *cityIdDic;  //以城市id为key值

/**
 *  动态加载城市列表
 */
@property (nonatomic, strong) HYFlightCityVersionRequest *versionRequest;
@property (nonatomic, strong) HYFlightCityListRequest *cityListRequest;

@end

@implementation HYFlightCityViewController

- (void)dealloc
{
    [_versionRequest cancel];
    _versionRequest = nil;
    [_cityListRequest cancel];
    _cityListRequest = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataSoucreType = FlightCity;
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
	searchPhoneNumber.keyboardType = UIKeyboardTypeDefault;
	searchPhoneNumber.autocorrectionType = UITextAutocorrectionTypeDefault;
	searchPhoneNumber.autocapitalizationType = UITextAutocapitalizationTypeNone;   //对文本对象自动大小写
    
	UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchPhoneNumber
                                                                                    contentsController:self];
	searchController.delegate = self;
	searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
	self.searchController = searchController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    if (self.titleName == Country)
    {
        self.title = @"选择国籍";
    }
    else
    {
        self.title = @"选择城市";
    }
    
    _indexView = [[HYSectionIndexView alloc] initWithDefault];
    
    [self loadCityData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_indexView dismiss];
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

#pragma mark setter/getter
- (void)loadCityData
{
    [[SearchCoreManager share] Reset];
    
    NSArray *array = nil;
    if (self.dataSoucreType == FlightCity)
    {
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"kFlightCityListVersion": @(-1)}];
        //[[NSUserDefaults standardUserDefaults] setObject:@(-1) forKey:@"kFlightCityListVersion"];
        self.versionRequest = [[HYFlightCityVersionRequest alloc] init];
        __weak typeof(self) b_self = self;
        [_versionRequest sendReuqest:^(HYFlightCityVersionResponse* rs, NSError *error)
        {
            if (rs.status == 200)
            {
                CGFloat version = rs.cityVersion;
                CGFloat old_version = [[NSUserDefaults standardUserDefaults] floatForKey:@"kFlightCityListVersion"];
                if (version > old_version || version == -100)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@(version) forKey:@"kFlightCityListVersion"];
                    [b_self requestFlightCityList];
                }
                else
                {
                    [b_self updateWithCityList:[HYFlightCity getAllCityflight]];
                }
            }
        }];
    }
    else if (self.dataSoucreType == FlightCountry)
    {
        array = [HYCountryInfo getAllCountries];
        [self updateWithCityList:array];
    }
}

- (void)requestFlightCityList
{
    self.cityListRequest = [[HYFlightCityListRequest alloc] init];
    __weak typeof(self) b_self = self;
    [HYLoadHubView show];
    [_cityListRequest sendReuqest:^(id result, NSError *error)
    {
        [HYLoadHubView dismiss];
        if ([result isKindOfClass:[HYFlightCityListResponse class]] && [result status] == 200)
        {
            HYFlightCityListResponse *rs = (HYFlightCityListResponse *)result;
            NSArray *cityList = rs.cityList;
            [HYFlightCity storyFlightCities:rs.cityListJson];
            
            [b_self updateWithCityList:cityList];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取城市列表失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)updateWithCityList:(NSArray *)cityList
{
    if ([cityList count] > 0)
    {
        //重建索引，muKeys为拼音索引数组,muDicy为以拼音索引为键的字典
        NSMutableArray *muKeys = [[NSMutableArray alloc] init];
        NSMutableDictionary *muDicy = [[NSMutableDictionary alloc] init];
        //id 对城市的索引表
        NSMutableDictionary *muIdDic = [[NSMutableDictionary alloc] init];
        
        //这里的排序没有起到作用
        NSMutableArray *allCitys = [cityList mutableCopy];
        [allCitys sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *key1 = [(HYCountryInfo *)obj1 pinyin];
            NSString *key2 = [(HYCountryInfo *)obj2 pinyin];
            return [key1 compare:key2];
        }];
        
        NSMutableArray *hotCity = [[NSMutableArray alloc] init];
        
        for (HYCountryInfo *obj in cityList)
        {
            NSInteger cityId = [obj.countryId integerValue];
            NSNumber *idKey = [NSNumber numberWithInteger:cityId];
            
            //加入城市到搜索列表
            [[SearchCoreManager share] AddContact:idKey
                                             name:obj.countryName
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
                //如果索引表中没有该键，加入键并在字典中加入
                if (![muKeys containsObject:key])
                {
                    NSMutableArray *array = [NSMutableArray arrayWithObject:obj];
                    [muDicy setObject:array forKey:key];
                    [muKeys addObject:key];
                }
                else
                {
                    //这里没有进行排序，说明取回的数组本身是排好序的
                    NSMutableArray *array = [muDicy objectForKey:key];
                    [array addObject:obj];
                    [muDicy setObject:array forKey:key];
                }
            }
        }
        
        //对索引数组进行排序
        [muKeys sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *key1 = (NSString *)obj1;
            NSString *key2 = (NSString *)obj2;
            return [key1 compare:key2];
        }];
        
        //热点城市按热度排序并插入到索引数组起始位置
        if ([hotCity count] > 0)
        {
            [hotCity sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                HYCountryInfo *city1 = (HYFlightCity *)obj1;
                HYCountryInfo *city2 = (HYFlightCity *)obj2;
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
            HYFlightCity *city = [self.cityIdDic objectForKey:key];
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
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 24)];
        bgView.backgroundColor = [UIColor colorWithRed:247.0/255.0
                                                 green:247.0/255.0
                                                  blue:247.0/255.0
                                                 alpha:1.0f];
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(12, 2, 60, 20)];
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
            id city = [self.searchResults objectAtIndex:indexPath.row];
            
            if ([city isKindOfClass:[HYCountryInfo class]])
            {
                HYCountryInfo *c = (HYCountryInfo *)city;
                cell.textLabel.text = c.countryName;
            }
            else if ([city isKindOfClass:[HYFlightCity class]])
            {
                HYFlightCity *c = (HYFlightCity *)city;
                cell.textLabel.text = c.cityName;
            }
        }
    }
    else
    {
        if (indexPath.section < [self.cityKeys count])
        {
            NSString *key = [self.cityKeys objectAtIndex:indexPath.section];
            NSArray *citys = [self.cityList objectForKey:key];
            id city = [citys objectAtIndex:indexPath.row];
            if ([city isMemberOfClass:[HYCountryInfo class]])
            {
                HYCountryInfo *c = (HYCountryInfo *)city;
                cell.textLabel.text = c.countryName;
            }
            else if ([city isMemberOfClass:[HYFlightCity class]])
            {
                HYFlightCity *c = (HYFlightCity *)city;
                cell.textLabel.text = c.cityName;
            }
        }
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(didSelectCity:)])
    {
        HYCountryInfo *city = nil;
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
            [self.delegate didSelectCity:city];
            [self.navigationController popViewControllerAnimated:YES];
        }
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
