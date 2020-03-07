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
#import "MyGroupInfoItemsCell.h"
#import "MyGroupInfoModel.h"
#import "MyChatInfoItemModel.h"
#import "UIViewAdditions.h"
#import "MyCommOperation.h"
#import "MyGroupInfoViewController.h"
#import "GlobalData.h"


@interface MyGroupInfoItemsCell()

@property (nonatomic, strong)MyChatInfoItemModel* model;
@property (nonatomic, strong)UILabel* itemNameView;
@property (nonatomic, strong)UILabel* itemContentView;
@end

@implementation MyGroupInfoItemsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reusedId
{
    if (self = [super initWithStyle:style reuseIdentifier:reusedId]) {
        self.contentView.frame = self.bounds;
        self.contentView.userInteractionEnabled = YES;
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell:)];
        [self addGestureRecognizer:tap];
    }
    return  self;
}

- (UILabel *)itemNameView{
    if (_itemNameView == nil) {
        _itemNameView = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, self.contentView.ttheight)];
        _itemNameView.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_itemNameView];
        
    }
    return _itemNameView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(8, self.contentView.ttheight-2, self.contentView.ttwidth-16, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    self.itemContentView.frame = CGRectMake(self.contentView.ttright-200-10, 0, 200, self.contentView.ttheight);
}

-(UILabel*)itemContentView{
    if (_itemContentView == nil) {
        _itemContentView = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.ttright-200-10, 0, 200, self.contentView.ttheight)];
        _itemContentView.textAlignment = NSTextAlignmentRight;
        _itemContentView.textColor = [UIColor grayColor];
        [self.contentView addSubview:_itemContentView];
    }
    return _itemContentView;
}

#pragma mark - Interface

- (void)setContent:(MyChatInfoItemModel *)model{
    self.model = model;
    switch (model.type) {
        case GroupInfoItemType_Id:
        case GroupInfoItemType_Title:
        case GroupInfoItemType_Owner:
        case GroupInfoItemType_Introduction:
        case GroupInfoItemType_Notification:
        case GroupInfoItemType_MemberNum:
        case GroupInfoItemType_Namecard:
            self.itemNameView.text = model.infoTitle;
            self.itemContentView.text = model.infoContent;
            
            break;
        default:
            break;
    }
}

#pragma mark - Event Response<UITapGestureRecognizer>

- (void)tapCell:(id)sender{
    if (![self.model.dataModel isKindOfClass:[MyGroupInfoModel class]] || !self.isAcessForChange) {
        return;
    }
    if (self.model.type == GroupInfoItemType_Namecard) {
        UIResponder* responder = self;
        while (responder) {
            responder = responder.nextResponder;
            if ([responder isKindOfClass:[MyGroupInfoViewController class]]) {
                [((MyGroupInfoViewController*)responder) changeGroupNamecard];
            }
        }
    }
    if (self.model.type == GroupInfoItemType_Title) {
        UIResponder* responder = self;
        while (responder) {
            responder = responder.nextResponder;
            if ([responder isKindOfClass:[MyGroupInfoViewController class]]) {
                [((MyGroupInfoViewController*)responder) changeGroupTitle];
            }
        }
    }
    if (self.model.type == GroupInfoItemType_Introduction) {
        UIResponder* responder = self;
        while (responder) {
            responder = responder.nextResponder;
            if ([responder isKindOfClass:[MyGroupInfoViewController class]]) {
                [((MyGroupInfoViewController*)responder) changeGroupIntroduction];
            }
        }
    }
    if (self.model.type == GroupInfoItemType_Notification) {
        UIResponder* responder = self;
        while (responder) {
            responder = responder.nextResponder;
            if ([responder isKindOfClass:[MyGroupInfoViewController class]]) {
                [((MyGroupInfoViewController*)responder) changeGroupNotification];
            }
        }
    }
}

@end
