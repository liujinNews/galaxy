//
//  MyRecommendFriendCell.m
//  MyDemo
//
//  Created by wilderliao on 15/9/9.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "MyFutureFriendCell.h"
#import "MySystemNotifyModel.h"
#import "NSStringEx.h"
#import "ConstDefine.h"
#import "UIViewAdditions.h"

#import "MyFutureFriendModel.h"

@interface MyFutureFriendCell(){
    UILabel *_nameLabel;
    UIImageView *_headerFaceView;
    UIView *_bgView;
    UIButton *_addBtn;
    UILabel *_remarkLabel;
}

@property (nonatomic, strong)MyFutureFriendModel* futureFriendModel;

@end

@implementation MyFutureFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initBgView];
        [self initHeadImage];
        [self initNameLabel];
        [self initRemark];
        [self initAddBtn];
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
    _headerFaceView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (CONTACT_CELL_H-headerImage.size.height)/2,headerImage.size.width, headerImage.size.height)];
    _headerFaceView.image = headerImage;
    [self.contentView addSubview:_headerFaceView];
}

- (void)initNameLabel{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerFaceView.frame.origin.x + _headerFaceView.frame.size.width+10, 7, 200, 20)];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _nameLabel.numberOfLines = 0;
    _nameLabel.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_nameLabel];
}

- (void)initRemark{
    _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, 26, 200, 20)];
    _remarkLabel.font = [UIFont systemFontOfSize:16];
    _remarkLabel.textColor = [UIColor grayColor];
    _remarkLabel.backgroundColor = [UIColor clearColor];
    _remarkLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _remarkLabel.numberOfLines = 0;
    _remarkLabel.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_remarkLabel];
}

- (void)initAddBtn{
    _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.ttright-30, (self.ttheight-20)/2, 70, 30)];
    _addBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_addBtn setTitle:@"同意" forState:UIControlStateNormal];
    [_addBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_addBtn setTitle:@"已添加" forState:UIControlStateDisabled];
    
    _addBtn.clipsToBounds = YES;
    _addBtn.layer.borderWidth = 1.0f;
    _addBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _addBtn.layer.cornerRadius = _addBtn.frame.size.height/2;
    [_addBtn.layer setMasksToBounds:YES];
    _addBtn.backgroundColor = [UIColor blueColor];
    [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_addBtn addTarget:self action:@selector(onAddDownClick:) forControlEvents:UIControlEventTouchDown];
    [_addBtn addTarget:self action:@selector(onAddUpInClick:) forControlEvents:UIControlEventTouchUpInside];
    [_addBtn addTarget:self action:@selector(onAddUpOutClick:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView addSubview:_addBtn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updateModel:(MyFutureFriendModel *)model{
    if (!model) {
        return;
    }
    self.futureFriendModel = model;
    
    //好友昵称or账号
    _nameLabel.text = self.futureFriendModel.nickName;
    if (_nameLabel.text == nil || [_nameLabel.text isEqualToString:@""]) {
        _nameLabel.text = self.futureFriendModel.user;
    }
    
    //好友备注信息
    _remarkLabel.text = self.futureFriendModel.remarkInfo;
    
    //好友类型：收到的未决请求、发出去的未决请求、推荐好友
    if (self.futureFriendModel.futureFriendType == FUTURE_FRIEND_PENDENCY_IN_TYPE){
        [_addBtn setTitle:@"同意" forState:UIControlStateNormal];
    }
    else if (self.futureFriendModel.futureFriendType == FUTURE_FRIEND_PENDENCY_OUT_TYPE){
        [_addBtn setTitle:@"等待验证" forState:UIControlStateDisabled];
        _addBtn.enabled = NO;
    }
    else if (self.futureFriendModel.futureFriendType == FUTURE_FRIEND_RECOMMEND_TYPE){
        [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
    }
    else if (self.futureFriendModel.futureFriendType == FUTURE_FRIEND_RECOMMEND_ADDED){
        
    }
}

- (void) onAddDownClick:(id)sender{
    UIButton *btn = (UIButton*)sender;
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (void)onAddUpInClick:(id)sender {
    UIButton *btn = (UIButton*)sender;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (self.addBtnAction) {
        if (self.futureFriendModel.futureFriendType == FUTURE_FRIEND_PENDENCY_IN_TYPE){
            self.acceptBtnAction(self.futureFriendModel);
        }
        else if (self.futureFriendModel.futureFriendType == FUTURE_FRIEND_RECOMMEND_TYPE){
             self.addBtnAction(self.futureFriendModel);
        }
    }
}

- (void)onAddUpOutClick:(id)sender{
    UIButton *btn = (UIButton*)sender;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end

