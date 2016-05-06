//
//  HYAddCardViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-15.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAddCardViewController.h"
#import "HYAgencyDataRequestParam.h"
#import "HYAgencyDataInfo.h"
#import "HYPopSelectViewController.h"
#import "HYAddVIPCardRequestParma.h"
#import "HYSingleAddCardRequestParam.h"
#import "UIAlertView+Utils.h"
#import "HYAddCardSearchParam.h"
#import "UIView+FrameUtils.h"

#define kMultiPubTag 1001
#define kSinglePubTag 1002


@interface HYAddCardViewController ()
<
HYPopSelectViewDelegate
>
{
    UIPopoverController *_popController;
    
    NSInteger _mulPubAgencyIdx;
    NSInteger _singlePubAgencyIdx;
}

@property (nonatomic, strong) HYAgencyDataRequestParam *agencyListRequest;
@property (nonatomic, strong) HYAddVIPCardRequestParma *mulPubRequest;
@property (nonatomic, strong) HYSingleAddCardRequestParam *singlePubRequest;
@property (nonatomic, strong) HYAddCardSearchParam *cardSearchRequest;
@property (nonatomic, strong) NSArray *agencyList;

@end

@implementation HYAddCardViewController

- (void)dealloc
{
    [_agencyListRequest cancel];
    [_mulPubRequest cancel];
    [_singlePubRequest cancel];
    [_cardSearchRequest cancel];
    [self hideLoadingView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    _publicView = [HYPublicView instanceView];
    self.view = _publicView;
    _publicView.delegate = self;
    _publicView.agencyName = @"运营中心";
    _publicView.titleName1 = @"批量分配会员卡";
    _publicView.titleName2 = @"单张分配会员卡";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"分配会员卡";
    
    [_publicView.allSelectBtn addTarget:self action:@selector(agencyListBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_publicView.allSubmitBtn addTarget:self action:@selector(transmitMultiPubData) forControlEvents:UIControlEventTouchUpInside];
    [_publicView.singleSelectBtn addTarget:self action:@selector(agencyListBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_publicView.singleSubmitBtn addTarget:self action:@selector(transmitSinglePubData) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)loadAgencyList
{
    [self fetchAgencyListFromNet];
    
    [self.publicView resetSelectBtn];
    
    _mulPubAgencyIdx = -1;
    _singlePubAgencyIdx = -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)n
{
    //[self layoutTextField:YES];
}

- (void)keyboardWillHide:(NSNotification *)n
{
    [self.publicView keyboardHide];
}

- (void)keyboardWillChange:(NSNotification *)n
{
    
}


#pragma mark - 选择票务中心

- (void)agencyListBtnClicked:(UIButton *)btn
{
    if (_agencyList.count > 0) {
        
        [self.view endEditing:YES];
        
        NSMutableArray *names = [NSMutableArray array];
        for (HYAgencyDataInfo *info in _agencyList) {
            [names addObject:info.name];
        }
        
        HYPopSelectViewController *select = [[HYPopSelectViewController alloc] init];
        select.title = @"选择运营中心";
        select.dataArray = names;
        select.associatedControl = btn;
        select.delegate = self;
        
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

- (void)becomeState:(SlideState)slideState
{
    [super becomeState:slideState];
    
    if (slideState == Open)
    {
        [self.view endEditing:YES];
    }
}

#pragma mark -
#pragma mark Internet

- (void)fetchAgencyListFromNet
{
    if (_agencyListRequest) {
        [_agencyListRequest cancel];
        _agencyListRequest = nil;
    }
    _agencyListRequest = [[HYAgencyDataRequestParam alloc] init];
    [self showLoadingView];
    __weak typeof(self) _self = self;
    [self.agencyListRequest sendReuqest:^(id result, NSError *error)
    {
        [_self hideLoadingView];
        
        if ([result isKindOfClass:[HYAgencyDataResponse class]])
        {
            HYAgencyDataResponse *response = (HYAgencyDataResponse *)result;
            if (response.status == 200)
            {
                _self.agencyList = [response.agencyDataList copy];
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

- (HYAddVIPCardRequestParma *)mulPubRequest
{
    if (!_mulPubRequest) {
        _mulPubRequest = [[HYAddVIPCardRequestParma alloc] init];
    }
    return _mulPubRequest;
}

- (void)transmitMultiPubData
{
    [self.view endEditing:YES];
    
    if (_mulPubAgencyIdx == -1)
    {
        [UIAlertView showMessage:@"请选择运营中心"];
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
    
    [self showLoadingView];
    
    HYAgencyDataInfo *agency = [self.agencyList objectAtIndex:_mulPubAgencyIdx];
    self.mulPubRequest.start_number = from;
    self.mulPubRequest.end_number = end;
    self.mulPubRequest.agency_id = agency.m_id;
    
    __weak typeof(self) b_self = self;
    [self.mulPubRequest sendReuqest:^(id result, NSError *error)
    {
        [b_self hideLoadingView];
        
        if ([result isKindOfClass:[HYAddVIPCardReponse class]])
        {
            HYAddVIPCardReponse *response = (HYAddVIPCardReponse *)result;
            if (response.status == 200 &&
                response.count > 0)
            {
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

- (HYSingleAddCardRequestParam *)singlePubRequest
{
    if (!_singlePubRequest) {
        _singlePubRequest = [[HYSingleAddCardRequestParam alloc] init];
    }
    return _singlePubRequest;
}

- (void)transmitSinglePubData
{
    [self.view endEditing:YES];
    
    if (_singlePubAgencyIdx == -1) {
        [UIAlertView showMessage:@"请选择运营中心"];
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
    
    [self showLoadingView];
    HYAgencyDataInfo *agency = [self.agencyList objectAtIndex:_singlePubAgencyIdx];
    self.singlePubRequest.number = number;
    self.singlePubRequest.agency_id = agency.m_id;
    
    __weak typeof(self) b_self = self;
    [self.singlePubRequest sendReuqest:^(id result, NSError *error)
    {
        [b_self hideLoadingView];
        
        if ([result isKindOfClass:[HYSingleAddCardResponse class]])
        {
            HYSingleAddCardResponse *response = (HYSingleAddCardResponse *)result;
            if (response.status == 200 &&
                response.number.length > 0)
            {
                NSString *msg = [NSString stringWithFormat:@"会员卡%@分配成功", response.number];
                [UIAlertView showMessage:msg];
                [_publicView resetNumber];
            }
            else
            {
                [UIAlertView showMessage:response.rspDesc];
                //[UIAlertView showMessage:@"分配会员卡失败"];
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

- (HYAddCardSearchParam *)cardSearchRequest
{
    if (!_cardSearchRequest)
    {
        _cardSearchRequest = [[HYAddCardSearchParam alloc] init];
    }
    return _cardSearchRequest;
}

- (void)didGetNumber:(NSString *)number endNumber:(NSString *)endNumber
{
    [self searchWithNumber:number endNumber:endNumber withField:nil];
}

- (void)didGetSigleNumber:(NSString *)number
{
    [self searchWithNumber:number endNumber:nil withField:nil];
}

- (void)searchWithNumber:(NSString *)number
               endNumber:(NSString *)endNumber
               withField:(UITextField *)field
{
    static BOOL search = NO;
    if (search)
    {
        [self.cardSearchRequest cancel];
    }
    
    self.cardSearchRequest.number = number;
    self.cardSearchRequest.end_number = endNumber;
    
    search = YES;
    __weak typeof(self) _self = self;
    [self.cardSearchRequest sendReuqest:^(id result, NSError *error)
    {
        search = NO;
        
        HYAddCardSearchResponse *response = (HYAddCardSearchResponse *)result;
        if (response.status == 200)
        {
            [_self.publicView setNumberSearchResult:response.numbers];
        }
    }];
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
