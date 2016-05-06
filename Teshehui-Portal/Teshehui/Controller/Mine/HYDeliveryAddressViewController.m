//
//  HYDeliveryAddress.m
//  Teshehui
//
//  Created by ichina on 14-2-28.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYDeliveryAddressViewController.h"
#import "HYGetAdressListRequest.h"
#import "HYGetAdressListResponse.h"
#import "HYMallOrderAdressListCell.h"
#import "HYAdressTableHeadViewCell.h"
#import "HYLoadHubView.h"
#import "HYAddressEditViewController.h"
#import "HYDelAddressRequest.h"
#import "HYUpdateAddressRequest.h"
#import "HYDelAddressResponse.h"
#import "HYUpdateAdressResponse.h"
#import "HYNavigationController.h"
#import "HYUserInfo.h"
#import "METoast.h"
#import "HYNullView.h"
#import "HYSettingsViewController.h"

@interface HYDeliveryAddressViewController()
<UITableViewDataSource,UITableViewDelegate,
HYMallOrderAddressListCellDelegate>
{
    HYGetAdressListRequest *_getAddressReq;
    HYDelAddressRequest *_delAdressRequest;
    HYUpdateAddressRequest *_updateAddressReq;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *addressList;
@property (nonatomic, strong) HYNullView *nullView;

@property (nonatomic, strong) UIView *noDataShowView;
@property (nonatomic, strong) UILabel *showLab;
@property (nonatomic, strong) UIImageView *showImageView;

@property (nonatomic, assign, getter=isEditing) BOOL editing;

@end

@implementation HYDeliveryAddressViewController

- (void)dealloc
{
    [_updateAddressReq cancel];
    _updateAddressReq = nil;
    
    [_getAddressReq cancel];
    _getAddressReq = nil;
    
    [_delAdressRequest cancel];
    _delAdressRequest = nil;
    
    [HYLoadHubView dismiss];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_addressList removeAllObjects];
    
    [self loadAddressList];
    [_tableView reloadData];
    
//    if ([self.navigationController isKindOfClass:[CQBaseNavViewController class]])
//    {
//        CQBaseNavViewController *nav = (CQBaseNavViewController *)self.navigationController;
//        [nav setEnableSwip:NO];
//    }
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:TFRectMake(0, 0, 30, 30)];
    [right setTitle:@"添加" forState:UIControlStateNormal];
    [right addTarget:self
              action:@selector(addAddress:)
    forControlEvents:UIControlEventTouchDown];
    [right setTitleColor:[UIColor grayColor]
                forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:right];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                           green:237.0f/255.0f
                                            blue:237.0f/255.0f
                                           alpha:1.0];
    self.view = view;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor colorWithRed:0.94 green:0.95 blue:0.96 alpha:1.0];
    tableview.backgroundView = nil;
    tableview.sectionFooterHeight = 0;
    tableview.sectionHeaderHeight = 10;
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    _noDataShowView = [[UIView alloc] initWithFrame:frame];
    _noDataShowView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_noDataShowView];
    
    _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TFScalePoint(110), 100, TFScalePoint(100), TFScalePoint(100))];
    [_noDataShowView addSubview:_showImageView];
    _showImageView.image = [UIImage imageNamed:@"newManageAddressIcon"];
    
    _showLab = [[UILabel alloc] initWithFrame:CGRectMake(TFScalePoint(70), CGRectGetMaxY(_showImageView.frame) + 20, TFScalePoint(180), 40)];
    [_noDataShowView addSubview:_showLab];
    _showLab.numberOfLines = 2;
    _showLab.lineBreakMode = NSLineBreakByCharWrapping;
    _showLab.font = [UIFont systemFontOfSize:15];
    _showLab.textAlignment = NSTextAlignmentCenter;
    _showLab.textColor = [UIColor grayColor];
    _showLab.text = @"您未添加任何常用地址请点击右上角按钮进行添加";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"管理地址";
    self.canDragBack = NO;
    _noDataShowView.hidden = YES;

//    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 1.0)];
//    lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
//                                                                                   topCapHeight:0];
    
    _addressList = [[NSMutableArray alloc]initWithCapacity:0];
    
//    self.canDragBack = NO;
}

#pragma mark setter/getter
- (HYNullView *)nullView
{
    if (!_nullView)
    {
        CGRect frame = self.view.frame;
        frame.origin = CGPointZero;
        
        _nullView = [[HYNullView alloc] initWithFrame:frame];
        _nullView.needTouch = YES;
        [_nullView addTarget:self
                      action:@selector(didClickUpdateEvent:)
            forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nullView];
    }
    
    return _nullView;
}

#pragma mark private methods
//重新加载数据
//在点击nullView的时候调用
- (void)didClickUpdateEvent:(id)sender
{
    [self.nullView setHidden:YES];
    
    [self loadAddressList];
}

- (void)setAddressDefault:(HYAddressInfo *)address
{
    if (address)
    {
        HYAddressInfo *nAddress = [address copy];
        nAddress.isDefault = YES;
        _updateAddressReq = [[HYUpdateAddressRequest alloc] init];
        _updateAddressReq.addressInfo = nAddress;
        
        [HYLoadHubView show];
        
        __weak typeof(self) b_self = self;
        
        [_updateAddressReq sendReuqest:^(id result, NSError *error)
        {
            [HYLoadHubView dismiss];
            
            if (result && [result isKindOfClass:[HYUpdateAdressResponse class]])
            {
                [b_self updateAddressDefault:address];
            }
        }];
    }
}

- (void)updateAddressDefault:(HYAddressInfo *)addr
{
    for (HYAddressInfo *address in self.addressList)
    {
        address.isDefault = NO;
    }
    
    //更换位置
    [self.addressList removeObject:addr];
    [self.addressList insertObject:addr
                           atIndex:0];
    addr.isDefault = YES;
    [self.tableView reloadData];
}

- (void)addAddress:(UIButton *)sender
{
    HYAddressEditViewController* setVC = [[HYAddressEditViewController alloc]init];
    setVC.navbarTheme = self.navbarTheme;
    setVC.type = HYAddressManageAdd;
    [self.navigationController pushViewController:setVC animated:YES];
}

-(void)loadAddressList
{
    if (!_getAddressReq)
    {
        _getAddressReq = [[HYGetAdressListRequest alloc] init];
    }
    
    HYUserInfo *user = [HYUserInfo getUserInfo];
    _getAddressReq.userId = user.userId;
    
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_getAddressReq sendReuqest:^(id result, NSError *error) {
        
      //  [HYLoadHubView dismiss];
        
        NSArray *addressList = nil;
        if (!error && [result isKindOfClass:[HYGetAdressListResponse class]])
        {
            HYGetAdressListResponse *response = (HYGetAdressListResponse *)result;
            addressList = response.addressList;
        }
        
        [b_self updateViewWithData:addressList
                             error:error];
    }];
}

- (void)updateViewWithData:(NSArray *)array error:(NSError *)error
{
    [HYLoadHubView dismiss];
    

    if ([array count])
    {
        [self.tableView setHidden:NO];
        [_nullView setHidden:YES];
        
        self.addressList = [NSMutableArray arrayWithArray:array];
        _noDataShowView.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }
    else if ([self.addressList count] <= 0)
    {
        _noDataShowView.hidden = NO;
        self.tableView.hidden = YES;
        
        if ([error.domain isEqualToString:@"网络请求出现异常"])
        {
            _noDataShowView.hidden = NO;
            _showLab.text = @"由于网络原因加载失败";
        }
        else
        {
           
           // [self.nullView setNeedTouch:NO];
            NSString *str = error.domain;
            if ([str length] <= 0)
            {
                str = @"您未添加任何常用地址请点击右上角按钮进行添加";
            }
            _showLab.text = str;
        }
        
//        [self.tableView setHidden:YES];
//        [self.nullView setHidden:NO];
//        
//        if ([error.domain isEqualToString:@"网络请求出现异常"])
//        {
//            [self.nullView setNeedTouch:YES];
//            self.nullView.descInfo = @"由于网络原因加载失败，请点击重新加载";
//        }
//        else
//        {
//            
//            [self.nullView setNeedTouch:NO];
//            NSString *str = error.domain;
//            if ([str length] <= 0)
//            {
//                str = @"您还没有添加常用收货地址哦，现在就去添加吧～";
//            }
//            self.nullView.descInfo = str;
//        }
    }
    else
    {
        if (error.domain)
        {
            [METoast toastWithMessage:error.domain];
        }
    }
}

-(void)deleteAddress:(HYAddressInfo *)info
{
    if (!_delAdressRequest)
    {
        _delAdressRequest = [[HYDelAddressRequest alloc] init];
    }
    
    _delAdressRequest.user_id = [HYUserInfo getUserInfo].userId;
    _delAdressRequest.addr_id = info.addr_id;
    
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_delAdressRequest sendReuqest:^(id result, NSError *error) {
        [HYLoadHubView dismiss];
        if (result && [result isKindOfClass:[HYDelAddressResponse class]])
        {
            HYDelAddressResponse *response = (HYDelAddressResponse *)result;
            if (response.status == 200)
            {
                [b_self loadAddressList];
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:error.domain
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
            }
        }
    }];
}

#pragma mark Tableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _addressList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYMallOrderAdressListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HYMallOrderAdressListCell"];
    if (!cell)
    {
        cell = [[HYMallOrderAdressListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HYMallOrderAdressListCell"];
    }
    
    cell.delegate = self;
    HYAddressInfo* info = [_addressList objectAtIndex:indexPath.section];
    
    if (_type == 1)
    {
        cell.editIcon.hidden = NO;
        
        if (info.isDefault)
        {
            [cell.editIcon setBackgroundImage:[UIImage imageNamed:@"icon_white_edit_address"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.editIcon setBackgroundImage:[UIImage imageNamed:@"icon_black_edit_address"] forState:UIControlStateNormal];
        }
    }

    [cell setAddressInfo:info];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TFScalePoint(80.0);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow -1){
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
//    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9,self.view.frame.size.width, 1.0)];
//    lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
//                                                                                   topCapHeight:0];
//    [head addSubview:lineView];
//    return head;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.editRow = indexPath.section;
//    [self.tableView setEditing:YES animated:YES];
//    return ;
    
    if (self.type == 2) {
        
        HYAddressEditViewController* setVC = [[HYAddressEditViewController alloc]init];
        setVC.navbarTheme = self.navbarTheme;
        setVC.type = HYAddressManageEdit;
        HYMallOrderAdressListCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        setVC.addressInfo = [cell.addressInfo copy];
        [self.navigationController pushViewController:setVC animated:YES];
    } else {
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (indexPath.section < [_addressList count] &&
            [self.delegate respondsToSelector:@selector(getAdress:)])
        {
            HYAddressInfo* info = [_addressList objectAtIndex:indexPath.section];
            [self.delegate getAdress:info];
            [self.navigationController popViewControllerAnimated:YES];
        }
//        if (indexPath.section < [_addressList count] &&
//            [self.delegate respondsToSelector:@sebbbblector(getAdress:)])
//        {
//            HYAddressInfo* info = [_addressList objectAtIndex:indexPath.section];
//            [self.delegate getAdress:info];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEditing)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == self.editRow) {
//        return UITableViewCellEditingStyleDelete;
//    }
//    return UITableViewCellEditingStyleNone;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
        
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            if (self.type == 2)
            {
                HYMallOrderAdressListCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                HYAddressInfo *info = cell.addressInfo;
                if (info)
                {
                    if (!info.isDefault)
                    {
                        [self deleteAddress:info];
                    }
                    else
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:@"默认地址不能删除，请先修改为非默认地址"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                }
            }
            else
            {
                HYAddressEditViewController* setVC = [[HYAddressEditViewController alloc]init];
                setVC.navbarTheme = self.navbarTheme;
                setVC.type = HYAddressManageEdit;
                HYMallOrderAdressListCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                setVC.addressInfo = [cell.addressInfo copy];
                [self.navigationController pushViewController:setVC animated:YES];
            }
            
        }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 2)
    {
        return @"删除";
    }
    else
    {
        return @"编辑";
    }
}

#pragma mark HYMallOrderAddressListCellDelegate
- (void)editBtnAction:(HYMallOrderAdressListCell *)cell
{
    HYAddressEditViewController* setVC = [[HYAddressEditViewController alloc]init];
    setVC.navbarTheme = self.navbarTheme;
    setVC.type = HYAddressManageEdit;
    setVC.addressInfo = [cell.addressInfo copy];
    [self.navigationController pushViewController:setVC animated:YES];
}

- (void)editIconAction:(HYMallOrderAdressListCell *)cell
{
    HYAddressEditViewController* setVC = [[HYAddressEditViewController alloc]init];
    setVC.navbarTheme = self.navbarTheme;
    setVC.type = HYAddressManageEdit;
    setVC.addressInfo = [cell.addressInfo copy];
    [self.navigationController pushViewController:setVC animated:YES];
//    if (cell.contentView.frame.origin.x == 0)
//    {
//        cell.contentView.frame = CGRectMake(-TFScalePoint(55), 0, cell.frame.size.width, cell.frame.size.height);
//        cell.editbtn.hidden = NO;
//        self.editing = YES;
//    }
//    else
//    {
//        cell.contentView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
//        cell.editbtn.hidden = YES;
//        self.editing = NO;
//    }
}
//-(void)addressCellDidClickDelete:(HYMallOrderAdressListCell *)cell
//{
//    HYAddressInfo *info = cell.addressInfo;
//    if (info)
//    {
//        if (!info.isDefault)
//        {
//            [self deleteAddress:info];
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"默认地址不能删除，请先修改为非默认地址"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
//        }
//    }
//}

//- (void)addressCellDidClickEdit:(HYMallOrderAdressListCell *)cell
//{
//    HYAddressEditViewController* setVC = [[HYAddressEditViewController alloc]init];
//    setVC.navbarTheme = self.navbarTheme;
//    setVC.type = HYAddressManageEdit;
//    setVC.addressInfo = [cell.addressInfo copy];
//    [self.navigationController pushViewController:setVC animated:YES];
//}

- (void)addressCellDidClickDefaultBtn:(HYMallOrderAdressListCell *)cell
{
    if (!cell.addressInfo.isDefault)
    {
        //更新
        [self setAddressDefault:cell.addressInfo];
        
//        [[self tableView] reloadData];
    }
}

@end
