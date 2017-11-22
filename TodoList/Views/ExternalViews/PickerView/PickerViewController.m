//
//  PickerViewController.m
//  YourDrs
//
//  Created by Naga on 20/06/17.
//  Copyright © 2017 Naga. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerBottomConstraint;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) void(^doneHandler)(NSInteger selectedRow);
@property (nonatomic, assign) NSInteger selectedRow;

@end

@implementation PickerViewController

- (id)init
{
    if (self = [super init]) {
        self = [[PickerViewController alloc]initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle bundleForClass:[self class]]];
    }
    return self;
}

- (id)initWithData:(NSArray *)data
{
    if (self = [self init]) {
        self.data = data;
    }
    return self;
}

- (id)initWithData:(NSArray *)data selectedIndex:(NSInteger)selectedIndex
{
    if (self = [self init]) {
        self.data = data;
        if (selectedIndex <= 0) {
            selectedIndex = 0;
        }
        
        self.selectedRow = selectedIndex;
    }
    return self;
}

- (void)showPickerFromController:(UIViewController *)controller doneHandler:(void (^)(NSInteger selectedRow))doneHandler
{
    [controller.view endEditing:YES];
    [controller addChildViewController:self];
    self.view.frame = controller.view.bounds;
    [controller.view addSubview:self.view];
    
    if (self.data.count == 0) {
        self.doneButton.enabled = false;
    }
    
    self.doneHandler = doneHandler;
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.overlayView.alpha = 0.5;
        self.pickerBottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    [self.pickerView selectRow:self.selectedRow inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDoneTapped:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.overlayView.alpha = 0.0;
        self.pickerBottomConstraint.constant = 0 - self.pickerView.frame.size.height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        self.doneHandler(self.selectedRow);
    }];
    
}

- (IBAction)onCancelTapped:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.overlayView.alpha = 0.0;
        self.pickerBottomConstraint.constant = 0 - self.pickerView.frame.size.height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedRow = row;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    // create attributed string
    NSString *title = [self.data objectAtIndex:row];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}];
    
    // add the string to a label's attributedText property
    UILabel *labelView = [[UILabel alloc] init];
    labelView.attributedText = attributedTitle;
    labelView.textAlignment = NSTextAlignmentCenter;
    
    // return the label
    return labelView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.data count];;
}

@end
