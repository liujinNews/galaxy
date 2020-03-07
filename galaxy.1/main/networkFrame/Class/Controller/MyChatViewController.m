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
//  聊天窗口

#import "MyChatViewController.h"
#import "MyChatToolBarView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MyMsgTextModel.h"
#import "MyTimeModel.h"
#import "MyMsgAudioModel.h"
#import "MyMsgPicModel.h"
#import "MyMsgFileModel.h"
#import "MyMsgVideoModel.h"
#import "MyChatBaseCell.h"
#import "MyChatTextCell.h"
#import "MyChatTimeCell.h"
#import "MyChatPicCell.h"
#import "MyChatFileCell.h"
#import "MyChatAudioCell.h"
#import "MyChatTipsCell.h"
#import "MyChatVideoCell.h"
#import "MyImageBrowserView.h"
#import "UIResponder+addtion.h"
#import "UIImage+fixOrientation.h"
#import "MyGroupInfoViewController.h"
#import "MyGroupInfoModel.h"
#import "GlobalData.h"
#import "MyMemberModel.h"
#import "MyFriendModel.h"
#import <ImSDK/TIMManager.h>
#import "MyCommOperation.h"
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

#import "MyImageViewController.h"

#import "MyMenuItem.h"
#import "Macro.h"

#import "MyAudioManager.h"

static MyChatViewController* gCurrentChatViewController;

@interface MyChatViewController()<UIAlertViewDelegate>{
    
    NSString* _chatId;
    TIMConversationType  _type;
    NSTimeInterval _lastMsgTime;
    BOOL _bIsOriPic;
    BOOL _isUpdateEnd;           //控制刷新频率
    BOOL _isFristUpdate;         //是否第一次刷新
}

@property (strong, nonatomic) id ImageDisplayChangeObserver;
@property (nonatomic, assign) BOOL HideStatusBar;
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) MyChatToolBarView* toolbar;
@property (strong, nonatomic) NSString* chatId;

@property (strong, nonatomic) TIMConversation* conversation;
@property (strong, nonatomic) NSMutableArray* dataSource;   //储存消息的队列
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) MyImageViewController *myImageViewController;

@property (strong, nonatomic) TIMMessage *lastMsg;          //上一次拉取的最后一条消息

@end

@implementation MyChatViewController

+(MyChatViewController*)current{
    return gCurrentChatViewController;
}

- (id)initWithC2C:(NSString*)friendInfo{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.chatId = friendInfo;
        self.friendInfo = friendInfo;
        _type = TIM_C2C;
        self.title = [[GlobalData shareInstance] getFriendInfo:friendInfo].nickName;
    }
    return self;
}

- (id)initWithGroup:(NSString*)groupId{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _type = TIM_GROUP;
        self.chatId = groupId;
        MyGroupInfoModel* model = [[GlobalData shareInstance] getGroupInfo:groupId];
        if (model) {
            self.title = model.groupTitle;
        }
        [self isMyselfIsAdmin:self.chatId];
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = @"返回";
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    }
    return self;
}

- (void)isMyselfIsAdmin:(NSString *)groupId
{
    _isMySelfIsAdmin = NO;
    [[TIMGroupManager sharedInstance] GetGroupMembers:groupId ByFilter:TIM_GROUP_MEMBER_FILTER_ADMIN flags:TIM_GET_GROUP_MEM_INFO_FLAG_ROLE_INFO custom:nil nextSeq:0 succ:^(uint64_t nextSeq, NSArray *admins){
        
        for (TIMGroupMemberInfo* memberInfo in admins)
        {
            //如果自己是管理员
            if ([memberInfo.member isEqualToString:[GlobalData shareInstance].me] &&
                memberInfo.role == TIM_GROUP_MEMBER_ROLE_ADMIN) {
                _isMySelfIsAdmin = YES;
            }
        }
        
    } fail:^(int code, NSString *err){
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    gCurrentChatViewController = self;
    
    [self hiddenKeyBoard];
    
    [self setAllMsgReaded];
    
    //再次进入聊天界面，重新获取消息(保证实时显示最新消息)
    _lastMsg = nil;
    _isFristUpdate = YES;
    [self updateData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    gCurrentChatViewController = nil;
    [[MyAudioManager sharedInstance] stopPlay];
    [self setAllMsgReaded];
    //每次离开聊天界面，清空tableview的数据，方便下次进入的时候重绘
    if (_dataSource && _tableView) {
        [_dataSource removeAllObjects];
        [_tableView reloadData];
    }
    
    //退出聊天界面时，刷新会话列表
    [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationReccentListViewUpdate object:nil userInfo:nil];
}

- (void)setupSubViews{
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    self.view.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - NavBarHeight);
    
    NSString* iconName;
    if (_type == TIM_C2C) {
        iconName = @"header_icon_single";
    }
    else{
        iconName = @"header_icon_group";
    }
    
    [self setTitle:_friendInfo backButton:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-shanchu"] style:UIBarButtonItemStyleDone target:self action:@selector(rightNavButtonAction:)];
    self.navigationItem.rightBarButtonItem.tintColor = Color_Black_Important_20;
    
    CGFloat kToolbarY = CGRectGetMaxY(self.view.bounds) - CHAT_BAR_MIN_H - 2*CHAT_BAR_VECTICAL_PADDING;
    _toolbar = [[MyChatToolBarView alloc] initWithFrame:CGRectMake(0, kToolbarY, CGRectGetWidth(self.view.bounds), CHAT_BAR_MIN_H+2*CHAT_BAR_VECTICAL_PADDING) chatType:_type];
    _toolbar.delegate = self;
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMinY(self.view.frame), CGRectGetWidth(self.view.frame), kToolbarY);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = Color_White_Same_20;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 10.f;
    _tableView.sectionFooterHeight = 0.f;
    _tableView.superview.backgroundColor = Color_White_Same_20;
    [self.view addSubview:_tableView];
    [self.view addSubview:_toolbar];
    [(MyMoreView *)_toolbar.moreView setDelegate:self];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupSubViews];
    [self setupRefresh];
    
    self.dataSource = [NSMutableArray arrayWithCapacity:MAX_CHATMSG_ORGIN_LOAD];
    _conversation = [[TIMManager sharedInstance] getConversation:_type receiver:self.chatId];
    _lastMsg = nil;
    _isUpdateEnd = YES;
    _isFristUpdate = YES;
//    [self updateData];
    
    if (_type == TIM_GROUP) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupInfoChange:) name:kMyNotificationGroupInfoChange object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appendRecieveMessage:) name:kMyNotificationChatViewMessageUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyClose)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    __weak MyChatViewController *weakSelf = self;
    self.ImageDisplayChangeObserver = [[NSNotificationCenter defaultCenter]
                                       addObserverForName:kMyNotificationImageViewDisplayChange
                                       object:nil
                                       queue:[NSOperationQueue mainQueue]
                                       usingBlock:^(NSNotification *note) {
                                           weakSelf.HideStatusBar = [[note.userInfo objectForKey:@"DisplayImage"] isEqualToNumber:[NSNumber numberWithBool:YES]];
                                           [weakSelf setNeedsStatusBarAppearanceUpdate];
                                       }];
}

//添加刷新控件
-(void)setupRefresh
{
    UIRefreshControl *control=[[UIRefreshControl alloc]init];
    [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
}

-(void)refreshStateChange:(UIRefreshControl *)control
{
    if (_isUpdateEnd) {
        [self updateData];
    }
    [control endRefreshing];
}

- (void)updateData{
    _isUpdateEnd = NO;
    __weak MyChatViewController* weakself = self;
    [_conversation getMessage:MAX_CHATMSG_ORGIN_LOAD last:_lastMsg succ:^(NSArray* msgList){
        if (msgList.count < 1) {
            if (!_isFristUpdate) {
                [weakself showTips:@"没有更多消息了"];
            }
            else {
                _isFristUpdate = NO;
            }
            _isUpdateEnd = YES;
            return ;
        }
        _lastMsg = msgList[msgList.count-1];
        NSArray *msgModels = [self removeDeletedMsg:msgList];
        
        NSIndexSet *indexSets = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, msgModels.count)];
        
        [weakself.dataSource insertObjects:msgModels atIndexes:indexSets];
        
        UITapGestureRecognizer* tapAction = [[UITapGestureRecognizer alloc] initWithTarget:weakself action:@selector(hiddenKeyBoard)];
        [weakself.tableView addGestureRecognizer:tapAction];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.tableView reloadData];
            if (weakself.tableView.contentSize.height > weakself.tableView.frame.size.height)
            {
                static float offsetY = 0;
                //如果是第一次刷新，需要计算偏移量
                if (_isFristUpdate) {
                    offsetY = weakself.tableView.contentSize.height - weakself.tableView.frame.size.height;
                    _isFristUpdate = NO;
                }
                CGPoint offset = CGPointMake(0, offsetY);
                [weakself.tableView setContentOffset:offset animated:NO];
            }
            else{
                if (_isFristUpdate) {
                    _isFristUpdate = NO;
                }
            }
        });
        _isUpdateEnd = YES;
        
    } fail:^(int code, NSString* err){
        TDDLogEvent(@"get conversation message failed");
        _isUpdateEnd = YES;
    }];
}

- (void)hideTips:(NSTimer*)theTimer
{
    UIAlertView *tips = (UIAlertView*)[theTimer userInfo];
    [tips dismissWithClickedButtonIndex:0 animated:NO];
    tips = NULL;
}

- (void)showTips:(NSString*)showInfo
{
    UIAlertView *tips = [[UIAlertView alloc] initWithTitle:nil message:showInfo delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5f
                                     target:self
                                   selector:@selector(hideTips:)
                                   userInfo:tips
                                    repeats:NO];
    [tips show];
}

- (NSArray*)removeDeletedMsg:(NSArray*)msgList{
    __weak MyChatViewController *weakself = self;
    NSMutableArray *msgModel = [[NSMutableArray alloc] init];
    NSUInteger index = msgList.count;
    while (index>0) {
        TIMMessage* msg = [msgList objectAtIndex:index-1];
        if (msg.status == TIM_MSG_STATUS_HAS_DELETED) {
            //被删除的消息不处理
        }
        else{
            //将消息转换为model
            [msgModel addObjectsFromArray:[weakself modelFromMessage:msg]];
        }
        index--;
    }
    return msgModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self releaseImagePicker];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMyNotificationGroupInfoChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMyNotificationChatViewMessageUpdate object:nil];
}

- (UIImagePickerController *)imagePicker{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        //修改导航栏背景颜色
        [_imagePicker.navigationBar setBarTintColor:[UIColor whiteColor]];
        //修改取消文字颜色
        [_imagePicker.navigationBar setTintColor:[UIColor blackColor]];
        //修改中间文字颜色
        NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
        [_imagePicker.navigationController.navigationBar setTitleTextAttributes:attributes];
    }
    return _imagePicker;
}

- (void)releaseImagePicker {
    _imagePicker = nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id obj = [self.dataSource objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[MyMsgTextModel class]]) {
        MyMsgTextModel* model = (MyMsgTextModel *)obj;
        return  [MyChatTextCell heightForModel:model];
    }
    else if ([obj isKindOfClass:[MyTimeModel class]]) {
        MyTimeModel* model = (MyTimeModel *)obj;
        return  [MyChatTimeCell heightForModel:model];
    }
    else if ([obj isKindOfClass:[MyMsgPicModel class]]) {
        MyMsgPicModel* model = (MyMsgPicModel *)obj;
        return  [MyChatPicCell heightForModel:model];
    }
    else if ([obj isKindOfClass:[MyMsgAudioModel class]]) {
        MyMsgAudioModel* model = (MyMsgAudioModel *)obj;
        return  [MyChatAudioCell heightForModel:model];
    }
    else if ([obj isKindOfClass:[MyMsgFileModel class]]) {
        MyMsgFileModel* model = (MyMsgFileModel *)obj;
        return  [MyChatFileCell heightForModel:model];
    }
    else if ([obj isKindOfClass:[MyMsgTipsModel class]]) {
        MyMsgTipsModel* model = (MyMsgTipsModel *)obj;
        return  [MyChatTipsCell heightForModel:model];
    }
    else if ([obj isKindOfClass:[MyMsgVideoModel class]]) {
        MyMsgVideoModel* model = (MyMsgVideoModel *)obj;
        return [MyChatVideoCell heightForModel:model];
    }
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* kTextCellReusedID = @"TextCellReusedID";
    static NSString* kTimeCellReusedID = @"TimeCellReusedID";
    static NSString* kImageCellReusedID = @"ImageCellReusedID";
    static NSString* kAudioCellReusedID = @"AudioCellReusedID";
    static NSString* kFileCellReusedID = @"FileCellReusedID";
    static NSString* kTipsCellReusedID = @"TipsCellReusedID";
    static NSString* kVideoCellReusedID = @"VideoCellReusedID";
    
    __weak MyChatViewController *weakSelf = self;
    UITableViewCell* cell;
    id obj = [self.dataSource objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[MyMsgTextModel class]]) {
        MyChatTextCell* textCell = [tableView dequeueReusableCellWithIdentifier:kTextCellReusedID];
        if (!textCell) {
            textCell = [[MyChatTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTextCellReusedID];
        }
        [textCell setContent:obj];
        cell = textCell;
    }
    else if ([obj isKindOfClass:[MyTimeModel class]]) {
        MyChatTimeCell* timeCell = [tableView dequeueReusableCellWithIdentifier:kTimeCellReusedID];
        if (!timeCell) {
            timeCell = [[MyChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTimeCellReusedID];
        }
        [timeCell setContent:obj];
        cell = timeCell;
    }
    else if ([obj isKindOfClass:[MyMsgPicModel class]]) {
        MyChatPicCell* picCell = [tableView dequeueReusableCellWithIdentifier:kImageCellReusedID];
        if (!picCell) {
            picCell = [[MyChatPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kImageCellReusedID];
        }
        [picCell setContent:obj];
        cell = picCell;
    }
    else if ([obj isKindOfClass:[MyMsgAudioModel class]]) {
        MyChatAudioCell* audioCell = [tableView dequeueReusableCellWithIdentifier:kAudioCellReusedID];
        if (!audioCell) {
            audioCell = [[MyChatAudioCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAudioCellReusedID];
        }
        [audioCell setContent:obj];
        cell = audioCell;
    }
    else if ([obj isKindOfClass:[MyMsgFileModel class]]) {
        MyChatFileCell* fileCell = [tableView dequeueReusableCellWithIdentifier:kFileCellReusedID];
        if (!fileCell) {
            fileCell = [[MyChatFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFileCellReusedID];
        }
        [fileCell setContent:obj];
        fileCell.downloadFile = ^(MyMsgFileModel *fileModel){
            [weakSelf downloadFile:fileModel];
        };
        cell = fileCell;
    }
    else if ([obj isKindOfClass:[MyMsgTipsModel class]]) {
        MyChatTipsCell* tipsCell = [tableView dequeueReusableCellWithIdentifier:kTipsCellReusedID];
        if (!tipsCell) {
            tipsCell = [[MyChatTipsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTipsCellReusedID];
        }
        [tipsCell setContent:obj];
        cell = tipsCell;
    }
    else if ([obj isKindOfClass:[MyMsgVideoModel class]]) {
        MyChatVideoCell* videoCell = [tableView dequeueReusableCellWithIdentifier:kVideoCellReusedID];
        if (!videoCell) {
            videoCell = [[MyChatVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kVideoCellReusedID];
        }
        [videoCell setContent:obj];
        cell = videoCell;
    }
    cell.backgroundColor = Color_White_Same_20;
    return cell;
}

#pragma mark - download file
- (void)downloadFile:(MyMsgFileModel *)model{
    //NSLog(@"mode = %@",model);
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *ourDocumentPath =[documentPaths objectAtIndex:0];
    
    NSString *FileName=[ourDocumentPath stringByAppendingPathComponent:model.fileName];//fileName就是保存文件的文件名
    
    [model.data writeToFile:FileName atomically:YES];//将NSData类型对象data写入文件，文件名为FileName

    NSString *showPath = [[NSString alloc] initWithFormat:@"文件已保存到%@",documentPaths];
    [self showAlert:@"提示" andMsg:showPath];
}

#pragma mark- BaseCell deleteCell
- (BOOL) tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    id model = [self.dataSource objectAtIndex:indexPath.row];
    MyMsgBaseModel *baseModel = (MyMsgBaseModel *)model;
    __weak MyChatViewController *weakSelf = self;
    __block NSIndexPath *index = indexPath;
    
    if ([cell isKindOfClass:[MyChatBaseCell class]])
    {
        MyChatBaseCell *chatCell = (MyChatBaseCell *)cell;
        
        UIView *view = [chatCell showMenuView];
        if (view)
        {
            [self canBecomeFirstResponder];
            [cell becomeFirstResponder];
            NSMutableArray *arrayItems = [[NSMutableArray alloc] init];
            
            MyMenuItem *delete = [[MyMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteCell:)];
            delete.tag = ChatViewMenu_ItemDelete;
            delete.menuAction = ^(MyMenuItem *item) {
                [weakSelf OnDeleteCellAt:index];
            };
            [arrayItems addObject:delete];
            
            if (baseModel.status == TIM_MSG_STATUS_SEND_FAIL && ![baseModel isKindOfClass:[MyMsgAudioModel class]]) {
                MyMenuItem *resend = [[MyMenuItem alloc] initWithTitle:@"重发" action:@selector(resendCell:)];
                resend.tag = ChatViewMenu_ItemResend;
                resend.menuAction = ^(MyMenuItem *item){
                    [weakSelf OnResendCell:index];
                };
                [arrayItems addObject:resend];
            }
            
            UIMenuController *menu = [UIMenuController sharedMenuController];
            [menu setMenuItems:arrayItems];
            [menu setTargetRect:view.bounds inView:view];
            [menu setMenuVisible:YES animated:YES];
            return YES;
        }
    }
    return NO;
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
   
    if (action == @selector(deleteCell:) ) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView*)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    
}

- (void)resendCell:(UIMenuController *)sender{
    for (MyMenuItem *item in sender.menuItems) {
        if ((item.tag == ChatViewMenu_ItemResend) && item.menuAction) {
            item.menuAction(item);
        }
    }
}

- (void)OnResendCell:(NSIndexPath *)index{
    id model = [self.dataSource objectAtIndex:index.row];
    [self OnDeleteCellAt:index];
    
    ((MyMsgBaseModel *)model).sendTime = [NSDate date];
    
    if ([model isKindOfClass:[MyMsgTextModel class]]) {
        [self sendTextMessage:model];
    }
    else if ([model isKindOfClass:[MyMsgAudioModel class]]) {
        [self sendAudioMessage:model];
    }
    else if ([model isKindOfClass:[MyMsgPicModel class]]) {
        [self sendImageMessage:model];
        [self appendSendMsg:model];
    }
    else if ([model isKindOfClass:[MyMsgFileModel class]]) {
        [self sendFileMessage:model];
        [self appendSendMsg:model];
    }
    else if ([model isKindOfClass:[MyMsgVideoModel class]]) {
        [self sendVideoMessage:model];
    }
}

- (void)deleteCell:(UIMenuController *)sender{
    NSLog(@"deleteCell");
    
    for (MyMenuItem *item in sender.menuItems) {
        if ((item.tag == ChatViewMenu_ItemDelete) && item.menuAction) {
            item.menuAction(item);
        }
    }
}

- (void)OnDeleteCellAt:(NSIndexPath *)index
{
    NSInteger indexRow = [index row];
    
    NSIndexPath *preIndex = nil;
    UITableViewCell *preCell = nil;
    
    NSIndexPath *nextIndex = nil;
    UITableViewCell *nextCell = nil;
    
    if (indexRow > 0) {
        preIndex = [NSIndexPath indexPathForRow:indexRow-1 inSection:0];
        preCell = [self.tableView cellForRowAtIndexPath:preIndex];
    }
    if (indexRow < self.dataSource.count-1) {
        nextIndex = [NSIndexPath indexPathForRow:indexRow+1 inSection:0];
        nextCell = [self.tableView cellForRowAtIndexPath:nextIndex];
    }
    
    NSArray *deleteArray = nil;
    
    //case1：当前cell的上一个cell为timecell且后一个cell也为timecell
    //case2:当前cell的上一个cell为timecell且后一个cell为空
    //以上两种情况，需要删除cell前面的timecell;
    if (preCell) {
        id preObj = nil;
        if (nextCell) {
            preObj = [self.dataSource objectAtIndex:preIndex.row];
            id nextObj = [self.dataSource objectAtIndex:nextIndex.row];
            
            if ([preObj isKindOfClass:[MyTimeModel class]] && [nextObj isKindOfClass:[MyTimeModel class]]){
                deleteArray = [[NSArray alloc] initWithObjects:index,preIndex, nil];
            }
            else{
                deleteArray = [[NSArray alloc] initWithObjects:index, nil];
            }
        }
        else{
            preObj = [self.dataSource objectAtIndex:preIndex.row];
            if ([preObj isKindOfClass:[MyTimeModel class]]) {
                deleteArray = [[NSArray alloc] initWithObjects:index,preIndex, nil];
            }
            else{
                deleteArray = [[NSArray alloc] initWithObjects:index, nil];
            }
        }
    }
    
    [_tableView beginUpdates];
    
    [_tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationRight];//@[index, preIndex]
   
    for (int i=0; i<deleteArray.count; i++) {
        NSIndexPath *tempIndex = [deleteArray objectAtIndex:i];
        id obj = [_dataSource objectAtIndex:tempIndex.row];
        if (![obj isKindOfClass:[MyTimeModel class]]) {
            MyMsgBaseModel *baseModel = obj;
           [baseModel.msg remove];
        }
        [_dataSource removeObjectAtIndex:tempIndex.row];
    }

    [_tableView endUpdates];
}

//add a cell
-(void)appendRecieveMessage:(NSNotification *)notify
{
    NSArray *messages = [notify.userInfo objectForKey:@"msgs"];
    int msgIndex = 0;
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (TIMMessage *message in messages) {
        
        TIMConversation * conversation = [message getConversation];
        
        dispatch_async(dispatch_get_global_queue(0,0),^{
            [[TIMManager sharedInstance] log:TIM_LOG_DEBUG tag:@"Duplicate Msg Check" msg:[NSString stringWithFormat:@"Append Msg: msgs_len=%lu msg_id=%@ msgIndex=%d", (unsigned long)messages.count, [message msgId], msgIndex]];
            TDDLogEvent(@"NewMessage: %@ : %@", conversation, message);
        });
        msgIndex ++;
        
        if (![[conversation getReceiver] isEqualToString:self.chatId]) {
            continue;
        }

        NSArray *msgModels = [self modelFromMessage:message];

        for (int i = 0; i < msgModels.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count+i inSection:0];
            [indexPaths addObject:indexPath];
        }
        [_dataSource addObjectsFromArray:msgModels];
    }
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
    [_tableView scrollToRowAtIndexPath:[indexPaths lastObject] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)setAllMsgReaded{
    if ([_conversation getUnReadMessageNum] > 0 ) {
        //当前视图可见，则标记为已读
        if (!self.view.hidden) {
            [_conversation setReadMessage];
            //更新RecentView
            [[NSNotificationCenter defaultCenter] postNotificationName:kMyNotificationReccentListViewUpdate object:nil];
        }
    }
}

-(void)appendSendMsg:(MyMsgBaseModel*) model{
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    if ([model.sendTime timeIntervalSince1970]- _lastMsgTime > 60) {
        MyTimeModel* timeModel = [[MyTimeModel alloc] init];
        timeModel.inMsg = model.inMsg;
        timeModel.timeStr = [self formatMsgTime:model.sendTime];
        _lastMsgTime = [model.sendTime timeIntervalSince1970];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count inSection:0];
        [indexPaths addObject:indexPath];
        [_dataSource addObject:timeModel];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count inSection:0];
    [indexPaths addObject:indexPath];
    [_dataSource addObject:model];
    
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
    [_tableView scrollToRowAtIndexPath:[indexPaths lastObject] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (NSArray*)modelFromMessage:(TIMMessage*)msg{
    NSMutableArray* models = [NSMutableArray arrayWithCapacity:2];
    BOOL isNeedTimeModel = NO;
    MyTimeModel* timeModel;
    if (fabs([msg.timestamp timeIntervalSince1970]- _lastMsgTime) > 60) {
        timeModel = [[MyTimeModel alloc] init];
        timeModel.inMsg = !msg.isSelf;
        timeModel.timeStr = [self formatMsgTime:msg.timestamp];
        timeModel.msg = msg;
        _lastMsgTime = [msg.timestamp timeIntervalSince1970];
        isNeedTimeModel = YES;
    }
    
    for (int index=0; index<msg.elemCount; index++) {
        TIMElem* elem = [msg getElem:index];
        if ([elem isKindOfClass:[TIMTextElem class]]) {
            [[TIMManager sharedInstance]
             log:TIM_LOG_DEBUG
             tag:@"Duplicate Msg Check"
             msg:[NSString stringWithFormat:@"Append Elem: msg_id=%@ text=%@ elemCount=%d elemIndex=%lu", [msg msgId], [(TIMTextElem *)elem text], msg.elemCount, (unsigned long)index]];
            
            TIMTextElem* textElem = (TIMTextElem *)elem;
            MyMsgTextModel* textModel = [[MyMsgTextModel alloc]init];
            textModel.inMsg = !msg.isSelf;
            textModel.friendUserName = msg.sender;
            textModel.sendTime = msg.timestamp;
            textModel.textMsg = textElem.text;
            textModel.chatType = _type;
            textModel.status = msg.status;
            textModel.preStatus = msg.status;
            textModel.elem = elem;
            textModel.msg = msg;
            textModel.conversation = self.conversation;
            [models addObject:textModel];
        }
        else if([elem isKindOfClass:[TIMSoundElem class]]) {
            TIMSoundElem* soundsElem = (TIMSoundElem *)elem;
            MyMsgAudioModel* soundModel = [[MyMsgAudioModel alloc]init];
            soundModel.inMsg = !msg.isSelf;
            soundModel.friendUserName = msg.sender;
            soundModel.data = soundsElem.data;
            soundModel.sendTime = msg.timestamp;
            soundModel.chatType = _type;
            soundModel.status = msg.status;
            soundModel.preStatus = msg.status;
            soundModel.duration = soundsElem.second;
            soundModel.elem = elem;
            soundModel.msg = msg;
            soundModel.isPlayed = YES;
            soundModel.conversation = self.conversation;
            [models addObject:soundModel];
        }
        else if([elem isKindOfClass:[TIMImageElem class]]) {
            TIMImageElem* picElem = (TIMImageElem *)elem;
            MyMsgPicModel* picModel = [[MyMsgPicModel alloc]init];
            picModel.inMsg = !msg.isSelf;
            picModel.friendUserName = msg.sender;
            picModel.picWidth = 60.f;
            picModel.picHeight = 60.f;
            for (TIMImage* image in picElem.imageList) {
                if (image.type == TIM_IMAGE_TYPE_THUMB) {
                    picModel.picThumbHeight = image.height==0 ? 50 : image.height;
                    picModel.picThumbWidth = image.height==0 ? 90 : image.width;
                }else {
                    picModel.picHeight = image.height;
                    picModel.picWidth = image.width;
                }
            }
            if (picElem.imageList.count < 1) {
                UIImage *imgFromPath=[[UIImage alloc]initWithContentsOfFile:picElem.path];
                if(imgFromPath){
                    CGFloat scale = 1;
                    scale = MIN(CELL_PIC_THUMB_MAX_H/imgFromPath.size.height, CELL_PIC_THUMB_MAX_W/imgFromPath.size.width);
                    UIImage *thumbImage = [self thumbnailWithImage:imgFromPath size:CGSizeMake(imgFromPath.size.width*scale, imgFromPath.size.height*scale)];
                    picModel.data = UIImageJPEGRepresentation(thumbImage, 1);
                    picModel.picHeight = imgFromPath.size.height;
                    picModel.picWidth = imgFromPath.size.width;
                    picModel.picThumbHeight = picModel.picHeight * scale;
                    picModel.picThumbWidth = picModel.picWidth * scale;
                    picModel.inMsg = NO;
                }
            }
            picModel.chatType = _type;
            picModel.picPath = picElem.path;
            picModel.status = msg.status;
            picModel.preStatus = msg.status;
            picModel.msg = msg;
            picModel.elem = elem;
            picModel.conversation = self.conversation;
            
            //缩约图和原图均大小为0
//            if (picModel.picThumbHeight==0||picModel.picThumbWidth==0) {
//                if(picModel.picHeight==0||picModel.picWidth==0){
//                    picModel.picThumbWidth = 90;
//                    picModel.picThumbHeight = 50;
//                }
//                else{
//                    picModel.picThumbWidth = picModel.picWidth;
//                    picModel.picThumbHeight = picModel.picHeight;
//                }
//            }

            picModel.sendTime = msg.timestamp;
            [models addObject:picModel];
        }
        else if([elem isKindOfClass:[TIMFileElem class]]) {
            TIMFileElem* fileElem = (TIMFileElem *)elem;
            MyMsgFileModel* fileModel = [[MyMsgFileModel alloc]init];
            fileModel.inMsg = !msg.isSelf;
            fileModel.friendUserName = msg.sender;
            NSURL *url = [NSURL URLWithString:fileElem.filename];
            fileElem.data = [NSData dataWithContentsOfURL:url];
            fileModel.fileName = [url pathComponents].lastObject;
            fileModel.filesize = fileElem.fileSize;
            fileModel.sendTime = msg.timestamp; 
            fileModel.chatType = _type;
            fileModel.msg = msg;
            fileModel.elem = fileElem;
            fileModel.status = msg.status;
            fileModel.preStatus = msg.status;
            fileModel.conversation = self.conversation;
            
            __weak MyMsgFileModel *weakFileModel = fileModel;
            [fileElem getFileData:^(NSData *data){
                //NSLog(@"data = %@",data);
                weakFileModel.data = data;
            } fail:^(int code,NSString *err){
            
            }];
            [models addObject:fileModel];
        }
        else if([elem isKindOfClass:[TIMGroupTipsElem class]]){
            isNeedTimeModel = NO;
            TIMGroupTipsElem* tipsElem = (TIMGroupTipsElem *)elem;
            NSArray* tipsArray = [self formatGroupTipsMsg:tipsElem];
            for (NSString* tip in tipsArray) {
                MyMsgTipsModel* tipsModel = [[MyMsgTipsModel alloc] init];
                tipsModel.tipsStr = tip;
                _lastMsgTime = [msg.timestamp timeIntervalSince1970];
                [models addObject:tipsModel];
            }
        }
        else if ([elem isKindOfClass:[TIMVideoElem class]]){
            TIMVideoElem* videoElem = (TIMVideoElem*)elem;
            MyMsgVideoModel* videoModel = [[MyMsgVideoModel alloc] init];
            videoModel.inMsg = !msg.isSelf;
            videoModel.friendUserName = msg.sender;
            videoModel.sendTime = msg.timestamp;
            videoModel.chatType = _type;
            videoModel.msg = msg;
            videoModel.elem = videoElem;
            videoModel.status = msg.status;
            videoModel.preStatus = msg.status;
            videoModel.conversation = self.conversation;
            
            videoModel.videoPath = videoElem.videoPath;
            videoModel.videoType = videoElem.video.type;
            videoModel.duration = videoElem.video.duration;
            videoModel.snapshotPath = videoElem.snapshotPath;
            videoModel.snapshotType = videoElem.snapshot.type;
            videoModel.width = videoElem.snapshot.width;
            videoModel.height = videoElem.snapshot.height;
            
            [models addObject:videoModel];
        }
    }
    
    if (isNeedTimeModel) {
        [models insertObject:timeModel atIndex:0];
    }

    return models;
}

- (NSString*)formatMsgTime:(NSDate*)date{
    NSString* strDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

- (NSArray*)formatGroupTipsMsg:(TIMGroupTipsElem*)elem{
    NSMutableArray* tipsArray = [NSMutableArray arrayWithCapacity:10];
    NSMutableString* userList = [[NSMutableString alloc] init];
    TIMGroupTipsElemGroupInfo *groupInfo = nil;
    int i = 0;
    NSString* action;
    switch (elem.type) {
        case TIM_GROUP_TIPS_TYPE_INVITE:
            action = @"%@ 邀请%@ 加入了群";
            i = 0;
            for (NSString* user in elem.userList) {
                if (i++ > 0) {
                    [userList appendString:@","];
                }
                [userList appendString:user];
            }
            [tipsArray addObject:[NSString stringWithFormat:action, elem.opUser, userList]];
            break;
        case TIM_GROUP_TIPS_TYPE_QUIT_GRP:
            action = @"%@ 退出了群";
            [tipsArray addObject:[NSString stringWithFormat:action, elem.opUser]];
            break;
        case TIM_GROUP_TIPS_TYPE_KICKED:
            action = @"%@ 将%@ 移除出群";
            userList = [[NSMutableString alloc] init];
            i = 0;
            for (NSString* user in elem.userList) {
                if (i++ > 0) {
                    [userList appendString:@","];
                }
                [userList appendString:user];
            }
            [tipsArray addObject:[NSString stringWithFormat:action, elem.opUser, userList]];
            break;
        case TIM_GROUP_TIPS_TYPE_INFO_CHANGE:
            {
                groupInfo = [elem.groupChangeList objectAtIndex:0];
                switch (groupInfo.type) {
                    case TIM_GROUP_INFO_CHANGE_GROUP_NAME:
                        action = @"%@ 将群名修改为 %@";
                        break;
                    case TIM_GROUP_INFO_CHANGE_GROUP_INTRODUCTION:
                        action = @"%@ 将群简介修改为 %@";
                        break;
                    case TIM_GROUP_INFO_CHANGE_GROUP_NOTIFICATION:
                        action = @"%@ 将群公告修改为 %@";
                        break;
                    case TIM_GROUP_INFO_CHANGE_GROUP_FACE:
                        action = @"%@ 将群头像修改为 %@";
                        break;
                    case TIM_GROUP_INFO_CHANGE_GROUP_OWNER:
                        action = @"%@ 将群主修改为 %@";
                        break;
                    default:
                        break;
                }
                [tipsArray addObject:[NSString stringWithFormat:action, elem.opUser, groupInfo.value]];
            }
            
        default:
            break;
    }
    return tipsArray;
}


#pragma mark - MyChatToolBarViewDelegate

- (void)didChangeToolBarHight:(CGFloat)toHeight{
    __weak MyChatViewController* weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = weakself.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = weakself.view.frame.size.height - toHeight;
        weakself.tableView.frame = rect;
        [weakself.toolbar updateEmoj];
    }];
    
    if (_tableView.contentSize.height > _tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, _tableView.contentSize.height - _tableView.frame.size.height);
        [_tableView setContentOffset:offset animated:YES];
    }
}

- (void)sendText:(NSString *)text
{
    if (text && text.length > 0) {
        MyMsgTextModel* model = [[MyMsgTextModel alloc ]init];
        model.friendUserName = _chatId;
        model.chatType = _type;
        model.inMsg = NO;
        model.textMsg = text;
        model.sendTime = [NSDate date];
        [self sendTextMessage:model];
    }
}

#pragma mark - moreView
-(void)hiddenKeyBoard
{
    [_toolbar endEditing:YES];
}

-(void)keyClose
{
    [self.view endEditing:YES];
    [_toolbar endEditing:YES];
}

- (void)moreViewPhotoAction
{
    // 隐藏键盘
    [self hiddenKeyBoard];
    _imagePicker = [[UIImagePickerController alloc]init];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.delegate = self;
    
    _imagePicker.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    _imagePicker.navigationController.navigationBar.translucent = NO;
    
    
    [_imagePicker.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,[UIColor blackColor],NSShadowAttributeName,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)], NSShadowAttributeName,Font_Important_15_20, NSFontAttributeName,nil]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 36, 33);//local_back.png
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
    _imagePicker.navigationItem.rightBarButtonItem=temporaryBarButtonItem;
    
    
    
    [self presentViewController:_imagePicker animated:YES completion:NULL];
}

- (void)moreVideVideoAction
{
    [self hiddenKeyBoard];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    self.imagePicker.videoMaximumDuration = 10.0f; // 10 seconds
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
    [self.imagePicker setEditing:YES];
    if ([[AVCaptureDevice class] respondsToSelector:@selector(authorizationStatusForMediaType:)]){
        AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorizationStatus == AVAuthorizationStatusRestricted
            || authorizationStatus == AVAuthorizationStatusDenied) {
            
            // 没有权限
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请在设备的\"设置-隐私-相机\"中允许访问相机。"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    
}

- (void)moreViewCameraAction
{
    [self hiddenKeyBoard];
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self.imagePicker setEditing:YES];
    if ([[AVCaptureDevice class] respondsToSelector:@selector(authorizationStatusForMediaType:)]){
        AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorizationStatus == AVAuthorizationStatusRestricted
            || authorizationStatus == AVAuthorizationStatusDenied) {
            
            // 没有权限
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请在设备的\"设置-隐私-相机\"中允许访问相机。"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    
}

- (void)moreViewFileAction
{
    // 隐藏键盘，只能选择图片或视频文件
    [self hiddenKeyBoard];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage* image = [info[UIImagePickerControllerOriginalImage] fixOrientation];
        _myImageViewController = [[[MyImageViewController alloc] init] initViewController:image];
        [_myImageViewController setDelegate:self];
        [picker pushViewController:_myImageViewController animated:YES];
        
    }else if([mediaType isEqualToString:(NSString*)kUTTypeMovie]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        if (self.imagePicker.mediaTypes.count == 2) {
            NSURL *url = info[UIImagePickerControllerMediaURL];
            NSError *err;
            NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&err];
            if(data.length < 28*1024*1024){//文件最大不超过28MB
                MyMsgFileModel* model = [[MyMsgFileModel alloc] init];
                model.data = [NSData dataWithContentsOfURL:url];
                model.fileName = [url pathComponents].lastObject;
                model.filesize = data.length;
                
                TIMFileElem* elem = [[TIMFileElem alloc] init];
                elem.data = model.data;
                elem.fileSize = model.filesize;
                elem.filename = [url absoluteString];
                
                model.elem = elem;
                
                // NSLog(@"filename = %@",[url pathComponents].lastObject);
                model.inMsg = NO;
                [self releaseImagePicker];
                [self sendFileMessage:model];
                
                //7.1.2(8.0版本一下)发送文件时，文件消息没有及时显示在聊天界面中，这里做一下版本兼容
                NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
                float version = [phoneVersion floatValue];
                if (version < 8.0) {
                    [self appendSendMsg:model];
                }
            }
            else{
                [self showPrompt:@"传输文件过大"];
            }
        }
        else {
            NSURL *url = info[UIImagePickerControllerMediaURL];
            NSError *err;
            NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&err];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSString *nsTmpDIr = NSTemporaryDirectory();
            NSString *videoPath = [NSString stringWithFormat:@"%@uploadVideoFile%3.f.%@", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate], @"mp4"];
            BOOL isDirectory;
            
            if ([fileManager fileExistsAtPath:videoPath isDirectory:&isDirectory]) {
                if (![fileManager removeItemAtPath:nsTmpDIr error:&err]) {
                    TDDLogEvent(@"Upload Image Failed: same upload filename: %@", err);
                    return;
                }
            }
            NSString *snapshotPath = [NSString stringWithFormat:@"%@uploadSnapshotFile%3.f", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate]];
            if ([fileManager fileExistsAtPath:snapshotPath isDirectory:&isDirectory]) {
                if (![fileManager removeItemAtPath:nsTmpDIr error:&err]) {
                    TDDLogEvent(@"Upload Image Failed: same upload filename: %@", err);
                    return;
                }
            }
            
            AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
            AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
            imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
            CMTime time = CMTimeMakeWithSeconds(1.0, 30);   // 1.0为截取视频1.0秒处的图片，30为每秒30帧
            CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:nil error:nil];
            UIImage *image = [UIImage imageWithCGImage:cgImage];
            
            [self convertToMP4:urlAsset videoPath:videoPath succ:^{
                UIGraphicsBeginImageContext(CGSizeMake(240, 320));
                // 绘制改变大小的图片
                [image drawInRect:CGRectMake(0,0, 240, 320)];
                // 从当前context中创建一个改变大小后的图片
                UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
                // 使当前的context出堆栈
                UIGraphicsEndImageContext();
                NSData *snapshotData = UIImageJPEGRepresentation(scaledImage, 0.75);
                if (![fileManager createFileAtPath:snapshotPath contents:snapshotData attributes:nil]) {
                    TDDLogEvent(@"Upload Image Failed: fail to create uploadfile: %@", err);
                    return;
                }
                
                MyMsgVideoModel* model = [[MyMsgVideoModel alloc] init];
                model.videoPath = videoPath;
                model.videoType = @"mp4";
                model.duration = urlAsset.duration.value/urlAsset.duration.timescale;
                model.snapshotPath = snapshotPath;
                model.snapshotType = @"kTypeSnapshot";
                model.width = scaledImage.size.width;
                model.height = scaledImage.size.height;
                
                TIMVideoElem* elem = [[TIMVideoElem alloc] init];
                TIMVideo* video = [[TIMVideo alloc] init];
                TIMSnapshot* snapshot = [[TIMSnapshot alloc] init];
                elem.video = video;
                elem.snapshot = snapshot;
                elem.videoPath = videoPath;
                elem.snapshotPath = snapshotPath;
                
                video.type = model.videoType;
                video.duration = model.duration;
                snapshot.type = model.snapshotType;
                snapshot.width = model.width;
                snapshot.height = model.height;
                
                model.elem = elem;
                
                // NSLog(@"filename = %@",[url pathComponents].lastObject);
                model.inMsg = NO;
                [self performSelectorOnMainThread:@selector(sendVideoMessage:) withObject:model waitUntilDone:NO];
            } fail:^{
                [fileManager removeItemAtPath:videoPath error:nil];
            }];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    [self releaseImagePicker];
}

#pragma mark - send message
-(void)sendTextMessage:(MyMsgTextModel*) model
{   
    TIMTextElem* elem = [[TIMTextElem alloc] init];
    elem.text = model.textMsg;
    TIMMessage* msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    
    model.elem = elem;
    model.conversation = self.conversation;
    model.msg = msg;
    model.status = msg.status;
    model.preStatus = msg.status;
    
    //发送数据
    __weak MyChatViewController *weakSelf = self;
    __weak MyMsgTextModel *weakModel = model;
    [_conversation sendMessage:msg succ:^(){
        TDDLogEvent(@"text msg send sucess:%@", elem.text);
    } fail:^(int code, NSString * err){
        TDDLogEvent(@"msg send failed. msg:%@|code:%d|err:%@", elem.text, code, err);
        weakModel.status = msg.status;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (code == 6011) {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"对方账号未登陆过喜报，请让对方登陆喜报后重试"]];
            }
            else if (code == 6014) {
                [ApplicationDelegate accountIM];
                [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"本条信息发送失败，请重新尝试"]];
            }
            else if (code == 6201) {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"网络连接失败，请等待网络恢复后重试"]];
            }
            else if (code == 6208) {
                UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"其他终端登录账户被踢，需重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] ;
                alt.tag = 101;
                [alt show];
            }
            else
            {
                [weakSelf showPrompt:ERRORCODE_TO_ERRORDEC(code)];
            }
        });
    }];
    [self appendSendMsg:model];
}


//登陆IM
-(void)loginIM
{
    TIMLoginParam * login_param = [[TIMLoginParam alloc ]init];
    
    // accountType 和 sdkAppId 通讯云管理平台分配
    // identifier为用户名，userSig 为用户登录凭证
    // appidAt3rd 在私有帐号情况下，填写与sdkAppId 一样
    login_param.accountType = IMAccountType;
    login_param.identifier = [NSString stringWithFormat:@"%@_%@",self.userdatas.userId,self.userdatas.logName];
    login_param.userSig = self.userdatas.sig;
    login_param.appidAt3rd = [NSString stringWithFormat:@"%d",IMsdkAppId];
    
    login_param.sdkAppId = IMsdkAppId;
    
    [[TIMManager sharedInstance] login: login_param succ:^(){
        [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"登陆成功！"]];
    } fail:^(int code, NSString * err) {
        if (code == 20005) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"登陆失败，服务器异常，请重试"]];
        }
        if (code == 6011) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"对方账号不存在，请重试"]];
        }
        if (code == 6014) {
            [ApplicationDelegate accountIM];
        }
        if (code == 6201) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"网络连接失败，请等待网络恢复后重试"]];
        }
        if (code == 6208) {
            //            [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"其他终端登录账户被踢，需重新登录"]];
            UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"其他终端登录账户被踢，需重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] ;
            [alt show];
        }
        NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Login Failed: %d->%@", code, err);
    }];
}


-(void)sendImageMessage:(MyMsgPicModel*)model{
    TIMImageElem* elem = [[TIMImageElem alloc] init];
    elem.path = model.picPath;
    
    if (_bIsOriPic) {
        elem.level = TIM_IMAGE_COMPRESS_ORIGIN;
    }
    else{
        elem.level = TIM_IMAGE_COMPRESS_HIGH;
    }
    
    TIMMessage* msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    model.conversation = self.conversation;
    
    model.elem = elem;
    model.msg = msg;
    model.status = msg.status;
    model.preStatus = msg.status;
    //发送数据
    __weak MyMsgPicModel *weakModel = model;
    __weak TIMMessage *weakMsg = msg;
    [_conversation sendMessage:msg succ:^(){
        TDDLogEvent(@"image msg send success");
    } fail:^(int code, NSString * err){
        TDDLogEvent(@"image msg send failed. code:%d|err:%@",code, err);
        weakModel.status = weakMsg.status;
    }];

//    [self appendSendMsg:model];
}

-(void)sendAudioMessage:(MyMsgAudioModel*)model{
    TIMSoundElem* elem = [[TIMSoundElem alloc] init];
    elem.second = (int)model.duration;
    elem.data = model.data;
    TIMMessage* msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    
    model.elem = elem;
    model.msg = msg;
    model.conversation = self.conversation;
    model.status = msg.status;
    model.preStatus = msg.status;
    
    //发送数据
    __weak MyMsgAudioModel *weakModel = model;
    [_conversation sendMessage:msg succ:^(){
        TDDLogEvent(@"sounds msg send success");
    } fail:^(int code, NSString * err){
        TDDLogEvent(@"sounds msg send failed. code:%d|err:%@",code, err);
        weakModel.status = msg.status;
    }];
    [self appendSendMsg:model];
}

-(void)sendFileMessage:(MyMsgFileModel*)model{

    TIMMessage* msg = [[TIMMessage alloc] init];
    [msg addElem:model.elem];
    
    model.msg = msg;
    model.conversation = self.conversation;
    model.status = msg.status;
    model.preStatus = msg.status;
    
    //发送数据
    __weak MyMsgFileModel *weakModel = model;
    [_conversation sendMessage:msg succ:^(){
        TDDLogEvent(@"file msg send success");
        weakModel.status = msg.status;
    } fail:^(int code, NSString * err){
        TDDLogEvent(@"file msg send failed. code:%d|err:%@",code, err);
        weakModel.status = msg.status;
    }];
    
//    [self appendSendMsg:model];
}

-(void)sendVideoMessage:(MyMsgVideoModel*)model{
    TIMMessage* msg = [[TIMMessage alloc] init];
    [msg addElem:model.elem];
    
    model.msg = msg;
    model.conversation = self.conversation;
    model.status = msg.status;
    model.preStatus = msg.status;
    
    //发送数据
    __weak MyMsgVideoModel *weakModel = model;
    [_conversation sendMessage:msg succ:^(){
        TDDLogEvent(@"file msg send success");
        TIMVideoElem *elem = (TIMVideoElem *)[msg getElem:0];
        weakModel.elem = elem;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *nsTmpDir = NSTemporaryDirectory();
        NSString *videoUUID = elem.video.uuid;
        NSString *type = elem.video.type;
        NSString *videoPath = [NSString stringWithFormat:@"%@video_%@.%@", nsTmpDir, videoUUID, type];
        [fileManager moveItemAtPath:weakModel.videoPath toPath:videoPath error:nil];
        [fileManager removeItemAtPath:weakModel.videoPath error:nil];
        weakModel.videoPath = videoPath;
        
        NSString *snapshotUUID = elem.snapshot.uuid;
        NSString *imagePath = [NSString stringWithFormat:@"%@snapshot_%@", nsTmpDir, snapshotUUID];
        [fileManager moveItemAtPath:weakModel.snapshotPath toPath:imagePath error:nil];
        [fileManager removeItemAtPath:weakModel.snapshotPath error:nil];
        weakModel.snapshotPath = imagePath;
        
    } fail:^(int code, NSString * err){
        TDDLogEvent(@"file msg send failed. code:%d|err:%@",code, err);
        weakModel.status = msg.status;
    }];
    //因为发送为视屏是异步的，发送视频之后立即返回聊天界面，getmessage无法获取到当前发送的这条微视屏消息，所以需要在这里把为视屏消息插入聊天界面
    [self appendSendMsg:model];
}

#pragma mark- MyAudioInputDeletage
- (void)sendAudioRecord:(AudioRecord *)audio{
    MyMsgAudioModel* audioModel = [[MyMsgAudioModel alloc] init];
    audioModel.data = audio.audioData;
    audioModel.duration = audio.duration;
    audioModel.isReaded = YES;
    audioModel.isPlayed = YES;
    audioModel.conversation = self.conversation;
    audioModel.sendTime = [NSDate date];
    audioModel.inMsg = NO;
    [self sendAudioMessage:audioModel];
}

#pragma mark - StatusBarStyleDelegate
- (BOOL)prefersStatusBarHidden
{
    return self.HideStatusBar;//隐藏为YES，显示为NO
}

#pragma mark- navi
- (void)rightNavButtonAction:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"确定清空聊天记录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
//    [YXSpritesLoadingView showWithText:@"删除成功" andShimmering:YES andBlurEffect:YES];
//    [self.toolbar resignFirstResponder];
//    
//    InfoPageSource source;
//    MyGroupInfoModel* infoModel;
//    if (_type == TIM_C2C) {
//        source = InfoPageSource_C2C;
//        infoModel = [[MyGroupInfoModel alloc] init];
//        infoModel.memberList = [NSMutableArray arrayWithCapacity:1];
//        infoModel.type = _type;
//        MyFriendModel* friendInfo;
//        friendInfo = [[GlobalData shareInstance] getFriendInfo:self.chatId];
//        if (friendInfo == nil) {
//            friendInfo = [[MyFriendModel alloc] init];
//            friendInfo.user = _chatId;
//            friendInfo.nickName = _chatId;
//        }
//        MyMemberModel* member = [MyMemberModel memberWithUserModel:friendInfo];
//        member.isSelected = YES;
//        [infoModel.memberList addObject:member];
//        
//    }else{
//        source = InfoPageSource_GROUP;
//        infoModel = [[GlobalData shareInstance] getGroupInfo:_chatId];
//        if (infoModel == nil) {
//            //创建一个没有成员的群结构
//            MyGroupInfoModel* infoModel = [[MyGroupInfoModel alloc] init];
//            infoModel.groupId = _chatId;
//            infoModel.groupTitle = self.title;
//        }
//        infoModel.type = _type;
//    }
//    
//    MyGroupInfoViewController* infoViewController = [[MyGroupInfoViewController alloc] initWithGroupInfo:infoModel source:source];
//    [infoViewController setMySelfIsAdmin:_isMySelfIsAdmin];
//    [self.navigationController pushViewController:infoViewController animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        if (buttonIndex==1) {
            [self loginIM];
        }
    }else{
        if (buttonIndex == 1) {
            for (int i=0; i<_dataSource.count; i++) {
                id obj = [_dataSource objectAtIndex:i];
                if (![obj isKindOfClass:[MyTimeModel class]]) {
                    MyMsgBaseModel *baseModel = obj;
                    [baseModel.msg remove];
                }
            }
            [_dataSource removeAllObjects];
            [_tableView reloadData];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:@"删除成功!"];
        }
    }
}

- (void)groupInfoChange:(NSNotification *)notify{
    id data = [notify.userInfo objectForKey:@"data"];
    if ([data isKindOfClass:[MyGroupInfoModel class]]) {
        MyGroupInfoModel* model = (MyGroupInfoModel *)data;
        if (_type ==TIM_GROUP && [model.groupId isEqualToString:_chatId]) {
            self.title = model.groupTitle;
        }
    }
}

#pragma mark - Private Methods
- (void)willSendPcikerImage:(UIImage *)image {
    MyMsgPicModel* model = [[MyMsgPicModel alloc] init];
    CGFloat scale = 1;
    scale = MIN(CELL_PIC_THUMB_MAX_H/image.size.height, CELL_PIC_THUMB_MAX_W/image.size.width);
    UIImage *thumbImage = [self thumbnailWithImage:image size:CGSizeMake(image.size.width*scale, image.size.height*scale)];
    model.data = UIImageJPEGRepresentation(thumbImage, 1);
    model.picHeight = image.size.height;
    model.picWidth = image.size.width;
    model.picThumbHeight = model.picHeight * scale;
    model.picThumbWidth = model.picWidth * scale;
    model.inMsg = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *nsTmpDIr = NSTemporaryDirectory();
    NSString *filePath = [NSString stringWithFormat:@"%@uploadFile%3.f", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate]];
    BOOL isDirectory;
    NSError *err;
    
    // 当前sdk仅支持文件路径上传图片，将图片存在本地
    if ([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        if (![fileManager removeItemAtPath:nsTmpDIr error:&err]) {
            TDDLogEvent(@"Upload Image Failed: same upload filename: %@", err);
            return;
        }
    }
    if (![fileManager createFileAtPath:filePath contents:UIImageJPEGRepresentation(image, 0.75) attributes:nil]) {
        TDDLogEvent(@"Upload Image Failed: fail to create uploadfile: %@", err);
        return;
    }
    model.picPath = filePath;
    [self sendImageMessage:model];
}

- (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

#pragma mark- ImageViewControllerDelegate
- (void)sendImageAction:(UIImage*)image isSendOriPic:(BOOL)bIsOriPic{
    _bIsOriPic = bIsOriPic;
    [self willSendPcikerImage:image];
}

- (void)releasePicker{
    [self releaseImagePicker];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Convert Video Format, Change Image Scale
- (void)convertToMP4:(AVURLAsset*)avAsset videoPath:(NSString*)videoPath succ:(void (^)())succ fail:(void (^)())fail {
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality])
        
    {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        
        exportSession.outputURL = [NSURL fileURLWithPath:videoPath];
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        CMTime start = CMTimeMakeWithSeconds(0, avAsset.duration.timescale);
        
        CMTime duration = avAsset.duration;
        
        CMTimeRange range = CMTimeRangeMake(start, duration);
        
        exportSession.timeRange = range;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                    fail();
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    fail();
                    break;
                default:
                    succ();
                    break;
            }
        }];
    }
}


@end
