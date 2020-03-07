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

#import "MySearchResultCell.h"
#import "MyUserModel.h"
#import "UIViewAdditions.h"
#import "GlobalData.h"
#import "AccountHelper.h"

#define ADD_BTN_WIDTH 60.0f
#define ADD_BTN_HEIGHT 20.0f
@interface MySearchResultCell(){
}

@property (nonatomic, strong)MyUserModel* friendModel;
@end

@implementation MySearchResultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        
    }
    return self;
}

- (void)onAddBtnClick:(id)sender{
    if (self.addBtnAction) {
        self.addBtnAction(self.friendModel);
    }
}

- (void)onBlackBtnClick:(id)sender {
    if (self.blackBtnAction) {
        self.blackBtnAction(self.friendModel);
    }
}

- (void)updateModel:(MySearchResultModel *)model{
    self.friendModel = (MyUserModel*)model.sourceModel;
    [self reloadModel];
}

- (void)reloadModel {
    
    if (_bgView) {
        [_bgView removeFromSuperview];
        _bgView = nil;
    }
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CONTACT_CELL_H)];
    [self.contentView addSubview:_bgView];
    
    //设置表格单元样式
    UIImage *headerImage = [UIImage imageNamed:@"tab_contact_nor"];
    _headerFaceView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (CONTACT_CELL_H-headerImage.size.height)/2,
                                                                    headerImage.size.width, headerImage.size.height)];
    _headerFaceView.image = headerImage;
    [self.contentView addSubview:_headerFaceView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerFaceView.frame.origin.x + _headerFaceView.frame.size.width+10, 10, self.frame.size.width, 20)];
    _nameLabel.font = [UIFont boldSystemFontOfSize:12];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _nameLabel.numberOfLines = 0;
    _nameLabel.backgroundColor = [UIColor clearColor];
    NSString *nickName = self.friendModel.nickName;
    if (nickName==nil || [nickName isEqualToString:@""]) {
        nickName = self.friendModel.user;
    }
    NSString *identifer = self.friendModel.user;
    
    NSString *nameInfo = [[NSString alloc] initWithFormat:@"%@(%@)",nickName,identifer];
    _nameLabel.text = NSLocalizedString(nameInfo, @"");
    [_bgView addSubview:_nameLabel];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //        btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(_bgView.ttwidth-ADD_BTN_WIDTH-15, _bgView.ttheight-ADD_BTN_HEIGHT-6, ADD_BTN_WIDTH, ADD_BTN_HEIGHT);
    
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    if ([[GlobalData shareInstance] getFriendInfo:self.friendModel.user]) {
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitle:@"已是好友" forState:UIControlStateNormal];
    }
    else {
        [btn setTitle:@"添加为好友" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onAddBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_bgView addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //        btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(_bgView.ttwidth-2.3*ADD_BTN_WIDTH-15, _bgView.ttheight-ADD_BTN_HEIGHT-6, ADD_BTN_WIDTH, ADD_BTN_HEIGHT);
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    if ([[GlobalData shareInstance] getBlackInfo:self.friendModel.user]) {
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitle:@"已在黑名单" forState:UIControlStateNormal];
    }
    else {
        [btn setTitle:@"加入黑名单" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onBlackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_bgView addSubview:btn];
}

@end
