//
//  MyGroupSystemNotifyCell.m
//  MyDemo
//
//  Created by tomzhu on 15/7/11.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "MyGroupSystemNotifyCell.h"
#import "MySystemNotifyModel.h"
#import "MyGroupInfoModel.h"
#import "GlobalData.h"
#import "NSStringEx.h"
#import "ConstDefine.h"

@interface MyGroupSystemNotifyCell(){
    UILabel *_nameLabel;
    UILabel *_notifyLabel;
    UIImageView *_headerFaceView;
    UIView *_bgView;
    UIButton *_acceptBtn;
}
@property (nonatomic, strong)MySystemNotifyModel *model;
@end

@implementation MyGroupSystemNotifyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:RGBACOLOR(0xf7, 0xf7, 0xf1, 1.0f)];
        self.contentView.backgroundColor = RGBACOLOR(0xf7, 0xf7, 0xf1, 1.0f);
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
        
        _notifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerFaceView.frame.origin.x + _headerFaceView.frame.size.width+10, 30, 200, 20)];
        _notifyLabel.font = [UIFont boldSystemFontOfSize:12];
        _notifyLabel.textColor = [UIColor blackColor];
        _notifyLabel.backgroundColor = [UIColor clearColor];
        _notifyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _notifyLabel.numberOfLines = 0;
        _notifyLabel.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_notifyLabel];
        
        _acceptBtn = [[UIButton alloc] init];
        _acceptBtn.bounds = CGRectMake(0, 0, 80, 30);
        _acceptBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_acceptBtn setTitle:@"允许入组" forState:UIControlStateNormal];
        [_acceptBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_acceptBtn addTarget:self action:@selector(acceptBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.accessoryView = _acceptBtn;
        
        [self setSelected:NO];
    }
    
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateModel:(MySystemNotifyModel *)model {
    if (!model) {
        return;
    }
    self.model = model;
    TIMGroupSystemElem *elem = (TIMGroupSystemElem *) model.elem;
    NSString *grouTitle = [[GlobalData shareInstance] getGroupInfo:elem.group].groupTitle;
    _nameLabel.text = model.user;
    _notifyLabel.text = [NSString stringWithFormat:@"申请加入:%@", grouTitle];
    if (model.notifyType == GroupSystemNotifyType_JoinGroupReq) {
        _acceptBtn.enabled = YES;
    }
}

- (void)acceptBtnClick:(id)sender {
    self.acceptBtnAction(self.model);
}

@end
