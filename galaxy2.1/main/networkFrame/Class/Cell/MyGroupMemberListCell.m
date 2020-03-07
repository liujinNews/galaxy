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

#import "MyGroupMemberListCell.h"
#import "UIViewAdditions.h"
#import "MyGroupAddFriendViewController.h"
#import "MyGroupInfoViewController.h"
#import "GlobalData.h"
#import "UIResponder+addtion.h"
#import "MyCommOperation.h"

enum GroupEditMod{
    GROUP_MEMBER_ADD,
    GROUP_MEMBER_DEL,
    GRoup_MEMBER_NAMECARD
};

@interface MyGroupMemberListCell()


@property (nonatomic, strong)MyGroupInfoModel* model;
@property (nonatomic, strong)UIButton* addBtn;
@property (nonatomic, strong)UIButton* delBtn;
@property (nonatomic, assign)enum GroupEditMod editMode;

@end


@implementation MyGroupMemberListCell

#pragma mark - Interface
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.frame = self.bounds;
        self.contentView.userInteractionEnabled = YES;
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

+ (CGFloat)heightForModel:(MyGroupInfoModel*)model{
    NSUInteger itemCount = 0;
    NSUInteger groupCount = model.memberList.count;
    if (model.type == TIM_C2C) {
        itemCount = model.memberList.count + 1; //add member
    }
    else if ([model.groupType isEqualToString:GROUP_TYPE_PRIVATE]) {
        if ([model.owner isEqualToString:[GlobalData shareInstance].me]) {
            if (model.memberNum > 1) {
                itemCount = groupCount + 2; //add, delete member
            }
            else {
                itemCount = groupCount + 1; //add member
            }
        }
        else {
            itemCount = groupCount + 1; //add member
        }
    }
    else {
        if ([model.owner isEqualToString:[GlobalData shareInstance].me]) {
            itemCount = groupCount + 1; //add member
        }
        else {
            itemCount = groupCount; //no authority
        }
    }
    
    NSUInteger lines = ceilf(itemCount*1.0f/GROUP_INFO_ITEM_COUNT_PER_LINE);
    
    return lines*(GROUP_INFO_ITEM_PADDING+[MyGroupMemberListCell heightForHeadView])+GROUP_INFO_ITEM_PADDING;
}


+ (CGFloat)heightForHeadView{
    return GROUP_INFO_MEMBER_IMG_H + GROUP_INFO_MEMBER_NAME_H + GROUP_INFO_MEMBER_NAME_IMAG_PADDING;
}


- (void)setContent:(MyGroupInfoModel*) model{
    self.model = model;
}

- (void)setMyRole:(BOOL)isAdmin
{
    _isMySelfIsAdmin = isAdmin;
}
#pragma mark - LifeCycle

- (void)layoutSubviews{
    
    for (UIView* subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    NSUInteger index = 0;
    CGFloat itemPadding = (self.contentView.ttwidth-(GROUP_INFO_MEMBER_IMG_H*GROUP_INFO_ITEM_COUNT_PER_LINE))/(GROUP_INFO_ITEM_COUNT_PER_LINE+1);
    CGFloat itemHeight = [MyGroupMemberListCell heightForHeadView];
    for (MyMemberModel* memberInfo in self.model.memberList) {
        UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(itemPadding+(index%GROUP_INFO_ITEM_COUNT_PER_LINE)*(GROUP_INFO_MEMBER_IMG_H+itemPadding), index/GROUP_INFO_ITEM_COUNT_PER_LINE*(itemHeight+GROUP_INFO_ITEM_PADDING)+GROUP_INFO_ITEM_PADDING/2, GROUP_INFO_MEMBER_IMG_H, itemHeight)];
        
        UIButton* headBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        headBtn.frame = CGRectMake(0, 0, GROUP_INFO_MEMBER_IMG_H, GROUP_INFO_MEMBER_IMG_H);
        [headBtn setImage:[UIImage imageNamed:@"tab_contact_nor"] forState:UIControlStateNormal];
        headBtn.tag = index+1;
        headBtn.enabled = (([self.model.owner isEqualToString:[GlobalData shareInstance].me] || _isMySelfIsAdmin)
                           && memberInfo.role!=TIM_GROUP_MEMBER_ROLE_SUPER
                           && memberInfo.user!=[GlobalData shareInstance].me
                           && ![self.model.groupType isEqualToString:GROUP_TYPE_PRIVATE]) ? true:false;
        if (![memberInfo.user isEqualToString:[GlobalData shareInstance].me]
            && ([self.model.owner isEqualToString:[GlobalData shareInstance].me] || _isMySelfIsAdmin)
            && memberInfo.role!=TIM_GROUP_MEMBER_ROLE_SUPER
            && ![self.model.groupType isEqualToString:GROUP_TYPE_PRIVATE]) {
            [headBtn.layer setBorderWidth:2.0];
            [headBtn.layer setCornerRadius:8.0];
        }
        [headView addSubview:headBtn];
        [headBtn addTarget:self action:@selector(memberSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        UITextField *nameTF = [[UITextField alloc] initWithFrame:CGRectMake(0, GROUP_INFO_MEMBER_IMG_H+GROUP_INFO_MEMBER_NAME_IMAG_PADDING, GROUP_INFO_MEMBER_IMG_H, GROUP_INFO_MEMBER_NAME_H)];
        if (memberInfo.nameCard.length > 0) {
            nameTF.text = memberInfo.nameCard;
        }
        else{
            nameTF.text = memberInfo.nickName;
        }
        nameTF.userInteractionEnabled = (([self.model.owner isEqualToString:[GlobalData shareInstance].me] || _isMySelfIsAdmin)
                                         && memberInfo.role!=TIM_GROUP_MEMBER_ROLE_SUPER
                                         && ![self.model.groupType isEqualToString:GROUP_TYPE_PRIVATE]) ? true:false;
        nameTF.textAlignment = NSTextAlignmentCenter;
        nameTF.font = [UIFont systemFontOfSize:10];
        nameTF.textColor = [UIColor darkGrayColor];
        nameTF.delegate = self;
        nameTF.placeholder = memberInfo.user;
        [headView addSubview:nameTF];
        
        if (self.editMode == GROUP_MEMBER_DEL && ![memberInfo.user isEqualToString:([GlobalData shareInstance].me)]) {
            //添加删除图标
            headBtn.enabled = true;
            nameTF.userInteractionEnabled = YES;
            UIImageView* delIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"round_remove"]];
            delIcon.frame = CGRectMake(0, 0, 20, 20);
            [headView addSubview:delIcon];
        }
        
        if (memberInfo.role == TIM_GROUP_MEMBER_ROLE_ADMIN) {
            UILabel* roleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, GROUP_INFO_MEMBER_ROLE_H, GROUP_INFO_MEMBER_IMG_H, GROUP_INFO_MEMBER_NAME_H)];
            roleLabel.text = @"管理员";
            roleLabel.textAlignment = NSTextAlignmentCenter;
            roleLabel.font = [UIFont systemFontOfSize:10];
            roleLabel.textColor = [UIColor blueColor];
            [headView addSubview:roleLabel];
        }
        else if (memberInfo.role == TIM_GROUP_MEMBER_ROLE_SUPER) {
            UILabel* roleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, GROUP_INFO_MEMBER_ROLE_H, GROUP_INFO_MEMBER_IMG_H, GROUP_INFO_MEMBER_NAME_H)];
            roleLabel.text = @"群主";
            roleLabel.textAlignment = NSTextAlignmentCenter;
            roleLabel.font = [UIFont systemFontOfSize:10];
            roleLabel.textColor = [UIColor redColor];
            [headView addSubview:roleLabel];
        }
        
        [self.contentView addSubview:headView];
        
        
        index++;
    }
    
    
//    [self.contentView addSubview:self.addBtn];
//    if (self.model.memberList.count > 1 && [self.model.owner isEqualToString:[GlobalData shareInstance].me]) {
//        [self.contentView addSubview:self.delBtn];
//    }
    if ([self.model.groupType isEqualToString:GROUP_TYPE_PRIVATE] || self.model.type == TIM_C2C) {
        self.addBtn.frame = CGRectMake(itemPadding+(index%GROUP_INFO_ITEM_COUNT_PER_LINE)*(GROUP_INFO_MEMBER_IMG_H+itemPadding), index/GROUP_INFO_ITEM_COUNT_PER_LINE*(itemHeight+GROUP_INFO_ITEM_PADDING), GROUP_INFO_MEMBER_IMG_H, itemHeight);
        index++;
    }
    else {
        self.addBtn.hidden = YES;
    }
    
    if (self.model.memberList.count>1 && ([self.model.owner isEqualToString:[GlobalData shareInstance].me] || _isMySelfIsAdmin)) {
        self.delBtn.frame = CGRectMake(itemPadding+(index%GROUP_INFO_ITEM_COUNT_PER_LINE)*(GROUP_INFO_MEMBER_IMG_H+itemPadding), index/GROUP_INFO_ITEM_COUNT_PER_LINE*(itemHeight+GROUP_INFO_ITEM_PADDING), GROUP_INFO_MEMBER_IMG_H, itemHeight);
        index++;
    }
    else{
        self.delBtn.hidden = YES;
    }
    
    self.contentView.frame = self.bounds;
}

#pragma mark - EventResponse<headBtn, addMemberBtn>

static NSString *setToAdmin = @"设置为管理员";
static NSString *cancelFromAdmin = @"取消管理员资格";
static NSString *setToSilence = @"禁言该用户";
static NSString *cancelFromSilence = @"不对该用户禁言";
static NSString *user = nil;
- (void)memberSelected:(id)sender{
    
    if (self.editMode == GROUP_MEMBER_DEL) {
        [self doDeleteMember:sender];
    }
    else {
        NSUInteger tag = ((UIButton *)sender).tag;
        MyMemberModel* memberInfo = [self.model.memberList objectAtIndex:tag-1];
        NSString *managerSettingOpt;
        if (memberInfo.role == TIM_GROUP_MEMBER_ROLE_MEMBER) {
            managerSettingOpt = setToAdmin;
        }
        else {
            managerSettingOpt = cancelFromAdmin;
        }
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:managerSettingOpt,
                                      setToSilence,
                                      cancelFromSilence,
                                      nil];
        [actionSheet showFromRect:CGRectMake(0, 0, 0, 0) inView:self animated:YES];
        user = memberInfo.user;
    }
}



- (void)addMember:(id)sender{
    if (self.editMode != GROUP_MEMBER_ADD) {
        self.editMode = GROUP_MEMBER_ADD;
        //[[MyCommOperation shareInstance] requestGroupInfo:@[self.model.groupId]];
    }
    
    UIResponder* responder = self;
    UIViewController* controller;
    while (responder) {
        if ([responder isKindOfClass:[MyGroupInfoViewController class]]) {
            controller = (MyGroupInfoViewController*)responder;
            break;
        }
        responder = responder.nextResponder;
    }
    
    if (controller) {
        MyGroupAddFriendViewController* addViewController = [[MyGroupAddFriendViewController alloc] initWithGroupInfo:self.model];
        [controller.navigationController pushViewController:addViewController animated:YES];
    }
    
}

# pragma mark - delegate<UIActionSheet>
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *optionTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    __weak MyGroupMemberListCell* weakSelf = self;
    
    if ([optionTitle isEqualToString:setToAdmin]) {
        [[MyCommOperation shareInstance] modifyGroupMemberInfoSetRole:self.model.groupId
          user:user
          role:TIM_GROUP_MEMBER_ROLE_ADMIN
          succ:^{
              [weakSelf showAlert:@"提示" andMsg:@"任命成功"];
              user = nil;
          }
          fail:^(int code, NSString *err) {
              user = nil;
          }];
    }
    else if ([optionTitle isEqualToString:cancelFromAdmin]) {
        [[MyCommOperation shareInstance] modifyGroupMemberInfoSetRole:self.model.groupId
          user:user
          role:TIM_GROUP_MEMBER_ROLE_MEMBER
          succ:^{
              [weakSelf showAlert:@"提示" andMsg:@"取消任命成功"];
              user = nil;
          }
          fail:^(int code, NSString *err) {
              user = nil;
          }];
    }
    else if ([optionTitle isEqualToString:setToSilence]) {
        [[MyCommOperation shareInstance] modifyGroupMemberInfoSetSilence:self.model.groupId
         user:user
        stime:300000
         succ:^{
            user = nil;
        } fail:^(int code, NSString *err) {
            user = nil;
        }];
    }
    else if ([optionTitle isEqualToString:cancelFromSilence]) {
        [[MyCommOperation shareInstance] modifyGroupMemberInfoSetSilence:self.model.groupId
         user:user
        stime:0
         succ:^{
            user = nil;
        } fail:^(int code, NSString *err) {
            user = nil;
        }];
    }
}
#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSLog(@"xxxxxx");
    NSString *newNamecard = textField.text;
    __weak UITextField *wtf = textField;
    __weak MyGroupMemberListCell *ws = self;
    [[MyCommOperation shareInstance] modifyGroupNamecard:ws.model.groupId userId:textField.placeholder nameCard:newNamecard succ:^(){
        wtf.text = newNamecard;
    } fail:^(int code, NSString* err){
        //含敏感词汇
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:ERRORCODE_TO_ERRORDEC(code) delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
    return YES;
}

# pragma mark - private methods
- (void)delMember:(id)sender{
    self.editMode = GROUP_MEMBER_DEL;
    
    //更新视图
    [self setNeedsLayout];
    
}

- (void)doDeleteMember:(id)sender {
    NSUInteger tag = ((UIButton *)sender).tag;
    MyMemberModel* memberInfo = [self.model.memberList objectAtIndex:tag-1];
    __weak MyGroupMemberListCell* weakSelf = self;
    //send Req
    
    TDDLogEvent(@"send request delete member sucessful. gorupid:%@. memberList:%@", weakSelf.model.groupId, memberInfo.user);
    
    [[MyCommOperation shareInstance] deleteGroupMember:self.model.groupId members:@[memberInfo.user] succ:nil fail:nil];
}

#pragma mark - Getter and Setter
- (UIButton*)addBtn{
    if (!_addBtn || ![_addBtn superview]) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _addBtn.frame = CGRectMake(0, 0, GROUP_INFO_MEMBER_IMG_H, GROUP_INFO_ITEM_PADDING);
        [_addBtn setImage:[UIImage imageNamed:@"btn_member_add"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addBtn];
    }
    return _addBtn;
}

- (UIButton*)delBtn{
    if (!_delBtn || ![_delBtn superview]) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _delBtn.frame = CGRectMake(0, 0, 40, 40);
        [_delBtn setImage:[UIImage imageNamed:@"btn_member_delete"] forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(delMember:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_delBtn];
    }
    return _delBtn;
}

@end
