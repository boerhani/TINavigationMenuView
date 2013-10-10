//
//  CPNavigationMenuViewDelegate.h
//
//  Created by ishtar on 13. 10. 8..
//  Copyright (c) 2013년 Coupang. All rights reserved.
//

#ifndef project_TIMenuViewDelegate_h
#define project_TIMenuViewDelegate_h

#import "TIMenuCell.h"

@class TIMenuTableView;

@protocol TIMenuDelegate <NSObject>

@required
- (void)didSelectCell:(TIMenuCell *)selectedCell hasChild:(BOOL)hasChildMenu;

- (TIMenuCell *)menuCellForData:(NSDictionary *)menuData;

- (NSArray *)childMenuForData:(NSDictionary *)menuData;

@optional
// Redesign your back button
- (TIMenuCell *)applyRootButtonTheme:(TIMenuCell *)passedRootButton;

@end

#endif
