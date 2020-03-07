//
//  MyChatVideoCell.m
//  MyDemo
//
//  Created by tomzhu on 15/12/8.
//  Copyright © 2015年 sofawang. All rights reserved.
//

#import "AppDelegate.h"
#import "MyVideoBrowserView.h"
#import "MyMsgVideoModel.h"
#import "MyChatVideoCell.h"
#import "UIViewAdditions.h"
#import "UIResponder+addtion.h"

@interface MyChatVideoCell()
@property (nonatomic, assign)CGFloat picHeight;
@property (nonatomic, assign)CGFloat picWidth;
//@property (nonatomic, strong)NSURL* picUrl;
@property (nonatomic, strong)UIImageView* chatPic;
@property (nonatomic, strong)CALayer* picShadowLayer;
@property (nonatomic, strong)UIImage* thumbImage;
@property (nonatomic, strong)UIActivityIndicatorView* activityIndicator;
@property (nonatomic, strong)UIButton* playBtn;
@property (nonatomic, assign)BOOL hasVideo;
@property (nonatomic, assign)BOOL isDownloading;
@end

@implementation MyChatVideoCell

+ (CGFloat)heightForModel:(MyMsgVideoModel*)model{
    
    CGFloat height = model.height;
    CGFloat width = model.width;
    if (height > CELL_PIC_THUMB_MAX_H || width > CELL_PIC_THUMB_MAX_W) {
        CGFloat scale = MIN(CELL_PIC_THUMB_MAX_H/height, CELL_PIC_THUMB_MAX_W/width);
        width = width * scale;
        height = height * scale;
    }
    height += [MyChatBaseCell nickViewHeightWithType:model.chatType msgIn:model.inMsg];
    
    if (height < CELL_CONTENT_MIN_H) {
        height = CELL_IMG_SIZE_H +CELL_TOP_PADDING+CELL_BUTTOM_PADDING;
    }else{
        height += CELL_TOP_PADDING+CELL_BUTTOM_PADDING;
    }
    return height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

-(UIActivityIndicatorView*)activityIndicator{
    if (_activityIndicator == nil) {
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.contentView insertSubview:_activityIndicator aboveSubview:self.chatPic];
        _activityIndicator.hidesWhenStopped = YES;
    }
    return _activityIndicator;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat height = self.picHeight;
    CGFloat width = self.picWidth;
    
    if (height == 0 || width == 0) {
        return;
    }
    
    CGFloat bubbleTop = self.headView.tttop + [MyChatBaseCell nickViewHeightWithType:self.chatType msgIn:self.inMsg];
    
    if (height > CELL_PIC_THUMB_MAX_H || width > CELL_PIC_THUMB_MAX_W) {
        CGFloat scale = MIN(CELL_PIC_THUMB_MAX_H/height, CELL_PIC_THUMB_MAX_W/width);
        width = width * scale;
        height = height * scale;
    }
    
    self.chatPic.frame = CGRectMake(0, 0, width, height);
    self.bubble.frame = CGRectMake(0, bubbleTop, width, height);
    if (self.inMsg) {
        self.bubble.ttleft = CELL_IN_BUBBLE_LEFT;
        if (self.model.status != TIM_MSG_STATUS_SEND_SUCC) {
            self.statusView.ttcenterY = self.bubble.ttcenterY;
            self.statusView.ttleft = self.bubble.ttright + CELL_BUBBLE_INDICAGOR_PADDING;
        }
    }
    else{
        self.bubble.ttright = self.ttright - CELL_OUT_BUBBLE_RIGHT;
        if (self.model.status != TIM_MSG_STATUS_SEND_SUCC) {
            self.statusView.ttcenterY = self.bubble.ttcenterY;
            self.statusView.ttright = self.bubble.ttleft - CELL_BUBBLE_INDICAGOR_PADDING;
        }
    }
    
    self.picShadowLayer.frame = self.chatPic.bounds;
    self.activityIndicator.center = CGPointMake(self.bubble.ttleft+self.bubble.ttwidth/2, self.bubble.tttop+self.bubble.ttheight/2);
    
    self.playBtn = [[UIButton alloc] init];
    [self.chatPic addSubview:self.playBtn];
    self.playBtn.bounds = CGRectMake(0, 0, 50, 50);
    self.playBtn.center = self.chatPic.center;
    [self.playBtn setImage:[UIImage imageNamed:@"head_media"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(bubblePressed:) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn.hidden = NO;
}

- (UIImageView*)chatPic{
    if (_chatPic == nil) {
        _chatPic = [[UIImageView alloc] initWithFrame: CGRectZero];
        [self.bubble addSubview:_chatPic];
    }
    return _chatPic;
}

- (CALayer*)picShadowLayer{
    if (_picShadowLayer == nil){
        _picShadowLayer = [CALayer layer];
        _picShadowLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
        //        _picShadowLayer.backgroundColor = [UIColor clearColor].CGColor;
        _picShadowLayer.shadowOffset = CGSizeMake(0, 3);
        _picShadowLayer.shadowRadius = 5.0;
        _picShadowLayer.shadowColor = [UIColor blackColor].CGColor;
        _picShadowLayer.shadowOpacity = 0.8;
        //        _picShadowLayer.frame = CGRectMake(30, 30, 128, 192);
        _picShadowLayer.borderColor = [UIColor blackColor].CGColor;
        _picShadowLayer.borderWidth = 1.0;
        _picShadowLayer.cornerRadius = 10.0;
        _picShadowLayer.masksToBounds = YES;
        
        [self.chatPic.layer addSublayer:_picShadowLayer];
    }
    return _picShadowLayer;
}


- (void)setContent:(MyMsgVideoModel*)model{
    [super setContent:model];
    self.hasVideo = NO;
    self.isDownloading = NO;
    self.picHeight = model.height;
    self.picWidth = model.width;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (model.snapshotPath
        && [fileManager fileExistsAtPath:model.snapshotPath isDirectory:nil]) {
        NSData *data = [NSData dataWithContentsOfFile:model.snapshotPath];
        self.picShadowLayer.contents = (id)[UIImage imageWithData:data].CGImage;
        self.thumbImage = [UIImage imageWithData:data];
        if (model.videoPath
            && [fileManager fileExistsAtPath:model.videoPath isDirectory:nil]) {
            self.hasVideo = YES;
        }
    }
    else{
        //下载图片
        [self.activityIndicator startAnimating];
        
        NSString *nsTmpDir = NSTemporaryDirectory();
        NSString *snapshotUUID = ((TIMVideoElem*)model.elem).snapshot.uuid;
        NSString *imagePath = [NSString stringWithFormat:@"%@snapshot_%@", nsTmpDir, snapshotUUID];
        if ([fileManager fileExistsAtPath:imagePath isDirectory:nil]) {
            NSData *data = [fileManager contentsAtPath:imagePath];
            if (data) {
                self.thumbImage = [UIImage imageWithData:data];
                self.picShadowLayer.contents = (id)self.thumbImage.CGImage;
                [self.activityIndicator stopAnimating];
            }
            NSString *videoUUID = ((TIMVideoElem*)model.elem).video.uuid;
            NSString *type = ((TIMVideoElem*)model.elem).video.type;
            NSString *videoPath = [NSString stringWithFormat:@"%@video_%@.%@", nsTmpDir, videoUUID, type];
            if ([fileManager fileExistsAtPath:videoPath isDirectory:nil]) {
                self.hasVideo = YES;
                model.videoPath = videoPath;
            }
        }
        else {
            [((TIMVideoElem*)model.elem).snapshot getImage:imagePath succ:^{
                NSData *data = [fileManager contentsAtPath:imagePath];
                if (data) {
                    model.snapshotPath = imagePath;
                    self.thumbImage = [UIImage imageWithData:data];
                    self.picShadowLayer.contents = (id)self.thumbImage.CGImage;
                    [self.activityIndicator stopAnimating];
                }
            } fail:^(int code, NSString *err) {
                [self.activityIndicator stopAnimating];
                TDDLogEvent(@"download pic failed");
                [self showPrompt:@"下载图片失败"];
            }];
        }
    }
    
}

- (void)bubblePressed:(id)sender{
    TDDLogDebug(@"%s:%s", __FILE__, __FUNCTION__);
    [super bubblePressed:sender];
    if (self.isDownloading) {
        return;
    }
    else if (self.hasVideo) {
        [self showVideo];
    }
    else {
        [self downloadVideo];
    }
}

- (void)showVideo{
    AppDelegate* appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow* window = appDelegate.window;
    CGRect rectInWindow = CGRectZero;
    UIImage* image = self.thumbImage;
    if (image) {
        rectInWindow = CGRectMake((SCREEN_WIDTH-image.size.width)/2, (SCREEN_HEIGHT-image.size.height)/2, image.size.width, image.size.height);
    }
    MyVideoBrowserView* browseView =
    [[MyVideoBrowserView alloc] initWithVideoModel:(MyMsgVideoModel *)self.model fromRect:rectInWindow];
    [window addSubview:browseView];
    
}

- (void)downloadVideo {
    MyMsgVideoModel *model = (MyMsgVideoModel*) self.model;
    self.playBtn.hidden = YES;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (model.videoPath
        && [fileManager fileExistsAtPath:model.videoPath isDirectory:nil]) {
        self.hasVideo = YES;
        self.playBtn.hidden = NO;
    }
    else{
        //下载图片
        [self.activityIndicator startAnimating];
        
        NSString *nsTmpDir = NSTemporaryDirectory();
        NSString *videoUUID = ((TIMVideoElem*)model.elem).video.uuid;
        NSString *type = ((TIMVideoElem*)model.elem).video.type;
        NSString *videoPath = [NSString stringWithFormat:@"%@video_%@.%@", nsTmpDir, videoUUID, type];
        
        if ([fileManager fileExistsAtPath:videoPath isDirectory:nil]) {
            self.hasVideo = YES;
            self.playBtn.hidden = NO;
            model.videoPath = videoPath;
            [self.activityIndicator stopAnimating];
        }
        else {
            self.isDownloading = YES;
            [((TIMVideoElem*)model.elem).video getVideo:videoPath succ:^{
                [self.activityIndicator stopAnimating];
                self.isDownloading = NO;
                model.videoPath = videoPath;
                self.hasVideo = YES;
                self.playBtn.hidden = NO;
            } fail:^(int code, NSString *err) {
                TDDLogEvent(@"download video failed");
                self.isDownloading = NO;
                self.picShadowLayer.contents = nil;
                [self.activityIndicator stopAnimating];
                [self showPrompt:@"下载视频失败"];
            }];
        }
    }
}

@end
