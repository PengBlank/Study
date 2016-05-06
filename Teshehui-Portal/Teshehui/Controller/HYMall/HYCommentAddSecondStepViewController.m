//
//  HYCommentAddSecondStepViewController.m
//  Teshehui
//
//  Created by HYZB on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYCommentAddSecondStepViewController.h"
#import "HYMallGetEvidencePictureCell.h"
#import "HYCommentAddSecondStepHeaderView.h"
#import "HYCommentAddSecondStepHeaderSecondView.h"
#import "GWPhotoBrowserViewController.h"
#import "HYCommentAddSecondStepFooterView.h"
#import "HYMallGoodsCommentRequest.h"
#import "HYLoadHubView.h"
#import "HYGetGoodsCommentReq.h"
#import "HYLoadHubView.h"
#import "HYGetCommentResponse.h"
#import "HYCommentAddSecondStepResponse.h"
#import "HYMallOrderDetailViewController.h"
#import "HYExpensiveResultView.h"
#import <objc/runtime.h>
#import "HYAnalyticsManager.h"

@interface HYCommentAddSecondStepViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
HYMallGetEvidencePictureCellDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
HYAfterSaleDeletePhotoDelegate,
HYCommitDelegate,
CommentAddSecondStepHeaderViewDelegate,
UIActionSheetDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *picData;
@property (nonatomic, strong) NSMutableArray *picOriginalData;
@property (nonatomic, strong) HYMallGoodsCommentRequest *commentReq;
@property (nonatomic, strong) HYGetGoodsCommentReq *getCommentReq;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, strong) NSMutableArray *dataList;


// 接收从评论中发布的图片
@property (nonatomic, strong) NSArray *imageList;

@end

@implementation HYCommentAddSecondStepViewController

static void *HYCommentAddSecondStepActionSheetKey = "HYCommentAddSecondStepActionSheetKey";

- (void)dealloc
{
    [_commentReq cancel];
    _commentReq = nil;
    
    [_getCommentReq cancel];
    _getCommentReq = nil;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageNo = 1;
    _pageSize = 20;

    [self setTitleWithEvaluable:_infoModel.isEvaluable];
    
    
    _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitBtn.enabled = NO;
    [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_commitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _commitBtn.userInteractionEnabled = NO;
    [_commitBtn addTarget:self action:@selector(commitComment) forControlEvents:UIControlEventTouchDown];
    
    _commitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _commitBtn.frame = CGRectMake(0, 0, 40, 20);
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:_commitBtn];
    
    self.navigationItem.rightBarButtonItem = right;
    
    _tableView = [[UITableView alloc]initWithFrame:
                  CGRectMake(0, 0, ScreenRect.size.width, ScreenRect.size.height-64)
                                             style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[HYMallGetEvidencePictureCell class] forCellReuseIdentifier:@"MallGetEvidencePicture"];
    
    [self creatHeaderViewAndFooterView];
}


#pragma mark - getCommentData
- (void)getCommentData
{
    if (!_getCommentReq)
    {
        _getCommentReq = [[HYGetGoodsCommentReq alloc]init];
    }
    [_getCommentReq cancel];
    
    _getCommentReq.pageNo = [NSString stringWithFormat:@"%ld",_pageNo];
    _getCommentReq.pageSize = [NSString stringWithFormat:@"%ld",_pageSize];
    _getCommentReq.orderCode = _infoModel.orderCode;
    _getCommentReq.productSkuCode = _infoModel.productSKUCode;
    
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_getCommentReq sendReuqest:^(HYGetCommentResponse *result, NSError *error) {
        [HYLoadHubView dismiss];
        
        b_self.dataList = [result.dataList mutableCopy];
        
        if (b_self.dataList.count > 0) {
            
            HYCommentAddSecondStepHeaderSecondView *seconderView = (HYCommentAddSecondStepHeaderSecondView *)_tableView.tableHeaderView;
            HYGetCommentModel *model = nil;
            
            //取出当前商品的评论
            for (HYGetCommentModel *obj in result.dataList)
            {
                if ([obj.productCode isEqualToString:b_self.infoModel.productCode])
                {
                    model = obj;
                    break;
                }
            }
            
            if (model)
            {
                seconderView.commentLabel.text = model.commentMessage;
                
                [seconderView setDescstarLight:[model.productScore integerValue] andSeviceStarLight:[model.serviceScore integerValue] andSpeedStarLight:[model.deliveryScore integerValue]];
                // 接收图片地址
                b_self.imageList = model.imageList;
                
                // 设置评论内容Label高度
//                CGFloat width = [[UIScreen mainScreen] bounds].size.width-40;
//                //使用到字体大小（此处使用的字体要和UILabel所使用的字体是一致）
//                NSDictionary *dic = @{NSFontAttributeName:seconderView.commentLabel};
//                //textSize为最后字符串内容占用的区域大小
//                CGSize textSize = [model.commentMessage boundingRectWithSize:CGSizeMake(width, 3000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
//                CGFloat height = textSize.height;
//                seconderView.commentLabelWidthConstraint.constant = height;
//                [seconderView layoutIfNeeded];
                
                // 调整头部视图高度
               // [seconderView setNeedsLayout];
                [seconderView layoutIfNeeded];
                CGRect frame = seconderView.frame;
                frame.size.height = CGRectGetMaxY(seconderView.commentLabel.frame) + 15;
                seconderView.frame = frame;
                b_self.tableView.tableHeaderView = seconderView;
                
                b_self.commentId = model.commentId;
                
                [b_self.tableView reloadData];
            }
        }
        
    }];
}


#pragma mark - -----根据状态选择发表评价或追加评价的头部视图及尾部视图----
- (void)creatHeaderViewAndFooterView
{
    if (!self.isReply)
    {
        HYCommentAddSecondStepHeaderView *headerView = [[HYCommentAddSecondStepHeaderView alloc] initMyNib];
        headerView.delegate = self;
        _tableView.tableHeaderView = headerView;
        _tableView.sectionHeaderHeight = 15;
        
        HYCommentAddSecondStepFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:@"HYCommentAddSecondStepFooterView" owner:nil options:nil][0];
        _tableView.tableFooterView = footerView;
    }
    else
    {
        [self getCommentData];
        HYCommentAddSecondStepHeaderSecondView *seconderHeaderView = [[NSBundle mainBundle] loadNibNamed:@"HYCommentAddSecondStepHeaderSecondView" owner:nil options:nil][0];
        seconderHeaderView.delegate = self;
        _tableView.tableHeaderView = seconderHeaderView;
        _tableView.sectionHeaderHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
}

#pragma mark - HYCommentAddSecondStepHeaderSecondView代理方法
- (void)changeBtnState:(BOOL)isEnable
{
    if (isEnable) {
        _commitBtn.userInteractionEnabled = YES;
        [_commitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        _commitBtn.userInteractionEnabled = NO;
        [_commitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

#pragma mark - HYCommentAddSecondStepHeaderView代理方法
- (void)toChangeBtnState:(BOOL)isEnable
{
    if (isEnable) {
        _commitBtn.userInteractionEnabled = YES;
        [_commitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        _commitBtn.userInteractionEnabled = NO;
        [_commitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = self.isReply ? [self.imageList count] : [self.picData count];
    NSInteger row = (count+3)/4;
    CGFloat height = (ScreenRect.size.width-(4*TFScalePoint(64)))/5*(row+1)+TFScalePoint(64)*row;
    return height;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MallGetEvidencePicture";
    HYMallGetEvidencePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 设置相机图标及上传凭证图标
    if (self.isReply)
    {
        [cell setImgsUrlList:self.imageList];
    }
    else
    {
        [cell setPicData:[self.picData copy]];
        
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        [self.view endEditing:YES];
    }
    
}

#pragma mark getter and setter
- (void)setTitleWithEvaluable:(NSInteger)isEvaluable
{
//    if (isReply != _isReply)
//    {
//        _isReply = isReply;
//        
//        NSString *title = isReply ? @"追加评价" : @"发表评价";
//        self.title = title;
//    }
    if (isEvaluable == 1) {
        self.isReply = NO;
    } else if (isEvaluable == 2) {
        self.isReply = YES;
    }
    
    
    NSString *title = self.isReply ? @"追加评价" : @"发表评价";
    self.title = title;
   // self.isReply = isReply;
    
}

- (NSMutableArray *)picData
{
    if (!_picData)
    {
        _picData = [NSMutableArray array];
        
//        UIButton *photoAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
//        photoAlbum.frame = CGRectMake(70, 10, 50, 50);
//        [photoAlbum setBackgroundImage:[UIImage imageNamed:@"mall_afterSaleEvidence"] forState:UIControlStateNormal];
//        [_picData addObject:photoAlbum];
        
        UIButton *camera = [UIButton buttonWithType:UIButtonTypeCustom];
        [camera setBackgroundImage:[UIImage imageNamed:@"mall_afterSaleCamera"] forState:UIControlStateNormal];
        camera.frame = CGRectMake(10, 10, 50, 50);
        [_picData addObject:camera];
    }
    return _picData;
}

- (NSMutableArray *)picOriginalData
{
    if (!_picOriginalData)
    {
        _picOriginalData = [NSMutableArray array];
    }
    return _picOriginalData;
}

#pragma mark  HYMallGetEvidencePictureCellDelegate
- (void)getPicFromCamera
{
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//    {
//        UIImagePickerController *picker = [UIImagePickerController new];
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        picker.delegate = self;
//        picker.allowsEditing = YES;
//        [self presentViewController:picker animated:YES completion:nil];
//    }
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相机" otherButtonTitles:@"相册", nil];
    sheet.delegate = self;
    [sheet showInView:self.view];
    
    void (^commentBlock)(NSUInteger index) = ^(NSUInteger index){
        if (0 == index)//照相机
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker = [UIImagePickerController new];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
                picker.allowsEditing = YES;
                [self presentViewController:picker animated:YES completion:nil];
            }
        }else if (1 == index)//相册
        {
            [self getPicFromPhotoAlbum];
        }
    };
    
    objc_setAssociatedObject(sheet, HYCommentAddSecondStepActionSheetKey, commentBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

- (void)getPicFromPhotoAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

-(void)jumpToBrowserFromIndex:(NSInteger)index
{
    GWPhotoBrowserViewController *vc = [GWPhotoBrowserViewController new];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.picData = self.picOriginalData;
    vc.delegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - action sheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^commentBlock)(NSUInteger index) = objc_getAssociatedObject(actionSheet, HYCommentAddSecondStepActionSheetKey);
    commentBlock(buttonIndex);
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.picOriginalData.count < 5) {
        //生成一张缩略图
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.picOriginalData addObject:image];
        UIImage *thumb = [self imageThumbNailImageWith:image];
        UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [newBtn setBackgroundImage:thumb forState:UIControlStateNormal];
        [self.picData addObject:newBtn];
        [_tableView reloadData];
}


}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark aftersale deletephoto
- (void)updatePicData:(NSMutableArray *)picData
{
    NSMutableArray *temp = [NSMutableArray array];
    
    for (UIImage *img in picData)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        [temp addObject:btn];
    }
    
    //把第二张图后面的图全部删除，然后用新图数组追加
    [self.picData removeObjectsInRange:NSMakeRange(1, self.picData.count-1)];
    [self.picData addObjectsFromArray:temp];
    
    [_tableView reloadData];
}

#pragma mark private methods
- (UIImage *)imageThumbNailImageWith:(UIImage *)image
{
    UIImage *newImage;
    CGSize asize = CGSizeMake(TFScalePoint(64), TFScalePoint(64));
    
    if (nil == image)
    {
        newImage = nil;
    }
    else
    {
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return newImage;
}

#pragma mark - ----键盘弹窗处理----
- (void)toUpContentViewFrame
{
    [self.tableView setContentOffset:CGPointMake(0, 150) animated:YES];
    
}
- (void)toDownContentViewFrame
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

#pragma mark - 提交评论

- (void)commitComment
{
    HYCommentAddSecondStepFooterView *fView = (HYCommentAddSecondStepFooterView *)self.tableView.tableFooterView;
    if (!_commentReq) {
        _commentReq = [[HYMallGoodsCommentRequest alloc] init];
    }
    [_commentReq cancel];
    
    if (!self.isReply)
    {
        HYCommentAddSecondStepHeaderView *view = (HYCommentAddSecondStepHeaderView *)self.tableView.tableHeaderView;
        _commentReq.orderCode = _infoModel.orderCode;
        _commentReq.productCode = _infoModel.productCode;
        _commentReq.productSkuCode = _infoModel.productSKUCode;
        _commentReq.isReplyComment = @"0";
        _commentReq.productScore = [NSString stringWithFormat:@"%ld", (long)view.descStarNumber];
        _commentReq.serviceScore = [NSString stringWithFormat:@"%ld", (long)view.seviceStarNumber];
        _commentReq.deliveryScore = [NSString stringWithFormat:@"%ld", (long)view.speedStarNumber];
        _commentReq.comment = view.descTextView.text;
        if (fView.isAnonymousSwitch.isOn == YES)
        {
            _commentReq.isAnonymous = @"1";
        }
        else
        {
            _commentReq.isAnonymous = @"0";
        }
        
        _commentReq.uploadfile = self.picOriginalData;
        
        [_commentReq sendReuqest:^(id result, NSError *error) {
            
            HYCommentAddSecondStepResponse *response = (HYCommentAddSecondStepResponse*)result;
            if (response.status == 200)
            {
                HYExpensiveResultView *alertView = [HYExpensiveResultView instance];
                alertView.success = YES;
                [alertView showWithDuration:2.0f completionHanlder:^{
                    
                    UIViewController *detailVc = [self.navigationController.viewControllers objectAtIndex:2];
                    [self.navigationController popToViewController:detailVc animated:YES];
                }];
                
            }
            else
            {
                HYExpensiveResultView *alertView = [HYExpensiveResultView instance];
                alertView.success = NO;
                [alertView show];
                [alertView showWithDuration:2.0f completionHanlder:^{
                    
                    [alertView dismiss];
                }];
            }
            
            
            //统计
            HYCommentItem *item = [[HYCommentItem alloc] init];
            item.item_code = _infoModel.productCode;
            item.sku_code = _infoModel.productSKUCode;
            item.description_score = _commentReq.productScore;
            item.service_score = _commentReq.serviceScore;
            item.delivery_score = _commentReq.deliveryScore;
            
            NSArray *items = [NSArray arrayWithObject:item];
            [[[HYAnalyticsManager alloc] init] commentEventWith:items withOrderCode:_infoModel.orderCode];
        }];
        
    }
    else
    {
        
        HYCommentAddSecondStepHeaderSecondView *view = (HYCommentAddSecondStepHeaderSecondView *)self.tableView.tableHeaderView;
        _commentReq.isReplyComment = @"1";
        _commentReq.comment = view.commentTextView.text;
        _commentReq.rltId = self.commentId;
        _commentReq.orderCode = _infoModel.orderCode;
        
        [_commentReq sendReuqest:^(id result, NSError *error){
            HYCommentAddSecondStepResponse *response = (HYCommentAddSecondStepResponse*)result;
            if (response.status == 200)
            {
                
                HYExpensiveResultView *alertView = [HYExpensiveResultView instance];
                alertView.success = YES;
                [alertView showWithDuration:2.0f completionHanlder:^{
                    
                    UIViewController *detailVc = [self.navigationController.viewControllers objectAtIndex:2];
                    [self.navigationController popToViewController:detailVc animated:YES];
                }];
            }
            else
            {
                HYExpensiveResultView *alertView = [HYExpensiveResultView instance];
                alertView.success = NO;
                [alertView show];
                [alertView showWithDuration:2.0f completionHanlder:^{
                    
                    [alertView dismiss];
                }];
            }

        }];
    }
}


@end
