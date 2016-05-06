//
//  HYCommentAddViewController.m
//  Teshehui
//
//  Created by RayXiang on 14-9-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCommentAddViewController.h"
#import "HYKeyboardHandler.h"
#import "HYAddCommentsGoodsCell.h"
#import "HYAddCommentsLevelCell.h"
#import "HYAddCommentsDescCell.h"
#import "HYAddCommentsPhotoCell.h"
#import "HYMallGoodsCommentRequest.h"
#import "HYCommentModel.h"
#import "METoast.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Addition.h"
#import "HYMallOrderDetailRequest.h"

@interface HYCommentAddViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate,
UITextViewDelegate,
HYKeyboardHandlerDelegate,
HYAddCommentsLevelCellDelegate,
HYAddCommentsPhotoCellDelegate,
HYAddCommentsDescCellDelegate
>
{
    //instance variables.
    __weak HYCommentModel *_editingModel;
    
    NSInteger _commitIdx;
    NSInteger _commitCount;
    
    UIView *_activeView;
    BOOL _isLoading;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSArray *commentModels;

@property (nonatomic, strong) HYKeyboardHandler *keyboardHandler;

@property (nonatomic, strong) HYMallGoodsCommentRequest *commentRequest;
@property (nonatomic, strong) HYMallOrderDetailRequest *orderRequest;

@property (nonatomic, assign) NSInteger commitIdx;

@end

@implementation HYCommentAddViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    [_commentRequest cancel];
    _commentRequest = nil;
    [_orderRequest cancel];
    _orderRequest = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
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
    
    //tableview
    frame.size.height -= 44;    //底部按钮高度
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.sectionHeaderHeight = 10;
    tableview.sectionFooterHeight = 0;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    tableview.tableHeaderView = [self fillViewWithHeight:10];
    tableview.delaysContentTouches = NO;
    //tableview.tableFooterView = [self fillViewWithHeight:100];
    
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
    
    //底部按钮
    frame.origin.y = CGRectGetHeight(frame);
    frame.size.height = 44;
    UIButton *commitBtn = [[UIButton alloc] initWithFrame:frame];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"comment_commit"]
                         forState:UIControlStateNormal];
    [commitBtn setTitle:@"发表评价" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    
    self.keyboardHandler = [[HYKeyboardHandler alloc] initWithDelegate:self view:self.view];
    
    UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [subBtn setTitle:@"提交" forState:UIControlStateNormal];
    [subBtn setTitleColor:[UIColor colorWithRed:152/255.0
                                          green:10/255.0
                                           blue:0
                                          alpha:1]
                 forState:UIControlStateNormal];
    subBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    subBtn.frame = CGRectMake(0, 0, 40, 44);
    [subBtn addTarget:self
               action:@selector(commitAction:)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *subItem = [[UIBarButtonItem alloc] initWithCustomView:subBtn];
    self.navigationItem.rightBarButtonItem = subItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"评价";
    
    //这是一组测试数据
    /*
    HYMallOrderGoodsInfo *goods = [[HYMallOrderGoodsInfo alloc] init];
    goods.order_id = @"774";
    goods.goods_id = @"1236";
    goods.rec_id = @"918";
    goods.goods_name = @"耐克运动鞋";
    goods.small_goods_image = @"http://www.t.teshehui.com/data/files/store_82/goods_194/app_small_201408081539544496.jpg";
    
    self.orderInfo  = [[HYMallOrderSummary alloc] init];
    _orderInfo.order_id = @"774";
    self.orderInfo.goods = @[goods];
     */
    
    /*
    [HYLoadHubView show];
    self.orderRequest = [[HYMallOrderDetailRequest alloc] init];
    _orderRequest.order_id = self.orderInfo.order_id;
    __weak HYCommentAddViewController *b_self = self;
    [_orderRequest sendReuqest:^(id result, NSError *error)
    {
        [HYLoadHubView dismiss];
        HYMallOrderDetailResponse *rs = (HYMallOrderDetailResponse *)result;
        if (rs.status == 200)
        {
            b_self.orderInfo = rs.orderDetail;
            b_self.commentModels = [HYCommentModel modelsWithOrderInfo:self.orderInfo];
            [b_self.tableView reloadData];
        }
    }];
     */
    self.commentModels = [HYCommentModel modelsWithOrderInfo:self.orderInfo];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.orderInfo)
    {
        //[self.navigationController popViewControllerAnimated:YES];
    }
    [self.keyboardHandler startListen];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.keyboardHandler stopListen];
}

//- (void)keyboardHide
//{
//    CGRect frame = self.view.bounds;
//    frame.size.height -= 44;
//    self.tableView.frame = frame;
//}

- (void)keyboardChangeFrame:(CGRect)kFrame
{
//    CGFloat off = CGRectGetHeight(kFrame);
//    kFrame = self.view.bounds;
//    kFrame.size.height -= off;
//    self.tableView.frame = kFrame;
    
    //这里写成这样是因为keyboard的调用方法键盘弹出、textView代理的调用之后
    //所以在textView的代理中计算会出现错误
    if (_activeView)
    {
        //键盘在tableview上占用的高度 - textview距底部的高度
        CGFloat offset = CGRectGetHeight(kFrame) - 44 -
                        (CGRectGetHeight(_tableView.frame) - (CGRectGetMaxY(_activeView.frame) - _tableView.contentOffset.y));
        if (offset > 0) {
            offset += _tableView.contentOffset.y;
            [_tableView setContentOffset:CGPointMake(0, offset) animated:YES];
        }
        _activeView = nil;
    }
}

#pragma mark - UITableView data source.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HYCommentModel *model = self.commentModels.count > section ?
                            self.commentModels[section] : nil;
    if (model.evaluable == HYCanEvaluation) {
        return 4;
    } else if (model.evaluable == HYCanAddEvaluation) {
        return model.photos.count > 0 ? 4 : 3;
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.commentModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYCommentModel *model = [self commentModelWithIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        {
            //商品概要
            static NSString *identifier = @"goodsCell";
            HYAddCommentsGoodsCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!goodsCell) {
                goodsCell = [[HYAddCommentsGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            goodsCell.goodsInfo = model.goods;
            return goodsCell;
            break;
        }
        case 1:
        {
            //星级
            if (model.evaluable == HYCanEvaluation)
            {
                static NSString *levelIdentifier = @"levelCell";
                HYAddCommentsLevelCell *levelCell = [tableView dequeueReusableCellWithIdentifier:levelIdentifier];
                if (!levelCell)
                {
                    levelCell = [[HYAddCommentsLevelCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                              reuseIdentifier:levelIdentifier];
                }
                levelCell.delegate = self;
                levelCell.commentModel = [self commentModelWithIndexPath:indexPath];
                return levelCell;
                break;
            }
            else if (model.evaluable == HYCanAddEvaluation)
            {
                return [self commentDisplayCellWithModel:model];
                break;
            }
            
        }
        case 2:
        {
            //评价
            if (model.evaluable == HYCanEvaluation)
            {
                static NSString *descIdentifier = @"descCell";
                HYAddCommentsDescCell *descCell = [tableView dequeueReusableCellWithIdentifier:descIdentifier];
                if (!descCell) {
                    descCell = [[HYAddCommentsDescCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:descIdentifier];
                }
                descCell.commentModel = [self commentModelWithIndexPath:indexPath];
                descCell.delegate = self;
                return descCell;
                break;
            }
            else if (model.evaluable == HYCanAddEvaluation)
            {
                if (model.photos.count > 0) {
                    //照片
                    return [self photoCellWithModel:model];
                } else {
                    return [self descCellWithModel:model];
                }
                
                break;
            }
        }
        case 3:
        {
            //照片
            if (model.evaluable == HYCanEvaluation)
            {
                static NSString *photoIdentifier = @"photoCell";
                HYAddCommentsPhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:photoIdentifier];
                if (!photoCell) {
                    photoCell = [[HYAddCommentsPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:photoIdentifier];
                    
                }
                photoCell.delegate = self;
                photoCell.photos = [self commentModelWithIndexPath:indexPath].photos;
                photoCell.enable = YES;
                return photoCell;
                break;
            }
            else if (model.evaluable == HYCanAddEvaluation)
            {
                return [self descCellWithModel:model];
                break;
            }
            
        }
            
        default:
            break;
    }
    return nil;
}

- (HYAddCommentsDescCell *)descCellWithModel:(HYCommentModel *)model
{
    static NSString *descIdentifier = @"descCell";
    HYAddCommentsDescCell *descCell = [self.tableView dequeueReusableCellWithIdentifier:descIdentifier];
    if (!descCell) {
        descCell = [[HYAddCommentsDescCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:descIdentifier];
    }
    descCell.delegate = self;
    descCell.commentModel = model;
    return descCell;
}

- (HYCommentModel *)commentModelWithIndexPath:(NSIndexPath *)path
{
    if (self.commentModels.count > path.section) {
        return [self.commentModels objectAtIndex:path.section];
    }
    return nil;
}

#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self commentModelWithIndexPath:indexPath] evaluable] == HYCanEvaluation)
    {
        switch (indexPath.row) {
            case 0:
                //商品概览
                return 90;
                break;
            case 1:
                //三行星星
                return 120;
                break;
            case 2:
                //文字输入
                return 95;
                break;
            case 3:
                //照片拾取
                return 120;
                break;
            default:
                return 0;
                break;
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
                //商品概览
                return 90;
                break;
            case 1:
                //文字显示
                return [self commentDisplayCellHeightForModel:[self commentModelWithIndexPath:indexPath]];
                break;
            case 2:
                //照片显示或者文字输入
                if ([[[self commentModelWithIndexPath:indexPath] photos] count] > 0)
                {
                    return 70;
                } else {
                    return 95;
                }
                break;
            case 3:
                //文字输入
                return 95;
                break;
            default:
                return 0;
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    return [self fillViewWithHeight:10];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        [self.view endEditing:YES];
    }
}

#pragma mark - private method 提交评价在这里!
- (void)sendRequest
{
    if (_commitIdx < self.commentModels.count
        && _commitIdx >= 0)
    {
        
        HYCommentModel *model = [self.commentModels objectAtIndex:_commitIdx];
        if ([model canApply])
        {
            HYCommentAddViewController *b_self = self;
            if (model.evaluable != HYCannotEvaluation)
            {
                _commentRequest = [HYMallGoodsCommentRequest requestWithCommentModel:model];
             //   _commentRequest.isReplyComment = model.evaluable == HYCanAddEvaluation;
                [_commentRequest sendReuqest:^(id result, NSError *error){
                     BOOL succ = ([(HYMallGoodsCommentResponse *)result status] == 200);
                     [b_self updateWithResult:succ error:error];
                 }];
            }
        }
        else
        {
            [self updateWithResult:NO error:nil];
        }
    }
    else
    {
        [self updateWithResult:NO error:nil];
    }
}

- (void)updateWithResult:(BOOL)result error:(NSError *)error
{
    _commitIdx ++;
    
    if (error)
    {
        [METoast toastWithMessage:error.domain];
    }
    else if (result)  //
    {
        [METoast toastWithMessage:@"评价成功"];
    }
    else
    {
        [METoast toastWithMessage:@"评价失败"];
    }
    
    if (_commitIdx >= self.commentModels.count)
    {
        _commitIdx = -1;
        //完成
        [HYLoadHubView dismiss];
        _isLoading = NO;
        
        if (self.addCommentCallback)
        {
            self.addCommentCallback(YES);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self sendRequest];
    }
}

- (void)commitAction:(UIButton *)btn
{
    if (!_isLoading)
    {
        _isLoading = YES;
        [self.view endEditing:YES];
        [HYLoadHubView show];
        _commitIdx = 0;
        _commitCount = 0;
        [self sendRequest];
    }
}

- (UIView *)fillViewWithHeight:(CGFloat)height
{
    CGFloat width = CGRectGetWidth(self.view.frame);
    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    v.image = [[UIImage imageNamed:@"ticket_bg_gray_g5"] stretchableImageWithLeftCapWidth:2
                                                                             topCapHeight:4];
    
    return v;
}

#pragma mark - private,回调事件
- (void)descCellDidBeginEditing:(HYAddCommentsDescCell *)cell
{
    _activeView = cell;
}

- (void)levelCell:(HYAddCommentsLevelCell *)cell didGetDescriptionLevel:(NSInteger)level
{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    HYCommentModel *model = [self commentModelWithIndexPath:path];
    model.desctiptionLevel = level;
}

- (void)levelCell:(HYAddCommentsLevelCell *)cell didGetServiceLevel:(NSInteger)level
{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    HYCommentModel *model = [self commentModelWithIndexPath:path];
    model.serviceLevel = level;
}

- (void)levelCell:(HYAddCommentsLevelCell *)cell didGetDeliverLevel:(NSInteger)level
{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    HYCommentModel *model = [self commentModelWithIndexPath:path];
    model.deliverLevel = level;
}

- (void)photoCellDidClickAddPhoto:(HYAddCommentsPhotoCell *)cell
{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    HYCommentModel *model = [self commentModelWithIndexPath:path];
    _editingModel = model;
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:@"拍照"
                                               otherButtonTitles:@"相册", nil];
    [action showInView:self.view];
}

- (void)photoCell:(HYAddCommentsPhotoCell *)cell didClickDeletePhotoWithIndex:(NSInteger)idx
{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    HYCommentModel *model = [self commentModelWithIndexPath:path];
    if (model.photos.count > idx)
    {
        [model.photos removeObjectAtIndex:idx];
    }
    [self.tableView reloadData];
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
        _editingModel = nil;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (image)
    {
        [_editingModel.photos addObject:image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
    _editingModel = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//文字cell
- (UITableViewCell *)commentDisplayCellWithModel:(HYCommentModel *)model
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"commentDisplayCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"commentDisplayCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *grayBg = [[UIView alloc] initWithFrame:CGRectMake(20,
                                                                  6,
                                                                  CGRectGetWidth(ScreenRect)-2*20,
                                                                  CGRectGetHeight(cell.bounds)-2*6)];
        grayBg.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        grayBg.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
        [cell.contentView addSubview:grayBg];
        
        UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectZero];
        textLab.font = [UIFont systemFontOfSize:16.0];
        textLab.backgroundColor = [UIColor clearColor];
        textLab.tag = 1034;
        textLab.numberOfLines = 0;
        [cell.contentView addSubview:textLab];
        
        UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectZero];
        detailLab.font = [UIFont systemFontOfSize:14.0];
        detailLab.backgroundColor = [UIColor clearColor];
        detailLab.tag = 1035;
        detailLab.textColor = [UIColor grayColor];
        [cell.contentView addSubview:detailLab];
    }
    UILabel *textLab = (UILabel *)[cell.contentView viewWithTag:1034];
    CGSize commentSize = [model.preComment sizeWithFont:textLab.font
                                   constrainedToSize:CGSizeMake((ScreenRect.size.width-40), 1000)];
    textLab.frame = CGRectMake(25, 8, 280, commentSize.height);
    textLab.text = model.preComment;
    UILabel *detailLab = (UILabel *)[cell.contentView viewWithTag:1035];
    detailLab.frame = CGRectMake(25, CGRectGetMaxY(textLab.frame)+2, ScreenRect.size.width-40, 15);
    detailLab.text = model.creatTime;
    return cell;
}

//算高度
- (CGFloat)commentDisplayCellHeightForModel:(HYCommentModel *)model
{
    NSString *comment = model.preComment;
    CGSize commentSize = [comment sizeWithFont:[UIFont systemFontOfSize:16.0]
                             constrainedToSize:CGSizeMake((ScreenRect.size.width-40), 1000)];
    CGFloat height = 8 + commentSize.height + 2 + 15 + 8;
    return height > 44 ? height : 44;
}

//图片cell
- (UITableViewCell *)photoCellWithModel:(HYCommentModel *)model
{
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"photoDisCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"photoDisCell"];
        CGFloat w = 55, x = 20, y = 5;
        for (int i = 0; i < 4; i++)
        {
            UIImageView * btn = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, w)];
            btn.tag = 2000+i;
            [cell.contentView addSubview:btn];
            x += w + 10; //右移一个按钮的距离，加15空白再减去右上角空白
        }
    }
    NSArray *photos = model.photos;
    for (int i = 0; i < 4; i++)
    {
        UIImageView * btn = (UIImageView *)[cell.contentView viewWithTag:2000+i];
        if (photos.count > i) {
            NSDictionary *photoStrDict = [photos objectAtIndex:i];
            NSString *photoStr = [photoStrDict objectForKey:@"thumb"];
            [btn sd_setImageWithURL:[NSURL URLWithString:photoStr]];
        }
        else{
            btn.image = nil;
        }
    }
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

