//
//  StoreBalanceViewController.m
//  Teshehui
//
//  Created by macmini5 on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "StoreBalanceViewController.h"
#import "StoreBalanceView.h"
#import "XTSegmentControl.h"
#import "iCarousel.h"
#import "PrepayViewController.h"    // 充值
#import "ConsumeViewController.h"   // 账单

#import "DefineConfig.h"            // 宏
#import "Masonry.h"
#import "StoreBalanceInfo.h"        // 数据

@interface StoreBalanceViewController ()<iCarouselDataSource,iCarouselDelegate>

@property (strong, nonatomic) XTSegmentControl          *mySegmentControl;
@property (strong, nonatomic) iCarousel                 *myCarousel;
@property (strong, nonatomic) NSArray                   *segmentItems;
@property (assign, nonatomic) NSInteger                 oldSelectedIndex;

@property (nonatomic, strong) NSMutableArray  *sbInfoArray;     // 数据

@end

@implementation StoreBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sbInfoArray = [NSMutableArray array];
    self.title = @"实体店余额";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _segmentItems = @[@"普通商家",@"桌球商家"];
    //添加myCarousel
    _myCarousel = ({
        iCarousel *icarousel = [[iCarousel alloc] init];
        icarousel.dataSource = self;
        icarousel.delegate = self;
        icarousel.decelerationRate = 1.0;
        icarousel.scrollSpeed = 1.0;
        icarousel.type = iCarouselTypeLinear;
        icarousel.pagingEnabled = YES;
        icarousel.clipsToBounds = YES;
        icarousel.bounceDistance = 0.2;
        [self.view addSubview:icarousel];
        [icarousel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(44, 0, 0, 0));
        }];
        icarousel;
    });
    
    //    //添加滑块
    WS(weakSelf)
    __weak typeof(_myCarousel) weakCarousel = _myCarousel;
    _mySegmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44) Items:_segmentItems selectedBlock:^(NSInteger index) {
        
        if (index == weakSelf.oldSelectedIndex) {
            return;
        }
        [weakCarousel scrollToItemAtIndex:index animated:NO];
    }];
    self.icarouselScrollEnabled = NO;
    [self.view addSubview:_mySegmentControl];
}

- (void)dealloc{
    _myCarousel.dataSource = nil;
    _myCarousel.delegate = nil;
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

#pragma mark iCarousel M
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _segmentItems.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    WS(weakSelf);
    view = [[UIView alloc] initWithFrame:carousel.bounds];
   
    StoreBalanceView *sbView = [[StoreBalanceView alloc] initWithFrame:view.bounds Type:index Block:^(StoreBalanceInfo* model, BalanceType balanceType, ButtonType type) {
       WS(weakSelf)
        switch (type) {
            case prepayButtonType:
            {// 充值按钮
                [weakSelf preBtnClick:model BalanceType:balanceType];
            }
                break;
            case billButton:
            {// 账单按钮
                [weakSelf billBtnClick:model BalanceType:balanceType];
            }
                break;
                
            default:
                break;
        }
    }];
    
    [view addSubview:sbView];
    return view;
}

- (void)carouselDidScroll:(iCarousel *)carousel{
    
    if (_mySegmentControl) {
        float offset = carousel.scrollOffset;
        if (offset > 0) {
            [_mySegmentControl moveIndexWithProgress:offset];
        }
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    if (_mySegmentControl) {
        _mySegmentControl.currentIndex = carousel.currentItemIndex;
    }
    if (_oldSelectedIndex != carousel.currentItemIndex) {
        _oldSelectedIndex = carousel.currentItemIndex;
        
    }
}

- (void)setIcarouselScrollEnabled:(BOOL)icarouselScrollEnabled{
    _myCarousel.scrollEnabled = icarouselScrollEnabled;
}

#pragma make - 按钮点击事件
// 充值按钮
- (void)preBtnClick:(StoreBalanceInfo *)model BalanceType:(NSInteger)type
{
    PrepayViewController *vc = [[PrepayViewController alloc] init];
    
    vc.merId = model.merId; // 传入商家id
    //0为普通 1为充值
    vc.merchantType = type;
    vc.comeType = 2; // 进入路径
    
    [self.navigationController pushViewController:vc animated:YES];
}
// 账单按钮
- (void)billBtnClick:(StoreBalanceInfo *)model BalanceType:(NSInteger)type
{//0为普通 1为充值
    
    ConsumeViewController *vc = [[ConsumeViewController alloc] init];
    vc.merId = model.merId; // 传入商家id
    vc.type = type;
    [self.navigationController pushViewController:vc animated:YES];
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

@end
