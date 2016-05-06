//
//  HYPassengerListViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYPassengerListViewController.h"
#import "HYPassengerListCell.h"
#import "HYAddPassengerViewController.h"
#import "HYGetAllPassengerListRequest.h"
#import "HYAddPassengerRequest.h"
#import "HYDeletePassengerRequest.h"
#import "HYEidtPassengerViewController.h"
#import "HYUserInfo.h"
#import "HYLoadHubView.h"
#import "METoast.h"
#import "HYTabbarViewController.h"

@interface HYPassengerListViewController ()<HYPassengerDelegate>
{
    HYDeletePassengerRequest *_rDelete;
    HYGetAllPassengerListRequest *_pRequest;
    HYAddPassengerRequest *_addRequest;
    UITextField *_nameTextField;
    NSInteger _requesTotal;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *passengers;
@property (nonatomic, strong) UIView *noDataShowView;

@property (nonatomic, strong) UIButton *confirmFlighPassenger;

@property (nonatomic, assign) CGRect showBtnFrame;
@property (nonatomic, assign) CGRect hideBtnFrame;

@end

@implementation HYPassengerListViewController

- (void)dealloc
{
    [_pRequest cancel];
    _pRequest = nil;
    
    [_addRequest cancel];
    _addRequest = nil;
    
    [_rDelete cancel];
    _rDelete = nil;
    
    [HYLoadHubView dismiss];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.max = 1000;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                           green:237.0f/255.0f
                                            blue:237.0f/255.0f
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.sectionFooterHeight = 10;
    tableview.sectionHeaderHeight = 0;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
//    self.tableView.backgroundColor = [UIColor redColor];

    _confirmFlighPassenger = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmFlighPassenger.frame = CGRectMake(0, frame.size.height-45, self.view.frame.size.width, 45);
    _confirmFlighPassenger.titleLabel.font = [UIFont systemFontOfSize:15];
    [_confirmFlighPassenger setTitle:@"确认乘机人" forState:UIControlStateNormal];
    _confirmFlighPassenger.backgroundColor = [UIColor orangeColor];
    [_confirmFlighPassenger addTarget:self action:@selector(confirmFlighPassengerBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmFlighPassenger];
    _confirmFlighPassenger.hidden = YES;
    
    _noDataShowView = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:_noDataShowView];
    
    UIImageView *showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TFScalePoint(110), TFScalePoint(150), TFScalePoint(100), TFScalePoint(100))];
    [_noDataShowView addSubview:showImageView];
    showImageView.image = [UIImage imageNamed:@"newNoPassenger"];
    
    UILabel *showLab = [[UILabel alloc] initWithFrame:CGRectMake(TFScalePoint(70), CGRectGetMaxY(showImageView.frame) + 20, TFScalePoint(180), 40)];
    [_noDataShowView addSubview:showLab];
    showLab.numberOfLines = 2;
    showLab.lineBreakMode = NSLineBreakByCharWrapping;
    showLab.font = [UIFont systemFontOfSize:15];
    showLab.textAlignment = NSTextAlignmentCenter;
    showLab.textColor = [UIColor grayColor];
    showLab.text = @"您未添加任何常用旅客请点击右上角按钮进行添加";
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:TFRectMake(0, 0, 30, 30)];
    [right setTitle:@"添加" forState:UIControlStateNormal];
    [right addTarget:self
              action:@selector(addPassenger:)
    forControlEvents:UIControlEventTouchDown];
    [right setTitleColor:[UIColor grayColor]
                forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:right];
    
    self.navigationItem.rightBarButtonItem = rightButton;
 
    self.hideBtnFrame = frame;
    frame.size.height -= 45;
    self.showBtnFrame = frame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _noDataShowView.hidden = YES;
    
    
    if (self.type != Unknow)
    {
//        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        doneBtn.frame = CGRectMake(0, 0, 48, 30);
//        [doneBtn setTitle:NSLocalizedString(@"done", nil)
//                 forState:UIControlStateNormal];
//        [doneBtn setTitleColor:self.navBarTitleColor
//                      forState:UIControlStateNormal];
//        [doneBtn addTarget:self
//                    action:@selector(selectedPassengerComplete:)
//          forControlEvents:UIControlEventTouchUpInside];
//        if (!CheckIOS7)
//        {
//            [doneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12)];
//        }
//        UIBarButtonItem *itemBar = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
//        self.navigationItem.rightBarButtonItem = itemBar;
        
        if (self.type == Passenger)
        {
            self.title = @"选择乘机人";
        }
        else
        {
            self.title = @"选择入住人";
        }
    }
    else
    {
        self.title = @"常用旅客";
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //强行隐藏tabbar
    HYTabbarViewController *tab = (HYTabbarViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    if (tab)
    {
        if ([tab isKindOfClass:[HYTabbarViewController class]]) {
            [tab setTabbarShow:NO];
        }
    }
    
    [self didGetAllPassenger];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark setter/getter
- (NSMutableArray *)selectPassengers
{
    if (!_selectPassengers)
    {
        _selectPassengers = [[NSMutableArray alloc] init];
    }
    
    return _selectPassengers;
}

- (NSMutableArray *)passengers
{
    if (!_passengers)
    {
        _passengers = [[NSMutableArray alloc] init];
    }
    
    return _passengers;
}

- (void)backToRootViewController:(id)sender
{
  //  [self selectedPassengerComplete:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark private methods
- (void)addPassenger:(UIButton *)btn
{
//    if (self.type != Unknow && self.passengers.count)
//    {
//        [self selectedPassengerComplete:nil];
//    }
    HYAddPassengerViewController *vc = [[HYAddPassengerViewController alloc] init];
    vc.navbarTheme = self.navbarTheme;
    vc.type = self.type;
    vc.delegate = self;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)confirmFlighPassengerBtnDidClicked:(UIButton *)btn
{
    if (self.type == HotelGuest)
    {
        
        if (self.selectPassengers.count < self.max)
        {
            [METoast toastWithMessage:[NSString stringWithFormat:@"入住人数小于%ld人", (long)self.max]];
        }
        else
        {
            [self selectedPassengerComplete:nil];
        }
    }
    else
    {
        [self selectedPassengerComplete:nil];
    }
}

- (void)selectedPassengerComplete:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectPassengers:)])
    {
       [self.delegate didSelectPassengers:self.selectPassengers];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addNewPassenger:(id)sender
{
    if ([_nameTextField.text length] > 0)
    {
        [_nameTextField resignFirstResponder];
        
        if (!_addRequest)
        {
            _addRequest = [[HYAddPassengerRequest alloc] init];
        }
        
        HYUserInfo *user = [HYUserInfo getUserInfo];
        _addRequest.userId = user.userId;
        _addRequest.realName = _nameTextField.text;
        
        _nameTextField.text = nil;

        __weak typeof(self) b_self = self;
        [_addRequest sendReuqest:^(id result, NSError *error) {
            if (!error && [result isKindOfClass:[HYPassengerResponse class]])
            {
                HYPassengerResponse *rs = (HYPassengerResponse *)result;
                [b_self didUpdateWithPassenger:rs.passenger];
            }
            else
            {
                [METoast toastWithMessage:error.domain];
            }
        }];
    }
}

//- (void)editEvent:(id)sender
//{
//    UIButton *btn = (UIButton *)sender;
//    if (btn.tag < [self.passengers count])
//    {
//        HYPassengers *p = [self.passengers objectAtIndex:btn.tag];
//        [self editPassenger:p];
//    }
//}

- (void)editPassenger:(HYPassengers *)pessenger
{
    if (pessenger)
    {
        HYEidtPassengerViewController *vc = [[HYEidtPassengerViewController alloc] init];
        vc.navbarTheme = self.navbarTheme;
        vc.type = self.type;
        vc.passenger = [pessenger copy];
        vc.delegate = self;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

- (void)didGetAllPassenger
{
    if (_pRequest) {
        [_pRequest cancel];
    }
    
    _pRequest = [[HYGetAllPassengerListRequest alloc] init];
    
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_pRequest sendReuqest:^(id result, NSError *error) {
        NSArray *passengers = nil;
        
        if (!error && [result isKindOfClass:[HYPassengerListResponse class]])
        {
            HYPassengerListResponse *p = (HYPassengerListResponse *)result;
            passengers = p.passengerList;
        }
        
        [b_self getPassengersFinishedWithResult:passengers error:error];
    }];
}

- (void)getPassengersFinishedWithResult:(NSArray *)result error:(NSError *)error
{
    if (_requesTotal<2 && [result count] <= 0 && error.code != 1)
    {
        _requesTotal++;
        //继续获取
        [self didGetAllPassenger];
        [self.passengers removeAllObjects];
        [self.tableView reloadData];
        _noDataShowView.hidden = YES;
    }
    else if ([result count] > 0)
    {
        _requesTotal = 0;
        [self didUpdatePassengers:result];
        _noDataShowView.hidden = YES;
    }
    else
    {
        [HYLoadHubView dismiss];

        _noDataShowView.hidden = NO;
       // [METoast toastWithMessage:@"您还没有添加过常用旅客信息哦!"];
    }
}

- (void)didUpdatePassengers:(NSArray *)passengers
{
    [HYLoadHubView dismiss];
    
    if ([self.selectPassengers count] > 0)
    {
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        NSMutableArray *select = [self.selectPassengers mutableCopy];
        [self.selectPassengers removeAllObjects];
        
        for (HYPassengers *np in passengers)
        {
            for (HYPassengers *p in select)
            {
                if ([p.passengerId isEqualToString:np.passengerId])
                {
                    np.isSelected = p.isSelected;
                    [self.selectPassengers addObject:np];
                    [select removeObject:p];
                    break;
                }
            }
            
            [muArray addObject:np];
        }
        
        self.passengers = muArray;
    }
    else
    {
        self.passengers = [passengers mutableCopy];
    }
   
    [self.tableView reloadData];
}

- (void)showAlertWithMsg:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"知道了", nil];
    [alertView show];
}

#pragma mark - HYPassengerDelegate
- (void)didUpdateWithPassenger:(HYPassengers *)passenger
{
    int exist = -1;
    for (int i = 0; i < self.passengers.count; i++)
    {
        HYPassengers *p = [self.passengers objectAtIndex:i];
        if ([p.passengerId isEqualToString:passenger.passengerId])
        {
            exist = i;
            break;
        }
    }
    
    if (exist != -1 && exist < self.passengers.count)
    {
        [self.passengers replaceObjectAtIndex:exist withObject:passenger];
    }
    else
    {
        [self.passengers addObject:passenger];
    }
    
     _noDataShowView.hidden = YES;
    [self.tableView reloadData];
}

- (void)didDeletePassenger:(HYPassengers *)passenger
{
    for (HYPassengers *p in self.passengers)
    {
        if ([p.passengerId isEqualToString:passenger.passengerId])
        {
            [self.passengers removeObject:p];
            break;
        }
    }
    
    if (self.passengers.count == 0) {
        _noDataShowView.hidden = NO;
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.passengers count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = 60.0f;
    if (indexPath.row < [self.passengers count])
    {
        HYPassengers *p = [self.passengers objectAtIndex:indexPath.row];
        if ([p.phone length])
        {
            height = 80.0;
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow -1)
    {
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
        static NSString *passengerCellId = @"passengerCellId";
        HYPassengerListCell *cell = [tableView dequeueReusableCellWithIdentifier:passengerCellId];
        if (cell == nil)
        {
            cell = [[HYPassengerListCell alloc]initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:passengerCellId];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            [cell.eidtBtn addTarget:self
//                             action:@selector(editEvent:)
//                   forControlEvents:UIControlEventTouchUpInside];
            
            [cell setShowCheckBox:(self.type!=Unknow)];
        }
        
      //  NSInteger index = indexPath.row-1;
        NSInteger index = indexPath.row;
        if (index < [self.passengers count])
        {
            HYPassengers *p = [self.passengers objectAtIndex:index];
            cell.eidtBtn.tag = index;
            [cell setPassenger:p];
        }
        
        return cell;

/*
    if (indexPath.row == 0)
    {
        if (self.type == Passenger) // 机票乘客
        {
            static NSString *AddPassengerCellId = @"AddPassengerCellId";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddPassengerCellId];
            if (cell == nil)
            {
                cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:AddPassengerCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
                
                
                UIImage *arrIcon = [UIImage imageNamed:@"ico_arrow_list"];
                UIImageView *arrView1 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenRect.size.width-20, 14.5, 10, 15)];
                arrView1.image = arrIcon;
                [cell.contentView addSubview:arrView1];
            }
            
            cell.textLabel.text = @"新增乘机人";
            return cell;
        }
        else if (self.type == HotelGuest) // 机票乘客
        {
            static NSString *AddPassengerCellId = @"AddPassengerCellId";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddPassengerCellId];
            if (cell == nil)
            {
                cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:AddPassengerCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = self.view.backgroundColor;
                
                UILabel *_Lab = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, 100, 18)];
                _Lab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
                [_Lab setFont:[UIFont systemFontOfSize:16]];
                _Lab.backgroundColor = [UIColor clearColor];
                _Lab.text = @"新增入住人";
                [cell.contentView addSubview:_Lab];
                
                UIImage *image = [[UIImage imageNamed:@"bg_common_select"] stretchableImageWithLeftCapWidth:10
                                                                                               topCapHeight:5];
                UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(14, 39, TFScalePoint(208), 34)];
                bg.image = image;
                [cell.contentView addSubview:bg];
                _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(18, 46, TFScalePoint(200), 18)];
                _nameTextField.keyboardType = UIKeyboardTypeDefault;
                _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                _nameTextField.font = [UIFont systemFontOfSize:16];
                _nameTextField.returnKeyType = UIReturnKeyDone;
                _nameTextField.placeholder = @"姓名";
                _nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [cell.contentView addSubview:_nameTextField];
                
                UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                addBtn.frame = CGRectMake(ScreenRect.size.width-80, 39, 70, 34);
                [addBtn setBackgroundImage:image
                                  forState:UIControlStateNormal];
                [addBtn setBackgroundImage:image
                                  forState:UIControlStateHighlighted];
                [addBtn setImage:[UIImage imageNamed:@"icon_setting_add_normal"]
                        forState:UIControlStateNormal];
                [addBtn setTitle:@"添加" forState:UIControlStateNormal];
                [addBtn setTitleColor:[UIColor blackColor]
                             forState:UIControlStateNormal];
                [addBtn addTarget:self
                           action:@selector(addNewPassenger:)
                 forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:addBtn];
            }
            
            return cell;
        }
        else
        {
            static NSString *AddPassengerCellId = @"AddPassengerCellId";
            HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:AddPassengerCellId];
            if (cell == nil)
            {
                cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:AddPassengerCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
                
                UIImage *arrIcon = [UIImage imageNamed:@"ico_arrow_list"];
                UIImageView *arrView1 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenRect.size.width-20, 14.5, 10, 15)];
                arrView1.image = arrIcon;
                [cell.contentView addSubview:arrView1];
            }
            
            cell.textLabel.text = @"新增旅客";
            return cell;
        }
    }
    else
    {
        static NSString *passengerCellId = @"passengerCellId";
        HYPassengerListCell *cell = [tableView dequeueReusableCellWithIdentifier:passengerCellId];
        if (cell == nil)
        {
            cell = [[HYPassengerListCell alloc]initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:passengerCellId];
            [cell.eidtBtn addTarget:self
                             action:@selector(editEvent:)
                   forControlEvents:UIControlEventTouchUpInside];
            
            [cell setShowCheckBox:(self.type!=Unknow)];
        }
        
        NSInteger index = indexPath.row-1;
        if (index < [self.passengers count])
        {
            HYPassengers *p = [self.passengers objectAtIndex:index];
            cell.eidtBtn.tag = index;
            [cell setPassenger:p];
        }
        
        return cell;
    }
*/
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HYPassengers *p = [self.passengers objectAtIndex:indexPath.row];
    if (self.type == Unknow)
    {
        
        [self editPassenger:p];
    }
//    else if (self.type == HotelGuest)
//    {
//        [self.selectPassengers removeAllObjects];
//        [self.selectPassengers addObject:p];
//        [self selectedPassengerComplete:nil];
//    }
    else
    {
        if (self.type == Passenger && [p.cardID length]<=0)
        {
            [self showAlertWithMsg:@"请填写证件号"];
            return;
        }
        
        if ([self.selectPassengers count] < self.max)
        {
            if (p.isSelected)
            {
                [self.selectPassengers removeObject:p];
                p.isSelected = NO;
            }
            else
            {
                p.isSelected = YES;
                [self.selectPassengers addObject:p];
            }
        }
        else
        {
            if (p.isSelected)
            {
                [self.selectPassengers removeObject:p];
            }
            else
            {
                HYPassengers *lp = [self.selectPassengers lastObject];
                lp.isSelected = NO;
                [self.selectPassengers removeObject:lp];
                
                [self.selectPassengers addObject:p];
            }
            
            p.isSelected = !p.isSelected;
        }
        
        if (self.selectPassengers.count)
        {
            
            _confirmFlighPassenger.hidden = NO;
            self.tableView.frame = self.showBtnFrame;
            
            if (self.type == HotelGuest)
            {
                
                [_confirmFlighPassenger setTitle:@"确认入住人" forState:UIControlStateNormal];
            }
            else
            {
                
                [_confirmFlighPassenger setTitle:@"确认乘机人" forState:UIControlStateNormal];
            }
            
        }
        else
        {
            
            _confirmFlighPassenger.hidden = YES;
            self.tableView.frame = self.hideBtnFrame;
        }
        [self.tableView reloadData];
        
    }

/*
    if (indexPath.row > 0)
    {
        NSInteger index = indexPath.row-1;
        if (index < [self.passengers count])
        {
            HYPassengers *p = [self.passengers objectAtIndex:index];
            
            if (self.type == Unknow)  //如果是查看常用旅客，则直接编辑
            {
                [self editPassenger:p];
            }
            else
            {
                if (self.type == Passenger && [p.cardID length]<=0)
                {
                    [self showAlertWithMsg:@"请填写证件号"];
                    return;
                }
                
                if ([self.selectPassengers count] < self.max)
                {
                    if (p.isSelected)
                    {
                        [self.selectPassengers removeObject:p];
                        p.isSelected = NO;
                    }
                    else
                    {
                        p.isSelected = YES;
                        [self.selectPassengers addObject:p];
                    }
                }
                else
                {
                    if (p.isSelected)
                    {
                        [self.selectPassengers removeObject:p];
                    }
                    else
                    {
                        HYPassengers *lp = [self.selectPassengers lastObject];
                        lp.isSelected = NO;
                        [self.selectPassengers removeObject:lp];
                        
                        [self.selectPassengers addObject:p];
                    }
                    
                    p.isSelected = !p.isSelected;
                }
            }
        }
        
        [self.tableView reloadData];
    }
    else if (self.type != HotelGuest)
    {
        HYAddPassengerViewController *vc = [[HYAddPassengerViewController alloc] init];
        vc.navbarTheme = self.navbarTheme;
        vc.type = self.type;
        vc.delegate = self;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
*/
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (self.type != Unknow) {
            
            HYPassengers *p = self.passengers[indexPath.row];
            HYEidtPassengerViewController *vc = [[HYEidtPassengerViewController alloc] init];
            vc.navbarTheme = self.navbarTheme;
            vc.type = self.type;
            vc.passenger = [p copy];
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        } else {
            
            if (!_rDelete)
            {
                _rDelete = [[HYDeletePassengerRequest alloc] init];
            }
            
            [HYLoadHubView show];
            
            HYUserInfo *user = [HYUserInfo getUserInfo];
            if (user.userId) {
                
                _rDelete.user_id = user.userId;
            }
            HYPassengers *p = [self.passengers objectAtIndex:indexPath.row];
            _rDelete.passenger_id = p.passengerId;
            
            __weak typeof(self) b_self = self;
            [_rDelete sendReuqest:^(id result, NSError *error) {
                // [b_self deletePassengerFinished:error];
                if (!error)
                {
                    [b_self didDeletePassenger:p];
                }
                
                [HYLoadHubView dismiss];
                [b_self.tableView reloadData];
            }];
        }
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type != Unknow)
    {
        return @"编辑";
    }
    else
    {
        return @"删除";
    }
}

//- (void)deletePassengerFinished:(NSError *)error
//{
//    if (!error)
//    {
//        
//        [self didDeletePassenger:self.passenger];
//    }
//    
//    [HYLoadHubView dismiss];
//    [self.tableView reloadData];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_nameTextField resignFirstResponder];
}

@end
