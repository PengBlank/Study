//
//  HYGoodsReturnViewViewController.m
//  Teshehui
//
//  Created by RayXiang on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodsReturnViewViewController.h"
#import "UIView+Style.h"
#import "HYGoodsRetGrayCell.h"
#import "HYGoodsRetNumCell.h"
#import "HYGoodsRetTextCell.h"
#import "HYGoodsRetPhotoCell.h"
#import "HYGoodsRetDetailCell.h"
#import "HYPickerToolView.h"
#import "HYKeyboardHandler.h"
#import "HYGoodsRetValueCell.h"
#import "METoast.h"

//http
#import "HYMallOrderReturnRequest.h"
#import "HYMallOrderReturnResponse.h"

@interface HYGoodsReturnViewViewController ()
<
HYPickerToolViewDelegate,
HYKeyboardHandlerDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
HYAddCommentsPhotoCellDelegate,
HYGoodsRetDescCellDelegate,
hyGoodsRetNumberCellDelegate
>
{
    NSString *_descript;
    NSInteger _returnNumber;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYPickerToolView *pickerView;
@property (nonatomic, strong) HYKeyboardHandler *keyboardHandler;
@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) HYMallOrderReturnRequest *returnRequest;

@end

@implementation HYGoodsReturnViewViewController

- (void)dealloc
{
    [_returnRequest cancel];
    _returnRequest = nil;
    [HYLoadHubView dismiss];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _retType = HYGoodsReturn;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    frame.size.height -= 44;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.backgroundView = nil;
    tableview.delaysContentTouches = NO;
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)-44, CGRectGetWidth(self.view.bounds), 44)];
    [self.view addSubview:footer];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:footer.bounds];
    bg.image = [UIImage imageNamed:@"g_ret_foot_bg.png"];
    [footer addSubview:bg];
    
    UIImage *cancel = [UIImage imageNamed:@"g_ret_cancel.png"];
    CGFloat x = CGRectGetMidX(footer.bounds) - 15 - cancel.size.width;
    CGFloat y = CGRectGetMidY(footer.bounds) - cancel.size.height/2;
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, cancel.size.width, cancel.size.height)];
    [cancelBtn setImage:cancel forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                  action:@selector(cancelBtnAction:)
        forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:cancelBtn];
    
    UIImage *apply = [UIImage imageNamed:@"g_ret_apply.png"];
    x = CGRectGetMidX(footer.bounds) + 15;
    UIButton *applyBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, apply.size.width, apply.size.height)];
    [applyBtn setBackgroundImage:apply forState:UIControlStateNormal];
    [applyBtn addTarget:self action:@selector(applyBtnAction:)
       forControlEvents:UIControlEventTouchUpInside];
    [applyBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    [applyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [applyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [footer addSubview:applyBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"退/换货申请";
    
    [self.tableView registerClass:[HYGoodsRetGrayCell class] forCellReuseIdentifier:@"grayCell"];
    [self.tableView registerClass:[HYGoodsRetNumCell class] forCellReuseIdentifier:@"numCell"];
    [self.tableView registerClass:[HYGoodsRetTextCell class] forCellReuseIdentifier:@"descCell"];
    [self.tableView registerClass:[HYGoodsRetPhotoCell class] forCellReuseIdentifier:@"photoCell"];
    [self.tableView registerClass:[HYGoodsRetDetailCell class] forCellReuseIdentifier:@"detailCell"];
    [self.tableView registerClass:[HYGoodsRetValueCell class] forCellReuseIdentifier:@"valueCell"];
    
    self.keyboardHandler = [[HYKeyboardHandler alloc] initWithDelegate:self view:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.keyboardHandler startListen];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.keyboardHandler stopListen];
    [_pickerView dismissWithAnimation:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)cancelBtnAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)applyBtnAction:(UIButton *)btn
{
    [self commitGoodsReturn];
}

- (void)commitGoodsReturn
{
    //验证
    NSString *err = nil;
    if ([[_descript stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
        length] == 0)
    {
        err = @"请输入问题描述";
    }
    if (err)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:err delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.returnRequest = [[HYMallOrderReturnRequest alloc] init];
    _returnRequest.order_id = self.orderItem.orderId;
    _returnRequest.refund_type = _retType + 1;
    _returnRequest.goods_id = _orderItem.orderItemId;
    _returnRequest.return_number = _returnNumber;
    _returnRequest.refund_desc = _descript;
    _returnRequest.attachments = self.photos;
    
    [HYLoadHubView show];
    __weak HYGoodsReturnViewViewController *b_self = self;
    [self.returnRequest sendReuqest:^(id result, NSError *error)
    {
        [HYLoadHubView dismiss];
        HYMallOrderReturnResponse *response = (HYMallOrderReturnResponse *)result;
        if (response.status == 200)
        {
            [METoast toastWithMessage:@"售后服务申请成功"];
            if (b_self.returnCallback)
            {
                b_self.returnCallback(YES);
            }
            [b_self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [METoast toastWithMessage:error.domain];
        }
    }];
}

#pragma mark - TableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (_retType == HYGoodsReturn) {
//        return 4;
//    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return 145;
    } else if (indexPath.row == 3) {
        return 120;
    } else {
        return 42;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        HYGoodsRetGrayCell *grayCell = [tableView dequeueReusableCellWithIdentifier:@"grayCell"];
        grayCell.nessary = YES;
        grayCell.isGray = YES;
        grayCell.keyLab.text = @"服务类型";
        grayCell.valueLab.text = _retType == HYGoodsReturn ? @"退货":@"换货";
        grayCell.selectable = YES;
        return grayCell;
    }
    else if (indexPath.row == 1)
    {
        HYGoodsRetNumCell *numberCell = [tableView dequeueReusableCellWithIdentifier:@"numCell"];
        numberCell.delegate = self;
        NSInteger count = _returnNumber;
        numberCell.numLab.text = [NSString stringWithFormat:@"%ld", (long)count];
        return numberCell;
    }
    else if (indexPath.row == 2) {
        HYGoodsRetTextCell *descCell = [tableView dequeueReusableCellWithIdentifier:@"descCell"];
        descCell.descTxt = _descript;
        descCell.delegate = self;
        return descCell;
    }
    else if (indexPath.row == 3) {
        HYGoodsRetPhotoCell *photo = [tableView dequeueReusableCellWithIdentifier:@"photoCell"];
        photo.delegate = self;
        photo.photos = self.photos;
        return photo;
    }
    /*
    else if (indexPath.row == 4) {
        HYGoodsRetValueCell *grayCell = [tableView dequeueReusableCellWithIdentifier:@"valueCell"];
        grayCell.keyLab.text = @"商品返回方式";
        grayCell.valueLab.text = @"快递至卖家";
        return grayCell;
    }
    else if (indexPath.row == 5 && _retType == HYGoodsReturn)
    {
        HYGoodsRetValueCell *grayCell = [tableView dequeueReusableCellWithIdentifier:@"valueCell"];
        grayCell.keyLab.text = @"退款方式";
        grayCell.valueLab.text = @"原支付方式返回";
        return grayCell;
        
    }
    else if ((indexPath.row == 6 && _retType == HYGoodsReturn)||
             (indexPath.row == 5 && _retType == HYGoodsExchange))
    {
        HYGoodsRetDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        return cell;
    }*/
    
    //default
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.pickerView showWithAnimation:YES];
    }
}

#pragma mark setter/getter
- (HYPickerToolView *)pickerView
{
    if (!_pickerView)
    {
        _pickerView = [[HYPickerToolView alloc] initWithFrame:CGRectZero];
        _pickerView.delegate = self;
        _pickerView.dataSouce = @[@"退货", @"换货"];
        _pickerView.title = @"选择服务类型";
    }
    
    return _pickerView;
}

- (void)selectComplete:(HYPickerToolView *)pickerView
{
    if (_retType != pickerView.currentIndex) {
        _retType = pickerView.currentIndex;
        [self.tableView reloadData];
    }
}

- (void)setOrderItem:(HYMallOrderItem *)orderItem
{
    if (_orderItem != orderItem)
    {
        _orderItem = orderItem;
        _returnNumber = _orderItem.quantity;
    }
}

#pragma mark - keyboard
- (void)keyboardChangeFrame:(CGRect)kFrame
{
    CGFloat h = CGRectGetHeight(self.view.frame) - CGRectGetHeight(kFrame);
    CGRect frame = self.tableView.frame;
    frame.size.height = h;
    self.tableView.frame = frame;
}

- (void)keyboardHide
{
    self.tableView.frame = CGRectMake(0,
                                      0,
                                      CGRectGetWidth(self.view.frame),
                                      CGRectGetHeight(self.view.frame)-44);
}

#pragma mark - photo
#pragma mark - Detail cell delegate

- (void)photoCellDidClickAddPhoto:(UITableViewCell *)cell
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:@"拍照"
                                               otherButtonTitles:@"相册", nil];
    [action showInView:self.view];
}

- (void)photoCell:(UITableViewCell *)cell didClickDeletePhotoWithIndex:(NSInteger)idx
{
    if (self.photos.count > idx)
    {
        [self.photos removeObjectAtIndex:idx];
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
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (image)
    {
        if (!_photos) {
            _photos = [NSMutableArray array];
        }
        [_photos addObject:image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

#pragma mark - desc
- (void)descCell:(HYGoodsRetTextCell *)cell didGetText:(NSString *)txt
{
    if (txt) {
        _descript = txt;
    }
}

- (void)goodsRetNumberCellDidAddNumber:(HYGoodsRetNumCell *)numberCell
{
    if (_returnNumber <= _orderItem.quantity-1)
    {
        _returnNumber += 1;
    }
    [self.tableView reloadData];
}
- (void)goodsRetNumberCellDidMinusNumber:(HYGoodsRetNumCell *)numCell
{
    if (_returnNumber > 1)
    {
        _returnNumber -= 1;
    }
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.dragging)
    {
        [self.view endEditing:YES];
    }
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
