//
//  MyNewFriendCell.m
//  MyDemo
//
//  Created by tomzhu on 15/7/6.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "MyNewFriendCell.h"
#import "MySystemNotifyModel.h"
#import "NSStringEx.h"
#import "ConstDefine.h"
#import "UIViewAdditions.h"

@interface MyNewFriendCell(){
    UILabel *_nameLabel;
    UIImageView *_headerFaceView;
    UIView *_bgView;
    UIButton *_acceptBtn;
    UILabel *_appReason;
}

@property (nonatomic, strong)MySystemNotifyModel *model;

@end

@implementation MyNewFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initBgView];
        [self initHeadImage];
        [self initNameLabel];
        [self initApplyReason];
        [self initAcceptBtn];
        
        [self setSelected:NO];
    }
    return self;
}

- (void)initBgView{
    [self setBackgroundColor:RGBACOLOR(0xf7, 0xf7, 0xf1, 1.0f)];
    self.contentView.backgroundColor = RGBACOLOR(0xf7, 0xf7, 0xf1, 1.0f);
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CONTACT_CELL_H)];
    [self.contentView addSubview:_bgView];
}

- (void)initHeadImage{
    UIImage *headerImage = [UIImage imageNamed:@"tab_contact_nor"];
    _headerFaceView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (CONTACT_CELL_H-headerImage.size.height)/2,
                                                                    headerImage.size.width, headerImage.size.height)];
    _headerFaceView.image = headerImage;
    [self.contentView addSubview:_headerFaceView];
}

- (void)initNameLabel{
    CGFloat width = (SCREEN_WIDTH-_headerFaceView.frame.size.width-30)/4*3;//30为各控件之间间隔之和
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerFaceView.frame.origin.x + _headerFaceView.frame.size.width+10, 7, width, 20)];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _nameLabel.numberOfLines = 0;
    _nameLabel.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_nameLabel];
}

- (void)initApplyReason{
    CGFloat width = (SCREEN_WIDTH-_headerFaceView.frame.size.width-30)/4*3;//30为各控件之间间隔之和
    _appReason = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, 24, width, 20)];
    _appReason.font = [UIFont systemFontOfSize:16];
    _appReason.textColor = [UIColor grayColor];
    _appReason.backgroundColor = [UIColor clearColor];
    _appReason.lineBreakMode = NSLineBreakByTruncatingTail;
    _appReason.numberOfLines = 0;
    _appReason.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_appReason];
}

- (void)initAcceptBtn{
    CGFloat width = (SCREEN_WIDTH-_headerFaceView.frame.size.width-30)/4;//30为各控件之间间隔之和
    _acceptBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.ttright-width-10, (self.ttheight-20)/2, width, 30)];
    _acceptBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_acceptBtn setTitle:@"同意" forState:UIControlStateNormal];
    [_acceptBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_acceptBtn setTitle:@"已添加" forState:UIControlStateDisabled];
    
    _acceptBtn.clipsToBounds = YES;
    _acceptBtn.layer.borderWidth = 1.0f;
    _acceptBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _acceptBtn.layer.cornerRadius = _acceptBtn.frame.size.height/2;
    [_acceptBtn.layer setMasksToBounds:YES];
    _acceptBtn.backgroundColor = [UIColor blueColor];
    [_acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [_acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [_acceptBtn addTarget:self action:@selector(onAcceptBtnDownClick:) forControlEvents:UIControlEventTouchDown];
    [_acceptBtn addTarget:self action:@selector(onAacceptBtnUpInClick:) forControlEvents:UIControlEventTouchUpInside];
    [_acceptBtn addTarget:self action:@selector(onAcceptBtnUpOutClick:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView addSubview:_acceptBtn];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateModel:(MySystemNotifyModel *)model {
    if (!model) {
        return;
    }
    self.model = model;
    _nameLabel.text = model.user;
    _appReason.text = model.wording;
    if (model.notifyType == SNSSystemNotifyType_addFriendReq) {
        _acceptBtn.enabled = YES;
        [_acceptBtn setTitle:@"同意" forState:UIControlStateNormal];
    }
    if (model.notifyType == SNSSystemNotifyType_AddFriend) {
        _acceptBtn.enabled = NO;
        [_acceptBtn setTitle:@"已添加" forState:UIControlStateDisabled];
        _acceptBtn.backgroundColor = [UIColor grayColor];
    }
}

- (void) onAcceptBtnDownClick:(id)sender{
    UIButton *btn = (UIButton*)sender;
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (void)onAacceptBtnUpInClick:(id)sender {
    self.acceptBtnAction(self.model.user);
}

- (void)onAcceptBtnUpOutClick:(id)sender{
    UIButton *btn = (UIButton*)sender;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (MySystemNotifyModel *)getModel{
    return self.model;
}

@end
