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

#import "MyContactCell.h"
#import "MyMemberModel.h"
#import "MyFriendModel.h"

@interface MyContactCell(){
    UILabel *_nameLabel;
    UIImageView *_headerFaceView;
    UIView *_bgView;
    UIButton* _operBtn;
}

@property (nonatomic, assign)ContactCellType type;

@end

@implementation MyContactCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithType:(ContactCellType)type style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:RGBACOLOR(0xf7, 0xf7, 0xf1, 1.0f)];
        self.contentView.backgroundColor = RGBACOLOR(0xf7, 0xf7, 0xf1, 1.0f);
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CONTACT_CELL_H)];
        [self.contentView addSubview:_bgView];
        
        //设置表格单元样式
        UIImage *headerImage = [UIImage imageNamed:@"tab_contact_nor"];
        _headerFaceView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (CONTACT_CELL_H-headerImage.size.height)/2,
                                                                        headerImage.size.width, headerImage.size.height)];
        _headerFaceView.image = headerImage;
        [self.contentView addSubview:_headerFaceView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerFaceView.frame.origin.x + _headerFaceView.frame.size.width+10, 20, 200, 20)];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.numberOfLines = 0;
        _nameLabel.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_nameLabel];
        
        self.type = type;
        if (self.type == ContactCellType_AddGroup) {
            _operBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _operBtn.frame = CGRectMake(0, 0, 20, 20);
            CALayer * layer = [_operBtn layer];
            [layer setMasksToBounds:YES];
            [layer setCornerRadius:10.0];
            [layer setBorderWidth:1.0];
            [layer setBorderColor:[[UIColor grayColor] CGColor]];
            [_operBtn setImage:[UIImage imageNamed:@"chat_group_selected"] forState:UIControlStateSelected];
//            self.accessoryView.backgroundColor = [UIColor redColor];
            self.accessoryView = _operBtn;
//            self.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
//            UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
//            longPressGesture.minimumPressDuration = 1.0;
//            [self addGestureRecognizer:longPressGesture];
        }
        [self setSelected:NO];
    }
    return self;
}

- (void) updateModel:(MyUserModel *)model{
    
    //头像,目前是写死统一
    
    //名字
    NSString* name = model.nickName;
    if (name==nil || [name isEqualToString:@""]) {
        name = model.user;
    }
    
    _nameLabel.text = NSLocalizedString(name, @"");
    
    //从好友列表添加群，每一个cell需要设置选中状态，对于已经在群中的成员，不允许取消
    if ([model isKindOfClass:[MyMemberModel class]]) {
        MyMemberModel* member = (MyMemberModel*)model;
        if (_operBtn) {
            [_operBtn setSelected:member.isSelected];
        }
        if ((self.type == ContactCellType_AddGroup)&&member.isJoined) {
            _operBtn.selected = YES;
            self.selectionStyle = UITableViewCellSelectionStyleNone; //添加进入群组时，不允许选择已经在群组中的人
        }
    }
}

//- (BOOL)canBecomeFirstResponder{
//    return YES;
//}


//- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        [self becomeFirstResponder];
//        
//        UIMenuItem *itDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteFriend:)];
//        UIMenuController *menu = [UIMenuController sharedMenuController];
//        
//        [menu setMenuItems:[NSArray arrayWithObjects:itDelete,  nil]];
//        [menu setTargetRect:self.frame inView:self.superview];
//        [menu setMenuVisible:YES animated:YES];
//    }
//}
//
//- (void)deleteFriend:(id)sender{
//    NSLog(@"Delete Msg");
//}

@end
