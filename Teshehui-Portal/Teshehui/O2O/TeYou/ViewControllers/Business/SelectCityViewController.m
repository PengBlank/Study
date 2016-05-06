//
//  SelectCityViewController.m
//  Teshehui
//
//  Created by apple_administrator on 15/8/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "SelectCityViewController.h"
#import "GetHotCityRequest.h"
#import "HYAppDelegate.h"
#import "ChineseString.h"
#import "UIColor+hexColor.h"
#import "DefineConfig.h"
#import "MJExtension.h"
#import "METoast.h"
#import "Masonry.h"
#import "HotCityCell.h"

#import "UIView+Common.h"
#import "UIColor+expanded.h"
#import "UISearchBar+Common.h"
@interface SelectCityViewController ()<UISearchDisplayDelegate,UISearchBarDelegate>{
    NSString *_recentlyCity;
}

@property (nonatomic, strong) NSString              *recentlyCity;
@property (nonatomic, strong) UIImageView           *imageV;

@property (nonatomic, strong) NSMutableArray    *cityKeys;
@property (nonatomic, strong) NSMutableArray    *citys;
@property (nonatomic, strong) NSMutableArray    *Recentlycitys;
@property (nonatomic, strong) NSMutableArray    *hotCitys;
@property (nonatomic, strong) NSMutableArray    *items;
@property (nonatomic, strong) NSMutableArray    *searchKeys;
@property (nonatomic, strong) NSArray           *searchResults;
@property (nonatomic, strong) NSArray           *cityArr;

@property (nonatomic, strong) CityListRequest   *request;
@property (nonatomic, strong) GetHotCityRequest *hotCityRequest;

@end

@implementation SelectCityViewController

- (void)dealloc
{
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
    [HYLoadHubView dismiss];
    [self.request cancel];
    [self.hotCityRequest cancel];
    self.hotCityRequest = nil;
    self.request = nil;
    
    _imageV = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"选择城市";
        
        _cityKeys   = [NSMutableArray array];
        _citys      = [NSMutableArray array];
        _hotCitys   = [NSMutableArray array];
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    self.view = view;
    
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    WS(weakSelf);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(44, 0, 0, 0));
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:RecentlyCityKey];
    NSString *city2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"city2"];
    if ([city isEqualToString:city2]) {
        _recentlyCity = city;
    }else{
        _recentlyCity = city2;
    }
    
    [self fetchDataFromNet];
    
    _mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    _mySearchBar.delegate = self;
    _mySearchBar.placeholder = @"请输入城市名";
    [_mySearchBar setTintColor:[UIColor colorWithHexString:@"0xb80000"]];
    [self.view addSubview: _mySearchBar];

    _mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_mySearchBar contentsController:self];
    _mySearchDisplayController.delegate = self;
    _mySearchDisplayController.searchResultsDelegate = self;
    _mySearchDisplayController.searchResultsDataSource = self;
    _mySearchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] init];

    
    
}


/**
 *  通过搜索条件过滤得到搜索结果
 *
 *  @param searchText 关键词
 *  @param scope      范围
 */
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
    
    self.searchResults = [self.items filteredArrayUsingPredicate:resultPredicate];
    if (self.searchResults.count == 0) {
          _imageV.hidden = NO;
        _mySearchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        [_imageV removeFromSuperview];
        _mySearchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
 //   self.searchKeys = [ChineseString IndexArray:self.items];
    
}

#pragma mark - UISearchDisplayController 代理

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                                         objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    for (UIView* v in self.mySearchDisplayController.searchResultsTableView.subviews) {
        NSLog(@"%@",v);
        if ([v isKindOfClass: [UILabel class]]) {
            UILabel *label = (UILabel *)v;
            //label.backgroundColor = [UIColor redColor];
            [label setText:@"暂无该城市，请重新输入城市"];
            // .. do whatever you like to the UILabel here ..
            if (!_imageV) {

                _imageV = [[UIImageView alloc] init];
                _imageV.hidden = YES;
                if(currentDeviceType() == iPhone4_4S){
                    [_imageV setFrame:CGRectMake(kScreen_Width/2 - 126,15, 252, 80)];
                }else{
                    [_imageV setFrame:CGRectMake(kScreen_Width/2 - 126,g_fitFloat(@[@60,@105,@145]), 252, 80)];
                }

                _imageV.image = IMAGE(@"nonecity");
                [self.mySearchDisplayController.searchResultsTableView addSubview:_imageV];
            }
            break;
        }
    }
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchDataFromNet
{
    [HYLoadHubView show];
    self.request                                = [[CityListRequest alloc] init];
    self.request.interfaceURL                   = [NSString stringWithFormat:@"%@/v3/Pub/GetCities",BASEURL];
    self.request.httpMethod                     = @"POST";
    self.request.postType                       = JSON;
    self.request.interfaceType                  = DotNET2;
    
    WS(weakSelf);
    [self.request sendReuqest:^(id result, NSError *error)
     {
         if(result){
             
             NSDictionary *objDic = [result jsonDic];
             NSArray *objArray = nil;
             NSArray *hotObjArray = nil;
             int code = [objDic[@"code"] intValue];
             if (code == 0) {
                 NSDictionary *dateDic = objDic[@"data"];
                 NSArray      *DataArray = dateDic[@"Cities"];
                 NSArray      *hotCitysArray = dateDic[@"HotCities"];
                 
                 //解析城市数据
                 [CitySelectInfo setupObjectClassInArray:^NSDictionary *{
                     return @{@"SubAdress" : @"cityInfo"};
                 }];
                 
                 objArray  = [CitySelectInfo objectArrayWithKeyValuesArray:DataArray];
                
                  weakSelf.items = [[NSMutableArray alloc] init];
                 for (CitySelectInfo *info in objArray) {
                     [weakSelf.items addObject:info.Name];
                 }
                 weakSelf.cityKeys = [ChineseString IndexArray:weakSelf.items];
                 weakSelf.citys = [ChineseString LetterSortArray:weakSelf.items];
                
                 if (weakSelf.recentlyCity != nil) {
                     [weakSelf.cityKeys insertObject:@"近" atIndex:0];
                     [weakSelf.citys insertObject:@[weakSelf.recentlyCity] atIndex:0];
                 }
                 
                 //解析热门数据
                 [CitySelectInfo setupObjectClassInArray:^NSDictionary *{
                     return @{@"SubAdress" : @"cityInfo"};
                 }];
                 
                 hotObjArray  = [CitySelectInfo objectArrayWithKeyValuesArray:hotCitysArray];
                 
                 for (CitySelectInfo *info in hotObjArray) {
                     [weakSelf.hotCitys addObject:info.Name];
                 }
                 
                 if (weakSelf.recentlyCity != nil) {
                     [weakSelf.cityKeys insertObject:@"热" atIndex:1];
                     [weakSelf.citys insertObject:@[@""] atIndex:1];
                 }else if (weakSelf.recentlyCity == nil){
                     [weakSelf.cityKeys insertObject:@"热" atIndex:0];
                     [weakSelf.citys insertObject:@[@""] atIndex:0];
                 }
           
                 [weakSelf.tableView reloadData];
                 [HYLoadHubView dismiss];
                 
             }else{
                 [HYLoadHubView dismiss];
                 [METoast toastWithMessage:@"获取信息失败"];
             }
             
         }else{
             [HYLoadHubView dismiss];
             [METoast toastWithMessage:@"无法连接服务器"];
         }
     }];
}


#pragma mark -Section的Header的值
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (tableView != self.tableView) {
        return nil;
    }

    NSString *key = [self.cityKeys objectAtIndex:section];
    return key;
}
#pragma mark - Section header view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (tableView != self.tableView) {
        return nil;
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 20)];
    bgView.backgroundColor = [UIColor colorWithHexColor:@"f2f2f2" alpha:1];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 250, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithHexString:@"0x434343"];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    NSString *key = [self.cityKeys objectAtIndex:section];
    if ([key rangeOfString:@"近"].location != NSNotFound) {
        titleLabel.text = @"最近访问城市";
    }else if ([key rangeOfString:@"热"].location != NSNotFound) {
        titleLabel.text = @"热门城市";
    }else{
        titleLabel.text = key;
    }


    [bgView addSubview:titleLabel];
    
    return bgView;
}
#pragma mark - row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView && indexPath.section == (self.recentlyCity != nil ? 1 : 0)) {
        
        return (self.hotCitys.count / 3 + (self.hotCitys.count % 3 == 0 ? 0 : 1)) * 44;
    }
    return 44.0;
}


#pragma mark -
#pragma mark Table View Data Source Methods
#pragma mark -设置右方表格的索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView != self.tableView) {
        return nil;
    }
    
    return self.cityKeys;
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return 20;
    }else{
        return 0.00001;
    }
    return 20.0;
}

#pragma mark -允许数据源告知必须加载到Table View中的表的Section数。
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView != self.tableView) {
        return 1;
    }
    
    return [self.cityKeys count];
}
#pragma mark -设置表格的行数为数组的元素个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView != self.tableView) {
        return [self.searchResults count];
    }
    
    return [[self.citys objectAtIndex:section] count];
}
#pragma mark -每一行的内容为数组相应索引的值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView != self.tableView) {

        static NSString *ID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        cell.textLabel.text = (tableView == self.tableView) ? self.items[indexPath.row] : self.searchResults[indexPath.row];
        
        return cell;
    }else{
        
        if (indexPath.section == (self.recentlyCity != nil ? 1 : 0)) {
            static NSString *CellIdentifier = @"Cellindentifier";
            
            HotCityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[HotCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            }
            WS(weakSelf);
            [cell setHotCityClick:^(UIButton *cityBtn) {
                
                NSString  *city = cityBtn.titleLabel.text;
                [[NSUserDefaults standardUserDefaults] setObject:city forKey:RecentlyCityKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setObject:weakSelf.currentCity forKey:@"city2"];
                [[NSUserDefaults standardUserDefaults] synchronize];
             
                 if (weakSelf.callback)
                 {
                     weakSelf.callback(city);
                 }
                 [weakSelf backToRootViewController:nil];
                
            }];
            
            [cell bindData:self.hotCitys];
            return cell;
        }
    
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
        }
        
        NSString *cityName = [[self.citys objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text = cityName;
        return cell;
    
    }
    
    
    

    
}
#pragma mark - Select内容为数组相应索引的值
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *city = nil;
    if (tableView != self.tableView) {
        city  = [self.searchResults objectAtIndex:indexPath.row];
    }else{
        
        if (indexPath.section == (self.recentlyCity != nil ? 1 : 0)) {
            return;
        }
        city = [[self.citys objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    }
    

        [[NSUserDefaults standardUserDefaults] setObject:city forKey:RecentlyCityKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
        [[NSUserDefaults standardUserDefaults] setObject:_currentCity forKey:@"city2"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    
        if (self.callback)
        {
            self.callback(city);
        }
        [self backToRootViewController:nil];

}


- (IBAction)backToRootViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
