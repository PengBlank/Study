//
//  HYMakeWishPoolViewController.m
//  Teshehui
//
//  Created by HYZB on 15/11/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMakeWishPoolViewController.h"
#import "HYMakeWishPoolThumbPhotosCell.h"
#import "MWPhotoBrowser.h"
#import "UIImage+Addition.h"
#import "HYUserInfo.h"
#import "HYMakeWishHeaderView.h"
#import "HYMakeWishCommitRequest.h"
#import "HYLoadHubView.h"
#import "NSString+Addition.h"
#import "HYMakeWishPoolDeclareView.h"
#import "HYMakeWishPoolDeclareRequest.h"
#import "HYMakeWishPoolDeclareResponse.h"

#import "HYUmengMobClick.h"

#define kThumbPhotosCellID @"ThumbPhotosCellID"
#define kFont [UIFont systemFontOfSize:14]

@interface HYMakeWishPoolViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
HYMakeWishPoolThumbPhotosCellDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate,
MWPhotoBrowserDelegate,
UITextFieldDelegate,
HYMakeWishHeaderViewDelegate
>

@property (nonatomic, strong) UITableView *makeWishPoolTableView;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *upPicture;
@property (nonatomic, strong) NSMutableArray *photoBrowserPhotos;
@property (nonatomic, assign) NSInteger selectedPhotoIndex;
@property (nonatomic, strong) UIActionSheet *deletePhotoSheet;
@property (nonatomic, strong) UIActionSheet *cameraAndPhotosAlbumSheet;
@property (nonatomic, assign) NSInteger deletePhotoIndex;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *phoneNumberTF;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) HYMakeWishCommitRequest *makeWishCommitReq;
@property (nonatomic, strong) HYMakeWishPoolDeclareRequest *makeWishPoolDeclareReq;

@property (nonatomic, strong) HYMakeWishPoolThumbPhotosCell *thumbPhotosCell;
@property (nonatomic, copy) NSString *nameTextFieldResult;
@property (nonatomic, copy) NSString *phoneTextFieldResult;

@property (nonatomic, strong) HYMakeWishPoolDeclareView *declareV;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation HYMakeWishPoolViewController

- (void)dealloc
{
    [_makeWishCommitReq cancel];
    _makeWishCommitReq = nil;
    
    [_makeWishPoolDeclareReq cancel];
    _makeWishPoolDeclareReq = nil;
    
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
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    
    [self.view addSubview:tableview];
    self.makeWishPoolTableView = tableview;
    
    HYMakeWishHeaderView *makeWishHeaderView = [[NSBundle mainBundle]
                                                loadNibNamed:@"HYMakeWishHeaderView" owner:nil options:nil][0];
    if (self.goodsName) {
        makeWishHeaderView.nameTextView.text = self.goodsName;
        [makeWishHeaderView.nameTextView becomeFirstResponder];
    }
    self.makeWishPoolTableView.tableHeaderView = makeWishHeaderView;
    makeWishHeaderView.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapDidClicked:)];
    [self.makeWishPoolTableView addGestureRecognizer:tap];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"帮我买";
    _isLoading = NO;
    [self.makeWishPoolTableView registerClass:[HYMakeWishPoolThumbPhotosCell class]
                       forCellReuseIdentifier:kThumbPhotosCellID];
    
    [self createFooterView];
    [self setupNoTipsFrame];
    [self loadDate];
}

#pragma mark - createFooterView
- (void)createFooterView
{
    // WithFrame:CGRectMake(0, 0, TFScalePoint(320), 190)
    _footerView = [[UIView alloc] init];
//    _footerView.backgroundColor = [UIColor colorWithRed:244/255.0f green:245/255.0f blue:246/255.0f alpha:1.0f];
    _footerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameAndPhoneTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(TFScalePoint(10), 10, 200, 20)];
    nameAndPhoneTitleLab.text = @"联系方式(便于联系你)";
    nameAndPhoneTitleLab.font = kFont;
    [_footerView addSubview:nameAndPhoneTitleLab];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, _footerView.frame.size.width - 20, 1)];
    topLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_footerView addSubview:topLineView];
    
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    
    _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(TFScalePoint(10), 60, TFScalePoint(260), 30)];
    _nameTF.leftViewMode = UITextFieldViewModeAlways;
    _nameTF.leftView = leftV;
    _nameTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _nameTF.layer.borderWidth = 1.0;
    NSString *name = [HYUserInfo getUserInfo].realName;
    _nameTF.text = name;
    _nameTF.placeholder = @"请输入姓名";
    _nameTF.delegate = self;
    [_nameTF addTarget:self action:@selector(textFieldDidChange:)
      forControlEvents:UIControlEventEditingChanged];
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    rightBtn.frame = CGRectMake(0, 0, 30, 30);
//    [rightBtn addTarget:self action:@selector(nameTFRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [rightBtn setBackgroundImage:[UIImage imageWithNamedAutoLayout:@"makeWishDelete"] forState:UIControlStateNormal];
//    _nameTF.rightView = rightBtn;
//    _nameTF.rightViewMode = UITextFieldViewModeAlways;
    _nameTF.clearButtonMode = UITextFieldViewModeAlways;
    [_footerView addSubview:_nameTF];
    
    _phoneNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(TFScalePoint(10), 100, TFScalePoint(260), 30)];
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _phoneNumberTF.leftViewMode = UITextFieldViewModeAlways;
    _phoneNumberTF.leftView = left;
    _phoneNumberTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _phoneNumberTF.layer.borderWidth = 1.0;
    _phoneNumberTF.text = [HYUserInfo getUserInfo].mobilePhone;
    _phoneTextFieldResult = _phoneNumberTF.text;
    _phoneNumberTF.placeholder = @"请输入联系电话";
    _phoneNumberTF.delegate = self;
//    UIButton *phoneNumberTFRightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    phoneNumberTFRightBtn.frame = CGRectMake(0, 0, 30, 30);
//    [phoneNumberTFRightBtn addTarget:self action:@selector(phoneNumberTFRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [phoneNumberTFRightBtn setBackgroundImage:[UIImage imageWithNamedAutoLayout:@"makeWishDelete"] forState:UIControlStateNormal];
//    _phoneNumberTF.rightView = phoneNumberTFRightBtn;
//    _phoneNumberTF.rightViewMode = UITextFieldViewModeAlways;
    _phoneNumberTF.clearButtonMode = UITextFieldViewModeAlways;
    [_footerView addSubview:_phoneNumberTF];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, _footerView.frame.size.width, 1)];
    _bottomLineView = bottomLineView;
    bottomLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_footerView addSubview:bottomLineView];
    
    HYMakeWishPoolDeclareView *declareV = [[HYMakeWishPoolDeclareView alloc]
                                           initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomLineView.frame), self.view.frame.size.width, 260)];
    [_footerView addSubview:declareV];
    _declareV = declareV;
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.frame = CGRectMake(TFScalePoint(10), CGRectGetMaxY(declareV.frame), TFScalePoint(300), 40);
    _confirmBtn.backgroundColor = [UIColor grayColor];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(confirmBtnDidClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn.enabled = NO;
    [_footerView addSubview:_confirmBtn];
    
    _footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, CGRectGetMaxY(_confirmBtn.frame)+20);
    self.makeWishPoolTableView.tableFooterView = _footerView;
}

#pragma mark - privateMethod
- (void)loadDate
{
    if (!_makeWishPoolDeclareReq)
    {
        _makeWishPoolDeclareReq = [[HYMakeWishPoolDeclareRequest alloc] init];
    }
    
    [HYLoadHubView show];
    WS(weakSelf)
    
    [_makeWishPoolDeclareReq sendReuqest:^(id result, NSError *error) {
       
        [HYLoadHubView dismiss];
        HYMakeWishPoolDeclareResponse *respon = (HYMakeWishPoolDeclareResponse *)result;
        if (respon.status == 200)
        {
            weakSelf.declareV.b5m_tips = respon.b5m_tips;
            if (respon.b5m_tips)
            {
                [weakSelf setupHaveTipsFrame];
            }
            else
            {
                [weakSelf setupNoTipsFrame];
            }
        }
    }];
}

- (void)setupNoTipsFrame
{
    _confirmBtn.frame = CGRectMake(TFScalePoint(10), CGRectGetMaxY(_bottomLineView.frame)+10, TFScalePoint(300), 40);
    _declareV.hidden = YES;
    _footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, CGRectGetMaxY(_confirmBtn.frame)+20);
    self.makeWishPoolTableView.tableFooterView = _footerView;
}

- (void)setupHaveTipsFrame
{
    _declareV.hidden = NO;
    _confirmBtn.frame = CGRectMake(TFScalePoint(10), CGRectGetMaxY(_declareV.frame), TFScalePoint(300), 40);
    _footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, CGRectGetMaxY(_confirmBtn.frame)+20);
    self.makeWishPoolTableView.tableFooterView = _footerView;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)tf
{
    if (tf == _nameTF) {
        if (tf.text.length > 9) {
            tf.text = [tf.text substringToIndex:9];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (currentDeviceType()) {
        case iPhone4_4S:
            [self.makeWishPoolTableView setContentOffset:CGPointMake(0, 500) animated:YES];
            break;
        case iPhone5_5S:
            [self.makeWishPoolTableView setContentOffset:CGPointMake(0, 430) animated:YES];
            break;
        case iPhone6Plus:
            [self.makeWishPoolTableView setContentOffset:CGPointMake(0, 290) animated:YES];
            break;
        case iPhone6:
            [self.makeWishPoolTableView setContentOffset:CGPointMake(0, 330) animated:YES];
            break;
        default:
            break;
    }
    
    _nameTextFieldResult = _nameTF.text;
    _phoneTextFieldResult = _phoneNumberTF.text;
    [self confirmBtnSetting];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.nameTF) {
        
        _nameTextFieldResult = [textField.text stringByReplacingCharactersInRange:range withString:string];
    } else {
        
        _phoneTextFieldResult = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    
    [self confirmBtnSetting];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{

    _nameTextFieldResult = _nameTF.text;
    _phoneTextFieldResult = _phoneNumberTF.text;
    [self confirmBtnSetting];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == _nameTF) {
        _nameTF.text = @"";
    } else {
        _phoneNumberTF.text = @"";
    }
    _nameTextFieldResult = _nameTF.text;
    _phoneTextFieldResult = _phoneNumberTF.text;
    [self confirmBtnSetting];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _nameTextFieldResult = _nameTF.text;
    _phoneTextFieldResult = _phoneNumberTF.text;
    [self confirmBtnSetting];
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _thumbPhotosCell = [tableView dequeueReusableCellWithIdentifier:kThumbPhotosCellID forIndexPath:indexPath];
    [_thumbPhotosCell setImageToImageBtnWithImage:self.photos];
    
    _thumbPhotosCell.delegate = self;
    return _thumbPhotosCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//}

#pragma mark - 点击事件
- (void)tapDidClicked:(UITapGestureRecognizer *)tap
{
    
    [self.view endEditing:YES];
    [self.makeWishPoolTableView setContentOffset:CGPointZero animated:YES];
}

- (void)confirmBtnDidClicked:(UIButton *)btn
{
    [HYUmengMobClick mineWishWithBtnType:WishViewBtnTypeConfirm];
    if ([_phoneNumberTF.text checkPhoneNumberValid]) {
        
        if (_isLoading == NO) {
            
            [self sendRequest];
        }
    } else {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:@"手机号码不正确" delegate:self
                                               cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertV show];
    }
}

- (void)sendRequest
{
    _isLoading = YES;
    if (!_makeWishCommitReq) {
        _makeWishCommitReq = [[HYMakeWishCommitRequest alloc] init];
    }
    [_makeWishCommitReq cancel];
    
    _makeWishCommitReq.userId = [HYUserInfo getUserInfo].userId;
    _makeWishCommitReq.contactName = _nameTF.text;
    _makeWishCommitReq.contactMobile = _phoneNumberTF.text;
    
    HYMakeWishHeaderView *headerView = (HYMakeWishHeaderView *)self.makeWishPoolTableView.tableHeaderView;
    _makeWishCommitReq.wishTitle = headerView.nameTextView.text;
    _makeWishCommitReq.wishContent = headerView.descTextView.text;
    
    // 上传的图片
    if (self.photos.count > 1) {
        
        for (NSInteger i = 1; i < self.photos.count; i++) {
            
            [self.upPicture addObject:self.photos[i]];
        }
        _makeWishCommitReq.uploadfile = self.upPicture;
    }
    
    [HYLoadHubView show];
    
    __weak typeof(self) weakSelf = self;
    [_makeWishCommitReq sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        _isLoading = NO;
        CQBaseResponse *response = result;
        if ([response.jsonDic[@"message"] isEqualToString:@"Success!"]) {
            
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:@"提交成功" delegate:weakSelf
                                                   cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [alertV show];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:@"提交失败" delegate:weakSelf
                                                   cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertV show];
        }
    }];
}

#pragma mark - confirmBtnSetting
- (void)confirmBtnSetting
{
    HYMakeWishHeaderView *headerView = (HYMakeWishHeaderView *)self.makeWishPoolTableView.tableHeaderView;
    // 用户姓名非必填
    if (headerView.nameTextView.text.length > 0 && headerView.descTextView.text.length > 0 && _phoneTextFieldResult.length > 0) {
        
        _confirmBtn.enabled = YES;
        _confirmBtn.backgroundColor = [UIColor redColor];
    } else {
        _confirmBtn.enabled = NO;
        _confirmBtn.backgroundColor = [UIColor grayColor];
    }
    // 所有必填
//    if (headerView.nameTextView.text.length > 0 && headerView.descTextView.text.length > 0 && _nameTextFieldResult.length > 0 && _phoneTextFieldResult.length > 0) {
//        _confirmBtn.enabled = YES;
//        _confirmBtn.backgroundColor = [UIColor redColor];
//    } else {
//        _confirmBtn.enabled = NO;
//        _confirmBtn.backgroundColor = [UIColor grayColor];
//    }
}

#pragma mark - 懒加载
- (NSMutableArray *)photos
{
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
        [_photos addObject:[UIImage imageWithNamedAutoLayout:@"makeWishThumbPhoto"]];
    }
    return _photos;
}

- (NSMutableArray *)upPicture
{
    if (!_upPicture) {
        _upPicture = [NSMutableArray array];
    }
    return _upPicture;
}

- (NSMutableArray *)photoBrowserPhotos
{
    if (!_photoBrowserPhotos) {
        _photoBrowserPhotos = [[NSMutableArray alloc] init];
    }
    
    [_photoBrowserPhotos removeAllObjects];
    
    MWPhoto *photo;
    for (NSInteger i = self.photos.count-1; i > 0; i--) {
        photo = [MWPhoto photoWithImage:self.photos[i]];
        [_photoBrowserPhotos addObject:photo];
    }
    return _photoBrowserPhotos;
}

#pragma mark - ThumbPhotosCellDelegate
- (void)imageBtnSelected
{
    [self.view endEditing:YES];
    _cameraAndPhotosAlbumSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"照相机" otherButtonTitles:@"相册", nil];
    _cameraAndPhotosAlbumSheet.delegate = self;
    [_cameraAndPhotosAlbumSheet showInView:self.view];
}

- (void)photoBrowserAndPhotoIndex:(NSInteger)PhotoIndex
{
    
    _selectedPhotoIndex = PhotoIndex;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // 自定义一个删除按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 30);
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    browser.navigationItem.rightBarButtonItem = btnItem;
    
    // Set options
    browser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = YES; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    // browser.autoPlayOnAppear = NO; // Auto-play first video
    
    // Customise selection images to change colours if required
    //    browser.customImageSelectedIconName = @"ImageSelected.png";
    //    browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
    
    // Optionally set the current visible photo before displaying
    // [browser setCurrentPhotoIndex:1];
    
    // Present
    [self.navigationController pushViewController:browser animated:YES];
    
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:_selectedPhotoIndex];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    
    return self.photoBrowserPhotos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (index < self.photoBrowserPhotos.count)
        return [self.photoBrowserPhotos objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index
{
    _deletePhotoIndex = index;
}

#pragma mark - MWPhotoBrowser自定义删除按钮点击事件
- (void)deleteImage:(UIButton *)btn
{
    _deletePhotoSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:@"删除照片" otherButtonTitles:nil];
    
    _deletePhotoSheet.delegate = self;
    
    [_deletePhotoSheet showInView:self.navigationController.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet == _deletePhotoSheet) {
        
        if (buttonIndex == 0) {
            
            NSInteger index = 0;
            
            for (NSInteger i = self.photos.count-1; i > 0; i--) {
                
                if (index == _deletePhotoIndex) {
                    
                    [self.photos removeObjectAtIndex:i];
                    
                    [self.makeWishPoolTableView reloadData];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                index++;
            }
        }
    } else if (actionSheet == _cameraAndPhotosAlbumSheet) {
        
        UIImagePickerController *pickerCtl = [[UIImagePickerController alloc] init];
        
        switch (buttonIndex) {
            case 0:
                pickerCtl.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickerCtl.delegate = self;
                pickerCtl.allowsEditing = YES;
                [self presentViewController:pickerCtl animated:YES completion:nil];
                break;
            case 1:
                pickerCtl.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                pickerCtl.delegate = self;
                pickerCtl.allowsEditing = YES;
                [self presentViewController:pickerCtl animated:YES completion:nil];
                break;
            default:
                break;
        }
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self.photos addObject:info[@"UIImagePickerControllerEditedImage"]];
    [self.makeWishPoolTableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
