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

#import "MyChatTimeCell.h"
#import "MyTimeModel.h"
#import "UIViewAdditions.h"

@interface MyChatTimeCell(){

}
@property (nonatomic, strong)UILabel* contentLabel;

@end

@implementation MyChatTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

+ (CGFloat)heightForModel:(MyTimeModel*)model{
    return CELL_TIME_CONTENT_H+CELL_TIME_BOTTOM_PADDING+CELL_TIME_TOP_PADDING;
}

- (UILabel*)contentLabel{
    if (_contentLabel == nil) {
//        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-CELL_TIME_CONTENT_W)/2, CELL_TIME_TOP_PADDING, 10, CELL_TIME_CONTENT_H)];
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = Color_White_Same_20;
        [_contentLabel setTextColor:Color_GrayDark_Same_20];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.preferredMaxLayoutWidth = CELL_TIME_CONTENT_W;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        [_contentLabel setNumberOfLines:1];
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (void)layoutSubviews{
    
    CGFloat kContentLength = CELL_TIME_CONTENT_W;
    self.contentLabel.frame = CGRectMake(0.f, CELL_TIME_TOP_PADDING,
                                         kContentLength, 0.f);
    [super layoutSubviews];
    [self.contentLabel sizeToFit];
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.ttheight);
    self.contentLabel.ttleft = (self.contentView.ttwidth-self.contentLabel.ttwidth)/2;
}

- (void)setContent:(MyTimeModel *)model{
    self.contentLabel.text = [NSDate NSDateChangeTime:model.timeStr];
}
@end
