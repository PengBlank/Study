//
//  HYMallAllBrandViewController.m
//  Teshehui
//
//  Created by Kris on 16/3/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
// 1.without database the memory is about 65MB
//

#import "HYMallAllBrandViewController.h"
#import "HYMallProductListViewController.h"
#import "HYMallGetAllBrandListReq.h"
#import "HYMallGetAllBrandListResponse.h"
#import "HYMallAllBrandCell.h"

#import "FMDatabase.h"
#import "HYMallAllBrandModel.h"
#import "METoast.h"

@interface HYMallAllBrandViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
{
    HYMallGetAllBrandListReq *_getAllBrandListReq;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *modelList;
@property (nonatomic, copy) NSOrderedSet *allKeys;
@property (nonatomic, copy) NSArray *allKeysWithRepeat;
@property (nonatomic, copy) NSArray *eachKeyCounts;
@property (nonatomic, copy) NSArray *eachDataForRowBySection;

@end

@implementation HYMallAllBrandViewController

-(void)dealloc
{
    [_getAllBrandListReq cancel];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"全部品牌";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupTableView];
    [self fetchBrandData];
}

#pragma mark private methods
- (void)setupTableView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionIndexColor = [UIColor darkGrayColor];
    [_tableView registerClass:[HYMallAllBrandCell class]
       forCellReuseIdentifier:@"HYMallAllBrandCell"];
}

#pragma mark tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYMallAllBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYMallAllBrandCell"
                                                           forIndexPath:indexPath];
    if (indexPath.section < self.allKeys.count)
    {
        NSArray *dataList = self.eachDataForRowBySection[indexPath.section];
        if (indexPath.row < dataList.count)
        {
            HYMallAllBrandModel *model = dataList[indexPath.row];
            [cell setData:model];
        }
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allKeys.count > 0 ? self.allKeys.count : 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.eachKeyCounts.count == self.allKeys.count) ? [self.eachKeyCounts[section] intValue] : 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *haha = [[UILabel alloc]init];
    NSString *str = nil;
    if (section < self.allKeys.count)
    {
        str = [self.allKeys objectAtIndex:section];
    }
    haha.text = [NSString stringWithFormat:@"    %@",str];
    haha.backgroundColor = [UIColor colorWithWhite:.96 alpha:1.0f];
    return haha;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.allKeys.count)
    {
        NSArray *dataList = self.eachDataForRowBySection[indexPath.section];
        if (indexPath.row < dataList.count)
        {
            HYMallAllBrandModel *model = dataList[indexPath.row];
 
            HYMallProductListViewController *vc = [[HYMallProductListViewController alloc]init];
            
            HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc]init];
            if (model.brandCode.length > 0)
            {
                req.brandIds = @[model.brandCode];
                req.searchType = @"30";
                
                vc.curSearchBrandId = model.brandCode;
            }
 
            vc.getSearchDataReq = req;
            if (model.brandName.length > 0)
            {
                vc.title = model.brandName;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.allKeys array];
}

#pragma mark data control
- (void)fetchBrandData
{
    if (!_getAllBrandListReq)
    {
        _getAllBrandListReq = [[HYMallGetAllBrandListReq alloc]init];
    }
    [_getAllBrandListReq cancel];
    
    WS(weakSelf);
    [_getAllBrandListReq sendReuqest:^(HYMallGetAllBrandListResponse *result, NSError *error) {
        if (result.dataList.count > 0)
        {
            weakSelf.modelList = result.dataList;
            
            [weakSelf calculateTableViewSectionsCountFromDataList:result.dataList];
            [weakSelf calculateRows];
            [weakSelf handleData];
            
            [weakSelf.tableView reloadData];
        }
        else
        {
            [METoast toastWithMessage:@"服务器异常"];
        }
    }];
}

- (NSUInteger)countForKey:(NSString *)key
{
    NSUInteger count = 0;
    if (key.length > 0)
    {
        for (NSString *obj in self.allKeysWithRepeat)
        {
            if ([key isEqualToString:obj])
            {
                ++count;
            }
        }
    }
    return count;
}

- (void)calculateTableViewSectionsCountFromDataList:(NSArray *)dataList
{
    //find all kinds of keys
    NSMutableArray *temp = [NSMutableArray array];
    for (HYMallAllBrandModel *model in dataList)
    {
        if (model.firstChar.length > 0)
        {
            [temp addObject:model.firstChar];
        }
    }
    self.allKeysWithRepeat = temp;
    
    //no repeats
    NSMutableOrderedSet *tempSet = [[NSMutableOrderedSet alloc]initWithArray:temp
                                                                   copyItems:YES];
    self.allKeys = tempSet;
}

- (void)calculateRows
{
    NSUInteger count;
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSString *key in self.allKeys)
    {
        count = [self countForKey:key];
        [array addObject:@(count)];
    }
    
    self.eachKeyCounts = array;
}

- (void)handleData
{
    NSUInteger loc = 0;
    NSMutableArray *temp = [NSMutableArray array];
    
    for (NSNumber *count in self.eachKeyCounts)
    {
        NSUInteger len = [count integerValue];
        NSArray *rowData = [NSArray arrayWithArray:
                            [self.modelList subarrayWithRange:NSMakeRange(loc, len)]];
        loc += len;
        [temp addObject:rowData];
    }
    self.eachDataForRowBySection = temp;
}

@end
