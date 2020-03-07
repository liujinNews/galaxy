//
//  UIView+Common.m
//  galaxy
//
//  Created by hfk on 2018/5/4.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (Common)
static char BlankPageViewKey;



#pragma mark BlankPageView
- (void)setBlankPageView:(EaseBlankPageView *)blankPageView{
    [self willChangeValueForKey:@"BlankPageViewKey"];
    objc_setAssociatedObject(self, &BlankPageViewKey,
                             blankPageView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"BlankPageViewKey"];
}

- (EaseBlankPageView *)blankPageView{
    return objc_getAssociatedObject(self, &BlankPageViewKey);
}

- (void)configBlankPage:(EaseBlankPageType)blankPageType hasTips:(NSString *)tips hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)(id))block{
    [self configBlankPage:blankPageType hasTips:tips hasData:hasData hasError:hasError offsetY:0 reloadButtonBlock:block];
}

- (void)configBlankPage:(EaseBlankPageType)blankPageType hasTips:(NSString *)tips hasData:(BOOL)hasData hasError:(BOOL)hasError offsetY:(CGFloat)offsetY reloadButtonBlock:(void(^)(id sender))block{
    if (hasData) {
        if (self.blankPageView) {
            self.blankPageView.hidden = YES;
            [self.blankPageView removeFromSuperview];
        }
    }else{
        if (!self.blankPageView) {
            self.blankPageView = [[EaseBlankPageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];//self.bounds
        }
        self.blankPageView.hidden = NO;
        [self.blankPageContainer insertSubview:self.blankPageView atIndex:0];
        [self.blankPageView configWithType:blankPageType hasTips:tips hasData:hasData hasError:hasError offsetY:offsetY reloadButtonBlock:block];
    }
}

- (UIView *)blankPageContainer{
    UIView *blankPageContainer = self;
    for (UIView *aView in [self subviews]) {
        if ([aView isKindOfClass:[UITableView class]]) {
            blankPageContainer = aView;
        }
    }
    return blankPageContainer;
}

@end


@implementation EaseBlankPageView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color_form_TextFieldBackgroundColor;
    }
    return self;
}

- (void)configWithType:(EaseBlankPageType)blankPageType hasTips:(NSString *)tips hasData:(BOOL)hasData hasError:(BOOL)hasError offsetY:(CGFloat)offsetY reloadButtonBlock:(void (^)(id))block{
    _curType = blankPageType;
    _reloadButtonBlock = block;
    
    if (hasData) {
        [self removeFromSuperview];
        return;
    }
    self.alpha = 1.0;
    //    图片
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_showImageView];
    }
    //    标题
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [GPUtils colorHString:ColorGray];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    //    文字
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.textColor = [GPUtils colorHString:ColorGray];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
    }
    //    按钮
    if (!_actionButton) {//新增按钮
        _actionButton = ({
            UIButton *button = [UIButton new];
            button.backgroundColor =[GPUtils colorHString:@"#425063"];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            button;
        });
        [self addSubview:_actionButton];
    }
    if (!_reloadButton) {//重新加载按钮
        _reloadButton = ({
            UIButton *button = [UIButton new];
            button.backgroundColor = [GPUtils colorHString:@"#425063"];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button addTarget:self action:@selector(reloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            button;
        });
        [self addSubview:_reloadButton];
    }
    NSString *imageName, *titleStr, *tipStr;
    NSString *buttonTitle;
    if (hasError) {
        //        加载失败
        _actionButton.hidden = YES;
        tipStr = @"呀，网络出了问题";
        imageName = @"blankpage_image_LoadFail";
        buttonTitle = @"重新连接网络";
    }else{
        //        空白数据
        _reloadButton.hidden = YES;
        if (tips) {
            tipStr = tips;
        }else{
            tipStr = Custing(@"暂无数据", nil);
        }
        switch (_curType) {
            case EaseBlankNormalView: {
            }
                break;
            default:
                break;
        }
    }
    imageName = @"noData_image_Default";
    UIButton *bottomBtn = hasError? _reloadButton: _actionButton;
    _showImageView.image = [UIImage imageNamed:imageName];
    _titleLabel.text = titleStr;
    _tipLabel.text = tipStr;
    [bottomBtn setTitle:buttonTitle forState:UIControlStateNormal];
    _titleLabel.hidden = titleStr.length <= 0;
    bottomBtn.hidden = buttonTitle.length <= 0;
    
//    //    布局
//    if (ABS(offsetY) > 0) {
//        self.frame = CGRectMake(0, offsetY, self.width, self.height);
//    }
    [_showImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_bottom).multipliedBy(0.15);
        make.size.mas_equalTo(CGSizeMake(175, 175));
    }];
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.top.equalTo(self.showImageView.mas_bottom);
    }];
    
    [_tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        if (titleStr.length > 0) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        }else{
            make.top.equalTo(self.showImageView.mas_bottom);
        }
    }];
    if (buttonTitle.length > 0) {
        
    }
    [bottomBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(130, 44));
        make.top.equalTo(self.tipLabel.mas_bottom).offset(25);
    }];
}

- (void)reloadButtonClicked:(id)sender{
    self.hidden = YES;
    [self removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.reloadButtonBlock) {
            self.reloadButtonBlock(sender);
        }
    });
}

-(void)btnAction{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.clickButtonBlock) {
            self.clickButtonBlock(self.curType);
        }
    });
}

@end

