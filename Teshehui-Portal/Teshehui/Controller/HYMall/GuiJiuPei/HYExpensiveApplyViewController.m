//
//  HYExpensiveApplyViewController.m
//  Teshehui
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYExpensiveApplyViewController.h"
#import "HYExpensiveTextCell.h"
#import "HYExpensivePhotoCell.h"
#import "HYExpensiveLinkCell.h"
#import "HYExpensiveAddRequest.h"
#import "HYUserInfo.h"
#import "HYExpensiveResultView.h"
#import "HYMallOrderListViewController.h"
#import "HYMallOrderDetailViewController.h"
#import "HYGuijiupeiProductUrlView.h"

@interface HYExpensiveApplyViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate,
HYExpensiveTextCellDelegate,
HYExpensivePhotoCellDelegate,
HYExpensiveLinkCellDelegate
>
@property (nonatomic, strong) UITableView *tableView;

//datas
@property (nonatomic, strong) NSString *expensiveDesc;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSString *expensiveLink;

//internet request
@property (nonatomic, strong) HYExpensiveAddRequest *addRequest;

@end

@implementation HYExpensiveApplyViewController

- (void)dealloc
{
    [_addRequest cancel];
    _addRequest = nil;
}

//手动初始化界面
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
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    [self.view addSubview:tableview];
    self.tableView = tableview;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"申请贵就赔";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HYExpensiveTextCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYExpensivePhotoCell" bundle:nil] forCellReuseIdentifier:@"photoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYExpensiveLinkCell" bundle:nil] forCellReuseIdentifier:@"linkCell"];
//    [self addPrompt];
    [self addBarButton];
}

- (void)addBarButton
{
    UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 44)];
    [commitBtn setTitleColor:self.navBarTitleColor forState:UIControlStateNormal];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [commitBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:commitBtn];
    self.navigationItem.rightBarButtonItem = item;
}

//- (void)addPrompt
//{
//    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//    footer.backgroundColor = [UIColor clearColor];
//    UILabel *prompt = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 280, 40)];
//    prompt.backgroundColor = [UIColor clearColor];
//    prompt.font = [UIFont systemFontOfSize:12.0];
//    prompt.textColor = [UIColor colorWithWhite:.63 alpha:1];
//    prompt.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    prompt.text = @"温馨提示：上传之前请确认该商品来自天猫或京东相同品牌的旗舰店！";
//    prompt.numberOfLines = 0;
//    [prompt sizeToFit];
//    [footer addSubview:prompt];
//    self.tableView.tableFooterView = footer;
//}

#pragma mark - request
- (void)commitAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self addExpensiveApply];
}

- (void)addExpensiveApply
{
    
    if (_addRequest) {
        [_addRequest cancel];
    }
    
    NSString *err = nil;
    if ([self.expensiveDesc length] <= 0)
    {
        err = @"请输入描述";
    }
    else if (self.photos.count == 0)
    {
        err = @"请选择图片";
    }
    else if (!self.expensiveLink || self.expensiveLink.length == 0)
    {
        err = @"请输入商品链接";
    }
    if (err)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:err delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.addRequest = [[HYExpensiveAddRequest alloc] init];
    
    _addRequest.productSkuCode = self.productSKUCode;
    _addRequest.productCode = self.productCode;
    _addRequest.orderCode = self.orderCode;
    _addRequest.desc = self.expensiveDesc;
    _addRequest.compare_url = self.expensiveLink;
    _addRequest.imgs = self.photos;
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_addRequest sendReuqest:^(HYExpensiveAddResponse* result, NSError *error)
    {
        [HYLoadHubView dismiss];
        [b_self updateWithResponse:result error:error];
        
    }];
}

- (void)updateWithResponse:(HYExpensiveAddResponse*)result error:(NSError *)error
{
    if (result && [result isKindOfClass:[HYExpensiveAddResponse class]])
    {
        if (result.status == 200)
        {
            HYExpensiveResultView *result = [HYExpensiveResultView instance];
            result.success = YES;
            __weak typeof(self) b_self = self;
            [result showWithDuration:2.0f completionHanlder:^{
                UIViewController *orderlist = nil;
                for (UIViewController *vc in b_self.navigationController.viewControllers)
                {
                    if ([vc isKindOfClass:[HYMallOrderDetailViewController class]])
                    {
                        orderlist = vc;
                        break;
                    }
                }
                if (orderlist)
                {
                    [b_self.navigationController popToViewController:orderlist animated:YES];
                }
            }];
            }
        else
        {
            HYExpensiveResultView *result = [HYExpensiveResultView instance];
            result.success = NO;
            [result show];
        }
    }
}

- (void)backToRootViewController:(id)sender
{
    UIViewController *orderDetailVC = nil;
    for (UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[HYMallOrderDetailViewController class]])
        {
            orderDetailVC = vc;
            break;
        }
    }
    if (orderDetailVC)
    {
        [self.navigationController popToViewController:orderDetailVC
                                              animated:YES];
    }
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        HYExpensiveTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
        textCell.delegate = self;
        return textCell;
    }
    else if (indexPath.section == 1)
    {
        HYExpensivePhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"photoCell"];
        photoCell.delegate = self;
        photoCell.photos = self.photos;
        photoCell.enable = YES;
        return photoCell;
    }
    else if (indexPath.section == 2)
    {
        HYExpensiveLinkCell *linkCell = [tableView dequeueReusableCellWithIdentifier:@"linkCell"];
        linkCell.delegate = self;
        return linkCell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 0 : 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120;
    }
    else if (indexPath.section == 1)
    {
        return 140;
    }
    else if (indexPath.section == 2)
    {
        return 250;
    }
    return 0;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.view endEditing:YES];
}

#pragma mark - cell delegate
- (void)expensiveTextCellDidGetText:(NSString *)string
{
    self.expensiveDesc = string;
    [self.tableView reloadData];
}

- (void)expensiveLinkCellDidBeginEditing
{
    [self.tableView setContentOffset:CGPointMake(0, 250) animated:YES];
}

- (void)expensiveLinkCellDidEndEditing:(NSString *)string
{
    self.expensiveLink = string;
}

//- (void)expensiveLinkCellDidClickQustionButton
//{
//    HYGuijiupeiProductUrlView *alert = [[HYGuijiupeiProductUrlView alloc]initMyNib];
//    
//    [self.view addSubview:alert];
////    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您可通过以下两种方式填写商品链接：\
////    1、天猫APP：找到该商品详情页右上角\"----\"，打开并点击“复制”或者“复制链接”，然后直接在本页面输入框中粘贴该链接即可。\n\
////2、京东APP：找到该商品详情页右上角\"----\"，打开并点击”分享”，选择“微信好友”或者“QQ好友”，发送并在QQ聊天记录中打开链接，打开后点击右上角分享，点击”复制链接“，然后再粘贴到本页面输入框即可。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
////    [alert show];
//}

#pragma mark - photo
- (void)photoCellDidClickAddPhoto:(UITableViewCell *)cell
{
    [self.view endEditing:YES];
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:@"拍照"
                                               otherButtonTitles:@"相册", nil];
    [action showInView:self.view];
}

- (void)photoCell:(UITableViewCell *)cell didClickDeletePhotoWithIndex:(NSInteger)idx
{
    if (idx < _photos.count)
    {
        [_photos removeObjectAtIndex:idx];
        [self.tableView reloadData];
    }
}

//从界面，从上往下看，依次为0,1,2
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 2)
    {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if (buttonIndex == 0) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        [self presentViewController:pickerImage animated:YES completion:nil];
    }
    else
    {
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (image)
    {
        [self.photos addObject:image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)photos
{
    if (!_photos)
    {
        _photos = [NSMutableArray array];
    }
    return _photos;
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
