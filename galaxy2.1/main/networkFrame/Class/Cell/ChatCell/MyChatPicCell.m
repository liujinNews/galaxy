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

#import "MyChatPicCell.h"
#import "MyMsgPicModel.h"
#import "UIViewAdditions.h"
#import "UIResponder+addtion.h"
#import "MyImageBrowserView.h"

@interface MyChatPicCell(){
}

@property (nonatomic, assign)CGFloat picHeight;
@property (nonatomic, assign)CGFloat picWidth;
@property (nonatomic, assign)CGFloat picThumbHeight;
@property (nonatomic, assign)CGFloat picThumbWidth;
//@property (nonatomic, strong)NSURL* picUrl;
@property (nonatomic, strong)UIImageView* chatPic;
@property (nonatomic, strong)CALayer* picShadowLayer;
@property (nonatomic, strong)UIImage* thumbImage;
@property (nonatomic, strong) UIActivityIndicatorView* activityIndicator;
@end

@implementation MyChatPicCell

+ (CGFloat)heightForModel:(MyMsgPicModel*)model{
    
    if (model.picThumbWidth==0 || model.picThumbHeight==0) {
        model.picThumbWidth = model.picWidth;
        model.picThumbHeight = model.picHeight;
    }
    
    CGFloat height = model.picThumbHeight;
    CGFloat width = model.picThumbWidth;
    if (height > CELL_PIC_THUMB_MAX_H || width > CELL_PIC_THUMB_MAX_W) {
        CGFloat scale = MIN(CELL_PIC_THUMB_MAX_H/height, CELL_PIC_THUMB_MAX_W/width);
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
    
    CGFloat height = self.picThumbHeight;
    CGFloat width = self.picThumbWidth;
    
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


- (void)setContent:(MyMsgPicModel*)model{
    [super setContent:model];
    self.picHeight = model.picHeight;
    self.picWidth = model.picWidth;
    self.picThumbWidth = model.picThumbWidth;
    self.picThumbHeight = model.picThumbHeight;
    if (model.data) {
        self.picShadowLayer.contents = (id)[UIImage imageWithData:model.data].CGImage;
        self.thumbImage = [UIImage imageWithData:model.data];
    }
    else{
        //下载图片
        TIMImage* timOriginImage;
        TIMImage* timThumbImage;
        TIMImageElem* elem = (TIMImageElem*)model.elem;
        for (TIMImage* timImage in elem.imageList) {
            if (timImage.type == TIM_IMAGE_TYPE_THUMB) {
                timThumbImage = timImage;
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *nsTmpDir = NSTemporaryDirectory();
                NSString *imagePath = [NSString stringWithFormat:@"%@/image_%@", nsTmpDir, timImage.uuid];
                BOOL isDirectory;
                
                if ([fileManager fileExistsAtPath:imagePath isDirectory:&isDirectory]
                    && isDirectory == NO) {
                    model.data = [fileManager contentsAtPath:imagePath];
                    if (model.data) {
                        self.thumbImage = [UIImage imageWithData:model.data];
                        self.picShadowLayer.contents = (id)self.thumbImage.CGImage;
                    }
                }
                else {
                    [self.activityIndicator startAnimating];
                    [timImage getImage:imagePath succ:^{
                        model.data = [fileManager contentsAtPath:imagePath];
                        if (model.data) {
                            self.thumbImage = [UIImage imageWithData:model.data];
                            self.picShadowLayer.contents = (id)self.thumbImage.CGImage;
                            [self.activityIndicator stopAnimating];
                        }
                        else {
                            //展示x图
                            [self.activityIndicator stopAnimating];
                            TDDLogEvent(@"download empty pic");
                            [self showPrompt:@"下载的图片是空的"];
                        }

                    } fail:^(int code, NSString *err) {
                        //展示x图
                        [self.activityIndicator stopAnimating];
                        TDDLogEvent(@"download pic failed");
                        [self showPrompt:@"下载图片失败"];
                    }];

                }
            }
            else if(timImage.type == TIM_IMAGE_TYPE_ORIGIN){
                timOriginImage = timImage;
            }
        }
        
        //没有缩约图，展示原图
        if (!timThumbImage && timOriginImage) {
            [self.activityIndicator startAnimating];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *nsTmpDir = NSTemporaryDirectory();
            NSString *imagePath = [NSString stringWithFormat:@"%@/image_%@", nsTmpDir, timOriginImage.uuid];
            BOOL isDirectory;
            
            if ([fileManager fileExistsAtPath:imagePath isDirectory:&isDirectory]
                && isDirectory == NO) {
                model.data = [fileManager contentsAtPath:imagePath];
                if (model.data) {
                    self.thumbImage = [UIImage imageWithData:model.data];
                    self.picShadowLayer.contents = (id)self.thumbImage.CGImage;
                    [self.activityIndicator stopAnimating];
                }
            }
            else {
                [timOriginImage getImage:imagePath succ:^{
                    model.data = [fileManager contentsAtPath:imagePath];
                    if (model.data) {
                        self.thumbImage = [UIImage imageWithData:model.data];
                        self.picShadowLayer.contents = (id)self.thumbImage.CGImage;
                        [self.activityIndicator stopAnimating];
                    }
                    else {
                        //展示x图
                        [self.activityIndicator stopAnimating];
                        TDDLogEvent(@"download empty pic");
                        [self showPrompt:@"下载的图片是空的"];
                    }
                    
                } fail:^(int code, NSString *err) {
                    //展示x图
                    [self.activityIndicator stopAnimating];
                    TDDLogEvent(@"download pic failed");
                    [self showPrompt:@"下载图片失败"];
                }];
            }
        }
    }
    
}

- (void)bubblePressed:(id)sender{
    TDDLogDebug(@"%s:%s", __FILE__, __FUNCTION__);
    [super bubblePressed:sender];
    
    [self showOriginImg];
}

- (void)showOriginImg{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    CGRect rectInWindow = CGRectZero;
    UIImage* image = self.thumbImage;
    if (image) {
        rectInWindow = CGRectMake((SCREEN_WIDTH-image.size.width)/2, (SCREEN_HEIGHT-image.size.height)/2, image.size.width, image.size.height);
    }
    MyImageBrowserView* browseView =
    [[MyImageBrowserView alloc] initWithPicModel:(MyMsgPicModel *)self.model
                                               thumbnail:self.thumbImage
                                                fromRect:rectInWindow];
    [window addSubview:browseView];
    
}
@end
