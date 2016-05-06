//
//  HYCIFillCarInfoViewController.m
//  Teshehui
//
//  Created by HYZB on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIFillCarInfoViewController.h"
#import "HYCIFillCarInfoCell.h"
#import "HYCITableViewSelectCell.h"
#import "HYCICarInfo.h"
#import "HYCICarBrandListViewController.h"
#import "HYCIQuoteViewController.h"
#import "METoast.h"
#import "NSDate+Addition.h"

#import "HYDatePickerView.h"
#import "HYPickerToolView.h"
#import "HYLoadHubView.h"
#import "HYCIAdditionInfoViewController.h"

@interface HYCIFillCarInfoViewController ()
<
HYPickerToolViewDelegate,
HYDatePickerViewDelegate,
HYCIFillCarInfoCellDelegate,
HYCICarBrandListViewControllerDelegate,
UIAlertViewDelegate,
UINavigationControllerDelegate
>
{
    HYCIGetCarFillInfoListReq *_getFillInfoReq;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYCICarInfo *carInfo;
@property (nonatomic, strong) UIButton *previousBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) HYPickerToolView *pickerView;
@property (nonatomic, strong) HYDatePickerView *datePickerView;

@property (nonatomic, strong) HYCICarBrandInfo *carTypeInfo;

@property (nonatomic, assign) BOOL specialCar;  //是否过户车



@end

@implementation HYCIFillCarInfoViewController

- (void)dealloc
{
    [_getFillInfoReq cancel];
    _getFillInfoReq = nil;
    
    [HYLoadHubView dismiss];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.isAdditionInfo = NO;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:251.0/255.0
                                           green:251.0/255.0
                                            blue:251.0/255.0
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    
    if (CheckIOS7)
    {
        [tableview setSeparatorInset:UIEdgeInsetsMake(0, 2, 0, 2) ];
    }
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"车辆信息";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCITableViewInputCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"inputCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCITableViewSelectCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"selectCell"];

    if (!_footerView)
    {
        _footerView = [[UIView alloc] initWithFrame:TFRectMakeFixWidth(0, 0, 320, 60)];
        
        
        self.nextBtn = [[UIButton alloc] initWithFrame:
                        CGRectMake(CGRectGetMidX(self.view.bounds)-85, 10, 170, 35)];
        NSString *next = _isAdditionInfo ? @"完成" : @"下一步";
        [self.nextBtn setTitle:next
                      forState:UIControlStateNormal];
        [self.nextBtn setTitleColor:[UIColor whiteColor]
                           forState:UIControlStateNormal];
        [self.nextBtn setBackgroundImage:[[UIImage imageNamed:@"ci_btn_on"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 2, 5, 2)]
                                forState:UIControlStateNormal];
        [self.nextBtn setBackgroundImage:[[UIImage imageNamed:@"ci_btn_off"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 2, 5, 2)]
                                forState:UIControlStateDisabled];
        [self.nextBtn addTarget:self
                         action:@selector(nextEvent:)
               forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:self.nextBtn];
        
        self.tableView.tableFooterView = _footerView;
    }
    
    //加载相关信息
    //[self loadCarFillInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - HYPickerToolViewDelegate
- (void)selectComplete:(HYPickerToolView *)pickerView
{
    if (pickerView.tag < [self.carInfoFillList count])
    {
        NSString *str = [pickerView.dataSouce objectAtIndex:pickerView.currentIndex];
        HYCICarInfoFillType *type = [self.carInfoFillList objectAtIndex:pickerView.tag];
        type.value = str;
        [self.tableView reloadData];
    }
}

#pragma mark - HYDatePickerViewDelegate
- (void)didSelectDate:(NSDate *)date
{
    if (self.datePickerView.tag < [self.carInfoFillList count])
    {
        HYCICarInfoFillType *type = [self.carInfoFillList objectAtIndex:self.datePickerView.tag];
        type.value = [date timeDescription];
        [self.tableView reloadData];
    }
}

#pragma mark setter/getter
- (HYPickerToolView *)pickerView
{
    if (!_pickerView)
    {
        _pickerView = [[HYPickerToolView alloc] initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 260)];
        _pickerView.delegate = self;
    }
    
    return _pickerView;
}

- (HYDatePickerView *)datePickerView
{
    if (!_datePickerView)
    {
        _datePickerView = [[HYDatePickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 260)];
        _datePickerView.delegate = self;
    }
    
    return _datePickerView;
}
#pragma mark private methods
- (void)previousEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextEvent:(id)sender
{
    [self.view endEditing:YES];
    
    NSString *err = nil;
    NSSet *validateAreas = [NSSet setWithObjects:
                            @"vehicleFrameNo",
                            @"vehicleModelName",
                            @"vehicleId",
                            @"engineNo",
                            @"seats",
                            @"firstRegisterDate",
                            nil];
    BOOL isspecial = NO;
    for (HYCICarInfoFillType *type in self.carInfoAllList)
    {
        if ([validateAreas containsObject:type.name])
        {
            if (type.value.length == 0)
            {
                err = [NSString stringWithFormat:@"请输入%@", type.inputShowName];
                break;
            }
        }
        else if ([type.name isEqualToString:@"specialCarFlag"])
        {
            isspecial = type.value.boolValue;
        }
        else if ([type.name isEqualToString:@"specialCarDate"])
        {
            if (isspecial && type.value.length == 0)
            {
                err = @"请选择过户日期";
            }
        }
    }

    if (err)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:err delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (_isAdditionInfo)
    {
        if (self.additionForController)
        {
            [self.additionForController setCarInfoList:self.carInfoAllList];
            [self.additionForController loadQuoteInfo];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else
    {
        HYCIQuoteViewController *vc = [[HYCIQuoteViewController alloc] init];
        vc.carInfoList = self.carInfoAllList;
        vc.carInfoKey = self.infoKey;
        vc.sessionId = self.sessionId;
        vc.packageTypeMap = self.packageTypeMap;
        vc.ownerInfo = self.ownerInfo;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

- (void)loadCarFillInfo
{
    [HYLoadHubView show];
    
    _getFillInfoReq = [[HYCIGetCarFillInfoListReq alloc] init];
    _getFillInfoReq.reqParam = self.ownerInfo;
    
    __weak typeof(self) bself = self;
    [_getFillInfoReq sendReuqest:^(id result, NSError *error) {
        
        [bself updateWithResponse:result error:error];
    }];
}

- (void)updateWithResponse:(HYCIGetCarFillInfoListResp *)response error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    if (!error)
    {
        self.carInfoFillList = [(HYCIGetCarFillInfoListResp *)response carInfoShowList];
        self.carInfoAllList = [(HYCIGetCarFillInfoListResp *)response carInfoAllList];
        self.infoKey = [(HYCIGetCarFillInfoListResp *)response infoKey];
        self.vichelSearchKey = response.vichelSearchKey;
        if (!_infoKey)
        {
            _infoKey = @"vehicleInfo";
        }
        self.sessionId = [(HYCIGetCarFillInfoListResp *)response sessionId];
        self.packageTypeMap = [(HYCIGetCarFillInfoListResp *)response packageTypeMap];
#if TARGET_IPHONE_SIMULATOR
        for (HYCICarInfoFillType *filltype in self.carInfoAllList)
        {
            if ([filltype.name isEqualToString:@"vehicleFrameNo"])
            {
                filltype.value = @"LVVDA11A9AD201987";
            }
            else if ([filltype.name isEqualToString:@"engineNo"])
            {
                filltype.value = @"AFAE03346";
            }
            else if([filltype.name isEqualToString:@"seats"])
            {
                filltype.value = @"5";
            }
            else if ([filltype.name isEqualToString:@"specialCarFlag"])
            {
                filltype.value = @"1";
                
            }
            else if ([filltype.name isEqualToString:@"specialCarDate"])
            {
                filltype.value = @"2015-02-06";
            }
            else if ([filltype.name isEqualToString:@"firstRegisterDate"])
            {
                filltype.value = @"2010-12-08";
            }
        }
#endif
        //如果只有一个，则直接跳下一步
        if (self.carInfoAllList.count == 1)
        {
            [self nextEvent:nil];
            return;
        }
        
        [self.tableView reloadData];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag = 2333;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2333)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - HYCIFillCarInfoCellDelegate
- (void)didTextInputFinished:(HYCIFillCarInfoCell *)cell
{
    
}

#pragma mark - HYCICarBrandListViewControllerDelegate
- (void)didSelectCarBrandType:(HYCICarBrandInfo *)brandTypeInfo
{
    for (HYCICarInfoFillType *type in self.carInfoAllList)
    {
        if ([type.name isEqualToString:@"vehicleModelName"])  //品牌ß
        {
            type.value = brandTypeInfo.typeDescription;
        }
        else if ([type.name isEqualToString:@"vehicleId"])
        {
            type.value = brandTypeInfo.typeCode;
        }
    }
    
    [self.tableView reloadData];
}

- (void)didTextInputNext:(NSInteger)nextIndex
{
    while (nextIndex<[self.carInfoFillList count])
    {
        HYCICarInfoFillType *type = [self.carInfoFillList objectAtIndex:nextIndex];
        if (type.inputType.intValue == 10)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:nextIndex];
            HYCIFillCarInfoCell *cell = (HYCIFillCarInfoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell.inputTF becomeFirstResponder];
            
            break;
        }
        
        nextIndex++;
    }
}

- (void)didEidtCheckStatus:(BOOL)checked
{
    if (!checked)
    {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.carInfoFillList];
        for (HYCICarInfoFillType *type in tempArr)
        {
            if ([type.name isEqualToString:@"specialCarDate"]) //不显示过户日期
            {
                type.value = nil;
                [tempArr removeObject:type];
                break;
            }
        }
        
        self.carInfoFillList = [tempArr copy];
    }
    else
    {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.carInfoFillList];
        for (HYCICarInfoFillType *type in self.carInfoAllList)
        {
            if ([type.name isEqualToString:@"specialCarDate"]) //不显示过户日期
            {
                type.value = nil;
                [tempArr addObject:type];
                break;
            }
        }
        
        self.carInfoFillList = [tempArr copy];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.carInfoFillList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *fillCarInfoCellId = @"fillCFarInfoCellId";
    
    HYCIFillCarInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:fillCarInfoCellId];
    
    if (!cell)
    {
        cell = [[HYCIFillCarInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:fillCarInfoCellId];
        cell.delegate = self;
    }
    
    //处理下一项的问题
    cell.tag = indexPath.section;
    
    if (indexPath.section < [self.carInfoFillList count])
    {
        HYCICarInfoFillType *type = [self.carInfoFillList objectAtIndex:indexPath.section];
        [cell setInfoType:type];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//}

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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < [self.carInfoFillList count])
    {
        HYCICarInfoFillType *type = [self.carInfoFillList objectAtIndex:indexPath.section];
        switch (type.inputType.integerValue)
        {
                
            case 21:  //下拉
                [self.view endEditing:YES];
                self.pickerView.tag = indexPath.section;
                [self.pickerView setDataSouce:[type inputValueList]];
                [self.pickerView showWithAnimation:YES];
                break;
            case 40:  //日期
                [self.view endEditing:YES];
                self.datePickerView.tag = indexPath.section;
                [self.datePickerView showWithAnimation:YES];
                break;
            case 100:  //品牌搜索
            {
                [self.view endEditing:YES];
                HYCICarBrandListViewController *vc = [[HYCICarBrandListViewController alloc] init];
                vc.delegate = self;
                vc.keyWord = self.vichelSearchKey;
                [self.navigationController pushViewController:vc
                                                     animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        [self.view endEditing:YES];
    }
}

@end
