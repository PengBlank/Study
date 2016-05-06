//
//  HYMallBrandViewController.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/21.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallBrandViewController.h"
#import "HYMallBrandView.h"
#import "HYMallBrandCell.h"
#import "HYMallBrandCellHeader.h"
#import "HYMallAllBrandViewController.h"
#import "HYMallProductListTableViewHeaderView.h"
#import "HYMallProductListViewController.h"
#import "HYMallBrandCellBtn.h"
#import "METoast.h"
#import "Masonry.h"

#import "HYMallGetIndexBrandListReq.h"
#import "HYMallGetIndexBrandListResponse.h"

@interface HYMallBrandViewController ()<HYMallBrandCellDelegate>
{
    HYMallGetIndexBrandListReq *_getIndexBrandListReq;
}
@property (copy, nonatomic) NSArray<HYMallBrandModel *> *modelList;
@property (strong, nonatomic) HYMallBrandView *mainView;

@end

@implementation HYMallBrandViewController

-(void)dealloc
{
    [_getIndexBrandListReq cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addAllBrandBtnSubView];
    [self fetchBrandData];
}

-(void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    HYMallBrandView *view = [[HYMallBrandView alloc] initWithFrame:frame];
    self.mainView = view;
    view.userInterfaceDelegate = self;
    self.view = view;
}

#pragma mark private methods
- (void)addAllBrandBtnSubView
{
    WS(weakSelf);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-10);
        make.top.equalTo(weakSelf.view.mas_top).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(40 ,40));
    }];
    [btn setBackgroundImage:[UIImage imageNamed:@"brandAll"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToAllBrandView:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark UI DELEGATE
#pragma button
- (void)goToAllBrandView:(UIButton *)sender
{
    HYMallAllBrandViewController *vc = [[HYMallAllBrandViewController alloc]initWithNibName:NSStringFromClass([HYMallAllBrandViewController class]) bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma HYMallBrandCellDelegate
- (void)checkBrandDetaill:(HYMallBrandSecModel *)brandItem
{
    HYMallProductListViewController *vc = [[HYMallProductListViewController alloc]init];
    
    HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc]init];
    if (brandItem.brandCode.length > 0)
    {
        req.brandIds = @[brandItem.brandCode];
        req.searchType = @"30";
        
        vc.curSearchBrandId = brandItem.brandCode;
    }
    
    vc.getSearchDataReq = req;
    vc.curSearchBrandId = brandItem.brandCode;
    if (brandItem.brandName.length > 0)
    {
        vc.title = brandItem.brandName;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma tableview Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYMallBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYMallBrandCell"
                             forIndexPath:indexPath];
    cell.hiddenLine = YES;
    cell.delegate = self;
    if (indexPath.section < self.modelList.count)
    {
        HYMallBrandModel *model = self.modelList[indexPath.section];
        [cell setModelList:model.brandList];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.modelList.count > 0 ? self.modelList.count : 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section < self.modelList.count)
    {
        CGFloat rowheigh = (ScreenRect.size.width-10*4)/3*3/4+40;
        
        HYMallBrandModel *model = self.modelList[indexPath.section];
        height = (model.brandList.count+2)/3*rowheigh;
    }
    
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36;
}

#pragma tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HYMallBrandCellHeader *header = [HYMallBrandCellHeader instanceView];
    if (self.modelList.count > 0)
    {
        if (section < self.modelList.count)
        {
            HYMallBrandModel *model = self.modelList[section];
            if (model.cateName.length > 0)
            {
               [header setText:model.cateName];
            }
        }
    }
    return header;
}

#pragma cellbtn delegate

#pragma mark DATA CONTROL
- (void)fetchBrandData
{
    if (!_getIndexBrandListReq)
    {
        _getIndexBrandListReq = [[HYMallGetIndexBrandListReq alloc]init];
    }
    [_getIndexBrandListReq cancel];
    
    WS(weakSelf);
    [_getIndexBrandListReq sendReuqest:^(HYMallGetIndexBrandListResponse *result, NSError *error) {
        if (result.dataList.count > 0)
        {
            weakSelf.modelList = result.dataList;
            [weakSelf.mainView reloadTableView];
        }
        else
        {
            [METoast toastWithMessage:result.suggestMsg];
        }
    }];
}

@end
