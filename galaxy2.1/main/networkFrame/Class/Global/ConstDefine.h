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

#ifndef MyDemo_ConstDefine_h
#define MyDemo_ConstDefine_h

typedef NS_ENUM(NSInteger, MyUITag){
    MyTagSwitchNotice = 1001,     //设置-通知开关
    MyTagSwitchSound,
    MyTagSwitchShake,
    MyTagSwitchEnvironment,
    MyTagSwitchConsoleLog,
    MyTagChatToolbarKeyboard,
    MyTagChatToolbarVoice,
    MyTagChatToolbarEmoj,
    MyTagChatToolbarMore,
    MyTagChatToolbarSend,
    MyTagChatToolbarMorePhoto,
    MyTagChatToolbarMoreCamera,
    MyTagChatToolbarMoreFile,
    MyTagChatToolbarMoreVideo,
};


typedef enum{
    ChatFromContacts,
    ChatFromRecent,
    ChatFromGroupList,
}ChatFrom;


#define NOREG_STRING @"#"

#define kMyNotificationFreindListChange   @"MyNotificationFreindListChange"
#define kMyNotificationPlayAudio          @"MyNotificationPlayAudio"
#define kMyNotificationGroupInfoChange     @"MyNotificationGroupInfoChange"
#define kMyNotificationReqFriendListResp  @"MyNotificationReqFriendListResp"
#define kMyNotificationReqBlackListResp  @"MyNotificationReqBlackListResp"
#define kMyNotificationReqGroupListResp   @"MyNotificationReqGroupListResp"
#define kMyNotificationSystemNofityListResp    @"MyNotificationSystemNofityListResp"
#define kMyNotificationGroupApplyListChange   @"MyNotificationGroupApplyListChange"
#define kMyNotificationFriendApplyListChange    @"MyNotificationFriendApplyListChange"
#define kMyNotificationSystemNofityListChange    @"MyNotificationSystemNofityListChange"
#define kMyNotificationReccentListViewUpdate    @"MyNotificationReccentListViewUpdate"
#define kMyNotificationChatViewMessageUpdate    @"MyNotificationChatViewMessageUpdate"
#define kMyNotificationImageViewDisplayChange   @"MyNotificationImageViewDisplayChange"

#define MAX_CHATMSG_ORGIN_LOAD  10
#define MAX_SNSSYSTEM_ORGIN_LOAD  50

#define MAX_ACCOUNT_NAME_LEN  30
#define MAX_ACCOUNT_PWD_LEN  30
#define MAX_ACCOUNT_GROUP_TITLE_LEN  30

#define MAX_GROUP_INFO_CONTENT_LEN  30

#define MAX_GROUP_INTRODUCTION_LEN 120
#define MAX_GROUP_NOTICE_LEN 150
#define MAX_GROUP_NAME_LEN 30

#define DING_HAO_ERR    6208

//key define
#define kNoticeSwitch @"NoticeSwitch"

#define kC2CSoundSwitch  @"C2CSoundSwitch"
#define kC2CShakeSwitch  @"C2CShakeSwitch"

#define kGroupSoundSwitch  @"GroupSoundSwitch"
#define kGroupShakeSwitch  @"GroupShakeSwitch"

#define kLyncSoundSwitch  @"LyncSoundSwitch"
#define kLyncShakeSwitch  @"LyncShakeSwitch"

#define kEnvironmentSwitch  @"EnvironmentSwitch"
#define kConsoleLogSwitch  @"ConsoleLogSwitch"
#define kLogLevel  @"LogLevel"

#define kNickMaxBytesLength 64

#define kEachKickErrorCode 6208  //互踢下线错误码

#define kVerifyMessageMaxBytesLength 120 //添加好友时验证信息的最大长度

#endif
