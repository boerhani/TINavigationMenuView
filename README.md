TINavigationMenuView
====================

Vertical breadcrumb navigation menu view

<a href="http://www.youtube.com/watch?v=kjajicq1vc8
" target="_blank"><img src="http://img.youtube.com/vi/kjajicq1vc8/0.jpg" 
alt="TINavigationMenuView" width="240" height="180" border="1" /></a>


USAGE
------

1. Add below files to your project
```obj-c
TIMenuCell.h
TIMenuCell.m
TIMenuDelegate.h
TIMenuTableView.h
```

2. Set delegate on your view or view controller and assign its delegate
```obj-c
#import "TIMenuDelegate.h"
@interface TISimpleMenuController : UIViewController <TIMenuDelegate>
{
}
@end
```

3. Customize your menu design and data
```obj-c
- (void)didSelectCell:(TIMenuCell *)selectedCell hasChild:(BOOL)hasChildMenu;
- (TIMenuCell *)menuCellForData:(NSDictionary *)menuData;
- (NSArray *)childMenuForData:(NSDictionary *)menuData;
- (TIMenuCell *)applyRootButtonTheme:(TIMenuCell *)passedRootButton;
```

4. For more samples, see Demo view controller
