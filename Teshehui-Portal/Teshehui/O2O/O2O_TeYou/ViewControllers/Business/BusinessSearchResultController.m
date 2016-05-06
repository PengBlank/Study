//
//  BusinessSearchResultController.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/8.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "BusinessSearchResultController.h"
#import "BusinessDetailViewController.h"
#import "SearchMerchantRequest.h"
#import "BusinessListInfo.h"
#import "UIColor+expanded.h"
#import "UIImage+Common.h"
#import "UITableView+Common.h"
#import "DefineConfig.h"
#import "BusinesslistCell.h"
#import "METoast.h"
#import "MJExtension.h"
#import "UIView+Common.h"
@interface BusinessSearchResultController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    SearchMerchantRequest   *_searchMerchantRequest;
}
@property (nonatomic, strong) UITableView                *tableView;
@property (nonatomic, strong) UISearchBar                *mySearchBar;
@property (nonatomic, strong) UIBarButtonItem             *rightBarItem;

@end

@implementation BusinessSearchResultController


- (UIView*)searchView
{
    if (!_mySearchBar) {
        _mySearchBar = [[UISearchBar alloc] init];
        [_mySearchBar setFrame:CGRectMake(0,0, 200 , 40)];
        _mySearchBar.delegate = self;
        [_mySearchBar setPlaceholder:self.placeholderText];
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
        [searchButton setTitle:@"取消" forState:UIControlStateNormal];
        [searchButton setTitleColor:[UIColor colorWithHexString:@"0xb80000"] forState:UIControlStateNormal];
        [[searchButton titleLabel] setFont:[UIFont systemFontOfSize:15]];
        [searchButton addTarget:self action:@selector(cancalButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        _rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    }
    return _rightBarItem;
}



- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kNavBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50.0f;
        _tableView.backgroundColor = UIColorFromRGB(245, 245, 245);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf1f1f1"];
    self.navigationItem.titleView = self.searchView;;
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
    [self.view addSubview:self.tableView];
    
    [self searchMerchant:self.searchKey];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}


#pragma mark -- 商家列表数据请求
- (void)searchMerchant:(NSString *)merchantName;
{
    
    [HYLoadHubView show];
    _searchMerchantRequest               = [[SearchMerchantRequest alloc] init];
    _searchMerchantRequest.interfaceURL  = [NSString stringWithFormat:@"%@/v3/Merchants/GetMerchantsByName",BASEURL];
    _searchMerchantRequest.httpMethod    = @"POST";
    _searchMerchantRequest.postType      = JSON;
    _searchMerchantRequest.interfaceType = DotNET2;
    
    _searchMerchantRequest.MerchantName  = merchantName;
    _searchMerchantRequest.City          = self.cityName ? :@"";
    
    _searchMerchantRequest.AreaId        = 0;
    _searchMerchantRequest.CategoryId    = 0;
    
    _searchMerchantRequest.Latitude      = _coor.latitude;
    _searchMerchantRequest.Longitude     = _coor.longitude;
    
    _searchMerchantRequest.SortType               = 0;
    _searchMerchantRequest.PageIndex              = kDefaultPageIndexStart;
    _searchMerchantRequest.PageSize               = 100;
    
    WS(weakSelf);
    [_searchMerchantRequest sendReuqest:^(id result, NSError *error)
     {
         NSArray  *objArray = nil;
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"code"] intValue];
             NSString *msg = objDic[@"msg"];
             if (code == 0) { //状态值为0 代表请求成功
                 NSArray *DateArray = objDic[@"data"];
                 objArray  = [BusinessListInfo objectArrayWithKeyValuesArray:DateArray];
             }else{
                 [METoast toastWithMessage:msg ? : @"搜索商家信息失败"];
             }
         }else{
             [METoast toastWithMessage:@"搜索商家信息失败"];
         }
         [weakSelf updateSearchData:objArray error:error];
     }];
}

- (void)updateSearchData:(NSArray *)objArray error:(NSError *)error{
    WS(weakSelf);
   
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:objArray];
    
    [self.tableView configBlankPage:EaseBlankPageTypeNoData hasData:objArray.count > 0 hasError:error
                      reloadButtonBlock:^(id sender) {
                          [weakSelf searchMerchant:weakSelf.mySearchBar.text];
                }];
    
    [self.tableView reloadData];
     [HYLoadHubView dismiss];

}


#pragma mark -- tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScaleHEIGHT(94);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"BusinesslistCell";
    BusinesslistCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[BusinesslistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    [cell setWithShop:[self.dataArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BusinessListInfo *bInfo = [self.dataArray objectAtIndex:indexPath.row];
    BusinessDetailViewController *tmpCtrl = [[BusinessDetailViewController alloc] init];
    tmpCtrl.businessInfo = bInfo;;
    [self.navigationController pushViewController:tmpCtrl animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
    return YES;
}

// 返回按钮
- (void)backToRootViewController:(id)sender
{

    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)cancalButtonPressed{
    [_mySearchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)dealloc{
    [HYLoadHubView dismiss];
    [_searchMerchantRequest cancel];
    _searchMerchantRequest = nil;
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
