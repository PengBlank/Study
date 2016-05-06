//
//  HYSelectContactsViewController.m
//  Teshehui
//
//  Created by HYZB on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYSelectContactsViewController.h"
#import "HYAddressBookHelper.h"
#import "HYPerson.h"
#import "HYSelectContactCell.h"
#import "METoast.h"
#import "SearchCoreManager.h"
#import "HYSectionIndexView.h"
#import "HYRedPacketNormalSendViewController.h"
#import "HYRPPersonInsertViewController.h"
#import "HYCheckIsMemberReq.h"

@interface HYSelectContactsViewController ()
{
    HYAddressBookHelper *_abHelper;
    HYSectionIndexView *_indexView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSDictionary *contacts;
@property (nonatomic, copy) NSString *searchContent;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSMutableDictionary *persons;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) HYCheckIsMemberReq *checkRequest;

@end

@implementation HYSelectContactsViewController

- (void)dealloc
{
    [[SearchCoreManager share] Reset];
    [_checkRequest cancel];
}

- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    
    UIColor *bgColor = [UIColor colorWithRed:255.0/255.0
                                       green:253.0/255.0
                                        blue:244.0/255.0
                                       alpha:1.0];
    
    view.backgroundColor = bgColor;
    self.view = view;
    
    rect.origin.y += 44;
    rect.size.height -= 44;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:rect
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    [self.view addSubview:tableview];
    self.tableView = tableview;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择朋友";
    
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [selectBtn setTitle:@"手动输入" forState:UIControlStateNormal];
    [selectBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [selectBtn setTitleColor:[UIColor grayColor]
                    forState:UIControlStateNormal];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [selectBtn addTarget:self
                action:@selector(manualInputAccount:)
      forControlEvents:UIControlEventTouchUpInside];
    
    self.selectBtn = selectBtn;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:selectBtn];
    self.navigationItem.rightBarButtonItem = item;

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 44)];
    searchBar.delegate = self;
    searchBar.keyboardType = UIKeyboardTypeDefault;
    searchBar.autocorrectionType = UITextAutocorrectionTypeDefault;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;   //对文本对象自动大小写
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
    _indexView = [[HYSectionIndexView alloc] initWithDefault];
    
    [self loadAddressbook];
}

- (void)didReceiveMemoryWarning {
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

#pragma mark private methods
- (void)manualInputAccount:(id)sender
{
    HYRPPersonInsertViewController *vc = [[HYRPPersonInsertViewController alloc] initWithNibName:@"HYRPPersonInsertViewController" bundle:nil];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)loadAddressbook
{
    [[SearchCoreManager share] Reset];
    
    if (!_abHelper)
    {
        _abHelper = [[HYAddressBookHelper alloc] init];
    }
    
    NSMutableArray *contacts = [[_abHelper getAllContacts] mutableCopy];
    
    //将联系人按照名字手字母排序分组
    NSMutableArray *muKeys = [[NSMutableArray alloc] init];
    NSMutableDictionary *muDicy = [[NSMutableDictionary alloc] init];
    
    //id 对联系人的id索引表
    NSMutableDictionary *muIdDic = [[NSMutableDictionary alloc] init];
    
    for (HYPerson *person in contacts)
    {
        //加入到搜索列表
        [[SearchCoreManager share] AddContact:[NSNumber numberWithInteger:person.recordId]
                                         name:person.name
                                        phone:[NSArray arrayWithObject:person.mobile]];
        
        if (![muKeys containsObject:person.index])
        {
            NSMutableArray *array = [NSMutableArray arrayWithObject:person];
            [muDicy setObject:array forKey:person.index];
            [muKeys addObject:person.index];
        }
        else
        {
            NSMutableArray *array = [muDicy objectForKey:person.index];
            [array addObject:person];
            [muDicy setObject:array forKey:person.index];
        }
        
        [muIdDic setObject:person
                    forKey:[NSNumber numberWithInteger:person.recordId]];
    }
    
    [muKeys sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *key1 = (NSString *)obj1;
        NSString *key2 = (NSString *)obj2;
        return [key1 compare:key2];
    }];
    
    //＃排最后
    if ([muKeys count] > 0)
    {
        NSString *f = [muKeys objectAtIndex:0];
        if ([f isEqualToString:@"#"])
        {
            [muKeys removeObjectAtIndex:0];
            [muKeys addObject:@"#"];
        }
    }

    self.sectionTitles = [muKeys copy];
    self.contacts = [muDicy copy];
    self.persons = [muIdDic copy];
}

- (void)filterWithSearchString:(NSString *)str
{
    if (str.length > 0)
    {
        self.searchContent = str;
        
        NSMutableArray *personIds = [[NSMutableArray alloc] init];
        NSMutableArray *phoneIds = [[NSMutableArray alloc] init];
        //搜索
        [[SearchCoreManager share] Search:str
                              searchArray:nil
                                nameMatch:personIds
                               phoneMatch:phoneIds];
        
        //取出联系人信息
        NSMutableArray *persons = [[NSMutableArray alloc] init];
        
        //合并搜索结果id
        NSMutableSet *pIdSet = [[NSMutableSet alloc] init];
        if ([personIds count])
        {
            [pIdSet addObjectsFromArray:personIds];
        }
        
        if ([phoneIds count])
        {
            [pIdSet addObjectsFromArray:phoneIds];
        }
        
        for (NSNumber *key in pIdSet)
        {
            HYPerson *person = [self.persons objectForKey:key];
            [persons addObject:person];
        }
        
        self.searchResults = persons;
        [self.tableView reloadData];
        [self.searchDisplayController.searchResultsTableView setContentOffset:CGPointZero];
    }
    else
    {
        self.searchContent = nil;
        self.searchResults = nil;
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark UISearchBarDelegate Delegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    [self filterWithSearchString:searchText];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchContent && [self.searchBar isFirstResponder])
    {
        return 1;
    }
    else
    {
        return [self.sectionTitles count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchContent && [self.searchBar isFirstResponder])
    {
        return [self.searchResults count];
    }
    else
    {
        NSString *key = [self.sectionTitles objectAtIndex:section];
        NSArray *contact = [self.contacts objectForKey:key];
        return [contact count];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.searchContent && [self.searchBar isFirstResponder])
    {
        return nil;
    }
    else
    {
        return self.sectionTitles;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat heigth = 20.0;
    if (self.searchContent && [self.searchBar isFirstResponder])
    {
        heigth = 0.0f;
    }
    
    return heigth;
}

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
    if (self.searchContent && [self.searchBar isFirstResponder])
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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    bgView.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                             green:237.0/255.0
                                              blue:237.0/255.0
                                             alpha:1.0f];
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 60, 20)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = [UIFont systemFontOfSize:15];
    titleLb.textColor = [UIColor colorWithWhite:0.2
                                          alpha:1.0];
    
    if (section < [self.sectionTitles count])
    {
        NSString *title = [self.sectionTitles objectAtIndex:section];
        titleLb.text = title;
    }
    
    [bgView addSubview:titleLb];
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *selectContactsCellId = @"selectContactsCellId";
    HYSelectContactCell *cell = [tableView dequeueReusableCellWithIdentifier:selectContactsCellId];
    if (!cell)
    {
        cell = [[HYSelectContactCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                         reuseIdentifier:selectContactsCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    if (self.searchContent && [self.searchBar isFirstResponder])
    {
        if (indexPath.row < [self.searchResults count])
        {
            HYPerson *person = [self.searchResults objectAtIndex:indexPath.row];
            [cell setPerson:person];
        }
    }
    else
    {
        if (indexPath.section < [self.sectionTitles count])
        {
            NSString *key = [self.sectionTitles objectAtIndex:indexPath.section];
            NSArray *arr = [self.contacts objectForKey:key];
            HYPerson *person = [arr objectAtIndex:indexPath.row];
            [cell setPerson:person];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HYPerson *person = nil;
    if (self.searchContent && [self.searchBar isFirstResponder])
    {
        if (indexPath.row < [self.searchResults count])
        {
            person = [self.searchResults objectAtIndex:indexPath.row];
        }
    }
    else
    {
        if (indexPath.section < [self.sectionTitles count])
        {
            NSString *key = [self.sectionTitles objectAtIndex:indexPath.section];
            NSArray *arr = [self.contacts objectForKey:key];
            person = [arr objectAtIndex:indexPath.row];
        }
    }
    
    self.checkRequest = [[HYCheckIsMemberReq alloc] init];
    _checkRequest.type = @"1";
    _checkRequest.user_name = person.mobile;
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_checkRequest sendReuqest:^(id result, NSError *error)
    {
        [HYLoadHubView dismiss];
        if (error)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            HYRedPacketNormalSendViewController *vc = [[HYRedPacketNormalSendViewController alloc] initWithNibName:@"HYRedPacketNormalSendViewController" bundle:nil];
            vc.mob_phone = person.mobile;
            vc.name = person.name;
            [b_self.navigationController pushViewController:vc
                                                 animated:YES];
        }
    }];
}


@end
