//
//  HYPromoterAddViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPromoterAddViewController.h"
#import "HYAddCardSubmitBackgroundView.h"
#import "HYSearchNumberCell.h"
#import "HYSearchUnPromoterCardRequestParam.h"
#import "UIView+Style.h"
#import "HYSearchMemberTelRequestParam.h"
#import "HYPromotersApplyCodeParma.h"
#import "HYPromotersAddRequest.h"
#import "METoast.h"
#import "UIAlertView+Utils.h"
#import "HYSpaceTextField.h"
#import "HYPhotoControl.h"
#import "SingleSelectForm.h"
#import "SDWebImageDownloader.h"
#import "HYPromotersEditRequest.h"
#import "UINavigationItem+Margin.h"


@interface HYPromoterAddViewController ()
<UITextFieldDelegate,
UITableViewDataSource,
UITableViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,
SingleSelectFormDelegate,
UIAlertViewDelegate
>
{
    //自动补全
    UITableView *_autoCompleteTable;
    UIView *_autoCompleteWrapper;
    NSArray *_searchNumbers;
    
    __weak UITextField *_activeField;
    
}
@property (nonatomic, strong) NSArray *searchNumbers;
@property (nonatomic, strong) HYSearchUnPromoterCardRequestParam *numSearchRequest;
@property (nonatomic, strong) NSDictionary *selectedMember;

//ui
@property (nonatomic, strong) IBOutlet UITextField *telField;
@property (nonatomic, strong) IBOutlet HYSpaceTextField *numField;
@property (nonatomic, strong) IBOutlet UIButton *inviteBtn;
@property (nonatomic, strong) IBOutlet UITextField *aliasField;
@property (nonatomic, weak) IBOutlet UIView *photoView;
@property (nonatomic, weak) IBOutlet UIButton *submitBtn;
@property (nonatomic, weak) IBOutlet UIButton *attaBtn;

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *typeBtns;
@property (nonatomic, strong) SingleSelectForm *form;

//号码搜索
@property (nonatomic, strong) HYSearchMemberTelRequestParam *telSearchRequest;

//邀请码创建
@property (nonatomic, strong) HYPromotersApplyCodeParma *codeRequest;
@property (nonatomic, strong) NSString *getCode;

//添加操作员
@property (nonatomic, strong) HYPromotersAddRequest *addRequest;

//编辑操作员
@property (nonatomic, strong) HYPromotersEditRequest *editRequest;

//照片控件
@property (nonatomic, strong) NSMutableArray *photoControl;
@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation HYPromoterAddViewController

- (void)dealloc
{
    [_addRequest cancel];
    [_editRequest cancel];
    [_codeRequest cancel];
    [_telSearchRequest cancel];
}

- (instancetype)init
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return [self initWithNibName:@"HYPromoterAddViewController_pad" bundle:nil];
    else
        return [self initWithNibName:@"HYPromoterAddViewController_phone" bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.photos = [NSMutableArray array];
        self.action = HYAddPromoter;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加操作员";
    
    self.form = [[SingleSelectForm alloc] initWithButtons:self.typeBtns];
    _form.delegate = self;
    _form.selectedIndex = 0;
    
    UIImage * btn_n = [UIImage imageNamed:@"orderlist_btn"];
    btn_n = [btn_n stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    [self.inviteBtn setBackgroundImage:btn_n forState:UIControlStateNormal];
    [self.attaBtn setBackgroundImage:btn_n forState:UIControlStateNormal];
    [self.submitBtn setBackgroundImage:btn_n forState:UIControlStateNormal];
    
    //自动补全
    _autoCompleteWrapper = [[UIView alloc] initWithFrame:CGRectZero];
    _autoCompleteWrapper.backgroundColor = [UIColor clearColor];
    _autoCompleteWrapper.clipsToBounds = YES;
    [self.view addSubview:_autoCompleteWrapper];
    
    _autoCompleteTable = [[UITableView alloc] initWithFrame:CGRectZero];
    _autoCompleteTable.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _autoCompleteTable.delegate = self;
    _autoCompleteTable.dataSource = self;
    _autoCompleteTable.rowHeight = 25;
    if ([_autoCompleteTable respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_autoCompleteTable setSeparatorInset:UIEdgeInsetsZero];
    }
    [_autoCompleteWrapper addSubview:_autoCompleteTable];
    
    _autoCompleteWrapper.hidden = YES;
    
    //修改操作员时，加班数据并改变标题，加入返回按钮
    if (self.action == HYEditPromoter && self.promotersInfo)
    {
        self.numField.text = self.promotersInfo.number;
        self.telField.text = self.promotersInfo.phone_mob;
        [self.inviteBtn setTitle:_promotersInfo.code forState:UIControlStateNormal];
        self.aliasField.text = _promotersInfo.nickname;
        self.form.selectedIndex = _promotersInfo.promoters_type - 1;
        self.numField.enabled = NO;
        self.telField.enabled = NO;
        self.inviteBtn.enabled = NO;
        
        //下载图片
        if (_promotersInfo.imgURLs.count > 0)
        {
            self.submitBtn.enabled = NO;
        }
        for (NSString *url in _promotersInfo.imgURLs)
        {
            __weak typeof(self) b_self = self;
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
             {
                 if (!error)
                 {
                     [b_self.photos addObject:image];
                     [b_self reloadPhotos];
                     if (b_self.promotersInfo.imgURLs.count == b_self.photos.count)
                     {
                         b_self.submitBtn.enabled = YES;
                     }
                 }
                 else
                 {
                     b_self.submitBtn.enabled = YES;
                 }
             }];
        }
        
        UIImage *back = [UIImage imageNamed:@"icon_back.png"];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [btn setImage:back forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backItemAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//        self.navigationItem.leftBarButtonItem = backItem;
        [self.navigationItem setLeftBarButtonItemWithMargin:backItem];
        
        self.title = @"添加操作员";
    }
}

- (void)backItemAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clearInfo
{
    _telField.text = nil;
    _numField.text = nil;
    [_inviteBtn setTitle:@"申请邀请码" forState:UIControlStateNormal];
    _getCode = nil;
    _aliasField.text = nil;
    [self.photos removeAllObjects];
    [self reloadPhotos];
}

#pragma mark - single delegate
//- (void)singleSelectForm:(SingleSelectForm *)form didSelectedButton:(UIButton *)button atIndex:(NSInteger)idx
//{
//    
//}

#pragma mark - add promoter

- (IBAction)applyBtnAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    if (_action == HYAddPromoter)
    {
        NSString *num = _numField.text;
        num = [num stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (!num || num.length < 12) {
            [UIAlertView showMessage:@"请输入完整的会员卡号"];
            return;
        }
        NSString *tel = _telField.text;
        if (!tel || tel.length == 0) {
            [UIAlertView showMessage:@"请点击手机号码输入框以获得该卡号所绑定的手机号码"];
            return;
        }
        if (!_getCode || _getCode.length == 0)
        {
            [UIAlertView showMessage:@"点击申请邀请码按钮以获取邀请码"];
            return;
        }
        
        NSString *nickname = _aliasField.text;
        
        if (_addRequest) {
            [_addRequest cancel];
            _addRequest = nil;
            [self hideLoadingView];
        }
        _addRequest = [[HYPromotersAddRequest alloc] init];
        _addRequest.number = num;
        _addRequest.tel = tel;
        _addRequest.code = _getCode;
        _addRequest.nickname = nickname;
        _addRequest.imgs = self.photos;
        _addRequest.promoters_type = self.form.selectedIndex + 1;
        
        [self showLoadingView];
        __weak HYPromoterAddViewController *b_self = self;
        [_addRequest sendReuqest:^(id result, NSError *error)
         {
             HYPromotersAddResponse *rs = (HYPromotersAddResponse *)result;
             [b_self didGetAddPromoters:rs error:error];
         }];
    }
    else
    {
        
        NSString *nickname = _aliasField.text;
        
        if (_addRequest) {
            [_addRequest cancel];
            _addRequest = nil;
            [self hideLoadingView];
        }
        _editRequest = [[HYPromotersEditRequest alloc] init];
        _editRequest.operator_id = _promotersInfo.user_id;
        _editRequest.nickname = nickname;
        _editRequest.imgs = self.photos;
        _editRequest.promoters_type = self.form.selectedIndex + 1;
        
        [self showLoadingView];
        __weak HYPromoterAddViewController *b_self = self;
        [_editRequest sendReuqest:^(id result, NSError *error)
         {
             HYPromotersEditResponse *rs = (HYPromotersEditResponse *)result;
             [b_self didGetAddPromoters:rs error:error];
         }];
    }
}

- (void)didGetAddPromoters:(HYBaseResponse *)rs error:(NSError *)error
{
    [self hideLoadingView];
    if (rs)
    {
        if ( rs.status == 200) {
            [UIAlertView showMessage:rs.rspDesc];
            [self clearInfo];
            if (_action == HYEditPromoter)
            {
                [self.navigationController popViewControllerAnimated:YES];
                if (self.editCallback)
                {
                    self.editCallback();
                }
            }
        }
        else
        {
            [UIAlertView showMessage:rs.rspDesc];
        }
    }
    else
    {
        if (self.view.window) {
            [UIAlertView showMessage:@"网络请求异常"];
        }
    }
}

#pragma mark - get Code
- (IBAction)inviteBtnAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    if (_action == HYAddPromoter)
    {
        [self getInviteCode];
    }
}

- (void)didGetCode:(NSString *)code error:(NSError *)error
{
    if (error) {
        [UIAlertView showMessage:error.domain];
        [self.inviteBtn setTitle:@"申请邀请码" forState:UIControlStateNormal];
    }
    else if (code.length <= 0)
    {
        [UIAlertView showMessage:@"获取邀请码失败"];
        [self.inviteBtn setTitle:@"申请邀请码" forState:UIControlStateNormal];
        DebugNSLog(@"请求成功但邀请码为空");
    }
    else
    {
        self.getCode = code;
        [self.inviteBtn setTitle:code forState:UIControlStateNormal];
    }
}

- (void)getInviteCode
{
    if (_codeRequest) {
        [_codeRequest cancel];
        _codeRequest = nil;
    }
    [self showLoadingView];
    self.codeRequest = [[HYPromotersApplyCodeParma alloc] init];
    __weak HYPromoterAddViewController *b_self = self;
    [_codeRequest sendReuqest:^(id result, NSError *error)
    {
        [b_self hideLoadingView];
        HYPromotersApplyCodeResponse *rs = (HYPromotersApplyCodeResponse *)result;
        if (rs)
        {
            if (rs.status == 200) {
                [b_self didGetCode:rs.code error:nil];
            } else {
                [b_self didGetCode:rs.code error:error];
            }
        }
        else
        {
            if (self.view.window) {
                [UIAlertView showMessage:@"网络请求异常"];
            }
        }
    }];
}

#pragma mark - get tel number

- (void)searchTelWithNumber:(NSString *)num
{
    if (_telSearchRequest) {
        [_telSearchRequest cancel];
        _telSearchRequest = nil;
    }
    self.telSearchRequest = [[HYSearchMemberTelRequestParam alloc] init];
    _telSearchRequest.number = num;
    __weak HYPromoterAddViewController *b_self = self;
    [_telSearchRequest sendReuqest:^(id result, NSError *error)
    {
        HYSearchMemberTelResponse *rs = (HYSearchMemberTelResponse *)result;
        if (rs)
        {
            if (rs.status == 200 && rs.tel)
            {
                b_self.telField.text = rs.tel;
            }
            else
            {
                [UIAlertView showMessage:@"获取手机号码失败"];
                b_self.telField.text = nil;
            }
        }
        else
        {
            if (self.view.window)
            {
                [UIAlertView showMessage:@"网络请求异常"];
            }
        }
    }];
}

#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.telField)
    {
        [self.view endEditing:YES];
        NSString *num = self.numField.text;
        num = [num stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (num.length > 0) {
            [self searchTelWithNumber:num];
        }
        return NO;
    }
    _activeField = textField;
    //[self layoutTextField:YES];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _aliasField)
    {
        if (CGRectGetHeight(self.view.frame) <= 480)
        {
            CGRect frame = self.view.frame;
            frame.origin.y -= 100;
            self.view.frame = frame;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self hideAutoCompleteField];
    if (textField == _aliasField)
    {
        if (CGRectGetHeight(self.view.frame) <= 480)
        {
            CGRect frame = self.view.frame;
            frame.origin.y = 64;
            self.view.frame = frame;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //[self showAutoCompleteTableWithField:textField];
    if (textField == _numField)
    {
        NSString *result = [textField.text stringByReplacingCharactersInRange:range
                                                                   withString:string];
        result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        //搜索关联卡号
        if (result.length > 0 && result.length <= 12)
        {
            [self searchWithNumber:result withField:textField];
        }
        
        //编辑结果与原来不一样时，清空电话号码
        if (textField.text.length == 12 && result != textField.text)
        {
            _telField.text = nil;
        }
        
        return YES;
    }
    return YES;
}

#pragma mark AutoCompleteTable
- (void)searchWithNumber:(NSString *)number
               withField:(UITextField *)field
{
    static BOOL search = NO;
    if (search)
    {
        [_numSearchRequest cancel];
        _numSearchRequest = nil;
    }
    
    _numSearchRequest = [[HYSearchUnPromoterCardRequestParam alloc] init];
    _numSearchRequest.number = number;
    
    search = YES;
    __weak typeof(self) b_self = self;
    [_numSearchRequest sendReuqest:^(id result, NSError *error)
     {
         search = NO;
         
         HYSearchUnPromoterCardResponse *response = (HYSearchUnPromoterCardResponse *)result;
         if (response)
         {
             if (response.status == 200)
             {
                 b_self.searchNumbers = response.numbers;
                 [b_self showAutoCompleteTableWithField:field];
             }
         }
     }];
}

- (void)showAutoCompleteTableWithField:(UITextField *)field
{
    float height = 0;
    float maxh = 150;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGRect f = [self.view convertRect:field.frame fromView:field.superview];
        maxh = CGRectGetHeight(self.view.window.frame) - CGRectGetMaxY(f) - 216;
    }
    if (self.searchNumbers.count > 0)
    {
        height = self.searchNumbers.count * 25;
        height = height > maxh ? maxh : height;
    }
    CGRect tframe = [self.view convertRect:field.frame fromView:field.superview];
    CGRect frame = CGRectMake(CGRectGetMinX(tframe), CGRectGetMaxY(tframe), CGRectGetWidth(tframe) + 20, height);
    _autoCompleteWrapper.frame = frame;
    [_autoCompleteWrapper addBorder:1 borderColor:[UIColor grayColor]];
    //_autoCompleteTable.frame = _autoCompleteWrapper.bounds;
    
    _autoCompleteWrapper.hidden = NO;
    [_autoCompleteTable reloadData];
}

- (void)hideAutoCompleteField
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = .25;
    [_autoCompleteWrapper.layer addAnimation:animation forKey:nil];
    _autoCompleteWrapper.hidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchNumbers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"autoComplete";
    HYSearchNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[HYSearchNumberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    if (indexPath.row < self.searchNumbers.count)
    {
        HYCardSummaryInfo *card = [self.searchNumbers objectAtIndex:indexPath.row];
        NSString *number = card.number;
        cell.numberLabel.text = number;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.searchNumbers.count)
    {
        HYCardSummaryInfo *card = [self.searchNumbers objectAtIndex:indexPath.row];
        NSString *number = card.number;
        if (_activeField)
        {
            _activeField.text = number;
            [_activeField resignFirstResponder];
            [self hideAutoCompleteField];
            _activeField = nil;
        }
        if (_numSearchRequest) {
            [_numSearchRequest cancel];
            _numSearchRequest = nil;
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (_autoCompleteTable.hidden == NO)
    {
        CGPoint location = [gestureRecognizer locationInView:_autoCompleteWrapper];
        if (CGRectContainsPoint(_autoCompleteWrapper.bounds, location))
        {
            return NO;
        }
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (!_autoCompleteWrapper.hidden)
    {
        [self showAutoCompleteTableWithField:_numField];
    }
}

#pragma mark - 照片

- (IBAction)addPhoto:(id)sender
{
    [self.view endEditing:YES];
    
    if (_photos.count == 5)
    {
        [UIAlertView showMessage:@"您最多只能添加5张图片"];
    }
    else
    {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"拍照"
                                                   otherButtonTitles:@"相册", nil];
        [action showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
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
        [self reloadPhotos];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)deletePhoto:(HYPhotoControl *)control
{
    [self.photos removeObjectAtIndex:control.idx];
    [self reloadPhotos];
}

- (void)reloadPhotos
{
    if (!self.photoControl && self.photoView)
    {
        self.photoControl = [NSMutableArray array];
        CGFloat x = 5;
        CGFloat w = (CGRectGetWidth(self.photoView.frame) - 2*x) / 5;
//        CGFloat h = CGRectGetHeight(self.photoView.frame);
        for (int i = 0; i < 5; i++)
        {
            HYPhotoControl *control = [[HYPhotoControl alloc] initWithFrame:CGRectMake(x, 0, w, w)];
            //control.backgroundColor = [UIColor redColor];
            control.idx = i;
            [self.photoView addSubview:control];
            [self.photoControl addObject:control];
            [control addTargetForDeleteAction:self action:@selector(deletePhoto:)];
            [control addTargetForTouchAction:self action:@selector(photoTouch:)];
            
            x += w;
        }
    }
    
    for (int i = 0; i < 5; i++)
    {
        if (i < self.photos.count)
        {
            UIImage *img = [self.photos objectAtIndex:i];
            HYPhotoControl *control = [self.photoControl objectAtIndex:i];
            control.photo = img;
        }
        else
        {
            HYPhotoControl *control = [self.photoControl objectAtIndex:i];
            control.photo = nil;
        }
    }
}

- (void)photoTouch:(HYPhotoControl *)control
{
    
}

- (IBAction)showPrompt
{
//    [UIAlertView showMessage:@"1、员工资料：身份证正面照片1张+身份证反面照片1张+劳务合同扫描件1张+操作员申请协议扫描件1张+手持身份证及操作员申请协议1张\n2、普通商户：企业营业执照扫描件1张+操作员申请协议1张\n3、O2O商户：操作员申请协议1张"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"1、员工资料：身份证正面照片1张+身份证反面照片1张+劳务合同扫描件1张+操作员申请协议扫描件1张+手持身份证及操作员申请协议1张\n2、普通商户：企业营业执照扫描件1张+操作员申请协议1张\n3、O2O商户：操作员申请协议1张" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alert.tag = 1024;
    [alert show];
}

//- (void)willPresentAlertView:(UIAlertView *)alertView
//{
//    for (UIView *view in alertView.subviews)
//    {
//        if ([view isKindOfClass:[UILabel class]])
//        {
//            UILabel *label = (UILabel *)view;
//            label.textAlignment = NSTextAlignmentLeft;
//        }
//    }
//}

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
