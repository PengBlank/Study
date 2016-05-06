//
//  HYPhoneNumberView.m
//  Teshehui
//
//  Created by 成才 向 on 16/2/25.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYPhoneNumberView.h"
#import "Masonry.h"
#import "HYKeyboardHandler.h"
#import "HYNumberHistoryView.h"
#import "HYAddressBookHelper.h"
#import "HYPerson.h"
#import "SearchCoreManager.h"
#import "HYPhoneChargeStore.h"
#import "NSString+Addition.h"
#import "HYUserInfo.h"

@interface HYPhoneNumberView ()
<UITextFieldDelegate,
HYKeyboardHandlerDelegate>
{
    HYAddressBookHelper *_abHelper;
}
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UILabel *additionLab;
@property (nonatomic, strong) UIButton *bookBtn;

@property (nonatomic, strong) HYKeyboardHandler *keyboardHandler;

@property (nonatomic, strong) HYNumberHistoryView *historyView;
@property (nonatomic, strong) NSMutableDictionary *personMap;


@end

@implementation HYPhoneNumberView

- (void)dealloc
{
    [_keyboardHandler stopListen];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectZero];
        line1.backgroundColor = [UIColor colorWithWhite:.85 alpha:1];
        [self addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectZero];
        line2.backgroundColor = [UIColor colorWithWhite:.85 alpha:1];
        [self addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        UITextField *phone = [[UITextField alloc] initWithFrame:CGRectZero];
        phone.clearButtonMode = UITextFieldViewModeWhileEditing;
        phone.delegate = self;
//        phone.backgroundColor = [UIColor redColor];
        phone.font = [UIFont systemFontOfSize:25];
        phone.keyboardType = UIKeyboardTypePhonePad;
        phone.placeholder = @"请输入手机号码";
        [self addSubview:phone];
        [phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(TFScalePoint(15));
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(40);
        }];
        self.phoneField = phone;
        
        UILabel *addi = [[UILabel alloc] initWithFrame:CGRectZero];
        addi.font = [UIFont systemFontOfSize:14.0];
        addi.textColor = [UIColor colorWithWhite:.7 alpha:1];
//        addi.text = @"广东移动";
        [self addSubview:addi];
        self.additionLab = addi;
        [addi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.equalTo(phone.mas_bottom).offset(TFScalePoint(3));
        }];
        
        UIButton *bkbtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [bkbtn addTarget:self action:@selector(bkbtnAction)
        forControlEvents:UIControlEventTouchUpInside];
        [bkbtn setImage:[UIImage imageNamed:@"address_book_btn"]
               forState:UIControlStateNormal];
        [self addSubview:bkbtn];
        self.bookBtn = bkbtn;
        [bkbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(phone);
            make.right.equalTo(phone.mas_right);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        self.keyboardHandler = [[HYKeyboardHandler alloc] initWithDelegate:self
                                                                      view:nil];
        
        self.phone = [HYUserInfo getUserInfo].mobilePhone;
        
   
    }
    return self;
}

//- (void)willMoveToSuperview :(UIView *)newSuperview
//{
//    [super willMoveToSuperview:newSuperview];
//    if (newSuperview) {
//        [self.keyboardHandler startListen];
//    }
//    else {
//        [self.keyboardHandler stopListen];
//    }
//}

#pragma mark setter & getter
-(void)setType:(NSUInteger)type
{
    _type = type;
    
    if (PhoneChargeController == type)
    {
        [self transformPhotoDataToMyView];
    }
}

- (void)setName:(NSString *)name
{
    _name = name;
}

- (void)setPhone:(NSString *)phone
{
    if (phone != _phone) {
        _phone = phone;
//        self.phoneField.text = phone;
        [self setSpaceText:phone];
        
        [self setPhoneAdditionInfo];
        if (self.didGetPhone) {
            self.didGetPhone(phone);
        }
    }
}

- (void)setPhoneAdditionInfo
{
    if (self.phone.length > 0)
    {
        if ([self.phone checkPhoneNumberValid])
        {
            self.additionLab.textColor = [UIColor colorWithWhite:.7 alpha:1];
            NSString *locate = [self.phone getPhoneNumberAttribution];
            NSString *carri = nil;
            Carrier carrier = [self.phone checkPhoneNumberCarrier];
            if (carrier == CHINA_CMCC) {
                carri = @"移动";
            }
            else if (carrier == CHINA_Unicom) {
                carri = @"联通";
            }
            else if (carrier == CHINA_Telecom) {
                carri = @"电信";
            }
            locate = [locate stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *additionInfo = [NSString stringWithFormat:@"%@ %@", locate, carri];
            if ([self.phone isEqualToString:[HYUserInfo getUserInfo].mobilePhone])
            {
                self.additionLab.text = [NSString stringWithFormat:@"账号绑定号码（%@）", additionInfo];
            }
            else if (self.name.length > 0)
            {
                self.additionLab.text = [NSString stringWithFormat:@"%@（%@）", self.name, additionInfo];
            }
            else {
                self.additionLab.text = additionInfo;
            }
        }
        else
        {
            self.additionLab.text = @"请输入正确的手机号码";
            self.additionLab.textColor = [UIColor redColor];
        }
    }
}

- (void)transformPhotoDataToMyView
{
    if (self.phone.length > 0)
    {
        if ([self.phone checkPhoneNumberValid])
        {
            self.additionLab.textColor = [UIColor colorWithWhite:.7 alpha:1];
            NSString *locate = [self.phone getPhoneNumberAttribution];
            NSString *carri = nil;
            Carrier carrier = [self.phone checkPhoneNumberCarrier];
            if (carrier == CHINA_CMCC) {
                carri = @"移动";
            }
            else if (carrier == CHINA_Unicom) {
                carri = @"联通";
            }
            else if (carrier == CHINA_Telecom) {
                carri = @"电信";
            }
            locate = [locate stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *additionInfo = [NSString stringWithFormat:@"%@ %@", locate, carri];
            if ([self.phone isEqualToString:[HYUserInfo getUserInfo].mobilePhone])
            {
                self.additionLab.text = [NSString stringWithFormat:@"账号绑定号码（%@）", additionInfo];
            }
            else if (self.name.length > 0)
            {
                self.additionLab.text = [NSString stringWithFormat:@"%@（%@）", self.name, additionInfo];
            }
            else {
                self.additionLab.text = additionInfo;
            }
            
            //post a notification to show price button
            NSArray *paramArray = @[@(carrier),self.phone];
            [self postNotificationWithParam:paramArray];
        }
        else
        {
            self.additionLab.text = @"请输入正确的手机号码";
            self.additionLab.textColor = [UIColor redColor];
            //as above of the notification
            [self postNotificationWithParam:nil];
        }
    }
    else
    {
        self.additionLab.text = nil;
        [self postNotificationWithParam:nil];
    }
}

#pragma mark - event
- (void)bkbtnAction
{
    if (self.didSelectAddressBook) {
        self.didSelectAddressBook();
    }
}

#pragma mark - function
/// 显示联系人列表
- (void)showPhoneList:(NSArray *)list
{
    [self showPhoneList:list showClear:NO];
}

- (void)showPhoneList:(NSArray *)list showClear:(BOOL)clear
{
    if (!_historyView) {
        _historyView = [[HYNumberHistoryView alloc] init];
        [self.superview addSubview:_historyView];
    }
    CGFloat y = CGRectGetMaxY(self.frame);
    CGFloat h = self.superview.frame.size.height - y - 216;
    h = MIN(h, (list.count + clear)*35);
    _historyView.frame = CGRectMake(0, y, self.frame.size.width, h);
    [self.superview bringSubviewToFront:_historyView];
    _historyView.phoneInfos = list;
    _historyView.showClear = clear;
    [_historyView.table reloadData];
    
    WS(weakSelf);
    /// 点击某一个联系人：设置选中信息，记忆，隐藏
    _historyView.didSelectInfo = ^(NSDictionary *info) {
        [weakSelf setPhoneInfo:info];
        [weakSelf hidePhoneList];
        [weakSelf transformPhotoDataToMyView];
        [weakSelf.phoneField resignFirstResponder];
    };
    
    _historyView.didClear = ^{
        [[HYPhoneChargeStore sharedStore]  clearRecords];
        [weakSelf hidePhoneList];
    };
}

/// 选中某一个联系人，将联系人数据赋值到各字段
- (void)setPhoneInfo:(NSDictionary *)phoneinfo
{
    self.name = phoneinfo[@"name"];
    self.phone = phoneinfo[@"phone"];
}

/// 隐藏联系人列表界面
- (void)hidePhoneList
{
    _historyView.frame = CGRectZero;
}

#pragma mark - text
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSString *result = [textField.text stringByReplacingOccurrencesOfString:@" "
                                                                 withString:@""];
    if (result.length > 0) {
        self.bookBtn.hidden = YES;
        [self searchAddressWithPhone:result];
    }
    else {
        self.bookBtn.hidden = NO;
        [self showHistory];
    }
}

//the funtion will be also called when click the clear button of textfiled
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.bookBtn.hidden = NO;
//    self.phone = textField.text;
    [self hidePhoneList];
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _phone = nil;
    [self setPhoneAdditionInfo];

    if (self.didGetPhone) {
        self.didGetPhone(nil);
    }
    /// 为空时显示历史记录
    [self showHistory];
    
    // !!! dont touch
    [self transformPhotoDataToMyView];

    return YES;
    
}


/*
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
 */


- (void)setSpaceText:(NSString *)text
{
    NSMutableString *str = [text mutableCopy];
    if (str.length > 3) {
        [str insertString:@" " atIndex:3];
    }
    if (str.length > 8) {
        [str insertString:@" " atIndex:8];
    }
    self.phoneField.text = str;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self setSpaceText:result];
    
    _phone = result;
    if (self.didGetPhone) {
        self.didGetPhone(result);
    }
    
    if (result.length > 0)
    {
        self.bookBtn.hidden = YES;
        /// 大于四位时时搜索联系人
        if (result.length >= 4)
        {
            [self searchAddressWithPhone:result];
        }
        else
        {
            [self hidePhoneList];
        }
        // 产品需求精准匹配，输入即开始搜索
//        if (result.length >= 1)
//        {
//            [self searchAddressWithPhone:result];
//        }
//        else
//        {
//            [self hidePhoneList];
//        }
        
        /// 满11位确认
        if (result.length == 11)
        {
            [textField resignFirstResponder];

            if (_historyView.phoneInfos.count == 1)
            {
                [self setPhoneInfo:_historyView.phoneInfos[0]];
                [self transformPhotoDataToMyView];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hidePhoneList];
                });
            }
            else
            {
                // !!! dont touch
                [self transformPhotoDataToMyView];
                [self setPhoneAdditionInfo];
            }
            
        }
        else    /// 未满则清除下面的额外信息
        {
            self.name = nil;
            _additionLab.text = nil;
        }
    }
    else {
        /// 为空时显示历史记录
        [self showHistory];
        /// 显示按钮
        self.bookBtn.hidden = NO;
    }
    
    
    
    //when the text length changes,post a notification to the price view
    if (result.length < 11)
    {
        [self postNotificationWithParam:nil];
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/// 在联系人中搜索电话号码
- (void)searchAddressWithPhone:(NSString *)phone
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (!_abHelper || self.personMap.count == 0)
        {
            _abHelper = [[HYAddressBookHelper alloc] init];
            [[SearchCoreManager share] Reset];
            self.personMap = [NSMutableDictionary dictionary];
            NSMutableArray *contacts = [[_abHelper getAllContacts] mutableCopy];
            
            for (HYPerson *person in contacts)
            {
                //加入到搜索列表
                [[SearchCoreManager share] AddContact:[NSNumber numberWithInteger:person.searchKey]
                                                 name:person.name
                                                phone:[NSArray arrayWithObject:person.mobile]];
                [self.personMap setObject:person forKey:@(person.searchKey)];
            }
        }
        
        //搜索
        NSMutableArray *result1 = [NSMutableArray array];
        NSMutableArray *result2 = [NSMutableArray array];
        [[SearchCoreManager share] Search:phone
                              searchArray:nil
                                nameMatch:result1
                               phoneMatch:result2];
        NSMutableSet *resultset = [[NSMutableSet alloc] init];
        [resultset addObjectsFromArray:result1];
        [resultset addObjectsFromArray:result2];
        NSMutableArray *resultShow = [NSMutableArray array];
        for (NSNumber *resultid in resultset)
        {
            // 取出号码并且比较是否一致
            HYPerson *person = [self.personMap objectForKey:resultid];
            NSInteger length = phone.length;
            if (person.mobile.length >= length)
            {
                NSString *subStr = [person.mobile substringWithRange:NSMakeRange(0, length)];
                if ([subStr isEqualToString:phone])
                {
                    [resultShow addObject:@{@"name": person.name, @"phone": person.mobile}];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showPhoneList:resultShow];
        });
    });
}

/// 显示历史充值记录
- (void)showHistory
{
    NSArray *historys = [[HYPhoneChargeStore sharedStore] getRecords];
    if (historys.count > 0)
    {
        [self showPhoneList:historys showClear:YES];
    }
}

/// 将当前数据添加到历史记录
- (void)rememberPhone
{
    if ([self.phone isEqualToString:[HYUserInfo getUserInfo].mobilePhone])
    {
        self.name = @"账号绑定号码";
    }
    if (!self.name)
    {
        NSString *locate = [self.phone getPhoneNumberAttribution];
        NSString *carri = nil;
        Carrier carrier = [self.phone checkPhoneNumberCarrier];
        if (carrier == CHINA_CMCC) {
            carri = @"移动";
        }
        else if (carrier == CHINA_Unicom) {
            carri = @"联通";
        }
        else if (carrier == CHINA_Telecom) {
            carri = @"电信";
        }
        locate = [locate stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *additionInfo = [NSString stringWithFormat:@"%@ %@", locate, carri];
        NSDictionary *store = @{@"phone": self.phone, @"info": additionInfo};
        [[HYPhoneChargeStore sharedStore] addRecord:store];
    }
    else
    {
        NSDictionary *store = @{@"name": self.name, @"phone": self.phone};
        [[HYPhoneChargeStore sharedStore] addRecord:store];
    }
}

//- (void)keyboardChangeFrame:(CGRect)kFrame
//{
//    CGFloat y = CGRectGetMaxY(self.frame);
//    CGFloat h = self.superview.frame.size.height - y - kFrame.size.height;
//    _historyView.frame = CGRectMake(0, y, self.frame.size.width, h);
//}

#pragma mark post notification
- (void)postNotificationWithParam:(id)object
{
    if (PhoneChargeController == _type)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"kWhetherShowPrice"
                                                           object:object];
    }
}

@end
