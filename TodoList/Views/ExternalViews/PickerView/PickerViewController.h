//
//  PickerViewController.h
//  YourDrs
//
//  Created by Naga on 20/06/17.
//  Copyright © 2017 Naga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerViewController : UIViewController

- (id)initWithData:(NSArray *)data;
- (id)initWithData:(NSArray *)data selectedIndex:(NSInteger)selectedIndex;

- (void)showPickerFromController:(UIViewController *)controller doneHandler:(void (^)(NSInteger selectedRow))doneHandler;

@end
