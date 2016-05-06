//
//  HYMyDesireDetailViewController.m
//  Teshehui
//
//  Created by Kris on 15/11/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentApiInterface.h>

#import "HYMyDesireDetailViewController.h"
#import "HYMyDesireDetailHeaderView.h"
#import "HYUserInfo.h"
#import "HYMyDesireDeleteRequest.h"
#import "HYLoadHubView.h"
#import "HYMyDesireDetailRequest.h"
#import "HYMyDesireDetailResponse.h"
#import "HYMyDesireDetailModel.h"
#import "HYMyDesireDetailFooterView.h"
#import "HYProductDetailViewController.h"
/// 环信
#import "HYChatManager.h"

@interface HYMyDesireDetailViewController ()<HYMyDesireDetailFooterViewDelegate,UIActionSheetDelegate>
{
    HYMyDesireDeleteRequest *_desireDeleteReq;
    HYMyDesireDetailRequest *_desireDetailReq;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYMyDesireDetailModel *desireDetail;
@property (nonatomic, strong) NSString *deleteReturnMessage;

@end

@implementation HYMyDesireDetailViewController

- (void)dealloc
{
    [_desireDeleteReq cancel];
    _desireDeleteReq = nil;
    
    [_desireDetailReq cancel];
    _desireDetailReq = nil;
    
    [HYLoadHubView dismiss];
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                           green:237.0/255.0
                                            blue:237.0/255.0
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    frame.size.height -= 50;
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
//    tableview.delegate = self;
//    tableview.dataSource = self;
//    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    HYMyDesireDetailHeaderView *header = [[HYMyDesireDetailHeaderView alloc] initMyNib];
    tableview.tableHeaderView = header;
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    HYMyDesireDetailFooterView *footerV = [[NSBundle mainBundle] loadNibNamed:@"HYMyDesireDetailFooterView" owner:nil options:nil][0];
    footerV.delegate = self;
    tableview.tableFooterView = footerV;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"帮我买";
    
    [self createDeleteDesireBtn];
    [self createServicePhoneView];
    [self getDesireDetailInfo];
}

#pragma mark - HYMyDesireDetailFooterViewDelegate
- (void)goToGoodsDetailView:(NSString *)productCode
{
    HYProductDetailViewController *productDetailV = [[HYProductDetailViewController alloc] init];
    productDetailV.goodsId = productCode;
    [self.navigationController pushViewController:productDetailV
                                         animated:YES];
}

#pragma mark - 客服栏
- (void)createServicePhoneView
{
    UIView *servicePhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), [UIScreen mainScreen].bounds.size.width, 50)];
    [self.view addSubview:servicePhoneView];

    UIButton *servicePhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    servicePhoneBtn.backgroundColor = [UIColor whiteColor];
    servicePhoneBtn.frame = CGRectMake(TFScalePoint(10), 5, TFScalePoint(145), 40);

    [servicePhoneBtn setImage:[UIImage imageNamed:@"customer_call"]
                 forState:UIControlStateNormal];
    [servicePhoneBtn setTitle:@"客服电话" forState:UIControlStateNormal];
    
    servicePhoneBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [servicePhoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [servicePhoneBtn addTarget:self
                        action:@selector(goToTelPhone)
              forControlEvents:UIControlEventTouchUpInside];
    [servicePhoneBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 60)];
    [servicePhoneView addSubview:servicePhoneBtn];
    
    UIButton *serviceQQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    serviceQQBtn.backgroundColor = [UIColor whiteColor];
    serviceQQBtn.frame = CGRectMake(CGRectGetMaxX(servicePhoneBtn.frame) + TFScalePoint(10), 5, TFScalePoint(145), 40);
    [serviceQQBtn setTitle:@"小秘书"
                  forState:UIControlStateNormal];
    [serviceQQBtn setImage:[UIImage imageNamed:@"customer_online"]
                  forState:UIControlStateNormal];
    serviceQQBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [serviceQQBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 60)];
    [serviceQQBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [serviceQQBtn addTarget:self
                     action:@selector(chatWithCustomer)
           forControlEvents:UIControlEventTouchUpInside];
    [servicePhoneView addSubview:serviceQQBtn];
}

- (void)goToTelPhone
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"特奢汇客服竭诚为您服务"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"拨打电话400-806-6528"
                                  otherButtonTitles:nil];
    
    [actionSheet showInView:self.view];
    
}

- (void)chatWithCustomer
{
    //检查登录
    [[HYChatManager sharedManager] chatLogin];
    
    // 对象
    /// 对象
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    
    [muDic setObject:@"order"
              forKey:@"type"];
    [muDic setObject:self.desireDetail.wishTitle
              forKey:@"title"];
    [muDic setObject:self.desireDetail.wishContent
              forKey:@"desc"];
    
    if ([self.desireDetail.wishPicList count])
    {
        [muDic setObject:self.desireDetail.wishPicList[0]
                  forKey:@"img_url"];
    }
    
    ChatViewController *vc = [[ChatViewController alloc] initWithChatter:kCustomerHXId
                                                                    type:eAfterSaleType];
    vc.commodityInfo = [muDic copy];
    
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        NSString *phone = [NSString stringWithFormat:@"telprompt://4008066528"];
        NSURL *url = [NSURL URLWithString:phone];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - 删除愿望按钮
- (void)createDeleteDesireBtn
{
    UIButton *deleteDesireBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteDesireBtn setTitleColor:[UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1.0] forState:UIControlStateNormal];
    deleteDesireBtn.frame = CGRectMake(0, 0, 60, 20);
    [deleteDesireBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteDesireBtn addTarget:self action:@selector(deleteDesire:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteDesireItem = [[UIBarButtonItem alloc] initWithCustomView:deleteDesireBtn];
    self.navigationItem.rightBarButtonItem = deleteDesireItem;
}

- (void)deleteDesire:(UIButton *)btn
{
    
    UIAlertView *deleterAlert = [[UIAlertView alloc] initWithTitle:nil message:@"是否删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定", nil];
    [deleterAlert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        
    } else {
        
        if (!_desireDeleteReq) {
            _desireDeleteReq = [[HYMyDesireDeleteRequest alloc] init];
        }
        
        _desireDeleteReq.delete_id = self.desireId;
        _desireDeleteReq.userId = [HYUserInfo getUserInfo].userId;
        
        [HYLoadHubView show];
        __weak typeof(self) weakSelf = self;
        [_desireDeleteReq sendReuqest:^(id result, NSError *error) {
            
            [HYLoadHubView dismiss];
            CQBaseResponse *response = (CQBaseResponse *)result;
            weakSelf.deleteReturnMessage = response.jsonDic[@"message"];
            
            if ([weakSelf.deleteReturnMessage isEqualToString:@"Success!"])
            {
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                
                UIAlertView *deleterAlert = [[UIAlertView alloc] initWithTitle:nil message:@"删除失败" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [deleterAlert show];
            }
        }];
    }
}

#pragma mark - getDesireDetailInfo
- (void)getDesireDetailInfo
{
    
    if (!_desireDetailReq) {
        _desireDetailReq = [[HYMyDesireDetailRequest alloc] init];
    }
    
    NSString *userId = [HYUserInfo getUserInfo].userId;
    if (userId) {
        _desireDetailReq.userId = userId;
    }
    _desireDetailReq.desire_id = self.desireId;
    [HYLoadHubView show];
    
    __weak typeof(self) weakSelf = self;
    [_desireDetailReq sendReuqest:^(id result, NSError *error) {
        
        HYMyDesireDetailResponse *response = (HYMyDesireDetailResponse *)result;
        weakSelf.desireDetail = response.data;
        
        // 头部视图信息
        HYMyDesireDetailHeaderView *header = (HYMyDesireDetailHeaderView *)weakSelf.tableView.tableHeaderView;
        HYMyDesireDetailModel *model = response.data;
        
        CGFloat wishContentWidth = [UIScreen mainScreen].bounds.size.width - 20;
        CGFloat wishContentHeight = [model.wishContent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(wishContentWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
        
        // 无图片高度
        if (!model.wishPicList.count) {
            
            header.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, wishContentHeight + 156);
            weakSelf.tableView.tableHeaderView = header;
        } else { // 有图片高度
            
            header.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, wishContentHeight + 166 + TFScalePoint(100));
            weakSelf.tableView.tableHeaderView = header;
        }
        [header setHeaderViewWithModel:model];
        
        // 尾部视图信息
        HYMyDesireDetailFooterView *footerV = (HYMyDesireDetailFooterView *)weakSelf.tableView.tableFooterView;
        
        // 测试数据
//         model.replyContent = @"东西无法找到";
//        [model.wishDetailPOList addObject:@{@"productCode":@"22343"}];
        
        CGFloat replyContentWidth = [UIScreen mainScreen].bounds.size.width - 20;
        CGFloat replyContentHeight = [model.replyContent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(replyContentWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height + 20;
        
        if (model.wishDetailPOList.count) {
            
            NSInteger colNumber = model.wishDetailPOList.count > 3 ? 3 : model.wishDetailPOList.count;
            // 行数
            NSUInteger rows = (model.wishDetailPOList.count + colNumber - 1) / colNumber;
            CGFloat height = replyContentHeight + 10 + rows * 80 + rows * 10;
            CGFloat footerViewHeight = 115 + height;
            
            footerV.hidden = NO;
            footerV.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, footerViewHeight);
            weakSelf.tableView.tableFooterView = footerV;
        } else if (model.replyContent) {
            
            footerV.replyContentLab.frame = CGRectMake(10, 95, 300, replyContentHeight);
            footerV.hidden = NO;
            footerV.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 115+replyContentHeight);
            weakSelf.tableView.tableFooterView = footerV;
        } else {
            
            footerV.hidden = YES;
            weakSelf.tableView.tableFooterView = footerV;
        }
        [footerV setFooterViewWithModel:model];
        [HYLoadHubView dismiss];
    }];
}

@end
