//
// Copyright 1999-2015 MyApp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "MyChatBaseCell.h"
#import "UIViewAdditions.h"
#import "MyMsgBaseModel.h"
#import "MyFriendModel.h"
#import "GlobalData.h"
#import "MyChatViewController.h"
#import "UAProgressView.h"
#import "NSString+Common.h"

@implementation MyChatBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_IMG_SIZE_W, CELL_IMG_SIZE_W)];
        self.bubble = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        self.failedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_INDICAGOR_IMAG_H, CELL_INDICAGOR_IMAG_H)];
        self.failedImageView.image = [UIImage imageNamed:@"tips_message_failed"];
        
        self.sendingView = [[UAProgressView alloc] initWithFrame:self.statusView.bounds];
        self.sendingView.tintColor = [UIColor lightGrayColor];
        self.sendingView.borderWidth = 2.0;
        self.sendingView.lineWidth = 1.0;
        
        [self.contentView addSubview:self.headView];
        [self.contentView addSubview:self.bubble];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.bubble setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubblePressed:)];
        [self.bubble addGestureRecognizer:tap];
    }
    return self;
}

- (UIView *)statusView{
    if (_statusView == nil) {
        _statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CELL_INDICAGOR_IMAG_H, CELL_INDICAGOR_IMAG_H)];
        _statusView.hidden = YES;
        [self.contentView addSubview:self.statusView];
    }
    return _statusView;
}

- (void)updateStatusView{
    
    if (self.model.status == TIM_MSG_STATUS_SEND_FAIL) {
        [self.statusView addSubview:self.failedImageView];
        [self.sendingView removeFromSuperview];
        self.statusView.hidden = NO;
    }
    else if(self.model.status == TIM_MSG_STATUS_SENDING){
        //在一定延时内不展示进度条，在发送超过一定延迟再检测发送状态
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
    }
    else{
        if (_statusView) {
            [self.sendingView removeFromSuperview];
            [self.failedImageView removeFromSuperview];
            _statusView.hidden = YES;
        }
    }
}

- (void)updateProgress:(NSTimer*)timer{
    if (self.model.msg == nil) {
        _statusView.hidden = YES;
        [timer invalidate];
        return;
    }
    
    self.model.status = self.model.msg.status;
    if (self.model.status == TIM_MSG_STATUS_SENDING) {
        if (self.model.preStatus == TIM_MSG_STATUS_SENDING) {
            _statusView.hidden = NO;
            
            self.sendingView.progress = ((int)((self.sendingView.progress * 100.0f) + 10.1) % 100) / 100.0f;
            [self.statusView addSubview:self.sendingView];
            [self.failedImageView removeFromSuperview];
        }
    }
    else{
        [timer invalidate];
        if(self.model.status == TIM_MSG_STATUS_SEND_FAIL){
            _statusView.hidden = NO;
            //if (self.model.preStatus!=TIM_MSG_STATUS_SEND_FAIL) {
                [self.statusView addSubview:self.failedImageView];
                [self.sendingView removeFromSuperview];
            //}
        }
        else{
            //发送成功
            [self.sendingView removeFromSuperview];
            [self.failedImageView removeFromSuperview];
            _statusView.hidden = YES;
        }
    }
    self.model.preStatus = self.model.status;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.ttheight);
    
    if (self.inMsg) {
        self.headView.tttop = CELL_TOP_PADDING;
        self.headView.ttleft = CELL_SIDE_PADDING;
    }else{
        self.headView.ttright = self.contentView.ttwidth-CELL_SIDE_PADDING;
        self.headView.tttop = CELL_TOP_PADDING;
    }
    
    UIImage* bubbleImag = [self bubbleImage:self.inMsg];
    
    [self.bubble setImage:[bubbleImag stretchableImageWithLeftCapWidth:bubbleImag.size.width/2 topCapHeight:bubbleImag.size.height/2]];
}

- (void)setContent:(MyMsgBaseModel *)model{
    self.model = model;
    self.chatType = model.chatType;
    self.inMsg = model.inMsg;
    [self.headView setImage:[UIImage imageNamed:@"Message_Man"]];
    
    if (!model.inMsg) {
        userData *user = [userData shareUserData];
        if ([NSString isEqualToNull:user.photoGraph]) {
            NSString * nicai = [NSString stringWithFormat:@"%@",user.photoGraph];
            if ([NSString isEqualToNull:nicai]) {
                [self.headView sd_setImageWithURL:[NSURL URLWithString:nicai]];
                //设置边框圆角的弧度
                [self.headView.layer setCornerRadius:20.0];
                //设置边框线的宽
                [self.headView.layer setBorderWidth:2];
                [self.headView.layer setBorderColor:[(Color_GrayLight_Same_20)CGColor]];
                //是否设置边框以及是否可见
                [self.headView.layer setMasksToBounds:YES];
            }
        }
    }
    else
    {
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSString* userInfoData = [userDefaults objectForKey:@"userHeader"];
        if ([NSString isEqualToNull:userInfoData]) {
            NSDictionary * dic = [NSString transformToDictionaryFromString:userInfoData];
            NSString * nicai = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
            if ([NSString isEqualToNull:nicai]) {
                [self.headView sd_setImageWithURL:[NSURL URLWithString:nicai]];
                //设置边框圆角的弧度
                [self.headView.layer setCornerRadius:20.0];
                //设置边框线的宽
                [self.headView.layer setBorderWidth:2];
                [self.headView.layer setBorderColor:[(Color_GrayLight_Same_20)CGColor]];
                //是否设置边框以及是否可见
                [self.headView.layer setMasksToBounds:YES];
            }
        }
    }
    
    self.model.status = TIM_MSG_STATUS_SENDING;
    if (model.friendNick == nil) {
        MyFriendModel* friendInfo = [[GlobalData shareInstance] getFriendInfo:model.friendUserName];
        if (friendInfo){
            model.friendNick = friendInfo.nickName;
        }
    }
    if (!model.friendNick) {
        model.friendNick = model.friendUserName;
    }
    [self updateStatusView];
}

- (UIImage *)bubbleImage:(BOOL)isIn
{
    UIImage *bubbleBgImage = nil;
    NSString *nameSuffix = isIn ? @"in" : @"out";
    bubbleBgImage = [UIImage imageNamed:[NSString stringWithFormat:@"chat_bubble_%@", nameSuffix]];
    return bubbleBgImage;
}

+ (CGFloat) nickViewHeightWithType:(TIMConversationType)chatType msgIn:(BOOL)inMsg{
    if (inMsg && chatType!=TIM_C2C){
        return CELL_NICK_H+CELL_NICK_PADDING;
    }
    return 0.0f;
}

- (void)bubblePressed:(UITapGestureRecognizer *)sender{
    TDDLogDebug(@"%s:%s", __FILE__, __FUNCTION__);
        UIResponder* responder = self;
        while (responder) {
            responder = responder.nextResponder;
            if ([responder isKindOfClass:[MyChatViewController class]]) {
                [((MyChatViewController*)responder) hiddenKeyBoard ];
            }
        }
}

#pragma mark- menu

- (BOOL)becomeFirstResponder{
    return YES;
}

- (UIView *)showMenuView
{
    return self.bubble;
}
@end
