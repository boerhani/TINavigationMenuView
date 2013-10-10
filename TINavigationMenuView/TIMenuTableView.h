//
//  TIMenuView.h
//
//  Created by ishtar on 13. 10. 8..
//  Copyright (c) 2013년 Coupang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TIMenuDelegate.h"

@class TIMenuCell;

@interface TIMenuTableView : UIScrollView
{
    NSMutableArray *_currentButtons;
    NSMutableArray *_historyData;
    
    NSArray *_menuData;
    
    TIMenuCell *_currentMenuButton;
    
    float _offsetY;
}

@property (nonatomic, assign, readwrite, setter = setMenuDelegate:) id <TIMenuDelegate> menuDataDelegate;
@property (nonatomic, assign, readwrite) BOOL cascadingTitleMargin;

- (id)initWithFrame:(CGRect)frame withMenuData:(NSArray *)menuData;

@end