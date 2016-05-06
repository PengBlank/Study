//
//  HYAroundCitySelectViewController.m
//  Teshehui
//
//  Created by RayXiang on 14-7-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAroundCitySelectViewController.h"
#import "HYQRCodeGetCityListRequest.h"
#import "HYAppDelegate.h"

@interface HYAroundCitySelectViewController ()

@property (nonatomic, strong) HYQRCodeGetCityListRequest *request;

@property (nonatomic, strong) NSArray *cityArr;

@end

@implementation HYAroundCitySelectViewController

- (void)dealloc
{
    [self.request cancel];
    self.request = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"选择城市";
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    self.view = view;
    
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSString *imageName = CheckIOS7 ? @"qr_nav_bg_128" : @"qr_nav_bg_88";
//    UIImage *image = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:2
//                                                                         topCapHeight:0];
//    [self.navigationController.navigationBar setBackgroundImage:image
//                                                  forBarMetrics:UIBarMetricsDefault];
    
    [self fetchDataFromNet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchDataFromNet
{
    [HYLoadHubView show];
    self.request = [[HYQRCodeGetCityListRequest alloc] init];
    
    __weak id weak_self = self;
    [self.request sendReuqest:^(id result, NSError *error)
    {
        [HYLoadHubView dismiss];
        if ([result isKindOfClass:[HYQRCodeGetCityListResponse class]])
        {
            HYQRCodeGetCityListResponse *response = (HYQRCodeGetCityListResponse *)result;
            if (response.status == 200)
            {
                HYAroundCitySelectViewController *strong_self = weak_self;
                strong_self.cityArr = [NSArray arrayWithArray:response.cityList];
                [strong_self.tableView reloadData];
            }
        }
    }];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cityArr.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    HYCityForQRCode *city = [self.cityArr objectAtIndex:indexPath.row];
    cell.textLabel.text = city.region_name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.callback)
    {
        HYCityForQRCode *city = [self.cityArr objectAtIndex:indexPath.row];
        self.callback(city);
    }
    
    [self backToRootViewController:nil];
}

- (IBAction)backToRootViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
