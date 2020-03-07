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

#import "MyChatTextCell.h"
#import "MyMsgTextModel.h"
#import "UIViewAdditions.h"

@interface MyChatTextCell()

@property (nonatomic, strong)UILabel* contentLabel;

@end

@implementation MyChatTextCell

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    CGFloat bubbleTop = self.headView.tttop + [MyChatBaseCell nickViewHeightWithType:self.chatType msgIn:self.inMsg];
    
    
    // content
    CGFloat kContentLength = CELL_LABEL_MAX_W;
    self.contentLabel.frame = CGRectMake(CELL_BUBBLE_SIDE_MARGIN, CELL_BUBBLE_TOP_MARGIN,kContentLength, 0.f);
    [self.contentLabel sizeToFit];
    if (self.contentLabel.ttheight < CELL_CONTENT_MIN_H) {
        self.contentLabel.ttheight = CELL_CONTENT_MIN_H;
    }
    
    self.bubble.frame = CGRectMake(self.bubble.ttleft, bubbleTop,
                                         self.contentLabel.ttwidth + CELL_BUBBLE_SIDE_MARGIN*2 + CELL_BUBBLE_ARROW_W,
                                         self.contentLabel.ttheight + CELL_BUBBLE_TOP_MARGIN + CELL_BUBBLE_BOTTOM_MARGIN);
    
    if (!self.inMsg) {
        self.bubble.ttright = self.headView.ttleft - CELL_BUBBLE_HEAD_PADDING;
        if (self.model.status != TIM_MSG_STATUS_SEND_SUCC) {
            self.statusView.ttcenterY = self.bubble.ttcenterY;
            self.statusView.ttright = self.bubble.ttleft - CELL_BUBBLE_INDICAGOR_PADDING;
        }
    }
    else {
        self.bubble.ttleft = self.headView.ttright + CELL_BUBBLE_HEAD_PADDING;
        CGRect frame = self.contentLabel.frame;
        frame.origin.x += CELL_BUBBLE_ARROW_W;
        self.contentLabel.frame = frame;
        if (self.model.status != TIM_MSG_STATUS_SEND_SUCC) {
            self.statusView.ttcenterY = self.bubble.ttcenterY;
            self.statusView.ttleft = self.bubble.ttright + CELL_BUBBLE_INDICAGOR_PADDING;
        }
    }
}

- (UILabel*)contentLabel{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.preferredMaxLayoutWidth = CELL_LABEL_MAX_W;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.font = Font_Important_15_20;
        
        [self.bubble addSubview:_contentLabel];
    }
    return _contentLabel;
}

+ (CGFloat)heightForContent:(MyMsgTextModel *)content withWidth:(CGFloat)width
{
    CGSize contentSize;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:CELL_CONTENT_FONT_SIZE};
        
        contentSize = [content.textMsg boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    else{
        contentSize = [content.textMsg sizeWithFont:CELL_CONTENT_FONT_SIZE constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    }
    return contentSize.height;
}

//计算本cell的高度
+ (CGFloat)heightForModel:(MyMsgTextModel*)model{
    //先计算出text的高度
    CGFloat contentHeight = [self heightForContent:model withWidth:CELL_LABEL_MAX_W];

    CGFloat height = CELL_TOP_PADDING+CELL_BUTTOM_PADDING ;   //每个cell的上下间距
    /*
     -----------------
     |||
     -----------------
     contentHeight+CELL_BUBBLE_TOP_MARGIN+CELL_BUBBLE_BUTTOM_MARGIN < HEADIMG
     */
    
    //展示昵称labble
    if (contentHeight+[MyChatBaseCell nickViewHeightWithType:model.chatType msgIn:model.inMsg]<CELL_CONTENT_MIN_H) {
        height = height + CELL_IMG_SIZE_H;
    }
    else{
        height = height + contentHeight + CELL_BUBBLE_TOP_MARGIN + CELL_BUBBLE_BOTTOM_MARGIN + [MyChatBaseCell nickViewHeightWithType:model.chatType msgIn:model.inMsg];
    }
    
    return height;
}


- (void)setContent:(MyMsgTextModel *)model{
    if (!model.inMsg) {
        self.contentLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        self.contentLabel.textColor = [UIColor blackColor];
    }
    [super setContent:model];
    self.contentLabel.text = model.textMsg;
    
}
@end
