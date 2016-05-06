//
//  HYMallCartCell.m
//  Teshehui
//
//  Created by RayXiang on 14-9-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallCartCell.h"
#import "UIView+Style.h"
#import "UIImage+Addition.h"
#import "UIImageView+WebCache.h"
#import "HYImageButton.h"
#import "HYShengView.h"
#import "HYUmengMobClick.h"

@interface HYMallCartCell ()

@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIImageView *invalidView;
@property (nonatomic, strong) UIImageView *productView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *sizeLab;
@property (nonatomic, strong) UILabel *totalLab;
@property (nonatomic, strong) UILabel *stockLab;
@property (nonatomic, strong) HYShengView *shengV;

@property (nonatomic, strong) HYQuantityControl *quantityControl;

@property (nonatomic, weak) UIView *editView;
@property (nonatomic, weak) HYImageButton *delBtn;
@property (nonatomic, weak) UILabel *editSizeLab;
@property (nonatomic, weak) UIImageView *editIndicator;

@end


@implementation HYMallCartCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.separatorLeftInset = 0;
        self.edit = NO;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [checkBtn setImage:[UIImage imageNamed:@"check_no"]
                  forState:UIControlStateNormal];
        [checkBtn setImage:[UIImage imageNamed:@"check_yes"] forState:UIControlStateSelected];
        [checkBtn setImage:[UIImage imageNamed:@"cart_expire"] forState:UIControlStateDisabled];
        UIImageView *invalidView = [[UIImageView alloc] init];
        invalidView.image = [UIImage imageNamed:@"cart_expire"];
        _invalidView = invalidView;
        [self.contentView addSubview:invalidView];
        [checkBtn addTarget:self
                     action:@selector(checkBtnAction:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:checkBtn];
        self.checkBtn = checkBtn;
        
        
        UIImageView *productView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:productView];
        self.productView = productView;
        
        
        //名称
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLab.font = [UIFont systemFontOfSize:16.0];
        nameLab.backgroundColor = [UIColor clearColor];
        nameLab.numberOfLines = 0;
        [self.contentView addSubview:nameLab];
        self.nameLab = nameLab;
        
        UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectZero];
        priceLab.font = [UIFont systemFontOfSize:13.0];
        priceLab.backgroundColor = [UIColor clearColor];
        priceLab.numberOfLines = 0;
        priceLab.textColor = [UIColor grayColor];
        [self.contentView addSubview:priceLab];
        self.priceLab = priceLab;
        
        
        //[aBtn addTarget:self
        //         action:@selector(addProductEvent:)
       //forControlEvents:UIControlEventTouchUpInside];
        //[self.contentView addSubview:aBtn];
        
        //尺码
        UILabel *sizeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        sizeLab.font = [UIFont systemFontOfSize:13.0];
        sizeLab.backgroundColor = [UIColor clearColor];
        sizeLab.textColor = [UIColor grayColor];
        sizeLab.numberOfLines = 0;
        [self.contentView addSubview:sizeLab];
        self.sizeLab = sizeLab;
        
        //小计
        UILabel *totalLab = [[UILabel alloc] initWithFrame:CGRectZero];
        totalLab.font = [UIFont systemFontOfSize:13.0];
        totalLab.backgroundColor = [UIColor clearColor];
        totalLab.textColor = [UIColor grayColor];
        totalLab.numberOfLines = 0;
        [self.contentView addSubview:totalLab];
        self.totalLab = totalLab;
        
        //库存
        UILabel *stockLab = [[UILabel alloc] initWithFrame:CGRectZero];
        stockLab.font = [UIFont systemFontOfSize:13.0];
        stockLab.backgroundColor = [UIColor clearColor];
        stockLab.textColor = [UIColor redColor];
        [self.contentView addSubview:stockLab];
        self.stockLab = stockLab;
        
        _shengV = [[HYShengView alloc] initWithDirection:HYShengRight height:36];
        [self.contentView addSubview:_shengV];
        
        HYQuantityControl *quantity = [[HYQuantityControl alloc] initWithFrame:CGRectZero];
        quantity.minQuantity = 0;
        [self.contentView addSubview:quantity];
        self.quantityControl = quantity;
        [self.quantityControl addTarget:self action:@selector(quantityAction:) forControlEvents:UIControlEventValueChanged];
        
        UIView *edit = [[UIView alloc] initWithFrame:CGRectZero];
        edit.backgroundColor = [UIColor colorWithWhite:.98 alpha:1];
        [self.contentView addSubview:edit];
        self.editView = edit;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(editProduct:)];
        [self.editView addGestureRecognizer:tap];
        
        HYImageButton *del = [[HYImageButton alloc] initWithFrame:CGRectZero];
        [del setTitle:@"删除" forState:UIControlStateNormal];
        [del setBackgroundColor:[UIColor redColor]];
        [del setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        del.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [del addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.editView addSubview:del];
        self.delBtn = del;
        
        UILabel *editLab = [[UILabel alloc] initWithFrame:CGRectZero];
        editLab.font = [UIFont systemFontOfSize:15.0];
        editLab.backgroundColor = [UIColor clearColor];
        editLab.textColor = [UIColor grayColor];
        editLab.numberOfLines = 0;
        [self.editView addSubview:editLab];
        _editSizeLab = editLab;
        
        UIImageView *indicator = [[UIImageView alloc] initWithImage:
                                  [UIImage imageNamed:@"icon_arrdown"]];
        [self.editView addSubview:indicator];
        _editIndicator = indicator;
    }
    return self;
}

- (void)checkBtnAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if ([self.delegate respondsToSelector:@selector(cartCellDidClickCheckButton:)])
    {
        [self.delegate cartCellDidClickCheckButton:self];
    }
}

- (void)quantityAction:(HYQuantityControl *)btn
{
    if ([self.delegate respondsToSelector:@selector(cartCell:didEditQuantity:)])
    {
        [self.delegate cartCell:self didEditQuantity:btn.quantity];
    }
    btn.quantity = _product.quantity.integerValue;
}

- (void)addBtnAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(cartCellDidClickAddButton:)])
    {
        [self.delegate cartCellDidClickAddButton:self];
    }
}

- (void)minusBtnAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(cartCellDidClickMinusButton:)])
    {
        [self.delegate cartCellDidClickMinusButton:self];
    }
}

- (void)deleteBtnAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(cartCellDidClickDeleteButton:)])
    {
        [self.delegate cartCellDidClickDeleteButton:self];
    }
}

+ (NSAttributedString *)getPriceDisplayWithProduct:(HYMallCartProduct *)_product
{
    double tprice = 0;
    if (_product.amountAfterSpare.length > 0)
    {
        tprice = _product.amountAfterSpare.floatValue * _product.quantity.integerValue;
    }
    else
    {
        tprice = _product.subPromotionAmount.doubleValue;
    }
    NSString *price = [NSString stringWithFormat:@"¥%.2f",tprice];
    
    long long tpoints = 0;
    if (_product.pointAterSpare.length > 0)
    {
        tpoints = _product.pointAterSpare.longLongValue * _product.quantity.integerValue;
    }
    else
    {
        tpoints = _product.subPromotionPoints.longLongValue;
    }
    
    NSString *points = [NSString stringWithFormat:@"+%@现金券", [NSNumber numberWithLongLong:tpoints]];
    NSString *priceInfo = [NSString stringWithFormat:@"%@%@",
                           price,
                           points];
    NSMutableAttributedString *priceAttr = [[NSMutableAttributedString alloc] initWithString:priceInfo];
    [priceAttr addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                               NSForegroundColorAttributeName: [UIColor colorWithRed:239/255.0 green:0/255.0 blue:44/255.0 alpha:1]}
                       range:NSMakeRange(0, price.length)];
    [priceAttr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13],
                               NSForegroundColorAttributeName: [UIColor grayColor]}
                       range:NSMakeRange(price.length, points.length)];
    return priceAttr;
}

- (void)editProduct:(UITapGestureRecognizer *)tap
{
    
    if ([self.delegate respondsToSelector:@selector(cartCellDidClickEditButton:)])
    {
        [HYUmengMobClick homePageEditColorAndSizeClicked];
        [self.delegate cartCellDidClickEditButton:self];
    }
}

+ (CGFloat)heightForGoods:(HYMallCartProduct *)product withWidth:(CGFloat)width
{
    UIFont *nameFont = [UIFont systemFontOfSize:16];
    UIFont *specFont = [UIFont systemFontOfSize:13];
    CGFloat miniHeight = 64;
    CGFloat left = 135;
    CGFloat xmargin = 12;
    CGFloat w = width - left - xmargin;
    
    //计算
    CGFloat h = 8;
    CGSize size = [product.productName sizeWithFont:nameFont constrainedToSize:CGSizeMake(w, nameFont.lineHeight*2+1)];
    h += MAX(size.height, nameFont.lineHeight);
    
    //尺码，可以没有高度
    if (product.productSKUSpecification.length > 0)
    {
        CGRect frame = [product.productSKUSpecification boundingRectWithSize:CGSizeMake(w, 200)
                                                              options:NSStringDrawingUsesFontLeading|
                 NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:specFont}
                                                              context:nil];
        h += 5 + frame.size.height;
    }
    //价格
    NSAttributedString *priceAttr = [self getPriceDisplayWithProduct:product];
    CGRect frame = [priceAttr boundingRectWithSize:CGSizeMake(w, 200)
                                    options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                    context:nil];
    h += MAX(frame.size.height, specFont.lineHeight) + 5;
    //        setViewYAndHeight(_priceLab, CGRectGetMaxY(_nameLab.frame)+3, size.height);
    
    h += 10 + 36 + 11;
    
    if (product.isOverStock > -1)
    {
        h += 5;
    }
    
    return MAX(h, miniHeight);
}

#pragma mark getter and setter
- (void)setEdit:(BOOL)edit
{
    [self setEdit:edit animated:NO];
}

- (void)setEdit:(BOOL)edit animated:(BOOL)animated
{
    if (_edit != edit)
    {
        _edit = edit;
        [self setViewWithEditAnimated:animated];
    }
}

-(void)setNavEdit:(BOOL)navEdit
{
    [self setNavEdit:navEdit animated:YES];
}

- (void)setNavEdit:(BOOL)edit animated:(BOOL)animated
{
    _navEdit = edit;
    [self setViewFromNavButtonWithEditAnimated:animated];
}

- (void)setViewWithEditAnimated:(BOOL)animated
{
    CGFloat x = _edit ? CGRectGetMinX(_nameLab.frame) : self.frame.size.width;
    CGFloat w = CGRectGetWidth(_nameLab.frame);
    CGFloat h = CGRectGetMaxY(_priceLab.frame) - CGRectGetMinY(_nameLab.frame);
    CGFloat y = CGRectGetMinY(_nameLab.frame);
    _delBtn.hidden = NO;
    
    if (animated)
    {
        [UIView animateWithDuration:.2f animations:^{
            
            _editView.frame = CGRectMake(x, y, w, h);
        } completion:^(BOOL finished) {

        }];
    }
    else
    {
        _editView.frame = CGRectMake(x, y, w, h);
    }
}

- (void)setViewFromNavButtonWithEditAnimated:(BOOL)animated
{
    _delBtn.hidden = YES;

    CGFloat x = _navEdit ? CGRectGetMinX(_nameLab.frame) : self.frame.size.width;
    CGFloat w = CGRectGetWidth(_nameLab.frame);
    CGFloat h = CGRectGetMaxY(_priceLab.frame) - CGRectGetMinY(_nameLab.frame);
    CGFloat y = CGRectGetMinY(_nameLab.frame);

    if (animated)
    {
        [UIView animateWithDuration:.2f animations:^{
            _editView.frame = CGRectMake(x, y, w, h);
        } completion:^(BOOL finished) {
        }];
    }
    else
    {
        _editView.frame = CGRectMake(x, y, w, h);
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.editView.backgroundColor = [UIColor colorWithWhite:.98 alpha:1];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.editView.backgroundColor = [UIColor colorWithWhite:.98 alpha:1];
}

- (void)setProduct:(HYMallCartProduct *)product
{
    //  选中状态
    self.checkBtn.selected = product.isSelect;
    
    //    if (product != _product)
    {
        _product = product;
        //        _product.salePoints = @"3000";
        //        _product.productName = @"adfdfff但是如果你只显示特定的两行，或者几行，也就是说你不需要全部显示label的内容，上面的方法就无法达到了。\
        //        还好，有人写了一个现成的label控件供我们使用。TTTAttributedLabel";
        //        _product.productName = @"abc控件";
        
        CGSize size;
        CGFloat left = 135;
        CGFloat xmargin = 12;
        
        //名称
        CGRect frame;
        frame = [_product.productName boundingRectWithSize:CGSizeMake(self.frame.size.width-xmargin-left, _nameLab.font.lineHeight*2)
                                                   options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:_nameLab.font}
                                                   context:nil];
        frame.size.height = MAX(frame.size.height, _nameLab.font.lineHeight);
        self.nameLab.frame = CGRectMake(left, 8, self.frame.size.width-xmargin-left, frame.size.height);
        self.nameLab.text = _product.productName;
        
        //尺码，可以没有高度
        if (_product.productSKUSpecification.length > 0)
        {
            frame = [_product.productSKUSpecification boundingRectWithSize:CGSizeMake(self.frame.size.width-xmargin-left, 200)
                                                                   options:NSStringDrawingUsesFontLeading|
                     NSStringDrawingUsesLineFragmentOrigin
                                                                attributes:@{NSFontAttributeName:_sizeLab.font}
                                                                   context:nil];
            _sizeLab.frame = CGRectMake(left, CGRectGetMaxY(_nameLab.frame) + 5, frame.size.width, frame.size.height);
        }
        else
        {
            _sizeLab.frame = CGRectZero;
        }
        self.sizeLab.text = [NSString stringWithFormat:@"%@", _product.productSKUSpecification];
        
        
        
        //价格
        NSAttributedString *priceAttr = [self.class getPriceDisplayWithProduct:_product];
        frame = [priceAttr boundingRectWithSize:CGSizeMake(self.frame.size.width-xmargin-left, 200)
                                        options:NSStringDrawingUsesFontLeading
                                        context:nil];
        frame.size.height = MAX(frame.size.height, _priceLab.font.lineHeight);
        //        setViewYAndHeight(_priceLab, CGRectGetMaxY(_nameLab.frame)+3, size.height);
        _priceLab.frame = CGRectMake(left, CGRectGetMaxY(_sizeLab.frame) + 5, frame.size.width, frame.size.height);
        self.priceLab.attributedText = priceAttr;
        
        //        NSLog(@"%@", priceAttr);
        //        NSLog(@"%@", frame);
        
        //图片
        NSURL *URL = [NSURL URLWithString:_product.productSKUPicUrl];
        [self.productView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"logo_loading"]];
        self.productView.frame = CGRectMake(54, CGRectGetMinY(_nameLab.frame)+10, 65, 57);
        
        /// 选中按钮
        //  如果库存为零，不显示选中按钮，显示失效标记，
        self.checkBtn.frame = CGRectMake(0, CGRectGetMinY(_productView.frame), 54, _productView.frame.size.height);
        self.invalidView.frame = CGRectMake(5, CGRectGetMaxY(self.checkBtn.frame)-10, 40, 16);
        if (product.isOverStock == 0)
        {
//            _checkBtn.selected = NO;
            
            if (self.isIconHiden)
            {
                self.checkBtn.enabled = NO;
                _invalidView.hidden = YES;
            }
            else
            {
                self.checkBtn.enabled = YES;
                _invalidView.hidden = NO;
            }
        }
        else
        {
            self.checkBtn.enabled = YES;
            _invalidView.hidden = YES;
        }
        
        //库存
        if (product.isOverStock > -1 && product.isSelect)
        {
            self.stockLab.hidden = NO;
            self.stockLab.text = [NSString stringWithFormat:@"您最多只能购买%ld件",(long)product.isOverStock];
            [self.stockLab sizeToFit];
            self.stockLab.frame = CGRectMake(self.frame.size.width-12 - _stockLab.frame.size.width,
                                             CGRectGetMaxY(_priceLab.frame)+5,
                                             _stockLab.frame.size.width,
                                             _stockLab.frame.size.height);
            
        }
        else
        {
            _stockLab.hidden = YES;
        }
        
        //数量
        CGFloat quantityWidth = 120;
        if (product.isOverStock > -1 && product.isSelect)
        {
            _quantityControl.frame = CGRectMake(self.frame.size.width-quantityWidth-12,
                                                CGRectGetMaxY(_stockLab.frame),
                                                quantityWidth,
                                                36);
        }
        else
        {
            self.quantityControl.frame = CGRectMake(self.frame.size.width-quantityWidth-12,
                                                    CGRectGetMaxY(_priceLab.frame) + 10,
                                                    quantityWidth,
                                                    36);
        }
        
        self.quantityControl.quantity = _product.quantity.integerValue;
        
        
        
        //省
        
        long long tspare = 0;
        if (_product.spareAmount.length > 0)
        {
            tspare = _product.spareAmount.longLongValue * _product.quantity.integerValue;
        }
        else
        {
            tspare = _product.subPromotionSpareAmount.longLongValue;
        }
        NSString *spare = [NSString stringWithFormat:@"%@", [NSNumber numberWithLongLong:tspare]];
        left = 55;
        [_shengV setPoint:CGPointMake(left, CGRectGetMinY(_quantityControl.frame)) maxWidth:(self.frame.size.width-left-_quantityControl.frame.size.width)];
        _shengV.sheng = spare;
        
        //编辑
        _editView.frame = CGRectMake(self.frame.size.width,
                                     CGRectGetMinY(_nameLab.frame),
                                     CGRectGetWidth(_nameLab.frame),
                                     CGRectGetMaxY(_priceLab.frame) - CGRectGetMinY(_nameLab.frame));
        _delBtn.frame = CGRectMake(_editView.frame.size.width-60, 0, 60, _editView.frame.size.height);
        _editSizeLab.text = _product.productSKUSpecification;
        size = [_editSizeLab sizeThatFits:CGSizeMake(_editView.frame.size.width-80,
                                                     _editView.frame.size.height-25)];
        _editSizeLab.frame = CGRectMake(10, 10, size.width, size.height);
        _editIndicator.frame = CGRectMake(CGRectGetMidX(_editSizeLab.frame)-_editIndicator.frame.size.width/2,
                                          _editView.frame.size.height - _editIndicator.frame.size.height-5,
                                          _editIndicator.frame.size.width,
                                          _editIndicator.frame.size.height);
       
        [self setViewWithEditAnimated:NO];
//        [self setViewFromNavButtonWithEditAnimated:NO];
    }
}



@end
