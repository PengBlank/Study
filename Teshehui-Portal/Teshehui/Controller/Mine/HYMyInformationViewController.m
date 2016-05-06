//
//  HYMyInformationViewController.m
//  Teshehui
//
//  Created by Kris on 15/9/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMyInformationViewController.h"
#import "HYLoginV2InputCell.h"
#import "HYLoginV2RadioCell.h"
#import "HYLoginV2SelectCell.h"
#import "HYCardTypeListViewController.h"
#import "HYCardType.h"
#import "HYRealnameConfirmViewController.h"
#import "HYMyInfoInputViewController.h"
#import "HYUserInfo.h"
#import "HYUserUpdateInfoReq.h"
#import "HYUserUpdateInfoResponse.h"
#import "METoast.h"
#import "HYRealnameConfirmViewController.h"
#import "HYGetPersonRequest.h"
#import "HYGetPersonResponse.h"
#import "NSString+Common.h"
#import "HYMyInfoHeadPortraitCell.h"
#import "HYImageUtilGetter.h"
#import "HYUserPortraitRequest.h"
#import "HYBaseLineHeadView.h"

@interface HYMyInformationViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
UIActionSheetDelegate,
HYCardTypeListViewControllerDelegate,
GetUserInfoDelegate,
HYMyInfoInputViewControllerDelegate
>
{
    HYUserUpdateInfoReq *_userUpdateInfoReq;
    HYGetPersonRequest* _getUserInfoReq;
    HYUserPortraitRequest *_portraitRequest;
    
    BOOL _isLoading;
    BOOL _isLogin;
}


@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *toConfrmLabel;
@property (nonatomic, strong) UIButton *toConfirm;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *idAuth;


@property (nonatomic, assign) BOOL isLoading;

//@property (nonatomic, assign) NSInteger sex;
//@property (nonatomic, strong) NSString *idNum;
//@property (nonatomic, copy) NSString *cardNum;
//@property (nonatomic, copy) NSString *cellphoneNum;
//@property (nonatomic, copy) NSString *email;
//@property (nonatomic, strong) NSString *userName;

@end

@implementation HYMyInformationViewController

-(instancetype)initWithAuthType:(NSString *)type
{
    _idAuth = type;
    return [self initWithNibName:@"HYMyInformationViewController" bundle:nil];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _cardInfo.certifacateCode = @"01";
        _cardInfo.certifacateName = @"身份证";
    }
    return self;
}

- (void)dealloc
{
    if (_callback)
    {
        _callback(_idAuth);
    }
    
    [_userUpdateInfoReq cancel];
    _userUpdateInfoReq = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人资料";
    
    //如果为非认证会员
//    CGRect frame = [UIScreen mainScreen].bounds;
//    if (![self.userInfo.idAuthentication isEqualToString:@"1"])
//    {
//        frame.size.height -= 150;
//    }
//    else
//    {
//        frame.size.height -= 120;
//    }
    
    //tableview
//    _tableView.frame = frame;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = TFScalePoint(44);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[HYLoginV2InputCell class] forCellReuseIdentifier:@"input"];
    [_tableView registerClass:[HYLoginV2InputCell class] forCellReuseIdentifier:@"radio"];
    [_tableView registerClass:[HYLoginV2SelectCell class] forCellReuseIdentifier:@"select"];
    [_tableView registerClass:[HYMyInfoHeadPortraitCell class] forCellReuseIdentifier:@"head"];
    
    if (![_idAuth boolValue])
    {
        [self setupNavItem];
    }
    //button
    /*
    UIImage *image = [[UIImage imageNamed:@"myinfo_saveBtn"]stretchableImageWithLeftCapWidth:5
                                                                                topCapHeight:10];
    [_saveBtn setBackgroundImage:image
                        forState:UIControlStateNormal];
    [_saveBtn setTitle:@"保  存" forState:UIControlStateNormal];
    [_saveBtn addTarget:self
                 action:@selector(saveData)
       forControlEvents:UIControlEventTouchDown];
    [_saveBtn setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateNormal];
    _saveBtn.frame = CGRectMake(TFScalePoint(30),
                                CGRectGetMaxY(_tableView.frame) + TFScalePoint(10),
                                TFScalePoint(260),
                                TFScalePoint(30));
     */
    
    /*
    if (![_userInfo.idAuthentication isEqualToString:@"1"])
    {
        _toConfrmLabel.frame = CGRectMake(frame.size.width-TFScalePoint(90),
                                          CGRectGetMaxY(_saveBtn.frame)+5,
                                          TFScalePoint(80),
                                          TFScalePoint(30));
        
        _toConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
        _toConfirm.backgroundColor = [UIColor clearColor];
        [_toConfirm addTarget:self
                       action:@selector(toConfirmAction)
             forControlEvents:UIControlEventTouchUpInside];
        _toConfirm.frame = CGRectMake(frame.size.width-TFScalePoint(90),
                                      CGRectGetMaxY(_saveBtn.frame)+5,
                                      TFScalePoint(80),
                                      TFScalePoint(30));
        [self.view addSubview:_toConfirm];
    }
    else
    {
        _toConfrmLabel.hidden = YES;
    }
     */
    
    [self updateUserInfo];
    
    [_tableView reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden = NO;
    
    _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
}


//autolayout
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    CGRect frame = _toConfrmLabel.frame;
//    _toConfirm.frame = frame;

}

#pragma mark private methods
- (void)setupNavItem
{
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 80, 15);
    [saveBtn addTarget:self action:@selector(toConfirmAction) forControlEvents:UIControlEventTouchDown];
    [saveBtn setTitle:@"实名登记" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [saveBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)getImage
{
    __weak typeof(self) b_self = self;
    UIViewController *root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [[HYImageUtilGetter sharedImageGetter] getImageInView:root.view callback:^(UIImage *img)
     {
         if (img)
         {
             [b_self uploadImage:img];
         }
     }];
}

- (void)uploadImage:(UIImage *)img
{
    if (_portraitRequest)
    {
        [_portraitRequest cancel];
    }
    _portraitRequest = [[HYUserPortraitRequest alloc] init];
    _portraitRequest.userId = self.userInfo.userId;
    _portraitRequest.portrait = img;
    __weak typeof(self) b_self = self;
    [_portraitRequest sendReuqest:^(HYUserPortraitResponse* result, NSError *error)
     {
         [b_self updateUserInfo];
     }];
}

- (void)toConfirmAction
{
    [self.view endEditing:YES];
    
    HYRealnameConfirmViewController *vc = [[HYRealnameConfirmViewController alloc]initWithNibName:@"HYRealnameConfirmViewController" bundle:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateWithUpgradeResponse:(HYUserUpdateInfoResponse *)response error:(NSError *)error
{
    
}

- (void)saveData
{
    if(!_isLoading)
    {
        _isLoading = YES;
        if (!_userUpdateInfoReq)
        {
            _userUpdateInfoReq = [[HYUserUpdateInfoReq alloc] init];
        }
        
        _userUpdateInfoReq.nickName = _nickName;
        _userUpdateInfoReq.sex = hyGetJavaSexStringFromSex(_sex);
        _userUpdateInfoReq.email = _email;
        
        [HYLoadHubView show];
        __weak typeof(self) b_self = self;
        [_userUpdateInfoReq sendReuqest:^(HYUserUpdateInfoResponse *result, NSError *error)
         {
             [HYLoadHubView dismiss];
             b_self.isLoading = NO;
             if (200 == result.status)
             {
                 [b_self updateWithUpgradeResponse:result error:error];
                 b_self.userInfo.nickName = b_self.nickName;
                 b_self.userInfo.localSex = b_self.sex;
                 b_self.userInfo.email = b_self.email;
                 [b_self.userInfo saveData];
                 [b_self.tableView reloadData];
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                message:result.suggestMsg
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                 [alert show];
             }
         }];
    }
}

- (void)gotoEditType:(MyInfoEditType)type withValue:(NSString *)value
{
    HYMyInfoInputViewController *vc = [[HYMyInfoInputViewController alloc] init];
    vc.editType = type;
    vc.delegate = self;
    vc.text = value;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

#pragma mark tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HYBaseLineHeadView *head = [[HYBaseLineHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    head.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
    return head;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //first get total rows in that section by current indexPath.
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow -1)
    {
        //this is the last row in section.
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 65;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            HYMyInfoHeadPortraitCell *head = [tableView dequeueReusableCellWithIdentifier:@"head" forIndexPath:indexPath];
            head.textLabel.text = @"头像";
            [head setUserInfo:_userInfo];
            return head;
        }
        else if(1 == indexPath.row)
        {
            HYLoginV2SelectCell *input = [tableView dequeueReusableCellWithIdentifier:@"select" forIndexPath:indexPath];
            input.textLabel.text = @"真实姓名";
            input.detailTextLabel.text = _userInfo.realName;
            input.selectEnable = NO;
            return input;
        }
        else if (2 == indexPath.row)
        {
            HYLoginV2SelectCell *input = [tableView dequeueReusableCellWithIdentifier:@"select" forIndexPath:indexPath];
            input.textLabel.text = @"昵称";
            input.detailTextLabel.text = _nickName ? _nickName : _userInfo.nickName;
            return input;
        }
        else if (3 == indexPath.row)
        {
            HYLoginV2SelectCell *input = [tableView dequeueReusableCellWithIdentifier:@"select" forIndexPath:indexPath];
            if (_userInfo.localSex == HYSexMale) {
                input.detailTextLabel.text = @"男";
            }
            else if (_userInfo.localSex == HYSexFemale) {
                input.detailTextLabel.text = @"女";
            }
            else {
                input.detailTextLabel.text = @"未知";
            }
            input.textLabel.text = @"性别";
            
            /// 如果服务器下发了就不能再更改
            if (_userInfo.localSex != HYSexUnknown &&
                _userInfo.idAuthentication.integerValue == 1)
            {
                input.selectEnable = NO;
            }
            else
            {
                input.selectEnable = YES;
            }
            return input;
        }
        else if (4 == indexPath.row)
        {
            HYLoginV2SelectCell *input = [tableView dequeueReusableCellWithIdentifier:@"select" forIndexPath:indexPath];
            //此处的cell要设置样式不然detaillabel无法显示
            input.textLabel.text = @"证件类型";
            input.accessoryType = UITableViewCellAccessoryNone;
            input.userInteractionEnabled = NO;
            input.detailTextLabel.text = _userInfo.certificateName;
            input.rightArrow.hidden = YES;
            return input;
        }
        else
        {
            HYLoginV2SelectCell *input = [tableView dequeueReusableCellWithIdentifier:@"select" forIndexPath:indexPath];
            input.textLabel.text = @"证件号码";
            input.detailTextLabel.text = [NSString turnToSecurityNum:_userInfo.certificateNumber];
            input.selectEnable = NO;
            return input;
        }
    }
    else
    {
        if (0 == indexPath.row)
        {
            HYLoginV2SelectCell *input = [tableView dequeueReusableCellWithIdentifier:@"select" forIndexPath:indexPath];
            input.textLabel.text = @"卡号";
            input.detailTextLabel.text = _userInfo.number;
            input.selectEnable = NO;
            return input;
        }
        else if (1 == indexPath.row)
        {
            HYLoginV2SelectCell *input = [tableView dequeueReusableCellWithIdentifier:@"select" forIndexPath:indexPath];
            input.textLabel.text = @"手机号";
            input.detailTextLabel.text = _userInfo.mobilePhone;
            input.selectEnable = NO;
            return input;
        }
        else
        {
            HYLoginV2SelectCell *input = [tableView dequeueReusableCellWithIdentifier:@"select" forIndexPath:indexPath];
            input.textLabel.text = @"电子邮箱";
            input.detailTextLabel.text = _email ? _email : _userInfo.email;
            input.selectEnable = YES;
            return input;
        }
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 6 : 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //关闭编辑事件
    [self.view endEditing:YES];
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                [self getImage];
                break;
            case 2:  //nickname
                [self gotoEditType:NickNameEdit withValue:(_nickName?_nickName:_userInfo.nickName)];
                break;
            case 3:
            {
                UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                  delegate:self
                                                         cancelButtonTitle:@"取消"
                                                    destructiveButtonTitle:@"男"
                                                         otherButtonTitles:@"女",nil];
                [sheet showInView:self.view];
            }
                break;
            case 4:
            {
                HYCardTypeListViewController *vc = [[HYCardTypeListViewController alloc] init];
                vc.navbarTheme = self.navbarTheme;
                vc.title = @"选择证件类型";
                vc.delegate = self;
                vc.type = UseForBuyInsourance;
                vc.navbarTheme = self.navbarTheme;
                vc.selectedCard = self.cardInfo;
                [self.navigationController pushViewController:vc
                                                     animated:YES];
            }
                break;
            default:
                break;
        }
    }
    else if (1 == indexPath.section)
    {
        switch (indexPath.row)
        {
            case 2:
                [self gotoEditType:EmailEdit withValue:_email?_email:_userInfo.email];
                break;
            default:
                break;
        }
    }
}

#pragma mark - HYMyInfoInputViewControllerDelegate
- (void)didEditFinished:(NSString *)text type:(MyInfoEditType)type
{
    switch (type)
    {
        case EmailEdit:
            self.email = text;
            break;
        case NickNameEdit:
            self.nickName = text;
            break;
        default:
            break;
    }
    
    [self saveData];
    [self.tableView reloadData];
}

#pragma mark actionsheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        _sex = buttonIndex + 1;
        
        [self saveData];
        [self.tableView reloadData];
    }
}

#pragma mark - HYCardTypeListViewControllerDelegate
- (void)didSelectCardtype:(HYCardType *)card
{
    self.cardInfo = card;
    [self.tableView reloadData];
}

#pragma mark GetUserInfoDelegate
-(void)updateUserInfo
{
    if (!_getUserInfoReq)
    {
        _getUserInfoReq = [[HYGetPersonRequest alloc] init];
        
    }
    _getUserInfoReq.userId = [HYUserInfo getUserInfo].userId;
    
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_getUserInfoReq sendReuqest:^(id result, NSError *error)
     {
         [HYLoadHubView dismiss];
         if (result && [result isKindOfClass:[HYGetPersonResponse class]])
         {
             HYGetPersonResponse *response = (HYGetPersonResponse *)result;
             if (response.status == 200)
             {
                 [b_self updateWithUserInfo:response.userInfo];
             }else
             {
                 [METoast toastWithMessage:response.suggestMsg];
             }
         }
     }];
}

- (void)updateWithUserInfo:(HYUserInfo *)userInfo
{
    _userInfo = userInfo;
    
    _idAuth = userInfo.idAuthentication;
    if (_idAuth.boolValue) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    _sex = userInfo.localSex;
    
    [self.tableView reloadData];
}

@end
