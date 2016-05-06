
//  HYPhoneChargeViewController.m
//  Teshehui
//
//  Created by 成才 向 on 16/2/25.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYPhoneChargeViewController.h"
#import "HYHYMallOrderListFilterView.h"
#import "HYPhoneNumberView.h"
#import "HYChargeSelectViewController.h"
#import "HYFlowSelectViewController.h"
#import "HYKeyboardHandler.h"
#import "HYNumberHistoryView.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "METoast.h"
#import "HYPhoneChargeOrder.h"
#import "HYPaymentViewController.h"
#import "HYPhoneChargeOrderListViewController.h"
#import "HYMineInfoViewController.h"
#import "NSString+Addition.h"
#import "UIAlertView+BlocksKit.h"

@interface HYPhoneChargeViewController ()
<
UIGestureRecognizerDelegate,
ABPeoplePickerNavigationControllerDelegate
>
{
    NSUInteger _childCtrlerType;
}



@property (nonatomic, strong) HYPhoneNumberView *numberView;
@property (nonatomic, strong) HYHYMallOrderListFilterView *filterView;
@property (nonatomic, strong) HYChargeSelectViewController *chargeSelect;
@property (nonatomic, strong) HYFlowSelectViewController *flowSelect;
@property (nonatomic, weak) UIViewController *currSelectView;
- (void)showSelectView:(UIViewController *)ctrl;

@property (nonatomic, strong) HYKeyboardHandler *keyboardHandler;
@property (nonatomic, strong) HYNumberHistoryView *historyView;

@end

@implementation HYPhoneChargeViewController

#pragma mark - life cycle
- (void)dealloc
{
    [_keyboardHandler stopListen];
}

- (instancetype)initWithChildControllerType:(ChargeTypeController)type
{
    if(self = [super init])
    {
        _childCtrlerType = type;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= 64;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor colorWithWhite:.96 alpha:1];
    
    HYHYMallOrderListFilterView *filter = [[HYHYMallOrderListFilterView alloc]
                                           initWithFrame:CGRectMake(0, 0, frame.size.width, 45)];
    filter.conditions = @[@"充话费", @"充流量"];
    filter.backgroundColor = [UIColor whiteColor];
    filter.currentIndex = _childCtrlerType;
    [filter addTarget:self
               action:@selector(filterAction)
     forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:filter];
    self.filterView = filter;
    
    WS(weakSelf);
    self.chargeSelect = [[HYChargeSelectViewController alloc] init];
    self.chargeSelect.delegate = self;
    
    HYPhoneNumberView *number = [[HYPhoneNumberView alloc] initWithFrame:
                                 CGRectMake(0,
                                            CGRectGetMaxY(filter.frame)+10,
                                            frame.size.width,
                                            TFScalePoint(80))];
    number.type = _childCtrlerType;
    number.didGetPhone = ^(NSString *phone) {
        [weakSelf didGetNumber:phone];
    };
    number.didSelectAddressBook = ^{
        [weakSelf showAddressBook];
    };
    [self.view addSubview:number];
    self.numberView = number;
    
    self.flowSelect = [[HYFlowSelectViewController alloc] init];
    self.flowSelect.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"手机充值";
    
    UIButton *orderListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderListBtn.frame = CGRectMake(0, 0, 100, 30);
    [orderListBtn setTitleColor:[UIColor colorWithRed:35/255.0f
                                                green:35/255.0f
                                                 blue:35/255.0f
                                                alpha:1.0f] forState:UIControlStateNormal];
    [orderListBtn setTitle:@"充值记录" forState:UIControlStateNormal];
    orderListBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [orderListBtn addTarget:self action:@selector(goToPhoneChargeOrderList:)
           forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithCustomView:orderListBtn];
    
    [self filterAction];
    
    /// 点击取消编辑状态
    UITapGestureRecognizer *etap = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self
                                    action:@selector(editTap)];
    etap.delegate = self;
    etap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:etap];
}

#pragma mark - setter getter

#pragma mark - event
- (void)filterAction
{
    
    if (self.filterView.currentIndex == 0) {
        _numberView.type = PhoneChargeController;
        [self showSelectView:self.chargeSelect];
    }
    else {
        _numberView.type = FlowChargeController;
        [self showSelectView:self.flowSelect];
        if (self.numberView.phone) {
            self.flowSelect.phoneNumber = self.numberView.phone;
        }
    }
}

- (void)editTap
{
    [self.view endEditing:YES];
}

#pragma mark - functions
#pragma mark -- public

#pragma mark -- private
/**
 * 跳转充值记录页面
 */
- (void)goToPhoneChargeOrderList:(UIButton *)btn
{
    HYPhoneChargeOrderListViewController *vc = [[HYPhoneChargeOrderListViewController alloc] init];
    // 默认展示话费充值订单列表
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didGetNumber:(NSString *)number
{
    if (_currSelectView == self.flowSelect) {
        self.flowSelect.phoneNumber = number;
    }
    else {
        
    }
}

- (void)showAddressBook
{
    ABAuthorizationStatus authStatus =
    ABAddressBookGetAuthorizationStatus();
    if (authStatus == kABAuthorizationStatusDenied)
    {
        [METoast toastWithMessage:@"请在设置中允许特奢汇APP访问您的通讯录！"];
        return;
    }
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    
    picker.peoplePickerDelegate = self;
    // Display only a person's phone, email, and birthdate
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], nil];
    picker.displayedProperties = displayedItems;
    // Show the picker
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)showSelectView:(UIViewController *)ctrl
{
    if (_currSelectView != ctrl) {
        [_currSelectView removeFromParentViewController];
        [_currSelectView.view removeFromSuperview];
        [self addChildViewController:ctrl];
        [self.view addSubview:ctrl.view];
        ctrl.view.frame = CGRectMake(0,
                                     CGRectGetMaxY(self.numberView.frame),
                                     self.view.frame.size.width,
                                     self.view.frame.size.height-CGRectGetMaxY(self.numberView.frame));
        _currSelectView = ctrl;
    }
}

#pragma mark - delegates
#pragma mark - child Ctrler Delegate
- (void)payWithOrder:(HYPhoneChargeOrder *)order
{
    HYPaymentViewController *payment = [[HYPaymentViewController alloc] init];
    payment.amountMoney = order.notPayAmount;
    payment.payMoney = order.notPayAmount;
    payment.orderCode = order.orderCode;
    payment.navbarTheme = self.navbarTheme;
    payment.canDragBack = NO;
    payment.type = pay_phoneCharge;
    [self.navigationController pushViewController:payment animated:YES];
    
    WS(weakSelf);
    payment.cancelCallback = ^(HYPaymentViewController *payvc) {
        
        [UIAlertView bk_showAlertViewWithTitle:nil
                                       message:@"您还没有完成支付，确定要退出？"
                             cancelButtonTitle:@"确认离开"
                             otherButtonTitles:@[@"继续支付"]
                                       handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                           if (0 == buttonIndex)
                                           {
                                               HYPhoneChargeOrderListViewController *orderlist = [[HYPhoneChargeOrderListViewController alloc] init];
                                               
                                               NSMutableArray *vcs = [payvc.navigationController.viewControllers mutableCopy];
                                               [vcs insertObject:orderlist atIndex:vcs.count-1];
                                               payvc.navigationController.viewControllers = vcs;
                                               [payvc.navigationController popViewControllerAnimated:YES];
                                               if (self.filterView.currentIndex == 0)
                                               {
                                                   orderlist.type = 2;
                                               }
                                               else
                                               {
                                                   orderlist.type = 5;
                                               }
                                           }
                                       }];
    };
    
    
    payment.paymentCallback = ^(HYPaymentViewController *payvc, id order) {
        NSMutableArray *vcs = [weakSelf.navigationController.viewControllers mutableCopy];
        [vcs removeObjectsInRange:NSMakeRange(1, vcs.count-1)];
        weakSelf.navigationController.viewControllers = vcs;
        
        HYPhoneChargeOrderListViewController *orderlist = (HYPhoneChargeOrderListViewController *)[[HYMineInfoViewController sharedMineInfoViewController]
                                                                                                   checkOrderListWithBusiness:PhoneCharge];
        if (orderlist) {
            orderlist.type = self.filterView.currentIndex == 0 ? 2 : 5;
        }
        
    };
    
    // 加入充值历鸣
    [self.numberView rememberPhone];
}
#pragma mark -- tableview delegate


#pragma mark - gesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_numberView.historyView]) {
        return NO;
    }
    return YES;
}


#pragma mark -

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    if (property == kABPersonPhoneProperty)
    {
        [peoplePicker dismissViewControllerAnimated:YES
                                         completion:NULL];
        
        CFStringRef chineseName = ABRecordCopyCompositeName(person);
        
        NSString *name = nil;
        if ([(__bridge NSString *)chineseName length] > 0)
        {
            name = (__bridge NSString *)chineseName;
        }
        else
        {
            ABMultiValueRef orgName = ABRecordCopyValue(person, kABPersonOrganizationProperty);
            
            if ([(__bridge NSString *)orgName length] > 0)
            {
                name = (__bridge NSString *)orgName;
            }
            
            if (orgName)
                CFRelease(orgName);
        }
        
        if (chineseName)
        {
            CFRelease(chineseName);
        }
        
        //phones
        NSString *phone = nil;
        ABMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFArrayRef values = ABMultiValueCopyArrayOfAllValues(phoneMulti);
        CFIndex idx = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
        NSString *number = CFArrayGetValueAtIndex(values, idx);
        if (number)
        {
            NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
            phone = [[number componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
        }
        
        if (values)
            CFRelease(values);
        if (phoneMulti)
            CFRelease(phoneMulti);
        
        if ([phone checkPhoneNumberValid])
        {
            _numberView.name = name;
            _numberView.phone = phone;
            [_numberView transformPhotoDataToMyView];
        }
        else
        {
            [METoast toastWithMessage:@"手机号码格式错误"];
        }
    }
}

// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    
    return NO;
}

// Dismisses the people picker and shows the application when users tap Cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
    [peoplePicker dismissViewControllerAnimated:YES
                                                  completion:NULL];
}

#pragma mark - Navigation

@end
