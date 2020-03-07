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

#import "MyChatAudioCell.h"
#import "MyMsgAudioModel.h"
#import "UIViewAdditions.h"
#import <AVFoundation/AVFoundation.h>
#import "UIResponder+addtion.h"
#import "MyAudioManager.h"

@interface MyChatAudioCell()

@property (nonatomic, strong)UIImageView* audioImg;
@property (nonatomic, strong)UIImageView* redPointImg;
@property (nonatomic, strong)UILabel* audioLable;
@property (nonatomic, strong)NSArray *senderAnimationImages;
@property (nonatomic, strong)NSArray *recevierAnimationImages;

//@property (nonatomic, strong)AVAudioPlayer* player;
//@property (nonatomic, readonly)MyMsgAudioModel* audioModel;

@end

@implementation MyChatAudioCell

+ (CGFloat)heightForModel:(MyMsgAudioModel*)model{
    
    CGFloat height = CELL_TOP_PADDING+CELL_BUTTOM_PADDING ;   //每个cell的上下间距
    CGFloat contentH = CELL_AUDIO_IMG_H + CELL_BUBBLE_TOP_MARGIN + CELL_BUBBLE_BOTTOM_MARGIN+[MyChatBaseCell nickViewHeightWithType:model.chatType msgIn:model.inMsg];
    height = contentH<CELL_IMG_SIZE_H?height+CELL_IMG_SIZE_H:height+contentH;
    return height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playAudioNotification:) name:kMyNotificationPlayAudio object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMyNotificationPlayAudio object:nil];
    
}

- (void)playAudioNotification:(NSNotification *)notify{
    id cell = [notify.userInfo objectForKey:@"cell"];
    MyMsgAudioModel* model = (MyMsgAudioModel *)self.model; //有其它cell在播放时，停止掉本cell的播放
    if (cell != self && model.isPlaying) {
        model.isPlaying = NO;
        [self.audioImg stopAnimating];
    }
    return;
}

- (UIImageView*)audioImg{
    if (_audioImg == nil) {
        _audioImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_AUDIO_IMG_H, CELL_AUDIO_IMG_H)];
        _audioImg.animationDuration = 1;
        [self.contentView addSubview:_audioImg];
    }
    return _audioImg;
}

- (UIImageView*)redPointImg{
    if (_redPointImg == nil) {
        _redPointImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _redPointImg.image = [UIImage imageNamed:@"red_dot_small"];
        [self.contentView addSubview:_redPointImg];
    }
    return _redPointImg;
}

- (NSArray *)senderAnimationImages{
    if (_senderAnimationImages == nil) {
        _senderAnimationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"bubble_voice_send_icon_1"],
                                  [UIImage imageNamed:@"bubble_voice_send_icon_2"],
                                  [UIImage imageNamed:@"bubble_voice_send_icon_3"],
                                  nil];
    }
    return _senderAnimationImages;
}


- (NSArray *)recevierAnimationImages{
    if (_recevierAnimationImages == nil) {
        _recevierAnimationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"bubble_voice_receive_icon_1"],
                                  [UIImage imageNamed:@"bubble_voice_receive_icon_2"],
                                  [UIImage imageNamed:@"bubble_voice_receive_icon_3"],
                                  nil];
    }
    return _recevierAnimationImages;
}


-(UILabel*)audioLable{
    if (_audioLable == nil) {
        _audioLable = [[UILabel alloc] initWithFrame:CGRectZero];
        [_audioLable setNumberOfLines:0];
        [_audioLable setFont:[UIFont systemFontOfSize:12]];
        [_audioLable setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:_audioLable];
    }
    return _audioLable;
}

- (void)setContent:(MyMsgAudioModel *)model{
    [super setContent:model];
//    MyMsgAudioModel * audioModel = (MyMsgAudioModel*)model;
    if (model.inMsg) {
        self.audioImg.image = [UIImage imageNamed:@"bubble_voice_receive_icon_nor"];
        _audioImg.animationImages = self.recevierAnimationImages;
    }
    else{
        self.audioImg.image = [UIImage imageNamed:@"bubble_voice_send_icon_nor"];
        _audioImg.animationImages = self.senderAnimationImages;
    }
    
    self.audioLable.text = [self getDurationString:model.duration];
}

- (NSString*)getDurationString:(NSUInteger) duration{
    NSInteger minius, seconds;
    minius = duration/60;
    seconds = duration%60;
    if (minius>0) {
        return [NSString stringWithFormat:@"%ld\'%ld\"", (long)minius, (long)seconds];
    }
    else{
        return [NSString stringWithFormat:@"%ld\"", (long)seconds];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    MyMsgAudioModel * audioModel = (MyMsgAudioModel*)self.model;
    
    CGFloat bubbleTop = self.headView.tttop + [MyChatBaseCell nickViewHeightWithType:self.chatType msgIn:self.inMsg];
    
    CGFloat kContentLength = CELL_AUDIO_MIN_W+(audioModel.duration-1)*3;
    if (kContentLength>CELL_AUDIO_MAX_W) {
        kContentLength=CELL_AUDIO_MAX_W;
    }
    
    self.bubble.frame = CGRectMake(self.bubble.ttleft, bubbleTop,
                                   kContentLength + CELL_BUBBLE_SIDE_MARGIN*2 + CELL_BUBBLE_ARROW_W,
                                   CELL_AUDIO_IMG_H+ CELL_BUBBLE_TOP_MARGIN + CELL_BUBBLE_BOTTOM_MARGIN);
    
    self.audioImg.tttop = self.bubble.tttop + CELL_BUBBLE_TOP_MARGIN;
    
    self.audioLable.frame = CGRectMake(0.f, self.bubble.tttop + CELL_AUDIO_LABLE_PADDING,
                                       CELL_TIME_CONTENT_W, 0.f);
    [self.audioLable sizeToFit];
    self.audioLable.tttop = self.bubble.tttop+(self.bubble.ttheight-self.audioLable.ttheight)/2;
    self.redPointImg.tttop = self.bubble.tttop+(self.bubble.ttheight-self.redPointImg.ttheight)/2;
    if (audioModel.inMsg && !audioModel.isPlayed) {
        self.redPointImg.hidden = NO;
    }
    else{
        self.redPointImg.hidden = YES;
    }
    
    
    if (!self.inMsg) {
        self.bubble.ttright = self.headView.ttleft - CELL_BUBBLE_HEAD_PADDING;
        self.audioImg.ttleft = self.bubble.ttleft + CELL_AUDIO_IMG_BUBBLE_PADDING + CELL_BUBBLE_SIDE_PADDING_FIX;
        self.audioLable.ttright = self.bubble.ttleft - CELL_AUDIO_LABLE_PADDING;
//        self.redPointImg.right = self.audioLable.left - CELL_AUDIO_LABLE_PADDING;
        if (self.model.status != TIM_MSG_STATUS_SEND_SUCC) {
            self.statusView.ttcenterY = self.bubble.ttcenterY;
            self.statusView.ttright = self.audioLable.ttleft - CELL_BUBBLE_INDICAGOR_PADDING;
        }
    }
    else {
        self.bubble.ttleft = self.headView.ttright + CELL_BUBBLE_HEAD_PADDING;
        self.audioImg.ttleft = self.bubble.ttleft + CELL_AUDIO_IMG_BUBBLE_PADDING + CELL_BUBBLE_ARROW_W-CELL_BUBBLE_SIDE_PADDING_FIX;
        self.audioLable.ttleft = self.bubble.ttright + CELL_AUDIO_LABLE_PADDING;
        self.redPointImg.ttleft = self.audioLable.ttright + CELL_AUDIO_LABLE_PADDING;
//        if (self.failed) {
//            self.indicator.centerY = self.bubble.centerY;
//            self.indicator.left = self.audioLable.right + CELL_BUBBLE_INDICAGOR_PADDING;
//        }
    }
    
}


- (void)bubblePressed:(id)sender{
    TDDLogDebug(@"%s:%s", __FILE__, __FUNCTION__);
    [super bubblePressed:sender];
    MyMsgAudioModel* model = (MyMsgAudioModel *)self.model;
    model.isPlaying = !model.isPlaying;
    if (!model.isPlayed) {
        model.isPlayed = YES;
        self.redPointImg.hidden = YES;
    }
    
    [self playAudio];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationPlayAudio object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationPlayAudio object:nil userInfo:@{@"cell":self}];
}


- (void)playAudio{
    MyMsgAudioModel* model = (MyMsgAudioModel *)self.model;
    if (model.isPlaying) {
        
        __weak MyChatAudioCell * weakself = self;
        if (model.data == nil) {
            TIMSoundElem* elem = (TIMSoundElem*)model.elem;
            [elem getSound:^(NSData* data){
                [weakself.audioImg startAnimating];
                model.data = data;
                [[MyAudioManager sharedInstance] playWithData:model.data finish:^(){
                    model.isPlaying = NO;
                    [weakself.audioImg stopAnimating];
                }];
                TDDLogDebug(@"download audio success. size:%lu", (unsigned long)data.length);
            } fail:^(int code, NSString* err){
                model.isPlaying = NO;
                TDDLogEvent(@"download audio failed: code:%d msg:%@", code, err);
            }];
        }
        else{
            [self.audioImg startAnimating];
            [[MyAudioManager sharedInstance] playWithData:model.data finish:^(){
                model.isPlaying = NO;
                [self.audioImg stopAnimating];
            }];
        }
    }
    else{
        [[MyAudioManager sharedInstance] stopPlay];
        [self.audioImg stopAnimating];
//        __weak typeof(self) weakself = self;
//        [[MyAudioManager sharedInstance] playWithData:model.data finish:^(){
//            [weakself.audioImg stopAnimating];
//        }];
    }
}

@end
