//
//  HYPromoterCardMoveViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPromoterCardMoveViewController.h"
#import "HYPopSelectViewController.h"
#import "UIAlertView+Utils.h"
#import "UIView+FrameUtils.h"
#import "HYKeyboardHandler.h"

#import "HYPromoterSelectListRequest.h"
#import "HYSearchInactiveBatchParam.h"

//转移会员卡请求
#import "HYInactiveBatchMigrateParam.h"
#import "HYInactiveSingleMigrateParam.h"

#define kMultiPubTag 1001
#define kSinglePubTag 1002

@interface HYPromoterCardMoveViewController ()
<
HYPopSelectViewDelegate,
HYKeyboardHandlerDelegate
>
{
    UIPopoverController *_popController;
    
    NSInteger _mulPubAgencyIdx;
    NSInteger _singlePubAgencyIdx;
}

@property (nonatomic, strong) HYKeyboardHandler *keyboardHandler;

//操作员列表，选择
@property (nonatomic, strong) HYPromoterSelectListRequest *agencyListRequest;
@property (nonatomic, strong) NSArray *agencyList;

//未关联未激活会员卡
@property (nonatomic, strong) HYSearchInactiveBatchParam *cardSearchRequest;

@property (nonatomic, strong) HYInactiveBatchMigrateParam *mulPubRequest;
@property (nonatomic, strong) HYInactiveSingleMigrateParam *singlePubRequest;

@end

@implementation HYPromoterCardMoveViewController

- (void)dealloc
{
    [_agencyListRequest cancel];
    [_cardSearchRequest cancel];
    [_mulPubRequest cancel];
    [_singlePubRequest cancel];
    [self hideLoadingView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.keyboardHandler = [[HYKeyboardHandler alloc] init];
        self.keyboardHandler.tapToDismiss = NO;
    }
    return self;
}

- (void)loadView
{
    _publicView = [HYPublicView instanceView];
    self.view = _publicView;
    _publicView.delegate = self;
    _publicView.agencyName = @"操作员";
    _publicView.titleName1 = @"批量指定操作员";
    _publicView.titleName2 = @"单张指定操作员";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"指定操作员";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [_publicView.allSelectBtn addTarget:self action:@selector(agencyListBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_publicView.singleSelectBtn addTarget:self action:@selector(agencyListBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_publicView.allSubmitBtn addTarget:self action:@selector(transmitMultiPubData) forControlEvents:UIControlEventTouchUpInside];
    [_publicView.singleSubmitBtn addTarget:self action:@selector(transmitSinglePubData) forControlEvents:UIControlEventTouchUpInside];
    
    self.keyboardHandler.view = self.view;
    self.keyboardHandler.delegate = self;
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
}

//- (void)keyboardShow;
//- (void)keyboardChangeFrame:(CGRect)kFrame;
- (void)keyboardHide
{
    [self.publicView keyboardHide];
}

#pragma mark - move card, single or multiple
- (void)transmitMultiPubData
{
    [self.view endEditing:YES];
    
    if (_mulPubAgencyIdx == -1)
    {
        [UIAlertView showMessage:@"请选择操作员"];
        return;
    }
    NSString *from;
    NSString *end;
    [_publicView getNumber:&from endNumber:&end];
    if (from.length == 0 || end.length == 0)
    {
        [UIAlertView showMessage:@"请输入起始和结束卡号"];
        return;
    }
    if (from.length != 12 || end.length != 12)
    {
        [UIAlertView showMessage:@"会员卡号需要12位"];
        return;
    }
    
    _mulPubRequest = [[HYInactiveBatchMigrateParam alloc] init];
    HYPromoterSelectInfo *agency = [self.agencyList objectAtIndex:_mulPubAgencyIdx];
    self.mulPubRequest.start = from;
    self.mulPubRequest.end = end;
    self.mulPubRequest.user_id = agency.user_id;
    
    [self showLoadingView];
    __weak typeof(self) b_self = self;
    [self.mulPubRequest sendReuqest:^(id result, NSError *error)
     {
         [b_self hideLoadingView];
         
         if ([result isKindOfClass:[HYInactiveBatchMigrateResponse class]])
         {
             HYInactiveBatchMigrateResponse *response = (HYInactiveBatchMigrateResponse *)result;
             if (response.status == 200)
             {
                 [UIAlertView showMessage:response.rspDesc];
                 [_publicView resetNumber];
             }
             else
             {
                 [UIAlertView showMessage:response.rspDesc];
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

- (void)transmitSinglePubData
{
    [self.view endEditing:YES];
    
    if (_singlePubAgencyIdx == -1) {
        [UIAlertView showMessage:@"请选择操作员"];
        return;
    }
    NSString *number;
    [_publicView getNumber:&number];
    if (number.length == 0) {
        [UIAlertView showMessage:@"请输入卡号"];
        return;
    }
    if (number.length != 12)
    {
        [UIAlertView showMessage:@"卡号需要12位"];
        return;
    }
    
    if (_singlePubRequest) {
        [_singlePubRequest cancel];
        _singlePubRequest = nil;
    }
    _singlePubRequest = [[HYInactiveSingleMigrateParam alloc] init];
    
    HYPromoterSelectInfo *agency = [self.agencyList objectAtIndex:_singlePubAgencyIdx];
    self.singlePubRequest.card_number = number;
    self.singlePubRequest.user_id = agency.user_id;
    __weak typeof(self) b_self = self;
    [self showLoadingView];
    [self.singlePubRequest sendReuqest:^(id result, NSError *error)
     {
         [b_self hideLoadingView];
         
         if ([result isKindOfClass:[HYInactiveSingleMigrateResponse class]])
         {
             HYInactiveSingleMigrateResponse *response = (HYInactiveSingleMigrateResponse *)result;
             if (response.status == 200)
             {
                 //NSString *msg = [NSString stringWithFormat:@"会员卡%@分配成功", response.number];
                 NSString *msg = response.rspDesc;
                 [UIAlertView showMessage:msg];
                 [_publicView resetNumber];
             }
             else
             {
                 [UIAlertView showMessage:response.rspDesc];
                 //[UIAlertView showMessage:@"添加会员卡失败"];
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

#pragma mark - get promoter list to select

- (void)loadPromoterList
{
    [self fetchAgencyListFromNet];
    
    [self.publicView resetSelectBtn];
    
    _mulPubAgencyIdx = -1;
    _singlePubAgencyIdx = -1;
}

- (void)fetchAgencyListFromNet
{
    if (self.agencyListRequest) {
        [self.agencyListRequest cancel];
        self.agencyListRequest = nil;
    }
    self.agencyListRequest = [[HYPromoterSelectListRequest alloc] init];
    
    [self showLoadingView];
    __weak typeof(self) b_self = self;
    [self.agencyListRequest sendReuqest:^(id result, NSError *error)
     {
         [b_self hideLoadingView];
         
         HYPromoterSelectListResponse *rs = (HYPromoterSelectListResponse *)result;
         if (rs)
         {
             if (rs.status == 200)
             {
                 HYPromoterSelectListResponse *response = (HYPromoterSelectListResponse *)result;
                 b_self.agencyList = [response.promoterList copy];
             }
             else {
                 [UIAlertView showMessage:rs.rspDesc];
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

#pragma mark - 选择票务中心

- (void)agencyListBtnClicked:(UIButton *)btn
{
    if (_agencyList.count > 0) {
        
        [self.view endEditing:YES];
        
        NSMutableArray *names = [NSMutableArray array];
        for (HYPromoterSelectInfo *info in _agencyList) {
            [names addObject:info.real_name];
        }
        
        HYPopSelectViewController *select = [[HYPopSelectViewController alloc] init];
        select.dataArray = names;
        select.associatedControl = btn;
        select.delegate = self;
        select.title = @"选择操作员";
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            _popController = [[UIPopoverController alloc] initWithContentViewController:select];
            [_popController presentPopoverFromRect:btn.frame inView:btn.superview permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
        else
        {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:select];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

- (void)popSelectView:(HYPopSelectViewController *)select didSelectIndex:(NSInteger)selectIdx andGetString:(NSString *)getString
{
    UIButton *btn = (UIButton *)select.associatedControl;
    
    [btn setTitle:getString forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self dismissPopoverController];
    
    if (select.associatedControl == _publicView.singleSelectBtn) {
        _singlePubAgencyIdx = selectIdx;
    }
    if (select.associatedControl == _publicView.allSelectBtn) {
        _mulPubAgencyIdx = selectIdx;
    }
}

- (void)dismissPopoverController
{
    if (_popController)
    {
        [_popController dismissPopoverAnimated:YES];
        _popController = nil;
    }
}

#pragma mark - Card search
- (void)didGetNumber:(NSString *)number endNumber:(NSString *)endNumber
{
    [self searchWithNumber:number endNumber:endNumber withType:1];
}

- (void)didGetSigleNumber:(NSString *)number
{
    [self searchWithNumber:number endNumber:nil withType:0];
}

- (void)searchWithNumber:(NSString *)number
               endNumber:(NSString *)endNumber
               withType:(NSInteger)type
{
    static BOOL search = NO;
    if (search)
    {
        [_cardSearchRequest cancel];
        _cardSearchRequest = nil;
    }
    
    self.cardSearchRequest = [[HYSearchInactiveBatchParam alloc] init];
    self.cardSearchRequest.start_number = number;
    self.cardSearchRequest.end_number = endNumber;
    self.cardSearchRequest.type = type;
    
    search = YES;
    __weak typeof(self) _self = self;
    [self.cardSearchRequest sendReuqest:^(id result, NSError *error)
     {
         search = NO;
         
         HYSearchInactiveBatchResponse *rs = (HYSearchInactiveBatchResponse *)result;
         if (rs.status == 200)
         {
             [_self.publicView setNumberSearchResult:rs.cardList];
         }
     }];
}

#pragma mark - super...
- (void)becomeState:(SlideState)slideState
{
    [super becomeState:slideState];
    
    if (slideState == Open)
    {
        [self.view endEditing:YES];
    }
}

#pragma mark -

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (![_publicView gestureRecognizerShouldBegin:gestureRecognizer])
    {
        return NO;
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
