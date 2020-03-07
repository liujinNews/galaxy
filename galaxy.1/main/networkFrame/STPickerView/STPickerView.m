//
//  STPickerView.m
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/17.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import "STPickerView.h"


@implementation STPickerView

#pragma mark - --- init 视图初始化 ---
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupDefault];
        [self setupUI];
    }
    return self;
}

- (void)setupDefault
{
    // 1.设置数据的默认值
    _title             = nil;
    _font              = [UIFont systemFontOfSize:15];
    _titleColor        = Color_Unsel_TitleColor;
    _borderButtonColor = RGB(205, 205, 205);
    _heightPicker      = 250;
    _contentMode       = STPickerContentModeBottom;
    
    // 2.设置自身的属性
    self.bounds = [UIScreen mainScreen].bounds;
    self.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
    self.layer.opacity = 0.0;
    [self addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.添加子视图
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.lineUpView];
    [self.contentView addSubview:self.pickerView];
    [self.contentView addSubview:self.buttonLeft];
    [self.contentView addSubview:self.buttonRight];
    [self.contentView addSubview:self.labelTitle];
    [self.contentView addSubview:self.lineViewDown];
}

- (void)setupUI
{

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.contentMode == STPickerContentModeBottom) {
    }else {
        self.buttonLeft.sty = self.lineViewDown.stbottom + STMarginSmall;
        self.buttonRight.sty = self.lineViewDown.stbottom + STMarginSmall;
    }
}

#pragma mark - --- delegate 视图委托 ---

#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    [self remove];
}

- (void)selectedCancel
{
    [self remove];
}

#pragma mark - --- private methods 私有方法 ---


- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setCenter:[UIApplication sharedApplication].keyWindow.center];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    if (self.contentMode == STPickerContentModeBottom) {
        CGRect frameContent =  self.contentView.frame;
        frameContent.origin.y -= self.contentView.stheight;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.layer setOpacity:1.0];
            self.contentView.frame = frameContent;
        } completion:^(BOOL finished) {
        }];
    }else {
        CGRect frameContent =  self.contentView.frame;
        frameContent.origin.y -= (ScreenHeight+self.contentView.stheight)/2;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.layer setOpacity:1.0];
            self.contentView.frame = frameContent;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)remove
{
    if (self.contentMode == STPickerContentModeBottom) {
        CGRect frameContent =  self.contentView.frame;
        frameContent.origin.y += self.contentView.stheight;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.layer setOpacity:0.0];
            self.contentView.frame = frameContent;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else {
        CGRect frameContent =  self.contentView.frame;
        frameContent.origin.y += (ScreenHeight+self.contentView.stheight)/2;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.layer setOpacity:0.0];
            self.contentView.frame = frameContent;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - --- setters 属性 ---

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.labelTitle setText:title];
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    [self.buttonLeft.titleLabel setFont:font];
    [self.buttonRight.titleLabel setFont:font];
    [self.labelTitle setFont:font];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    [self.labelTitle setTextColor:titleColor];
    [self.buttonLeft setTitleColor:titleColor forState:UIControlStateNormal];
    [self.buttonRight setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setBorderButtonColor:(UIColor *)borderButtonColor
{
    _borderButtonColor = borderButtonColor;
    [self.buttonLeft addBorderColor:borderButtonColor];
    [self.buttonRight addBorderColor:borderButtonColor];
}

- (void)setHeightPicker:(CGFloat)heightPicker
{
    _heightPicker = heightPicker;
    self.contentView.height = heightPicker;
}

- (void)setContentMode:(STPickerContentMode)contentMode
{
    _contentMode = contentMode;
    if (contentMode == STPickerContentModeCenter) {
        self.contentView.stheight += STControlSystemHeight;
    }
}
#pragma mark - --- getters 属性 ---
- (UIView *)contentView
{
    if (!_contentView) {
        CGFloat contentX = 0;
        CGFloat contentY = ScreenHeight;
        CGFloat contentW = ScreenWidth;
        CGFloat contentH = self.heightPicker;
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(contentX, contentY, contentW, contentH)];
        [_contentView setBackgroundColor:Color_White_Same_20];
    }
    return _contentView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        CGFloat lineX = 0;
        CGFloat lineY = STControlSystemHeight;
        CGFloat lineW = self.contentView.stwidth;
        CGFloat lineH = 0.5;
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
        [_lineView setBackgroundColor:Color_LineGray_Same_20];
    }
    return _lineView;
}
- (UIView *)lineUpView
{
    if (!_lineUpView) {
        CGFloat lineX = 0;
        CGFloat lineY = 0;
        CGFloat lineW = self.contentView.stwidth;
        CGFloat lineH = 0.5;
        _lineUpView = [[UIView alloc]initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
        [_lineUpView setBackgroundColor:Color_LineGray_Same_20];
    }
    return _lineUpView;
}
- (UIPickerView *)pickerView{
    if (!_pickerView) {
        CGFloat pickerW = self.contentView.stwidth;
        CGFloat pickerH = self.contentView.stheight - self.lineView.stbottom;
        CGFloat pickerX = 0;
        CGFloat pickerY = self.lineView.stbottom;
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 9.0) {
            _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(pickerX, pickerY, pickerW, pickerH+20)];
        } else {
            _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(pickerX, pickerY, pickerW, pickerH)];
        }
        [_pickerView setBackgroundColor:Color_form_TextFieldBackgroundColor];
    }
    return _pickerView;
}

- (UIButton *)buttonLeft
{
    if (!_buttonLeft) {
        CGFloat leftW = 45;
        CGFloat leftH = STControlSystemHeight;
        CGFloat leftX = 5;
        CGFloat leftY = 0;
        _buttonLeft=[GPUtils createButton:CGRectMake(leftX, leftY, leftW, leftH) action:@selector(selectedCancel) delegate:self title:Custing(@"取消", nil)  font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    }
    return _buttonLeft;
}

- (UIButton *)buttonRight
{
    if (!_buttonRight) {
        CGFloat rightW = 40;
        CGFloat rightH = STControlSystemHeight;
        CGFloat rightX = self.contentView.stwidth - 45;
        CGFloat rightY = 0 ;
        _buttonRight=[GPUtils createButton:CGRectMake(rightX, rightY, rightW, rightH) action:@selector(selectedOk) delegate:self title:Custing(@"确定", nil)  font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    }
    return _buttonRight;
}

- (UILabel *)labelTitle
{
    if (!_labelTitle) {
        CGFloat titleX = self.buttonLeft.stright + STMarginSmall;
        CGFloat titleY = 0;
        CGFloat titleW = self.contentView.stwidth - titleX * 2;
        CGFloat titleH = self.lineView.sttop;
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
        [_labelTitle setTextAlignment:NSTextAlignmentCenter];
        [_labelTitle setTextColor:Color_cellTitle];
        [_labelTitle setFont:Font_cellContent_16];
        _labelTitle.adjustsFontSizeToFitWidth = YES;
    }
    return _labelTitle;
}

- (UIView *)lineViewDown
{
    if (!_lineViewDown) {
        CGFloat lineX = 0;
        CGFloat lineY = self.pickerView.stbottom;
        CGFloat lineW = self.contentView.stwidth;
        CGFloat lineH = 0.5;
        _lineViewDown = [[UIView alloc]initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
        [_lineViewDown setBackgroundColor:self.borderButtonColor];
    }
    return _lineViewDown;
}
@end

