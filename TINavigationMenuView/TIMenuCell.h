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
    CGPoint _contentPadding;
}

@property (nonatomic, assign, readwrite, setter = setCellButtonType:) TIButtonType menuType;
@property (nonatomic, strong, readonly) NSDictionary *menuData;
@property (nonatomic, strong, readonly) NSString *imageName;

@property (nonatomic, assign, readonly) int menuDepth;
@property (nonatomic, assign, readonly) CGFloat menuHeight, menuWidth;

@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UILabel *cellTitle;
@property (nonatomic, strong, readonly) UILabel *subCellTitle;

- (id)initWithData:(NSDictionary *)menuData currentDepth:(int)menuDepth isCascadingTitle:(BOOL)isCascading cellHeight:(CGFloat)cellHeight
          menuType:(TIButtonType)buttonType contentPadding:(CGPoint)padding cellWidth:(CGFloat)cellWidth;

- (void)updateSubViews;

@end
