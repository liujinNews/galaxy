//
//  DoneBtnView.m
//  galaxy
//
//  Created by hfk on 2017/7/24.
//  Copyright © 2017年 赵碚. All rights reserved.
//
#define ItemWidth self.frame.size.width/_titleArray.count
#define ItemHeight self.frame.size.height
#import "DoneBtnView.h"

@implementation DoneBtnView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.clipsToBounds=YES;
    }
    return self;
}
-(void)updateNewFormViewWithTitleArray:(NSArray *)title{
    switch (title.count) {
        case 1:
            [self updateViewWithTitleArray:title WithTitleColorArray:@[Color_form_TextFieldBackgroundColor] WithBgColor:@[Color_Blue_Important_20] WithLineColroArray:@[Color_Blue_Important_20] WithLineStyle:1];
            break;
        case 2:
            [self updateViewWithTitleArray:title WithTitleColorArray:@[Color_Blue_Important_20,Color_form_TextFieldBackgroundColor] WithBgColor:@[Color_form_TextFieldBackgroundColor,Color_Blue_Important_20] WithLineColroArray:@[Color_Blue_Important_20,Color_Blue_Important_20] WithLineStyle:1];
            break;
        case 3:
            [self updateViewWithTitleArray:title WithTitleColorArray:@[] WithBgColor:@[] WithLineColroArray:@[] WithLineStyle:1];
            break;
        default:
            break;
    }
}
-(void)updateLookFormViewWithTitleArray:(NSArray *)title{
    switch (title.count) {
        case 1:
            [self updateViewWithTitleArray:title WithTitleColorArray:@[Color_form_TextFieldBackgroundColor] WithBgColor:@[Color_Blue_Important_20] WithLineColroArray:@[Color_Blue_Important_20] WithLineStyle:1];
            break;
        case 2:
            [self updateViewWithTitleArray:title WithTitleColorArray:@[Color_Blue_Important_20,Color_form_TextFieldBackgroundColor] WithBgColor:@[Color_form_TextFieldBackgroundColor,Color_Blue_Important_20] WithLineColroArray:@[Color_Blue_Important_20,Color_Blue_Important_20] WithLineStyle:1];
            break;
        case 3:
            [self updateViewWithTitleArray:title WithTitleColorArray:@[Color_Blue_Important_20,Color_Blue_Important_20,Color_form_TextFieldBackgroundColor] WithBgColor:@[Color_form_TextFieldBackgroundColor,Color_form_TextFieldBackgroundColor,Color_Blue_Important_20] WithLineColroArray:@[Color_Blue_Important_20,Color_Blue_Important_20,Color_Blue_Important_20] WithLineStyle:1];
            break;
        default:
            break;
    }
}

-(void)updateViewWithTitleArray:(NSArray *)title WithTitleColorArray:(NSArray *)titleColor WithBgColor:(NSArray *)bgColor WithLineColroArray:(NSArray *)lineColor WithLineStyle:(NSInteger)style{
    _titleArray=title;
    _titleColor=titleColor;
    _titleBgColor=bgColor;
    _titleLineColor=lineColor;
    [self createBtnsWithLineStyle:style];
}
-(void)updateViewWithTitleArray:(NSArray *)title WithSizeArray:(NSArray *)sizeArray WithTitleColorArray:(NSArray *)titleColor WithBgColor:(NSArray *)bgColor WithLineColroArray:(NSArray *)lineColor{
    _sizeArray=sizeArray;
    _titleArray=title;
    _titleColor=titleColor;
    _titleBgColor=bgColor;
    _titleLineColor=lineColor;
    [self createBtnsWithLineStyle:1];
}

-(void)createBtnsWithLineStyle:(NSInteger)lineStyle{
    
    NSInteger x=0;
    for (int i = 0;  i < self.titleArray.count; i++) {
        UIButton *btn;
        if (_sizeArray&&_sizeArray.count>0) {
            float width=Main_Screen_Width*[_sizeArray[i] floatValue];
            btn=[GPUtils createButton:CGRectMake(x, 0, width, ItemHeight) action:@selector(btn_Click:) delegate:self title:_titleArray[i] font:Font_filterTitle_17 titleColor:_titleColor[i]];
            x=x+width;
        }else{
            btn=[GPUtils createButton:CGRectMake(i*ItemWidth, 0, ItemWidth, ItemHeight) action:@selector(btn_Click:) delegate:self title:_titleArray[i] font:Font_filterTitle_17 titleColor:_titleColor[i]];
        }
        btn.backgroundColor=_titleBgColor[i];
        UIColor *color=_titleLineColor[i];
        [self borderForView:btn color:color withLineStyle:lineStyle];
        btn.tag=i;
        [self addSubview:btn];
    }
}
-(void)btn_Click:(UIButton *)btn{
    NSInteger index=btn.tag;
    btn.userInteractionEnabled=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.userInteractionEnabled=YES;
    });
    if (self.btnClickBlock) {
        self.btnClickBlock(index);
    }
}

-(void)updateBatchBtnWithTitle:(NSString *)title{

    NSInteger width=ceil(Main_Screen_Width*4/15);
    _btn_SelectAll=[GPUtils createButton:CGRectMake(0, 0, width, 50) action:@selector(selectAll_Click:) delegate:self title:nil font:Font_Important_15_20 titleColor:Color_Black_Important_20];
    [_btn_SelectAll setAttributedTitle:[self getStringWithTitle:@"0/0"] forState:UIControlStateNormal];
    _btn_SelectAll.titleLabel.numberOfLines=0;
    _btn_SelectAll.tag=0;
    _btn_SelectAll.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_btn_SelectAll setImage:[UIImage imageNamed:@"MyApprove_UnSelect"] forState:UIControlStateNormal];
    [self addSubview:_btn_SelectAll];
    [_btn_SelectAll makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(4/15.f);
    }];
    [self borderForView:_btn_SelectAll color:Color_Blue_Important_20 withLineStyle:1];

    UIButton *btn=[GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width-width, 50) action:@selector(selectAll_Click:) delegate:self title:title font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    btn.tag=1;
    btn.backgroundColor=Color_Blue_Important_20;
    [self addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btn_SelectAll.right);
        make.top.bottom.right.equalTo(self);
    }];
    [self borderForView:btn color:Color_Blue_Important_20 withLineStyle:1];
}

-(void)selectAll_Click:(UIButton *)btn{
    NSInteger index=btn.tag;
    if (self.btnClickBlock) {
        self.btnClickBlock(index);
    }
}
-(void)updateSelectAllBtnWithTitle:(NSString *)title withSelected:(BOOL)selected{
    [_btn_SelectAll setAttributedTitle:[self getStringWithTitle:title] forState:UIControlStateNormal];
    [_btn_SelectAll setImage:[UIImage imageNamed:selected ? @"MyApprove_Select":@"MyApprove_UnSelect"] forState:UIControlStateNormal];
}

-(void)borderForView:(UIButton *)original color:(UIColor *)color withLineStyle:(NSInteger)style{
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    
    if (style==1) {
        
        [bezierPath moveToPoint:CGPointMake(original.bounds.size.width,original.bounds.size.height)];
        
        [bezierPath addLineToPoint:CGPointMake(0, original.bounds.size.height)];
        
        [bezierPath addLineToPoint:CGPointMake(0, 0)];
        
        [bezierPath addLineToPoint:CGPointMake(original.bounds.size.width, 0)];

    }else if (style==2){
        
        [bezierPath moveToPoint:CGPointMake(original.bounds.size.width,14)];
        
        [bezierPath addLineToPoint:CGPointMake(original.bounds.size.width, 14+22)];
        
    }
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.strokeColor = color.CGColor;
    
    shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    
    shapeLayer.path = bezierPath.CGPath;
    
    shapeLayer.lineWidth = 1.0f;
    
    [original.layer addSublayer:shapeLayer];
}

-(NSMutableAttributedString *)getStringWithTitle:(NSString *)title{
    NSString *str1=Custing(@"  全选", nil);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n  %@",str1,title]];
    [str addAttribute:NSForegroundColorAttributeName value:Color_Black_Important_20 range:NSMakeRange(0, str1.length)];
    [str addAttribute:NSFontAttributeName value:Font_Important_15_20 range:NSMakeRange(0, str1.length)];
    [str addAttribute:NSForegroundColorAttributeName value:Color_GrayDark_Same_20 range:NSMakeRange(str1.length, str.length-str1.length)];
    [str addAttribute:NSFontAttributeName value:Font_Same_12_20 range:NSMakeRange(str1.length, str.length-str1.length)];
    return str;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
