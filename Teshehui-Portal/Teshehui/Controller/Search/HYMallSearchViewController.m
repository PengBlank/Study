//
//  HYMallSearchViewController.m
//  Teshehui
//
//  Created by apple on 15/1/23.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallSearchViewController.h"
#import "HYMallSearchField.h"
#import "HYSearchHotCell.h"
#import "HYClearHistoryCell.h"
#import "HYSearchHistoryStore.h"
#import "HYSearchSuggestRequest.h"
#import "HYSearchSuggestController.h"
#import "HYMallSearchResultController.h"
#import "HYSearchHotKeyRequest.h"
#import "HYBaseLineCell.h"
#import "HYNavigationController.h"
#import "HYKeyboardHandler.h"
#import "HYEarnTicketViewController.h"
#import "HYFlightSearchViewController.h"
#import "HYHotelMainViewController.h"
#import "HYGroupProtocolViewController.h"
#import "HYQRCodeEncoderViewController.h"
#import "HYCIBaseInfoViewController.h"
#import "HYUserInfo.h"
#import "HYAppDelegate.h"
#import "HYGroupProtocolViewController.h"
#import "HYCallTaxiViewController.h"
#import "HYPhoneChargeViewController.h"
#import "HYMallSearchView.h"

@interface HYMallSearchViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
HYSearchSuggestDelegate,
HYKeyboardHandlerDelegate,
HYMallSearchViewDelegate>
@property (weak, nonatomic) IBOutlet HYMallSearchField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *sheng;
//@property (weak, nonatomic) IBOutlet UITableView *suggestTable;

@property (nonatomic, strong) HYSearchSuggestRequest *suggestRequest;

@property (nonatomic, strong) HYSearchSuggestController *suggestController;
@property (nonatomic, strong) HYKeyboardHandler *handler;

@property (nonatomic, strong) HYSearchHotKeyRequest *hotRequest;
@property (nonatomic, strong) NSArray *hotKeys;
@property (nonatomic, strong) NSArray *serviceKeys;
@property (nonatomic, strong) NSArray *historyKeys;


@property (nonatomic, strong) HYMallSearchView *searchView;

@end

@implementation HYMallSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"HYClearHistoryCell" bundle:nil] forCellReuseIdentifier:@"clearHistory"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.suggestController = [[HYSearchSuggestController alloc] initWithNibName:@"HYSearchSuggestController" bundle:nil];
    [self.view addSubview:_suggestController.view];
    _suggestController.delegate = self;
    _suggestController.view.hidden = YES;
    
    self.historyKeys = [[HYSearchHistoryStore sharedStore] getHistoryRecords];
    [self.tableView reloadData];
    
    [self getHotKeys];
    
    self.handler = [[HYKeyboardHandler alloc] initWithDelegate:self
                                                          view:self.view];
    _handler.tapToDismiss = NO;
    
    self.navigationItem.titleView = [self searchView];
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor colorWithWhite:.6 alpha:1] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = searchItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_handler startListen];
    [self.navigationItem.titleView becomeFirstResponder];
    
    
    //[(CQBaseNavViewController *)self.navigationController setEnableSwip:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationItem.titleView resignFirstResponder];
    
    [_handler stopListen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark setter/getter
//- (UIView*)searchView
//{
//    UITextField *search = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame)-80, 30)];
//    search.clearButtonMode = UITextFieldViewModeAlways;
//    search.layer.borderWidth = 0.5;
//    search.layer.borderColor = [UIColor colorWithWhite:.83 alpha:0.6].CGColor;
//    search.layer.cornerRadius = 4.0;
//    search.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
//    UIImage *img = [UIImage imageNamed:@"i_search"];
//    UIImageView *searchv = [[UIImageView alloc] initWithImage:img];
//    searchv.contentMode = UIViewContentModeCenter;
//    searchv.frame = CGRectMake(0, 0, 30, 30);
//    search.leftView = searchv;
//    search.leftViewMode = UITextFieldViewModeAlways;
//    search.delegate = self;
//    search.returnKeyType = UIReturnKeySearch;
//    [search addTarget:self
//               action:@selector(textFieldValueChanged:)
//     forControlEvents:UIControlEventEditingChanged];
//    return search;
//}
- (UIView *)searchView
{
    if (!_searchView)
    {
        _searchView = [[HYMallSearchView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-80, 30)];
        _searchView.search.placeholder = self.searchKeyWord;
        _searchView.delegate = self;
    }
    return _searchView;
}


#pragma mark - privateMethod
- (void)getHotKeys
{
    [HYLoadHubView show];
    self.hotRequest = [[HYSearchHotKeyRequest alloc] init];
    __weak typeof(self) weakSelf = self;
    [_hotRequest sendReuqest:^(HYSearchHotKeyResponse* result, NSError *error)
    {
        [HYLoadHubView dismiss];
        if (result && result.status == 200)
        {
            weakSelf.hotKeys = result.hotKeys;
            weakSelf.serviceKeys = result.serviceKeys;
            [weakSelf.tableView reloadData];
        }
        else
        {
            
        }
    }];
}


- (IBAction)cancelAction:(id)sender
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sectionIdx = section;
    if (!_hotKeys || _hotKeys.count == 0) {
        sectionIdx += 1;
    }
    if (!_serviceKeys || _serviceKeys.count == 0) {
        if (sectionIdx > 0) {
            sectionIdx += 1;
        }
    }
    
    if (sectionIdx == 0 || sectionIdx == 1)
    {
        return 1;
    }
    else
    {
        return _historyKeys.count > 0 ? _historyKeys.count + 2 : 2;
        //return _historyKeys.count + 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 1;    //默认有历史
    if (_hotKeys.count > 0) {
        count += 1;
    }
    if (_serviceKeys.count > 0) {
        count += 1;
    }
    return count;
//    return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sectionIdx = indexPath.section;
    if (!_hotKeys || _hotKeys.count == 0) {
        sectionIdx += 1;
    }
    if (!_serviceKeys || _serviceKeys.count == 0) {
        if (sectionIdx > 0) {
            sectionIdx += 1;
        }
    }
    
    if (sectionIdx == 0)
    {
        static NSString *hot = @"hot";
        HYSearchHotCell *cell = [tableView dequeueReusableCellWithIdentifier:hot];
        if (!cell) {
            cell = [[HYSearchHotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hot];
            cell.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        }
        cell.imageView.image = [UIImage imageNamed:@"icon_search_hot"];
        cell.textLabel.text = @"大家都在搜";
        cell.textLabel.textColor = [UIColor colorWithRed:255/255.0 green:64/255.0 blue:89/255.0 alpha:1];
        cell.hotItems = self.hotKeys;
        //cell.hotItems = @[@"360随身WIFI",@"360随身WIFI",@"360随身WIFI",@"360随身WIFI",@"360随身WIFI",@"360随身WIFI",@"充气娃娃",@"充气娃娃",@"充气娃娃",@"充气娃娃",@"iphone",@"充气娃娃"];
        __weak typeof(self) b_self = self;
        cell.hotCellCallback = ^(HYSearchHotKey *hotKey)
        {
            [b_self didClickSearchKey:hotKey];
        };
        return cell;
    }
    else if (sectionIdx == 1)
    {
        static NSString *hot = @"hot";
        HYSearchHotCell *cell = [tableView dequeueReusableCellWithIdentifier:hot];
        if (!cell) {
            cell = [[HYSearchHotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hot];
            cell.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        }
        cell.imageView.image = [UIImage imageNamed:@"icon_search_service"];
        
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:@"生活服务(1:1送现金券)"];
        [attrText setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0
                                                                                  green:210/255.0
                                                                                   blue:250/255.0
                                                                                  alpha:1]}
                          range:NSMakeRange(0, 4)];
        
        [attrText setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6
                                                                                   alpha:1]}
                          range:NSMakeRange(4, 9)];
        cell.textLabel.attributedText = attrText;

//        cell.textLabel.textColor = [UIColor colorWithRed:0/255.0 green:210/255.0 blue:250/255.0 alpha:1];
//        cell.textLabel.text = @"生活服务(1:1送现金券)";
        
        cell.hotItems = self.serviceKeys;
        //cell.hotItems = @[@"360随身WIFI",@"360随身WIFI",@"360随身WIFI",@"360随身WIFI",@"360随身WIFI",@"360随身WIFI",@"充气娃娃",@"充气娃娃",@"充气娃娃",@"充气娃娃",@"iphone",@"充气娃娃"];
        __weak typeof(self) b_self = self;
        cell.hotCellCallback = ^(HYSearchHotKey *hotKey)
        {
            [b_self didClickHotKey:hotKey];
        };
        return cell;
    }
    else if (sectionIdx == 2)
    {
        if (indexPath.row == 0)
        {
            static NSString *hot = @"hot";
            HYSearchHotCell *cell = [tableView dequeueReusableCellWithIdentifier:hot];
            if (!cell) {
                cell = [[HYSearchHotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hot];
            }
            cell.textLabel.text = @"历史搜索";
            cell.imageView.image = [UIImage imageNamed:@"i_search"];
            return cell;
        }
        else if (indexPath.row == _historyKeys.count + 1)
        {
            HYClearHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"clearHistory"];
            cell.clearBtn.layer.borderColor = [UIColor colorWithWhite:.8 alpha:1].CGColor;
            cell.clearBtn.layer.borderWidth = 1.0;
            cell.clearBtn.layer.cornerRadius = 2.0;
            [cell.clearBtn addTarget:self action:@selector(clearHistoryAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.hasHistory = _historyKeys.count > 0;
            return cell;
        }
        else
        {
            static NSString *history = @"history";
            HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:history];
            if (!cell)
            {
                cell = [[HYBaseLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:history];
                cell.separatorLeftInset = 0;
            }
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
            cell.textLabel.textColor = [UIColor colorWithWhite:.73 alpha:1];
            if (indexPath.row-1 < _historyKeys.count)
            {
                cell.textLabel.text = [_historyKeys objectAtIndex:indexPath.row-1];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            return cell;
        }
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1)
    {
        HYSearchHotCell *cell = (HYSearchHotCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    else
    {
        if (indexPath.row == 0)
        {
            return 40;
        }
        else if (indexPath.row == _historyKeys.count+1)
        {
            return 45;
        }
        return 30;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 2 ? 15: 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 14.5)];
    head.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 14, self.view.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
    [head addSubview:line];
    return head;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger sectionIdx = indexPath.section;
    if (!_hotKeys || _hotKeys.count == 0) {
        sectionIdx += 1;
    }
    if (!_serviceKeys || _serviceKeys.count == 0) {
        if (sectionIdx > 0) {
            sectionIdx += 1;
        }
    }
    if (sectionIdx == 2 && indexPath.row > 0 && indexPath.row < _historyKeys.count+1)
    {
        NSString *historyKey = [_historyKeys objectAtIndex:indexPath.row - 1];
        [self searchWithKey:historyKey];
    }
}

#pragma mark - HYMallSearchViewDelegate
- (void)getSuggestWithString:(NSString *)str
{
    self.suggestRequest = [[HYSearchSuggestRequest alloc] init];
    _suggestRequest.key = str;
    _suggestRequest.businessType = @"01";
    __weak typeof(self) b_self = self;
    [_suggestRequest sendReuqest:^(HYSearchSuggestResponse* result, NSError *error)
     {
         if (result && result.status == 200)
         {
             b_self.suggestController.suggests = result.result;
             b_self.suggestController.view.hidden = NO;
         }
         else
         {
             b_self.suggestController.view.hidden = YES;
         }
     }];
}

- (void)hiddenSuggestController
{
    _suggestController.view.hidden = YES;
}

- (void)searchWithKey:(NSString *)key
{
    [self.searchView.search resignFirstResponder];
    
    HYMallSearchResultController *result = [[HYMallSearchResultController alloc] init];
    result.searchKey = key;
    result.searchKeyWord = _searchKeyWord;
    self.historyKeys = [[HYSearchHistoryStore sharedStore] addSearchRecord:key];
    [self.tableView reloadData];
    [self.navigationController pushViewController:result
                                         animated:YES];
}


#pragma mark - TextField
//- (IBAction)textFieldValueChanged:(UITextField *)field
//{
//    NSString *result = field.text;
//    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if (result.length > 0) {
//        [self getSuggestWithString:result];
//    }
//    else
//    {
//        _suggestController.view.hidden = YES;
//    }
//}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    //[textField resignFirstResponder];
//    NSString *key = textField.text;
//    key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if (key.length > 0)
//    {
//        [self searchWithKey:key];
//    }
//    return YES;
//}

- (void)suggestControllerDidSelectItem:(HYSearchSuggestItem *)item
{
    [self searchWithKey:item.display];
}



- (void)didClickSearchKey:(HYSearchHotKey *)searchKey
{
    [self searchWithKey:searchKey.keyword];
}

- (void)didClickHotKey:(HYSearchHotKey *)hotKey
{
    if (hotKey.businessCode.length > 0)
    {
//        BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
//        if (!isLogin)
//        {
//            HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
//            [appDelegate loadLoginView];
//        }
//        else
//        {}
        
        //clean keyboard
        [self.searchView.search resignFirstResponder];
        
        /// pop to root
        BusinessType type = [self getTypeFromSearchType:hotKey.businessCode];
        switch (type)
        {
            case AirTickets:
            {
                HYFlightSearchViewController *vc = [[HYFlightSearchViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case Hotel:
            {
                HYHotelMainViewController *vc = [[HYHotelMainViewController alloc] init];
                vc.navbarTheme = HYNavigationBarThemeBlue;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case Flower:
            {
                HYGroupProtocolViewController *webBrowser = [[HYGroupProtocolViewController alloc] init];
                webBrowser.type = Flower;
                [self.navigationController pushViewController:webBrowser animated:YES];
            }
                break;
            case QRScanInfo:
            {
                HYQRCodeEncoderViewController *vc = [[HYQRCodeEncoderViewController alloc] init];
                vc.showBottom = YES;
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent
                                                            animated:YES];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case CarInsurance:
            {
                NSString *userid = [HYUserInfo getUserInfo].userId;
                if (userid)
                {
                    HYCIBaseInfoViewController *webBrowser = [[HYCIBaseInfoViewController alloc] init];
                    
                    [self.navigationController pushViewController:webBrowser animated:YES];
                }
                else
                {
                    HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate loadLoginView];
                }
            }
                break;
            case Meituan:
            {
                HYGroupProtocolViewController *webBrowser = [[HYGroupProtocolViewController alloc] init];
                webBrowser.type = Meituan;
                
                [self.navigationController pushViewController:webBrowser animated:YES];
            }
                break;
            case DidiTaxi:
            {
                NSString *userid = [HYUserInfo getUserInfo].userId;
                if (userid)
                {
                    HYCallTaxiViewController *vc = [[HYCallTaxiViewController alloc] initWithNibName:@"HYCallTaxiViewController" bundle:nil];
                    
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate loadLoginView];
                }
                break;
            }
            case MeiWeiQiQi:
            {
                HYGroupProtocolViewController *webBrowser = [[HYGroupProtocolViewController alloc] init];
                webBrowser.type = MeiWeiQiQi;
                [self.navigationController pushViewController:webBrowser animated:YES];
            }
                break;
            case MovieTicket:
            {
                HYGroupProtocolViewController *webBrowser = [[HYGroupProtocolViewController alloc] init];
                webBrowser.type = MovieTicket;
                [self.navigationController pushViewController:webBrowser animated:YES];
                break;
            }
            case PhoneCharge:
            {
                BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
                if (login)
                {
                    HYPhoneChargeViewController *vc = [[HYPhoneChargeViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate loadLoginView];
                }
                break;
            }
            default:
                break;
        }
    }
}

- (BusinessType)getTypeFromSearchType:(NSString *)buisinessType
{
    BusinessType type = 0;
    if ([buisinessType isEqualToString:BusinessType_Flight]) {
        type = AirTickets;
    }
    else if ([buisinessType isEqualToString:BusinessType_Hotel]) {
        type = Hotel;
    }
    else if ([buisinessType isEqualToString:BusinessType_Flower]) {
        type = Flower;
    }
    else if ([buisinessType isEqualToString:BusinessType_DidiTaxi]) {
        type = DidiTaxi;
    }
    else if ([buisinessType isEqualToString:BusinessType_Meituan]) {
        type = Meituan;
    }
    else if ([buisinessType isEqualToString:BusinessType_MeiQiqi]) {
        type = MeiWeiQiQi;
    }
    else if ([buisinessType isEqualToString:BusinessType_Yangguang]) {
        type = CarInsurance;
    }
    else if ([buisinessType isEqualToString:BusinessType_MovieTicket]) {
        type = MovieTicket;
    }
    else if ([buisinessType isEqualToString:BusinessType_PhoneCharge]) {
        type = PhoneCharge;
    }
    return type;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [_searchView.search resignFirstResponder];
}

- (void)clearHistoryAction:(UIButton *)btn
{
    [[HYSearchHistoryStore sharedStore] clearSearchRecords];
    self.historyKeys = [[HYSearchHistoryStore sharedStore] getHistoryRecords];
    [self.tableView reloadData];
}

- (void)searchBtnAction:(UIButton *)btn
{
//    UITextField *textField = (UITextField *)self.navigationItem.titleView;
//    [textField resignFirstResponder];
//    NSString *key = textField.text;
//    key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if (key.length > 0)
//    {
//        [self searchWithKey:key];
//    }
    UITextField *textField = _searchView.search;
    [textField resignFirstResponder];
    NSString *key = textField.text;
    key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (key.length > 0)
    {
        [self searchWithKey:key];
    }
    else
    {
        [self searchWithKey:_searchKeyWord];
    }
}

#pragma mark - keyboard
- (void)keyboardChangeFrame:(CGRect)kFrame
{
   _suggestController.view.frame = CGRectMake(0, CGRectGetMinY(_tableView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(_tableView.frame)-kFrame.size.height);
}
- (void)keyboardHide
{
    _suggestController.view.frame = CGRectMake(0, CGRectGetMinY(_tableView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(_tableView.frame));
}

- (void)willSwipToBack
{
    self.navigationController.navigationBarHidden = NO;
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
