//
//  BusinessSearchViewController.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/8.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "BusinessSearchViewController.h"
#import "BusinessSearchResultController.h"
#import "LocalSearchManager.h"
#import "DefineConfig.h"
#import "UIColor+expanded.h"
#import "UIImage+Common.h"
#import "UITableView+Common.h"
#import "UILabel+Common.h"
#import "UIUtils.h"
#import "SearchMerchantRequest.h"
#import "BusinessListInfo.h"
#import "MJExtension.h"
#import "METoast.h"
#import "UIView+Common.h"
#import "METoast.h"
#import "SearchHistoryCell.h"
@interface BusinessSearchViewController()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
        SearchMerchantRequest   *_searchMerchantRequest;
}
@property (nonatomic, strong) UISearchBar                 *mySearchBar;
@property (nonatomic, strong) UIBarButtonItem             *rightBarItem;
@property (nonatomic, strong) UITableView                 *tableView;
@property (nonatomic, strong) NSMutableArray              *historyData;
@property (nonatomic, strong) NSMutableArray              *searchData;


@end



@implementation BusinessSearchViewController

- (UIView*)searchView
{
    
    if (!_mySearchBar) {
        _mySearchBar = [[UISearchBar alloc] init];
        [_mySearchBar setFrame:CGRectMake(0,0, kScreen_Width - 120 , 40)];
        [_mySearchBar setDelegate:self];
        [_mySearchBar setPlaceholder:@"搜索商家"];
        [_mySearchBar setBarStyle:UIBarStyleDefault];
        [_mySearchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        _mySearchBar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
        [_mySearchBar setTranslucent:YES];
        
        NSArray  *subViews = nil;
        subViews = IOS7 ? [_mySearchBar.subviews[0] subviews] : [_mySearchBar subviews];
        
        for (UIView *subview in subViews){
            
            if ( [subview isKindOfClass:[UITextField class]] ){
                
                UITextField *temTextFD = (UITextField *)subview;
                [temTextFD setTintColor:[UIColor colorWithHexString:@"0xb80000"]];
                [temTextFD setFont:[UIFont systemFontOfSize:13]];
                [temTextFD setValue:[UIColor colorWithHexString:@"0xc7c7c7"] forKeyPath:@"_placeholderLabel.textColor"];
                [temTextFD setTextColor:[UIColor colorWithHexString:@"0x343434"]];
                [temTextFD  setBackgroundColor:[UIColor colorWithHexString:@"0xf6f6f6"]];
                [[temTextFD  layer] setCornerRadius:5];
                [[temTextFD  layer] setMasksToBounds:YES];
                [[temTextFD layer] setBorderWidth:0.5];
                [[temTextFD layer] setBorderColor:[UIColor colorWithHexString:@"0xc7c7c7"].CGColor];
                UIImage *image = [UIImage imageNamed: @"search"];
                UIImageView *iView = [[UIImageView alloc] initWithImage:image];
                iView.frame = CGRectMake(0, 0, 17 , 17);
                [temTextFD setLeftView:iView];
                return _mySearchBar;
            }
        }
    }
    return _mySearchBar;
}

- (UIBarButtonItem *)rightBarItem{
    
    if (!_rightBarItem)
    {
        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        searchButton.frame = CGRectMake(0, 0, 55, 30);
        [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [searchButton setTitleColor:[UIColor colorWithHexString:@"0xb80000"] forState:UIControlStateNormal];
        [[searchButton titleLabel] setFont:[UIFont systemFontOfSize:15]];
        [searchButton addTarget:self action:@selector(searchButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        _rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    }
    return _rightBarItem;
}

- (UITableView *)tableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50.0f;
        _tableView.backgroundColor = UIColorFromRGB(245, 245, 245);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

- (NSMutableArray *)historyData{

    if (!_historyData) {
        _historyData = [NSMutableArray array];
    }
    return _historyData;
}

- (NSMutableArray *)searchData{
    
    if (!_searchData) {
        _searchData = [NSMutableArray array];
    }
    return _searchData;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf1f1f1"];
    self.navigationItem.titleView = self.searchView;;
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
    self.historyData = [[LocalSearchManager sharedManager] getSearchHistory];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mySearchBar becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self giveUpFirstResponder];
}

- (void)dealloc{
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _historyData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_historyData.count == 0) {
        return 0.000001f;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"0xf1f1f1"];
    UILabel *label = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"0x606060"]];
    [label setFrame:CGRectMake(13, 0,100, 40)];
    label.backgroundColor = [UIColor colorWithHexString:@"0xf1f1f1"];
    [label setText:@"搜索历史"];
    [view addSubview:label];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (_historyData.count == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(0, 0, kScreen_Width, 40);
    [clearButton setTitle:@"清除搜索历史" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor colorWithHexString:@"0x424242"] forState:UIControlStateNormal];
    [[clearButton titleLabel] setFont:[UIFont systemFontOfSize:15]];
    [clearButton addTarget:self action:@selector(clearButtonPressed) forControlEvents:UIControlEventTouchUpInside];
   
    [view addSubview:clearButton];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    SearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[SearchHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell bindData:_historyData[indexPath.row]];
//    cell.imageView.image = [UIImage imageNamed:@"i_search"];
//    cell.textLabel.text = _historyData[indexPath.row];
    WS(weakSelf);
    [cell setClearBtnClick:^(NSString *key) {
        [weakSelf clearHistoryOneKey:key];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *tmpKey = self.historyData[indexPath.row];
    
    BusinessSearchResultController *vc = [[BusinessSearchResultController alloc] init];
    vc.searchKey = tmpKey;
    vc.placeholderText = tmpKey;
    vc.coor = self.coor;
    vc.cityName = self.cityName;
    [self.navigationController pushViewController:vc animated:YES];
   
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:13 hasSectionLine:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self giveUpFirstResponder];
}

- (void)searchButtonPressed{
    
    [self giveUpFirstResponder];
    NSString *tmpKey = _mySearchBar.text;
    /**
     *  全部为空格就不保存
     */
    if ([[tmpKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        [METoast toastWithMessage:@"请输入商家名"];
        return;
    }
    [[LocalSearchManager sharedManager] saveSearchKey:tmpKey];
    
    BusinessSearchResultController *vc = [[BusinessSearchResultController alloc] init];
    vc.searchKey = tmpKey;
    vc.placeholderText = self.mySearchBar.text;
    vc.coor = self.coor;
    vc.cityName = self.cityName;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)clearHistoryOneKey:(NSString *)key{
    [[LocalSearchManager sharedManager] clearSearchOneKey:key];
    [_historyData removeObject:key];
     [_tableView reloadData];
}

- (void)clearButtonPressed{

    [_historyData removeAllObjects];
    [[LocalSearchManager sharedManager] clearSearchKey];
    [_tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchButtonPressed];
}

- (void)giveUpFirstResponder{
    
    if ([_mySearchBar isFirstResponder]) {
        [_mySearchBar resignFirstResponder];
    }
}


@end
