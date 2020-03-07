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

#import "MyChatFileCell.h"
#import "MyMsgFileModel.h"
#import "UIViewAdditions.h"

@interface MyChatFileCell()

@property (nonatomic, strong)UIImageView* fileImg;
@property (nonatomic, strong)UILabel* filenameLable;
@property (nonatomic, strong)UILabel* filesizeLable;

@end

@implementation MyChatFileCell


+ (CGFloat)heightForModel:(MyMsgFileModel*)model{
    
    CGFloat height = CELL_TOP_PADDING+CELL_BUTTOM_PADDING ;   //每个cell的上下间距
    CGFloat contentH = CELL_AUDIO_IMG_H + CELL_BUBBLE_TOP_MARGIN + CELL_BUBBLE_BOTTOM_MARGIN+[MyChatBaseCell nickViewHeightWithType:model.chatType msgIn:model.inMsg] + CELL_FILE_LABEL_H + CELL_FILE_BUNBLE_LABLE_PADDING;
    height = contentH<CELL_IMG_SIZE_H?height+CELL_IMG_SIZE_H:height+contentH;
    return height;
}

- (UIImageView*)fileImg{
    if (_fileImg == nil) {
        _fileImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_FILE_IMAGE_H, CELL_FILE_IMAGE_H)];
        _fileImg.image = [UIImage imageNamed:@"chat_icon_file"];
        [self.contentView addSubview:_fileImg];
    }
    return _fileImg;
}

-(UILabel*)filenameLable{
    if (_filenameLable == nil) {
        _filenameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CELL_FILE_LABLE_MAX_W,CELL_FILE_LABEL_H)];//CGRectZero];
        [_filenameLable setNumberOfLines:2 ];
        [_filenameLable setFont:[UIFont systemFontOfSize:12]];
        [_filenameLable setTextColor:[UIColor grayColor]];
        _filenameLable.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self.contentView addSubview:_filenameLable];
    }
    return _filenameLable;
}

-(UILabel*)filesizeLable{
    if (_filesizeLable == nil) {
        _filesizeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CELL_FILE_LABLE_MAX_W,CELL_FILE_LABEL_H)];//CGRectZero];
        [_filesizeLable setNumberOfLines:0];
        [_filesizeLable setFont:[UIFont systemFontOfSize:12]];
        [_filesizeLable setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:_filesizeLable];
    }
    return _filesizeLable;
}

- (void)bubblePressed:(id)sender{
    TDDLogDebug(@"%s:%s", __FILE__, __FUNCTION__);
    [super bubblePressed:sender];

    self.downloadFile(self.myFileModel);
}

- (void)setContent:(MyMsgFileModel *)model{
    [super setContent:model];
    self.myFileModel = model;
    self.filenameLable.text = model.fileName;
    self.filesizeLable.text = [self calculSize:model.filesize];
}

//计算文件大小
- (NSString *)calculSize:(NSInteger)size{

    int loopCount = 0;
    int mod=0;
    while (size >=1024) {
        mod = size%1024;
        size /= 1024;
        loopCount++;
        if (loopCount > 4) {
            break;
        }
    }
    
    CGFloat rate=1;
    int loop = loopCount;
    while (loop--) {
        rate *= 1000.0;
    }
    CGFloat fSize = size + (CGFloat)mod/rate;
    NSString *sizeUnit;
    switch (loopCount) {
        case 0:
            sizeUnit = [[NSString alloc] initWithFormat:@"%.0fB",fSize];
            break;
        case 1:
            sizeUnit = [[NSString alloc] initWithFormat:@"%0.1fKB",fSize];
            break;
        case 2:
            sizeUnit = [[NSString alloc] initWithFormat:@"%0.2fMB",fSize];
            break;
        case 3:
            sizeUnit = [[NSString alloc] initWithFormat:@"%0.3fGB",fSize];
            break;
        case 4:
            sizeUnit = [[NSString alloc] initWithFormat:@"%0.4fTB",fSize];
            break;
        default:
            break;
    }
    return sizeUnit;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat bubbleTop = self.headView.tttop + [MyChatBaseCell nickViewHeightWithType:self.chatType msgIn:self.inMsg];
    
    CGFloat kContentLength = CELL_FILE_IMAGE_H + CELL_FILE_BUNBLE_IMAG_PADDING;
    
    self.bubble.frame = CGRectMake(self.bubble.ttleft, bubbleTop,
                                   kContentLength + CELL_FILE_BUNBLE_IMAG_PADDING*3 + CELL_BUBBLE_ARROW_W+self.filenameLable.size.width,
                                   CELL_FILE_IMAGE_H+ CELL_BUBBLE_TOP_MARGIN + CELL_BUBBLE_BOTTOM_MARGIN);
    [self.filenameLable sizeToFit];
    
    if (!self.inMsg) {
        self.bubble.ttright = self.headView.ttleft - CELL_BUBBLE_HEAD_PADDING;
        self.fileImg.tttop = self.bubble.tttop + CELL_BUBBLE_TOP_MARGIN;
        self.fileImg.ttleft = self.bubble.ttleft + CELL_FILE_BUNBLE_IMAG_PADDING + CELL_BUBBLE_SIDE_PADDING_FIX;
        self.filenameLable.tttop = self.fileImg.tttop + CELL_FILE_BUNBLE_LABLE_PADDING*2;
        self.filenameLable.ttleft = self.fileImg.ttleft + self.fileImg.frame.size.width + CELL_FILE_BUNBLE_LABLE_PADDING;
        self.filesizeLable.ttbottom = self.fileImg.ttbottom - CELL_FILE_BUNBLE_LABLE_PADDING;
        self.filesizeLable.ttleft = self.filenameLable.ttleft;
        if (self.model.status != TIM_MSG_STATUS_SEND_SUCC) {
            self.statusView.ttcenterY = self.bubble.ttcenterY;
            self.statusView.ttright = self.bubble.ttleft - CELL_BUBBLE_INDICAGOR_PADDING;
        }
    }
    else {
        self.bubble.ttleft = self.headView.ttright + CELL_BUBBLE_HEAD_PADDING;
        self.fileImg.tttop = self.bubble.tttop + CELL_BUBBLE_TOP_MARGIN;
        self.fileImg.ttleft = self.bubble.ttleft + CELL_BUBBLE_ARROW_W + CELL_FILE_BUNBLE_IMAG_PADDING;
        //self.fileImg.right = self.bubble.right - (CELL_FILE_BUNBLE_IMAG_PADDING + CELL_BUBBLE_ARROW_W-CELL_BUBBLE_SIDE_PADDING_FIX);
        self.filenameLable.ttleft = self.fileImg.ttleft + self.fileImg.frame.size.width + CELL_FILE_BUNBLE_LABLE_PADDING;
        self.filenameLable.tttop = self.fileImg.tttop + CELL_FILE_BUNBLE_LABLE_PADDING*2;
        self.filesizeLable.ttbottom = self.fileImg.ttbottom - CELL_FILE_BUNBLE_LABLE_PADDING;
        self.filesizeLable.ttleft = self.filenameLable.ttleft;
        if (self.model.status != TIM_MSG_STATUS_SEND_SUCC) {
            self.statusView.ttcenterY = self.bubble.ttcenterY;
            self.statusView.ttleft = self.bubble.ttright + CELL_BUBBLE_INDICAGOR_PADDING;
        }
    }
}

@end
