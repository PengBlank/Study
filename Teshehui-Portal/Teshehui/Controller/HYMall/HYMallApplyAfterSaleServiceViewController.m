//
//  HYMallApplyAfterSaleServiceViewController.m
//  Teshehui
//
//  Created by Kris on 15/10/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallApplyAfterSaleServiceViewController.h"
#import "HYMallGetEvidencePictureCell.h"
#import "HYMallApplyAfterSaleHeaderView.h"
#import "HYMallGetEvidencePictureCell.h"
#import "GWPhotoBrowserViewController.h"
#import "HYMallApplyAfterSaleFooterView.h"
#import "HYApplyAfterSaleServiceReq.h"
#import "HYAddressInfo.h"
#import "HYAfterSaleServiceResponse.h"
#import "HYExpensiveResultView.h"
#import <objc/runtime.h>
#import "UIButton+WebCache.h"

//修改
#import "HYMallAfterSaleInfo.h"

@interface HYMallApplyAfterSaleServiceViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
HYMallGetEvidencePictureCellDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
HYAfterSaleDeletePhotoDelegate,
HYMallApplyAfterSaleFooterViewDelegate,
HYMallApplyAfterSaleHeaderViewDelegate,
UIActionSheetDelegate
>
{
    HYApplyAfterSaleServiceReq *_applyAfterSaleServiceReq;
    
    NSInteger _operationType;
    NSUInteger _quantity;
    NSString *_problemDescription;
    
    NSString *_receiverText;
    NSString *_mobileText;
    NSString *_addressDetailText;
    NSString *_addressDetailSecondText;
}


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *picData;
@property (nonatomic, strong) NSMutableArray *picOriginalData;
@property (nonatomic, strong)HYMallApplyAfterSaleFooterView *footerView;

@end

@implementation HYMallApplyAfterSaleServiceViewController

static void *HYMallApplyAfterSaleServiceActionSheetKey = "HYMallApplyAfterSaleServiceActionSheetKey";

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        _isChange = NO;
    }
    return self;
}

- (void)dealloc
{
    [_applyAfterSaleServiceReq cancel];
    _applyAfterSaleServiceReq = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_isChange)
    {
        self.title = @"修改售后服务";
    }
    else
    {
        self.title = @"申请售后服务";
    }
    
    if (_saleInfo) {
        //赋值信息
        _operationType = _saleInfo.operationType.integerValue;
        _quantity = _saleInfo.useDetail.quantity.integerValue;
        self.addressInfo = [[HYAddressInfo alloc] init];
        _addressInfo.provinceName = _saleInfo.contactProvinceName;
        _addressInfo.provinceId = _saleInfo.contactProvinceCode;
        _addressInfo.cityName = _saleInfo.contactCityName;
        _addressInfo.cityId = _saleInfo.contactCityCode;
        _addressInfo.areaName = _saleInfo.contactRegionName;
        _addressInfo.areaId = _saleInfo.contactRegionCode;
        _addressInfo.address = _saleInfo.contactAddress;
        _addressInfo.realName = _saleInfo.contactName;
        _addressInfo.mobile = _saleInfo.contactMobile;
        _problemDescription = _saleInfo.useDetail.remark;
        _addressDetailText = [_addressInfo fullRegion];
        _addressDetailSecondText = _saleInfo.contactAddress;
        _receiverText = _saleInfo.contactName;
        _mobileText = _saleInfo.contactMobile;
    }
    else {
        _operationType = -1;
        _quantity = 1;
    }
    
    _tableView = [[UITableView alloc]initWithFrame:
                  CGRectMake(0, 0, ScreenRect.size.width, ScreenRect.size.height-64)
                                             style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[HYMallGetEvidencePictureCell class] forCellReuseIdentifier:@"MallGetEvidencePicture"];
    
    //header
    HYMallApplyAfterSaleHeaderView *headerView = [[HYMallApplyAfterSaleHeaderView alloc]initMyNib];
    _tableView.tableHeaderView = headerView;
    headerView.delegate = self;
    headerView.isChange = self.isChange;
    if (self.saleInfo)
    {
        headerView.saleInfo = self.saleInfo;
    }
    else if (_returnGoodsInfo)
    {
        headerView.returnGoodsInfo = _returnGoodsInfo;
    }
    _tableView.sectionHeaderHeight = 300;
    
    //footer
    _footerView = [[HYMallApplyAfterSaleFooterView alloc]initMyNib];
    _tableView.tableFooterView = _footerView;
    _footerView.delegate = self;
//    footerView.saleInfo = self.saleInfo;
    [_footerView setAddressInfo:_addressInfo];
    _tableView.sectionHeaderHeight = 300;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    UIButton *commit = [UIButton buttonWithType:UIButtonTypeCustom];
    [commit setTitle:@"提交" forState:UIControlStateNormal];
    [commit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commit addTarget:self
               action:@selector(commitAfterSaleInfo)
     forControlEvents:UIControlEventTouchDown];
    commit.titleLabel.font = [UIFont systemFontOfSize:14];
    commit.frame = CGRectMake(0, 0, 40, 20);
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:commit];
    
    self.navigationItem.rightBarButtonItem = right;
}

#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = 0;
    if (self.picData) {
        row = (self.picData.count-1) / 4;
    }
    else if (self.saleInfo) {
        row = (self.saleInfo.useDetail.proof.count-1) / 4;
    }
    CGFloat height = 44;
    
    switch (row)
    {
        case 0:
            height = TFScalePoint(80);
            break;
        case 1:
            height = TFScalePoint(160);
            break;
        case 2:
            height = TFScalePoint(240);
            break;
        default:
            break;
    }
    return height;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MallGetEvidencePicture";
    HYMallGetEvidencePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.delegate = self;
    [cell setPicData:[self.picData copy]];
//    if (self.saleInfo)
//    {
//        cell.saleInfo = self.saleInfo;
//    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        [self.view endEditing:YES];
    }

}

#pragma mark  HYMallGetEvidencePictureCellDelegate
- (void)getPicFromCamera
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相机" otherButtonTitles:@"相册", nil];
    sheet.delegate = self;
    [sheet showInView:self.view];
    
    void (^block)(NSUInteger index) = ^(NSUInteger index){
        if (0 == index)//照相机
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker = [UIImagePickerController new];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
                picker.allowsEditing = YES;
                [self presentViewController:picker animated:YES completion:nil];
            }
        }else if (1 == index)//相册
        {
            [self getPicFromPhotoAlbum];
        }
    };
    
    objc_setAssociatedObject(sheet, HYMallApplyAfterSaleServiceActionSheetKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)jumpToBrowserFromIndex:(NSInteger)index
{
    GWPhotoBrowserViewController *vc = [GWPhotoBrowserViewController new];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.picData = self.picOriginalData;
    vc.delegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark action sheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^block)(NSUInteger index) = objc_getAssociatedObject(actionSheet, HYMallApplyAfterSaleServiceActionSheetKey);
    block(buttonIndex);
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //生成一张缩略图
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.picOriginalData addObject:image];
    
    UIImage *thumb = [self imageThumbNailImageWith:image];
    
    UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newBtn setBackgroundImage:thumb forState:UIControlStateNormal];
    [self.picData addObject:newBtn];
    
    [_tableView reloadData];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark aftersale deletephoto
- (void)updatePicData:(NSMutableArray *)picData
{
    NSMutableArray *temp = [NSMutableArray array];
    
    for (UIImage *img in picData)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        [temp addObject:btn];
    }

    //把第一张图后面的图全部删除，然后用新图数组追加
    [self.picData removeObjectsInRange:NSMakeRange(1, self.picData.count-1)];
    [self.picData addObjectsFromArray:temp];
    
    [_tableView reloadData];
}

#pragma mark getter and setter
-(void)setAddressInfo:(HYAddressInfo *)addressInfo
{
    _addressInfo = addressInfo;
    
    if (_addressInfo.realName)
    {
        _receiverText = _addressInfo.realName;
    }
    else
    {
        _receiverText = _addressInfo.name;
    }
    
    _mobileText = _addressInfo.mobile;
    _addressDetailText = _addressInfo.fullRegion;
    _addressDetailSecondText = _addressInfo.address;
    
}

- (NSMutableArray *)picData
{
    if (!_picData)
    {
        _picData = [NSMutableArray array];
        
        /*
        UIButton *photoAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
        photoAlbum.frame = CGRectMake(70, 10, 50, 50);
        [photoAlbum setBackgroundImage:[UIImage imageNamed:@"mall_afterSaleEvidence"] forState:UIControlStateNormal];
        [_picData addObject:photoAlbum];
         */
        UIButton *camera = [UIButton buttonWithType:UIButtonTypeCustom];
        [camera setBackgroundImage:[UIImage imageNamed:@"mall_afterSaleCamera"] forState:UIControlStateNormal];
        camera.frame = CGRectMake(10, 10, 50, 50);
        [_picData addObject:camera];
    }
    return _picData;
}

- (NSMutableArray *)picOriginalData
{
    if (!_picOriginalData)
    {
        _picOriginalData = [NSMutableArray array];
    }
    return _picOriginalData;
}

- (void)setSaleInfo:(HYMallAfterSaleInfo *)saleInfo
{
    if (_saleInfo != saleInfo)
    {
        _saleInfo = saleInfo;
        if (saleInfo.useDetail.proof.count > 0)
        {
            for (HYMallAfterSaleProof *proof in saleInfo.useDetail.proof)
            {
                UIImage *img = [UIImage imageNamed:@"loading"];
                [self.picOriginalData addObject:img];
                NSInteger idx = [saleInfo.useDetail.proof indexOfObject:proof];
                __weak typeof(self) weakSelf = self;
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                NSURL *url = [NSURL URLWithString:proof.imageUrl];
                [btn sd_setBackgroundImageWithURL:url
                                         forState:UIControlStateNormal
                                 placeholderImage:[UIImage imageNamed:@"loading"]
                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                {
                    if (img)
                    {
                        [weakSelf.picOriginalData replaceObjectAtIndex:idx withObject:image];
                    }
                }];
                [self.picData addObject:btn];
            }
        }
    }
}

#pragma mark HYMallApplyAfterSaleFooterViewDelegate
- (void)beginContentOffSet
{
    //IPhone 4S
    if ([UIScreen mainScreen].bounds.size.height == 480)
    {
        [_tableView setContentOffset:CGPointMake(0, 420) animated:YES];
    }else
    {
        [_tableView setContentOffset:CGPointMake(0, 320) animated:YES];
    }
}

- (void)informationOfReceiver:(NSString *)text
             fromTextFieldTag:(NSInteger)tag withObject:(id)object
{
    text = [text stringByReplacingOccurrencesOfString:@" "
                                           withString:@""];
    switch (tag)
    {
        case ReceiverTextFied:
            _receiverText = text;
            break;
        case MobileTextFied:
            _mobileText = text;
            break;
        case AddressRegion:
        {
            _addressDetailText = text;
            _addressInfo = object;
            _footerView.layer.borderColor = [UIColor clearColor].CGColor;
        }
            break;
        case AddressDetailTextField:
            _addressDetailSecondText = text;
        default:
            break;
    }
}

#pragma mark HYMallApplyAfterSaleHeaderViewDelegate
- (void)chooseAfteSaleWithType:(AfterSaleType)type
{
    _operationType = type;
}

-(void)applyAfterSaleQuantity:(NSUInteger)quantity
{
    _quantity = quantity;
}

-(void)applyAfterSaleProblemDescription:(NSString *)description
{
    _problemDescription = description;
}

#pragma mark private methods
- (void)getPicFromPhotoAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (UIImage *)imageThumbNailImageWith:(UIImage *)image
{
    UIImage *newImage;
    CGSize asize = CGSizeMake(TFScalePoint(64), TFScalePoint(64));
    
    if (nil == image)
    {
        newImage = nil;
    }
    else
    {
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return newImage;
}

- (void)commitAfterSaleInfo
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    NSString *str = nil;
    BOOL ok = NO;
    
    if (_operationType < 0)
    {
        str = @"请选择售后类型";
    }else if(_quantity <= 0)
    {
        str = @"请选择申请数量";
    }else if ([_problemDescription length] <= 0)
    {
        str = @"请输入问题描述";
    }
    else if (self.picData.count-1 <= 0)
    {
        str = @"请上传照片";
    }
    else if ([_receiverText length] <= 0)
    {
        str = @"请输入联系人姓名";
    }else if ([_mobileText length] <= 0)
    {
        str = @"请输入手机号";
    }else if ([_addressDetailText length] <= 0
              || [_addressDetailSecondText length] <= 0)
    {
        str = @"请输入收货信息";
    }else
    {
        ok = YES;
    }
    
    if (!ok)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else
    {
        if(!_applyAfterSaleServiceReq)
        {
            _applyAfterSaleServiceReq = [[HYApplyAfterSaleServiceReq alloc]init];
        }
        [_applyAfterSaleServiceReq cancel];
        
        _applyAfterSaleServiceReq.operationType = _operationType;
        _applyAfterSaleServiceReq.contactName = _receiverText;
        _applyAfterSaleServiceReq.contactMobile = _mobileText;
        
        //默认订单详情传过来的城市id
        if (_addressInfo.province)
        {
           _applyAfterSaleServiceReq.contactProvinceCode = _addressInfo.province;
        }
        //用户选择的城市ID
        else if (_addressInfo.provinceId)
        {
            _applyAfterSaleServiceReq.contactProvinceCode = _addressInfo.provinceId;
        }
   
        //默认订单详情传过来的城市id
        if (_addressInfo.city)
        {
            _applyAfterSaleServiceReq.contactCityCode = _addressInfo.city;
        }
        //用户选择的城市ID
        else if (_addressInfo.cityId)
        {
            _applyAfterSaleServiceReq.contactCityCode = _addressInfo.cityId;
        }
        
        if (_addressInfo.region)
        {
            _applyAfterSaleServiceReq.contactRegionCode = _addressInfo.region;
        }
        else if (_addressInfo.areaId)
        {
            _applyAfterSaleServiceReq.contactRegionCode = _addressInfo.areaId;
        }

        _applyAfterSaleServiceReq.contactAddress = _addressDetailSecondText;
        _applyAfterSaleServiceReq.quantity = _quantity;
        _applyAfterSaleServiceReq.remark = _problemDescription;
        _applyAfterSaleServiceReq.isUpdate = self.isChange;
        
        if (_returnGoodsInfo)
        {
            _applyAfterSaleServiceReq.orderCode = _orderCode;
            HYMallOrderItem *item = _returnGoodsInfo;
            _applyAfterSaleServiceReq.orderItemId = item.orderItemId;
        }
        else if (_saleInfo)
        {
            _applyAfterSaleServiceReq.orderCode = _saleInfo.orderCode;
            _applyAfterSaleServiceReq.returnFlowCode = _saleInfo.returnFlowCode;
            _applyAfterSaleServiceReq.orderItemId = _saleInfo.useDetail.orderItemId;
            _applyAfterSaleServiceReq.returnFlowDetailId = _saleInfo.useDetail.returnFlowDetailId;
            if (_saleInfo.useDetail.proof.count > 0) {
                NSMutableString *delProof = [NSMutableString string];
                for (HYMallAfterSaleProof *proof in _saleInfo.useDetail.proof) {
                    [delProof appendFormat:@"%@,", proof.returnProofId];
                }
                if (delProof.length > 0) {
                    [delProof deleteCharactersInRange:NSMakeRange(delProof.length-1, 1)];
                }
                _applyAfterSaleServiceReq.delProofId = delProof;
            }
        }
        //按钮的缩略图
//        NSMutableArray *imgDataList = [NSMutableArray array];
//        for (UIButton *btn in self.picData)
//        {
//            UIImage *img = [btn backgroundImageForState:UIControlStateNormal];
//            [imgDataList addObject:img];
//        }
//        if (imgDataList.count > 1)
//        {
//            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
//            [imgDataList removeObjectsAtIndexes:indexSet];
//        }
        
        _applyAfterSaleServiceReq.thumbPicArray = self.picOriginalData;
        
        __weak typeof (self) weakSelf = self;
        [_applyAfterSaleServiceReq sendReuqest:^(HYAfterSaleServiceResponse *result, NSError *error) {
            [weakSelf updateWithResponse:result error:error];
        }];
    }
}

- (void)updateWithResponse:(HYAfterSaleServiceResponse *)result error:(NSError *)error
{
    if (result && [result isKindOfClass:[HYAfterSaleServiceResponse class]])
    {
        if (result.status == 200)
        {
            HYExpensiveResultView *result = [HYExpensiveResultView instance];
            result.success = YES;
            result.desc = @"可在售后服务中查看售后进度";
            __weak typeof(self) b_self = self;
            [result showWithDuration:2 completionHanlder:^
            {
                NSMutableArray *controllers = [b_self.navigationController.viewControllers mutableCopy];
                [controllers removeObjectAtIndex:controllers.count-2];
                b_self.navigationController.viewControllers = controllers;
                [b_self.navigationController popViewControllerAnimated:YES];
            }];
            if (self.updateCallback) {
                self.updateCallback();
            }
            if (self.applyCallback) {
                self.applyCallback();
            }
        }
        /*
         针对此需求，服务端会对用户收货地址校验返回指定的错误code(下单：29901036收货地址升级，请小主重新编辑地址并保存，退换货：29901037退换货地址升级，请小主重新编辑地址并保存），请APP配合调整！
         */
        else if (result.code == 29901036 ||
                 result.code == 29901037)
        {
            _footerView.layer.borderColor = [UIColor redColor].CGColor;
            _footerView.layer.borderWidth = 2;
        }
        else
        {
            HYExpensiveResultView *result = [HYExpensiveResultView instance];
            result.success = NO;
            result.desc = error.domain;
            [result showWithDuration:2 completionHanlder:^{
                
            }];
        }
    }
}
@end
