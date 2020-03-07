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

#import "MyNaviCell.h"
#import "MyNaviCellModel.h"

@implementation MyNaviCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        static NSString *naviPrivateId = @"NaviPrivateTableCell";
        static NSString *naviChartrommId = @"NaviChartroomTableCell";
        static NSString *naviPublicId = @"NaviPublicTableCell";
        static NSString *naviNewNotifyId = @"NaviNewNotifyTableCell";
        static NSString *naviNewSystemNotifyId = @"NaviNewSystemNotifyTableCell";
        static NSString *naviRecommendFriendId = @"NaviRecommendFriendTableCell";
        
        //设置表格单元样式
        UIImage *headerImage = [UIImage imageNamed:@"contacts_nav_group"];
        _headerFaceView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (CONTACT_CELL_H-headerImage.size.height)/2,
                                                                        headerImage.size.width, headerImage.size.height)];
        _headerFaceView.image = headerImage;
        [self.contentView addSubview:_headerFaceView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
        if ([reuseIdentifier isEqualToString:naviPrivateId]) {
            _nameLabel.text = NSLocalizedString(@"私有群", @"");
        } else if ([reuseIdentifier isEqualToString:naviChartrommId]) {
            _nameLabel.text = NSLocalizedString(@"聊天室", @"");
        } else if ([reuseIdentifier isEqualToString:naviPublicId]) {
            _nameLabel.text = NSLocalizedString(@"公开群", @"");
        } else if ([reuseIdentifier isEqualToString:naviNewNotifyId]) {
            _nameLabel.text = NSLocalizedString(@"新的朋友", @"");
        } else if ([reuseIdentifier isEqualToString:naviNewSystemNotifyId]){
            _nameLabel.text = NSLocalizedString(@"系统消息", @"");
        } else if ([reuseIdentifier isEqualToString:naviRecommendFriendId]){
            _nameLabel.text = NSLocalizedString(@"推荐朋友", @"");
        }
        else{
            _nameLabel.text = NSLocalizedString(@"", @"");
        }
        _nameLabel.backgroundColor = [UIColor clearColor];
        CGSize size = [_nameLabel.text sizeWithFont:_nameLabel.font];
        _nameLabel.frame = CGRectMake(_headerFaceView.frame.origin.x + _headerFaceView.frame.size.width+10,
                                      (CONTACT_CELL_H-size.height)/2, size.width, size.height);
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameLabel];
        
    }
    
    return self;
}

- (void)updateModel:(MyNaviCellModel *)model{
//    if (model.type == NaviCellGroup) {
//        _nameLabel.text = NSLocalizedString(@"群组", @"");
//    }
}

@end
