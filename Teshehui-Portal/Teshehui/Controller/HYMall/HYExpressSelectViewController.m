//
//  HYExpressSelectViewController.m
//  Teshehui
//
//  Created by HYZB on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYExpressSelectViewController.h"
#import "HYGetExpressListRequest.h"
#import "HYLoadHubView.h"
#import "HYBaseLineCell.h"

@interface HYExpressSelectViewController ()
{
    HYGetExpressListRequest *_expressReq;
    NSInteger _curSelectIndex;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *expressList;

@end

@implementation HYExpressSelectViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_expressReq cancel];
    _expressReq = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"物流选择";
        _curSelectIndex = -1;
        _showAllExpress = NO;
    }
    return self;
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
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadExpressList];
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

#pragma mark - private methods
- (void)loadExpressList
{
    [HYLoadHubView show];
    _expressReq = [[HYGetExpressListRequest alloc] init];
    
    _expressReq.getAllExpressList = self.showAllExpress;
    
    if (!self.showAllExpress)
    {
        _expressReq.address = self.address.addr_id;
        _expressReq.storeId = self.storeInfo.store_id;
        _expressReq.storeProductAmount = _price;
        
        NSMutableArray *tempArr = [NSMutableArray array];
        
        for (HYMallCartProduct *goods in self.storeInfo.goods)
        {
            NSMutableDictionary *skuInfo = [NSMutableDictionary dictionary];
            if (goods.isSelect && goods.productSKUId && goods.quantity)
            {
                [skuInfo setObject:goods.productSKUId
                            forKey:@"productSKUId"];
                [skuInfo setObject:goods.quantity
                            forKey:@"quantity"];
            }
            
            if ([skuInfo count] > 0)
            {
                [tempArr addObject:skuInfo];
            }
        }

        _expressReq.productSKUQuantity = [tempArr copy];
    }
    
    __weak typeof(self) b_self = self;
    [_expressReq sendReuqest:^(id result, NSError *error) {
        
        NSArray *listArray = nil;
        if (!error && [result isKindOfClass:[HYGetExpressListResponse class]])
        {
            HYGetExpressListResponse *response = (HYGetExpressListResponse *)result;
            listArray = response.expressList;
        }
        
        [b_self updateViewWithExpress:listArray
                                error:error];
    }];
}

- (void)updateViewWithExpress:(NSArray *)array error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    if (!error)
    {
        self.expressList = array;
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.expressList count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *expressCellId = @"expressCellId";
    HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:expressCellId];
    if (!cell)
    {
        cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleValue1
                                    reuseIdentifier:expressCellId];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    
    HYExpressInfo *express = [self.expressList objectAtIndex:indexPath.row];
    
    if (indexPath.row < [self.expressList count])
    {
        cell.textLabel.text = express.expressName;
        
        if (!self.showAllExpress)
        {
            if (express.is_support)
            {
                NSString *price = @"免运费";
                if (express.price.floatValue > 0)
                {
                    price = [NSString stringWithFormat:@"运费:¥%@", express.price];
                }
                
                cell.detailTextLabel.text = price;
                
                if (express.is_default && _curSelectIndex<0)
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else if (_curSelectIndex == indexPath.row)
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            else
            {
                cell.detailTextLabel.text = @"(不支持配送)";
            }
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
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
    CGFloat height = 44;
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HYExpressInfo *express = nil;
    if (indexPath.row < [self.expressList count])
    {
        express = [self.expressList objectAtIndex:indexPath.row];
        
        if (express.is_support)
        {
            _curSelectIndex = indexPath.row;
            [self.tableView reloadData];
            
            if ([self.delegate respondsToSelector:@selector(didSelectExperss:)])
            {
                self.storeInfo.expressInfo = express;
                [self.delegate didSelectExperss:express];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"该物流不支持当前配送区域"
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }
}

@end
