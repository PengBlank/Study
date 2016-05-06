//
//  HYCIQuoteViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIQuoteViewController.h"
#import "HYHYMallOrderListFilterView.h"
#import "HYCITableViewQuoteDateCell.h"
#import "HYCITableViewQuoteTitleCell.h"
#import "HYCITableViewQuotePriceCell.h"
#import "HYCITableViewQuoteCheckCell.h"
#import "HYCIRecipiViewController.h"
#import "HYCIQuoteRequest.h"
#import "HYCIQuoteResponse.h"
#import "HYPickerToolView.h"
#import "HYCIQuoteCalculateRequest.H"
#import "HYDatePickerView.h"
#import "NSDate+Addition.h"
#import "HYCITableViewInputCell.h"
#import "HYCITableViewSelectCell.h"
#import "HYCICheckBoxCell.h"
#import "HYCICarInfo.h"
#import "HYCIAreaAndDriverInfo.h"
#import "HYCIFillCarInfoViewController.h"
#import "HYCIAdditionInfoViewController.h"

@interface HYCIQuoteViewController ()
<UITableViewDataSource,
UITableViewDelegate,
HYCITableViewQuotePriceDelegate,
HYCITableViewQuoteCheckCellDelegate,
HYPickerToolViewDelegate,
HYDatePickerViewDelegate,
UIAlertViewDelegate,
HYCICheckBoxCellDelegate,
UITextFieldDelegate,
AdditionInfoDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYHYMallOrderListFilterView *filterView;
@property (nonatomic, strong) NSArray *packageTypes;

@property (nonatomic, strong) HYCIQuoteRequest *request;
@property (nonatomic, strong) NSArray *quoteAllList;    //全部
@property (nonatomic, strong) NSArray *quoteList;
@property (nonatomic, strong) NSArray *forceList;
@property (nonatomic, strong) NSArray *dateList;
@property (nonatomic, strong) NSString *quoteKey;
@property (nonatomic, strong) NSString *forceKey;
@property (nonatomic, strong) NSString *dateKey;
@property (nonatomic, assign) BOOL useForce;    //是否需要交强险
@property (nonatomic, assign) BOOL quotesChanged;   //default no. 当前报价是否已被改变

@property (nonatomic, strong) HYCIAreaAndDriverInfo *driverAreaInfo;

//@property (nonatomic, assign) BOOL runAreaFlag;
//@property (nonatomic, assign) BOOL driverFlag;  //是否可指
//@property (nonatomic, assign) BOOL isAssignDriver;
//@property (nonatomic, strong) HYCICarInfoFillType *runAreaInfo;
//
////驾驶员信息
//@property (nonatomic, strong) NSString *driverName;
//@property (nonatomic, strong) NSString *driverNum;
//@property (nonatomic, strong) NSString *drivateDate;

@property (nonatomic, strong) HYPickerToolView *pickerView;
@property (nonatomic, strong) HYDatePickerView *datePicker;
@property (nonatomic, strong) HYCICarInfoFillType *handleFillType;

@property (nonatomic, assign) CGFloat marketPrice;
@property (nonatomic, assign) CGFloat netPrice;
@property (nonatomic, assign) CGFloat points;
@property (nonatomic, weak) UILabel *totalPriceLab;
@property (nonatomic, weak) UILabel *pointLab;
@property (nonatomic, weak) UIButton *nextBtn;

@property (nonatomic, strong) HYCIQuoteCalculateRequest *calculateRequest;

@end

@implementation HYCIQuoteViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    [_request cancel];
    [_calculateRequest cancel];
    
    [_pickerView dismissWithAnimation:YES];
    [_datePicker dismissWithAnimation:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:.98 alpha:1];
    self.title = @"精确报价";
    
    self.driverAreaInfo = [[HYCIAreaAndDriverInfo alloc] init];
    
    self.useForce = NO;
    self.quotesChanged = YES;
    self.driverAreaInfo.runAreaFlag = NO;
    self.driverAreaInfo.driverFlag = NO;
    self.driverAreaInfo.isAssignDriver = NO;
    
    _filterView = [[HYHYMallOrderListFilterView alloc] initWithFrame:
                   CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 35)];
    _filterView.conditions = @[@"大众热门", @"经济实惠", @"自由选择"];
    _filterView.userInteractionEnabled = YES;
    [_filterView addTarget:self
                    action:@selector(filterQuote:)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_filterView];
    
    UIView *footer = [self footerView];
    [self.view addSubview:footer];
    
    self.tableView = [[UITableView alloc] initWithFrame:
                      CGRectMake(0, 35, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-180)
                                                  style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCITableViewQuotePriceCell" bundle:nil]
         forCellReuseIdentifier:@"priceCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCITableViewQuoteDateCell" bundle:nil]
         forCellReuseIdentifier:@"dateCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCITableViewQuoteTitleCell" bundle:nil]
         forCellReuseIdentifier:@"titleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCITableViewQuoteCheckCell" bundle:nil]
         forCellReuseIdentifier:@"checkCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCITableViewInputCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"inputCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCITableViewSelectCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"selectCell"];
    [self.view addSubview:self.tableView];
    
    self.pickerView = [[HYPickerToolView alloc] initWithFrame:
                       CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 216)];
    self.pickerView.delegate = self;
    
    //如果没有packageType，界面无法显示
    if (self.packageTypeMap.allKeys.count > 0)
    {
//        self.filterView.conditions = [self.packageTypeMap allKeys];
        self.quoteKey = @"luxury";
        self.dateKey = @"deadline";
        self.forceKey = @"force";
    }
    
    [self loadQuoteInfo];
}

- (UIView *)footerView
{
    UIView *footer = [[UIView alloc] initWithFrame:
                      CGRectMake(0, CGRectGetHeight(self.view.bounds)-144, CGRectGetWidth(self.view.bounds), 80)];
    footer.backgroundColor = [UIColor whiteColor];
    UIColor *textColor = [UIColor colorWithRed:161.0/255.0
                                         green:0
                                          blue:0
                                         alpha:1.0];
    UILabel *totalLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 150, 17)];
    totalLab.textColor = textColor;
    totalLab.font = [UIFont systemFontOfSize:18.0];
    totalLab.backgroundColor = [UIColor clearColor];
    totalLab.text = @"总计:0.00元";
    [footer addSubview:totalLab];
    self.totalPriceLab = totalLab;
    
    UILabel *pointLab = [[UILabel alloc] initWithFrame:CGRectMake(190, 10, 120, 13)];
    pointLab.font = [UIFont systemFontOfSize:14.0];
    pointLab.textColor = textColor;
    pointLab.backgroundColor = [UIColor clearColor];
    [footer addSubview:pointLab];
    pointLab.text = @"可获得0现金券";
    self.pointLab = pointLab;
    
    UIImage *submit = [UIImage imageNamed:@"ci_btn_on"];
    submit = [submit stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds)-85, 35, 170, 35)];
    [nextBtn setBackgroundImage:submit forState:UIControlStateNormal];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self
                action:@selector(nextAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:nextBtn];
    self.nextBtn = nextBtn;
    
    UIImageView *_lineView = [[UIImageView alloc] initWithFrame:
                              CGRectMake(0, 0, CGRectGetWidth(footer.frame), 1.0)];
    _lineView.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
    [footer addSubview:_lineView];
    
    return footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadQuoteInfo
{
    if (!_request)
    {
        _request = [[HYCIQuoteRequest alloc] init];
    }
    
    _request.sessionId = self.sessionId;
    _request.packageType = self.quoteKey;
    _request.keyName = self.carInfoKey;
    _request.carInfoList = self.carInfoList;
    
//    //test
//    NSArray *array = [HYCICarInfoFillType arrayOfModelsFromDictionaries:@[@{@"name":@"vehicleFrameNo", @"value":@"ldca13r45b2041642"},
//                                                                         @{@"name":@"vehicleModelName", @"value":@"宝马 2.8L 宝马5系 自动档 1995款 自动档 参考价：790000"},
//                                                                          @{@"name":@"engineNo", @"value": @" 39350"},
//                                                                          @{@"name":@"seats", @"value":@"5"},
//                                                                          @{@"name":@"firstRegisterDate", @"value":@"2015-07-10"},
//                                                                          @{@"name":@"specialCarFlag", @"value":@"0"},
//                                                                          @{@"name":@"specialCarDate", @"value":@"2015-07-10"},
//                                                                          @{@"name":@"ownerName", @"value":@"爬爬"},
//                                                                          @{@"name":@"ownerIdNo", @"value":@"421022198812014816"},
//                                                                          @{@"name":@"isOcr", @"value":@"0"},
//                                                                          @{@"name":@"vehicleId", @"value":@"BMAAKI0013"},
//                                                                          @{@"name":@"packageType", @"value":@"luxury"}]];
//    
//    
//    _request.keyName = @"vehicleInfo";
//    _request.carInfoList = array;
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_request sendReuqest:^(id result, NSError *error)
    {
        [b_self updateWithQuoteResponse:result error:error];
    }];
}

- (void)updateWithQuoteResponse:(HYCIQuoteResponse *)response error:(NSError *)error
{
    [HYLoadHubView dismiss];
    if (error)
    {
        DebugNSLog(@"error: %@", error.domain);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:error.domain
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        alert.tag = 1024;
        alert.delegate = self;
        [alert show];
    }
    else if (response.additionList.count > 0)
    {
        NSMutableArray *additionList = [response.additionList mutableCopy];
        for (HYCICarInfoFillType *fillType in response.additionList)
        {
            if (fillType.inputType.integerValue == 30)
            {
                [additionList removeObject:fillType];
            }
        }
        HYCIAdditionInfoViewController *additionInput = [[HYCIAdditionInfoViewController alloc] init];
        additionInput.additionInfoList = additionList;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:additionInput];
        [self presentViewController:nav animated:YES completion:nil];
        __weak typeof(self) weakSelf = self;
        additionInput.additionInputCallback = ^(NSArray *infos)
        {
            weakSelf.carInfoList = [weakSelf.carInfoList arrayByAddingObjectsFromArray:infos];
//            weakSelf.carInfoList = infos;
//            weakSelf.request.sessionId = weakSelf.sessionId;
//            weakSelf.request.packageType = weakSelf.quoteKey;
//            weakSelf.request.keyName = weakSelf.carInfoKey;
//            weakSelf.request.carInfoList = infos;
//            [HYLoadHubView show];
//            __weak typeof(self) b_self = self;
//            [_request sendReuqest:^(id result, NSError *error)
//             {
//                 [b_self updateWithQuoteResponse:result error:error];
//             }];
            [weakSelf loadQuoteInfo];
        };
    }
    else
    {
        //这里通过这些key值在response中获取数据
        
        NSMutableArray *quoteList = [NSMutableArray array];
        for (HYCICarInfoFillType *fillType in response.quoteList)
        {
            if (fillType.inputType.integerValue == 21)
            {
                [quoteList addObject:fillType];
            }
            else if ([fillType.name isEqualToString:@"totalPremium"])
            {
                self.marketPrice = fillType.serverValue.floatValue;
                self.totalPriceLab.text = [NSString stringWithFormat:@"总计:%.2f元", self.marketPrice];
            }
            else if ([fillType.name isEqualToString:@"forceFlag"])
            {
                self.useForce = fillType.value.boolValue;
            }
        }
        
        self.quoteAllList = response.quoteList;
        self.quoteList = quoteList;
        self.forceList = response.forceList;
        self.dateList = response.dateList;
        self.points = response.points;
        self.pointLab.text = [NSString stringWithFormat:@"可获得%.0f现金券", self.points];
        self.driverAreaInfo.runAreaFlag = response.runAreaFlag;
        self.driverAreaInfo.driverFlag = response.driverFlag;
        self.driverAreaInfo.runAreaInfo = response.runAreaInfo;
        
        [self.tableView reloadData];
        
        _quotesChanged = NO;
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
}

- (void)calculateFees
{
    NSString *err = [self.driverAreaInfo checkError];
    if (err)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:err delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (!_calculateRequest)
    {
        _calculateRequest = [[HYCIQuoteCalculateRequest alloc] init];
    }
    [_calculateRequest cancel];
    
    _calculateRequest.fillTypeKey = @"optional";
    _calculateRequest.dateKey = self.dateKey;
    _calculateRequest.fillTypeList = self.quoteList;
    _calculateRequest.dateList = self.dateList;
    _calculateRequest.sessionId = self.sessionId;
    _calculateRequest.forceFlag = self.useForce;
    _calculateRequest.areaAndDriverInfo = self.driverAreaInfo;
    
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_calculateRequest sendReuqest:^(id result, NSError *error)
    {
        [b_self updateWithCalculateResponse:result error:error];
    }];
}

- (void)updateWithCalculateResponse:(HYCIQuoteCalculateResponse *)response
                              error:(NSError *)err
{
    [HYLoadHubView dismiss];
    if (err)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:err.domain
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSMutableArray *quoteList = [NSMutableArray array];
        for (HYCICarInfoFillType *fillType in response.quoteList)
        {
            if (fillType.inputType.integerValue == 21)
            {
                [quoteList addObject:fillType];
            }
            else if ([fillType.name isEqualToString:@"totalPremium"])
            {
                self.marketPrice = fillType.serverValue.floatValue;
                self.totalPriceLab.text = [NSString stringWithFormat:@"总计:%.2f元", self.marketPrice];
            }
            else if ([fillType.name isEqualToString:@"forceFlag"])
            {
                self.useForce = fillType.value.boolValue;
            }
        }
        
        self.quoteAllList = response.quoteList;
        self.quoteList = quoteList;
        self.forceList = response.forceList;
        self.dateList = response.dateList;
        self.points = response.points;
        self.pointLab.text = [NSString stringWithFormat:@"可获得%.0f现金券", self.points];
        [self.tableView reloadData];
        _quotesChanged = NO;
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
}

#pragma mark - private
- (void)filterQuote:(HYHYMallOrderListFilterView *)filter
{
    switch (filter.currentIndex)
    {
        case 0:
            self.quoteKey = @"luxury";
            break;
        case 1:
            self.quoteKey = @"affordable";
            break;
        case 2:
            self.quoteKey = @"optional";
            break;
        default:
            break;
    }
    [self loadQuoteInfo];
}

- (void)nextAction:(UIButton *)btn
{
    if (_quotesChanged)
    {
        [self calculateFees];
    }
    else
    {
        HYCIRecipiViewController *recipi = [[HYCIRecipiViewController alloc] init];
        recipi.totalAmount = self.marketPrice;
        recipi.insureDates = self.dateList;
        recipi.commercialInsureInfos = self.quoteAllList;
        recipi.forceInsureInfos = self.forceList;
        recipi.ownerInfo = self.ownerInfo;
        recipi.carInfo = [HYCICarInfo carInfoWithInputFillTypes:self.carInfoList];
        recipi.sessionid = self.sessionId;
        recipi.points = self.points;
        [self.navigationController pushViewController:recipi animated:YES];
    }
}

#pragma mark - table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (_driverAreaInfo.runAreaFlag||_driverAreaInfo.driverFlag) ? 3 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2 + self.quoteList.count;
    }
    else if (section == 1)
    {
        return _useForce ? (self.forceList.count+2) : 2;
    }
    else
    {
        NSInteger count = 0;
        if (_driverAreaInfo.runAreaFlag)
        {
            count += 1;
        }
        if (_driverAreaInfo.driverFlag)
        {
            count += 1;
            if (_driverAreaInfo.isAssignDriver)
            {
                count += 3;
            }
        }
        return count;
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            return 35;
        }
        else if (indexPath.row == 0)
        {
            return 60;
        }
        else
        {
            return 55;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 1) {
            return 60;
        }
        else
        {
            return 55;
        }
    }
    else if (indexPath.section == 2)
    {
        return 44;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return [self cellForCommercialWithIndex:indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        return [self cellForTrafficWithIndex:indexPath.row];
    }
    else
    {
        return [self cellForDriveWithIndex:indexPath.row];
    }
    return nil;
}

//商业险cell
- (UITableViewCell *)cellForCommercialWithIndex:(NSInteger)index
{
    if (index == 0)
    {
        HYCITableViewQuotePriceCell *headCell = [self.tableView
                                                dequeueReusableCellWithIdentifier:@"priceCell"];
        headCell.nameLab.text = @"商业险投保时间";
        if (self.dateList.count > 0)
        {
            HYCICarInfoFillType *keyvalue = [self.dateList objectAtIndex:0];
            [headCell setFillType:keyvalue];
            headCell.delegate = self;
        }
        return headCell;
    }
    else if (index == 1)
    {
        HYCITableViewQuoteTitleCell *titleCell = [self.tableView
                                                  dequeueReusableCellWithIdentifier:@"titleCell"];
        return titleCell;
    }
    else
    {
        HYCITableViewQuotePriceCell *priceCell = [self.tableView
                                                  dequeueReusableCellWithIdentifier:@"priceCell"];
        HYCICarInfoFillType *keyvalue = [self.quoteList objectAtIndex:(index-2)];
        [priceCell setFillType:keyvalue];
        priceCell.delegate = self;
        return priceCell;
    }
    return nil;
}

//交强险cell
- (UITableViewCell *)cellForTrafficWithIndex:(NSInteger)index
{
    if (index == 0)
    {
        HYCITableViewQuoteCheckCell *checkCell = [self.tableView dequeueReusableCellWithIdentifier:@"checkCell"];
        checkCell.nameLab.text = @"交强险";
        checkCell.checkBtn.selected = _useForce;
        checkCell.delegate = self;
        return checkCell;
    }
    else if (index == 1)
    {
        HYCITableViewQuotePriceCell *headCell = [self.tableView dequeueReusableCellWithIdentifier:@"priceCell"];
        headCell.nameLab.text = @"交强险投保时间";
        if (self.dateList.count > 1)
        {
            HYCICarInfoFillType *keyvalue = [self.dateList objectAtIndex:1];
            [headCell setFillType:keyvalue];
            headCell.delegate = self;
        }
        return headCell;
    }
    else
    {
        HYCITableViewQuotePriceCell *priceCell = [self.tableView
                                                  dequeueReusableCellWithIdentifier:@"priceCell"];
        HYCICarInfoFillType *keyvalue = [self.forceList objectAtIndex:(index-2)];
        [priceCell setFillType:keyvalue];
        priceCell.delegate = self;
        return priceCell;
    }
    return nil;
}

//指省指价
- (UITableViewCell *)cellForDriveWithIndex:(NSInteger)index
{
    if (!_driverAreaInfo.runAreaFlag)
    {
        index = index + 1;
    }
    
    if (index == 0)
    {
        HYCITableViewSelectCell *cityCell = [self.tableView dequeueReusableCellWithIdentifier:@"selectCell"];
        cityCell.nameLab.text = @"行驶区域:";
        //            cityCell.contentLab.text = self.city;
        NSString *key = nil;
        for (HYCICarInfoValue*keyvalue in self.driverAreaInfo.runAreaInfo.selectValueList)
        {
            if ([keyvalue.value isEqualToString:self.driverAreaInfo.runAreaInfo.value])
            {
                key = keyvalue.key;
            }
        }
        cityCell.contentLab.text = key;
        return cityCell;
    }
    else if (index == 1)
    {
        HYCICheckBoxCell *check = [self.tableView dequeueReusableCellWithIdentifier:@"checkBoxCell"];
        if (!check)
        {
            check = [[HYCICheckBoxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"checkBoxCell"];
            
        }
        check.textLabel.text = @"是否指定驾驶员:";
        check.isChecked = self.driverAreaInfo.isAssignDriver;
        check.delegate = self;
        check.tag = 1033;
        return check;
    }
    else if (index == 4)
    {
        HYCITableViewSelectCell *dateCell = [self.tableView dequeueReusableCellWithIdentifier:@"selectCell"];
        dateCell.nameLab.text = @"初资领证日期";
        //            cityCell.contentLab.text = self.city;
        dateCell.contentLab.text = self.driverAreaInfo.drivateDate;
        return dateCell;
    }
    else if (index == 2)
    {
        HYCITableViewInputCell *inputCell = [self.tableView dequeueReusableCellWithIdentifier:@"inputCell"];
        inputCell.inputField.keyboardType = UIKeyboardTypeDefault;
        inputCell.nameLab.text = @"姓名:";
        inputCell.inputField.placeholder = @"必填";
        inputCell.inputField.text = self.driverAreaInfo.driverName;
        inputCell.inputField.tag = 1;
        inputCell.inputField.delegate = self;
        return inputCell;
    }
    else if (index == 3)
    {
        HYCITableViewInputCell *inputCell = [self.tableView dequeueReusableCellWithIdentifier:@"inputCell"];
        inputCell.inputField.keyboardType = UIKeyboardTypeDefault;
        inputCell.nameLab.text = @"驾驶证号";
        inputCell.inputField.placeholder = @"必填";
        inputCell.inputField.text = self.driverAreaInfo.driverNum;
        inputCell.inputField.tag = 2;
        inputCell.inputField.delegate = self;
        return inputCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:
                      CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 48)];
    header.backgroundColor = [UIColor whiteColor];
    UIImageView *_lineView = [[UIImageView alloc] initWithFrame:
                              CGRectMake(0, CGRectGetMaxY(header.bounds)-1, CGRectGetWidth(header.frame), 1.0)];
    _lineView.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
    [header addSubview:_lineView];
    _lineView = [[UIImageView alloc] initWithFrame:
                              CGRectMake(0, 0, CGRectGetWidth(header.frame), 1.0)];
    _lineView.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
    [header addSubview:_lineView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, CGRectGetHeight(header.bounds))];
    titleLabel.font = [UIFont systemFontOfSize:20.0];
    titleLabel.textColor = [UIColor colorWithRed:161.0/255.0
                                           green:0
                                            blue:0
                                           alpha:1.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    [header addSubview:titleLabel];
    
    if (section == 0)
    {
        titleLabel.text = @"商业险";
    }
    else if(section == 1)
    {
        titleLabel.text = @"交强险";
    }
    else
    {
        titleLabel.text = @"指省指价";
    }
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2)
    {
        NSInteger index = indexPath.row;
        if (!_driverAreaInfo.runAreaFlag)
        {
            index = index + 1;
        }
        if (index == 0)
        {
            //行驶区域
            NSMutableArray *selectArray = [NSMutableArray array];
            for (HYCICarInfoValue *keyvalue in _driverAreaInfo.runAreaInfo.selectValueList)
            {
                [selectArray addObject:keyvalue.key];
            }
            self.pickerView.dataSouce = selectArray;
            self.handleFillType = _driverAreaInfo.runAreaInfo;
            self.pickerView.currentIndex = 0;
            [self.pickerView showWithAnimation:YES];
        }
        else if (index == 4)
        {
            //领证日期
            if (!_datePicker)
            {
                _datePicker = [[HYDatePickerView alloc] initWithFrame:
                               CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 216)];
                _datePicker.delegate = self;
                _datePicker.pickerView.maximumDate = nil;
            }
            self.handleFillType = nil;
            [_datePicker showWithAnimation:YES];
        }
    }
}

#pragma mark - cell delegate
- (void)quoteCellDidClick:(HYCITableViewQuotePriceCell *)cell
{
    if (cell.fillType.inputType.integerValue == 20 ||
        cell.fillType.inputType.integerValue == 21)
    {
        NSMutableArray *selectArray = [NSMutableArray array];
        for (HYCICarInfoValue *keyvalue in cell.fillType.selectValueList)
        {
            [selectArray addObject:keyvalue.key];
        }
        if (cell.fillType.isEditable.boolValue)
        {
            [selectArray addObject:@"编辑"];
        }
        self.pickerView.dataSouce = selectArray;
        self.handleFillType = cell.fillType;
        self.pickerView.currentIndex = 0;
        [self.pickerView.pickerView reloadComponent:0];
        [self.pickerView showWithAnimation:YES];
    }
    else if (cell.fillType.inputType.integerValue == 40)
    {
        if (!_datePicker)
        {
            _datePicker = [[HYDatePickerView alloc] initWithFrame:
                           CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 216)];
            _datePicker.delegate = self;
            _datePicker.pickerView.maximumDate = nil;
        }
        self.handleFillType = cell.fillType;
        [_datePicker showWithAnimation:YES];
    }
}

- (void)checkCellDidCheck:(HYCITableViewQuoteCheckCell *)cell
{
    _quotesChanged = YES;
    cell.checkBtn.selected = !cell.checkBtn.selected;
    self.useForce = cell.checkBtn.selected;
    
    [self.tableView reloadData];
    [self.nextBtn setTitle:@"修改报价" forState:UIControlStateNormal];
}

- (void)checkBoxCellIsChecked:(HYCICheckBoxCell *)cell
{
    if (cell.tag == 1033)
    {
        self.driverAreaInfo.isAssignDriver = cell.isChecked;
        [self.tableView reloadData];
    }
}

#pragma mark - picker delegate
//选择选项
- (void)selectComplete:(HYPickerToolView *)pickerView
{
    if (self.handleFillType)
    {
        HYCICarInfoFillType *fillType = self.handleFillType;
        if (pickerView.currentIndex < fillType.selectValueList.count)
        {
            HYCICarInfoValue *value = [fillType.selectValueList objectAtIndex:pickerView.currentIndex];
            fillType.value = value.value;
            _quotesChanged = YES;
            [self.tableView reloadData];
            [self.nextBtn setTitle:@"修改报价" forState:UIControlStateNormal];
            self.handleFillType = nil;
        }
        else
        {
            NSString *message = nil;
            if (fillType.rangeValue)
            {
                message = [NSString stringWithFormat:@"请在%.0f—%.0f元范围内调整金额",
                           fillType.rangeValue.minimum.floatValue,
                           fillType.rangeValue.maximum.floatValue];
            }
            else
            {
                message = @"请输入金额";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:fillType.inputShowName message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [[alert textFieldAtIndex:0] setTextAlignment:NSTextAlignmentCenter];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1024)
    {
        //返回结果出现的问题
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if (buttonIndex == 1)
        {
            HYCICarInfoFillType *filltype = self.handleFillType;
            self.handleFillType = nil;
            
            NSString *input = [[alertView textFieldAtIndex:0] text];
            if (input.length > 0 && input.floatValue >=filltype.rangeValue.minimum.floatValue
                && input.floatValue <= filltype.rangeValue.maximum.floatValue)
            {
                _quotesChanged = YES;
                filltype.value = [NSString stringWithFormat:@"%.2f", input.floatValue];
                [self.tableView reloadData];
                [self.nextBtn setTitle:@"修改报价" forState:UIControlStateNormal];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入不合法" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}

//选中日期
- (void)datePickerView:(HYDatePickerView *)pickerView didSelectDate:(NSDate *)date
{
    if (self.handleFillType)
    {
        self.handleFillType.value = [date timeDescription];
        _quotesChanged = YES;
        [self.tableView reloadData];
        [self.nextBtn setTitle:@"修改报价" forState:UIControlStateNormal];
        self.handleFillType = nil;
    }
    else
    {
        self.driverAreaInfo.drivateDate = [date timeDescription];
        [self.tableView reloadData];
    }
}

#pragma mark - text
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat offset = self.tableView.contentSize.height - 400;
    [self.tableView setContentOffset:CGPointMake(0, offset) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        [self.view endEditing:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
