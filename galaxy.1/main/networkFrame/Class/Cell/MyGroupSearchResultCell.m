//
//  MyGroupSearchResultCell.m
//  MyDemo
//
//  Created by tomzhu on 15/6/15.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "MyGroupSearchResultCell.h"
#import "MyUserModel.h"
#import "MyGroupInfoModel.h"
#import "UIViewAdditions.h"

#define ADD_BTN_WIDTH 60.0f
#define ADD_BTN_HEIGHT 20.0f

@interface MyGroupSearchResultCell() {
}
@property (nonatomic, strong)TIMGroupInfo* groupInfo;
@end

@implementation MyGroupSearchResultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //        self.contentView.backgroundColor = RGBACOLOR(0xf7, 0xf7, 0xf1, 1.0f);
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CONTACT_CELL_H)];
        [self.contentView addSubview:_bgView];
        
        //设置表格单元样式
        UIImage *headerImage = [UIImage imageNamed:@"contacts_nav_group"];
        _headerFaceView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (CONTACT_CELL_H-headerImage.size.height)/2,
                                                                        headerImage.size.width, headerImage.size.height)];
        _headerFaceView.image = headerImage;
        [self.contentView addSubview:_headerFaceView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerFaceView.frame.origin.x + _headerFaceView.frame.size.width+10, 10, 200, 20)];
        _nameLabel.font = [UIFont boldSystemFontOfSize:12];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.numberOfLines = 0;
        _nameLabel.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_nameLabel];
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //        btn.backgroundColor = [UIColor redColor];
        btn.frame = CGRectMake(_bgView.ttwidth-ADD_BTN_WIDTH-15, _bgView.ttheight-ADD_BTN_HEIGHT-6, ADD_BTN_WIDTH, ADD_BTN_HEIGHT);
        [btn setTitle:@"加入" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btn addTarget:self action:@selector(JoinBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:btn];
        
    }
    return self;
}

- (void)JoinBtnAction:(id)sender{
    if (self.addBtnAction) {
        self.addBtnAction(self.groupInfo);
    }
}

- (void)updateModel:(TIMGroupInfo *)model{
    self.groupInfo = model;
    
    NSString *groupName = self.groupInfo.groupName;
    NSString *groupID = self.groupInfo.group;
    NSString *groupInfo = [[NSString alloc] initWithFormat:@"%@(%@)",groupName,groupID];
    _nameLabel.text = NSLocalizedString(groupInfo, @"");
}

@end
