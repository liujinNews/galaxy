//
//  MeetingRoomCell.m
//  galaxy
//
//  Created by hfk on 2017/12/22.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "MeetingRoomCell.h"
@implementation MeetingRoomCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=Color_form_TextFieldBackgroundColor;
        self.selectionStyle=UITableViewCellAccessoryNone;
        [self createView];
    }
    return self;
}

-(void)createView{
    if (!_lab_Name) {
        _lab_Name=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_Name];
    }
    
    if (!_lab_Capacity) {
        _lab_Capacity=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_Capacity];
    }
    if (!_img_Equipment) {
        _img_Equipment=[GPUtils createImageViewFrame:CGRectZero imageName:@"Meeting_Room_Eq"];
        [self.contentView addSubview:_img_Equipment];
    }
    if (!_lab_Equipment) {
        _lab_Equipment=[GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_Equipment.numberOfLines=0;
        [self.contentView addSubview:_lab_Equipment];
    }
    
    if (!_img_Location) {
        _img_Location=[GPUtils createImageViewFrame:CGRectZero imageName:@"Meeting_Room_Loction"];
        [self.contentView addSubview:_img_Location];
    }
    if (!_lab_Location) {
        _lab_Location=[GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_Location];
    }
    
    if (!_view_MeetingDuringView) {
        _view_MeetingDuringView=[[MeetingDuringView alloc]initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        [self.contentView addSubview:_view_MeetingDuringView];
    }
    
    [_lab_Name makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(@10);
        make.left.equalTo(self.contentView.left).offset(@12);
        make.right.equalTo(self.contentView.right).offset(@(-80));
        make.height.equalTo(@25);
    }];
    
    [_lab_Capacity makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(@10);
        make.left.equalTo(self.lab_Name.right);
        make.right.equalTo(self.contentView.right).offset(@(-12));
        make.height.equalTo(@25);
    }];
    
    [_img_Equipment makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(@45);
        make.left.equalTo(self.contentView.left).offset(@12);
        make.width.equalTo(@12);
        make.height.equalTo(@12);
    }];
    
    [_lab_Equipment makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(@42);
        make.left.equalTo(self.contentView.left).offset(@35);
        make.right.equalTo(self.contentView.right).offset(@(-12));
        make.height.equalTo(@0);
    }];
    
    
    [_img_Location makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Equipment.bottom).offset(@10);
        make.left.equalTo(self.contentView.left).offset(@12);
        make.width.equalTo(@12);
        make.height.equalTo(@12);
    }];
    
    [_lab_Location makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Equipment.bottom).offset(@6);
        make.left.equalTo(self.contentView.left).offset(@35);
        make.right.equalTo(self.contentView.right).offset(@(-12));
        make.height.equalTo(@18);
    }];
    
    [_view_MeetingDuringView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Location.bottom).offset(@10);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];

}

-(void)configCellWithData:(MeetingRoomModel *)model{
    
    self.lab_Name.text=model.name;
    self.lab_Capacity.text=[NSString stringWithFormat:@"%@%@",model.capacity,Custing(@"人", nil)];
    
    CGSize size1 = [model.equipment sizeCalculateWithFont:Font_Same_14_20 constrainedToSize:CGSizeMake(Main_Screen_Width-35-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    NSInteger height=0;
    if (size1.height>18) {
        height=size1.height;
    }else{
        height=18;
    }
    [_lab_Equipment updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    _lab_Equipment.text=model.equipment;
    [_lab_Equipment sizeToFit];

    _lab_Location.text=model.location;
    [_lab_Location sizeToFit];

    if (model.meetingBookings.count>0) {
        NSInteger row =ceilf((float)(model.meetingBookings.count)/3);
        [_view_MeetingDuringView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(30+26*row));
        }];
        [_view_MeetingDuringView configMeetingDuringViewData:model.meetingBookings WithType:1];
    }else{
        [_view_MeetingDuringView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[MeetingRoomModel class]]) {
        MeetingRoomModel *task = (MeetingRoomModel *)obj;
        cellHeight += 78;
        CGSize size1 = [task.equipment sizeCalculateWithFont:Font_Same_14_20 constrainedToSize:CGSizeMake(Main_Screen_Width-35-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if (size1.height>18) {
            cellHeight += size1.height;
        }else{
            cellHeight += 18;
        }
        NSInteger row =ceilf((float)(task.meetingBookings.count)/3);
        if (row>0) {
            cellHeight += (35+26*row);
        }
    }
    return cellHeight;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
