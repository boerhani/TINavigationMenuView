//
//  TIMenuCell.h
//
//  Created by ishtar on 13. 10. 8..
//  Copyright (c) 2013년 Coupang. All rights reserved.
//

#ifndef timenu_define_header
#define timenu_define_header

typedef NS_ENUM(NSUInteger, TIButtonType)  {
    TIButtonTypeNormal      = 0,
    TIButtonTypeLabel       = 1,
    TIButtonTypeBack        = 2,
    TIButtonTypeHistory     = 3,
    
    // Icon Option
    TIButtonIconLeft        = 8 << 0,
    TIButtonIconRight       = 8 << 1,
    
    // Text Alignment
    TIButtonTextLeftAlign   = 8 << 2,
    TIButtonTextCenterAlign = 8 << 3,
    TIButtonTextRightAlign  = 8 << 4
};

#endif

@interface TIMenuCell : UIButton
{
}

@property (nonatomic, assign, readwrite, setter = setCellButtonType:) TIButtonType menuType;
@property (nonatomic, assign, readwrite, setter = setContentPadding:) CGPoint contentPaddings;
@property (nonatomic, strong, readonly) NSDictionary *menuData;
@property (nonatomic, strong, readonly) NSString *imageName;

@property (nonatomic, assign, readonly) int menuDepth;
@property (nonatomic, assign, readonly) CGSize menuSize;

@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UILabel *cellTitle;
@property (nonatomic, strong, readonly) UILabel *subCellTitle;

- (id)initWithData:(NSDictionary *)data withSize:(CGSize)size withDepth:(int)depth withType:(TIButtonType)type;

- (void)updateSubviews;

@end
