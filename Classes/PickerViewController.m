/** Cycle Philly, 2013 Code For Philly
 *                                    Philadelphia, PA. USA
 *
 *
 *   Contact: Corey Acri <acri.corey@gmail.com>
 *            Lloyd Emelle <lemelle@codeforamerica.org>
 *
 *   Updated/Modified for Philadelphia's app deployment. Based on the
 *   Cycle Atlanta and CycleTracks codebase for SFCTA.
 *
 * Cycle Atlanta, Copyright 2012, 2013 Georgia Institute of Technology
 *                                    Atlanta, GA. USA
 *
 *   @author Christopher Le Dantec <ledantec@gatech.edu>
 *   @author Anhong Guo <guoanhong@gatech.edu>
 *
 *   Updated/Modified for Atlanta's app deployment. Based on the
 *   CycleTracks codebase for SFCTA.
 *
 ** CycleTracks, Copyright 2009,2010 San Francisco County Transportation Authority
 *                                    San Francisco, CA, USA
 *
 *   @author Matt Paul <mattpaul@mopimp.com>
 *
 *   This file is part of CycleTracks.
 *
 *   CycleTracks is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   CycleTracks is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with CycleTracks.  If not, see <http://www.gnu.org/licenses/>.
 */

//
//	PickerViewController.m
//	CycleTracks
//
//  Copyright 2009-2010 SFCTA. All rights reserved.
//  Written by Matt Paul <mattpaul@mopimp.com> on 9/28/09.
//	For more information on the project, 
//	e-mail Billy Charlton at the SFCTA <billy.charlton@sfcta.org>


#import "CustomView.h"
#import "PickerViewController.h"
#import "DetailViewController.h"

//#import "TripDetailViewController.h"
#import "TookTransitViewController.h"

#import "TripManager.h"
#import "NoteManager.h"
#import "RecordTripViewController.h"


@implementation PickerViewController

@synthesize customPickerView, customPickerDataSource, delegate, description, tookPublicTransitLabel, tookPublicTransitSwitch,
detailTextView, additionalDetails, doneButton, answerYesNo, descriptionText, cancelButton;


// return the picker frame based on its size
- (CGRect)pickerFrameWithSize:(CGSize)size
{
	
	// layout at bottom of page
	/*
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect pickerRect = CGRectMake(	0.0,
									screenRect.size.height - 84.0 - size.height,
									size.width,
									size.height);
	 */
	
	// layout at top of page
	//CGRect pickerRect = CGRectMake(	0.0, 0.0, size.width, size.height );	
	
	// layout at top of page, leaving room for translucent nav bar
	//CGRect pickerRect = CGRectMake(	0.0, 43.0, size.width, size.height );
	
	CGRect pickerRect = CGRectMake(	0.0, 78.0, size.width, 2*size.height/3 );
	return pickerRect;
}


- (void)createCustomPicker
{
	customPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
	customPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	// setup the data source and delegate for this picker
	customPickerDataSource = [[CustomPickerDataSource alloc] init];
	customPickerDataSource.parent = self;
	customPickerView.dataSource = customPickerDataSource;
	customPickerView.delegate = customPickerDataSource;
	
	// note we are using CGRectZero for the dimensions of our picker view,
	// this is because picker views have a built in optimum size,
	// you just need to set the correct origin in your view.
	//
	// position the picker at the bottom
	CGSize pickerSize = [customPickerView sizeThatFits:CGSizeZero];
	customPickerView.frame = [self pickerFrameWithSize:pickerSize];
	
	customPickerView.showsSelectionIndicator = YES;
	
	// add this picker to our view controller, initially hidden
	//customPickerView.hidden = YES;
    [self.view insertSubview:customPickerView belowSubview:detailTextView];
}


- (IBAction)cancel:(id)sender
//add value to be sent in
{
    pickerCategory = [[NSUserDefaults standardUserDefaults] integerForKey:@"pickerCategory"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey: @"pickerCategory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(pickerCategory == 3) {
        [delegate didCancelNote];
    }
    else if(pickerCategory == 0) {
        [delegate didCancelTrip];
    }
}


- (IBAction)save:(id)sender
{
    pickerCategory = [[NSUserDefaults standardUserDefaults] integerForKey:@"pickerCategory"];
    
    if (pickerCategory == 0) {
        //New Save Code
        
        //Trip Purpose
        NSLog(@"Purpose Save button pressed");
        long row = [customPickerView selectedRowInComponent:0];
        [delegate didPickPurpose:row];
        
        //Took Public Transit
        if (self.tookPublicTransitSwitch.on) {
            NSLog(@"Noted took transit in TookTransitViewController");
            [delegate didTakeTransit];
        }
        
        //Additional Details
        NSString *details;
        
        NSLog(@"Save Detail");
        [detailTextView resignFirstResponder];
        [delegate didSaveTrip];
        
        pickerCategory = [[NSUserDefaults standardUserDefaults] integerForKey:@"pickerCategory"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey: @"pickerCategory"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        details = detailTextView.text;
        
        [delegate didEnterTripDetails:details];
        [delegate saveTrip];
        
    }
    else if (pickerCategory == 1){
        NSLog(@"Issue Save button pressed");
        NSLog(@"detail");
        NSLog(@"INIT + PUSH");
        //[self dismissModalViewControllerAnimated:YES];
        
        DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
        detailViewController.delegate = self.delegate;
        
        [self presentModalViewController:detailViewController animated:YES];
        NSLog(@"pickedNotedType is %ld", (long)pickedNotedType);
    }
    else if (pickerCategory == 2){
        NSLog(@"Asset Save button pressed");
        NSLog(@"detail");
        NSLog(@"INIT + PUSH");
        
        DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
        detailViewController.delegate = self.delegate;
        
        [self presentModalViewController:detailViewController animated:YES];
        //do something here: get index for later use.
        NSInteger row = [customPickerView selectedRowInComponent:0];
        
        pickedNotedType = [[NSUserDefaults standardUserDefaults] integerForKey:@"pickedNotedType"];
        
        [[NSUserDefaults standardUserDefaults] setInteger:row+6 forKey: @"pickedNotedType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        pickedNotedType = [[NSUserDefaults standardUserDefaults] integerForKey:@"pickedNotedType"];
        
        NSLog(@"pickedNotedType is %ld", (long)pickedNotedType);
        
    }
    else if (pickerCategory == 3){
        NSLog(@"Note This Save button pressed");
        NSLog(@"detail");
        NSLog(@"INIT + PUSH");
        
        DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
        detailViewController.delegate = self.delegate;
        
        [self presentModalViewController:detailViewController animated:YES];
        
        
        //Note: get index of type
        NSInteger row = [customPickerView selectedRowInComponent:0];
        
        NSNumber *tempType = 0;
        
        if(row == 0) {
            //Pavement Issue
            tempType = @0;
        }
        else if(row == 1) {
            //Trafic signal issue
            tempType = @1;
        }
        else if(row == 2) {
            //Bike lane issue
            tempType = @4;
        }
        else if(row == 3) {
            //Crash / Near miss
            tempType = @12;
        }
        else if(row == 4) {
            //Note this issue
            tempType = @5;
        }
        
        NSLog(@"tempType: %d", [tempType intValue]);
        
        [delegate didPickNoteType:tempType];
    }	
}


- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
	NSLog(@"initWithNibNamed");
	if (self = [super initWithNibName:nibName bundle:nibBundle])
	{
		//NSLog(@"PickerViewController init");		
		[self createCustomPicker];
        
		pickerCategory = [[NSUserDefaults standardUserDefaults] integerForKey:@"pickerCategory"];
        if (pickerCategory == 0) {
            // picker defaults to top-most item => update the description
            [self pickerView:customPickerView didSelectRow:0 inComponent:0];
        }
        else if (pickerCategory == 3){
            // picker defaults to top-most item => update the description
            [self pickerView:customPickerView didSelectRow:6 inComponent:0];
        }
        
		
	}
	return self;
}


- (id)initWithPurpose:(NSInteger)index
{
	if (self = [self init])
	{
		//NSLog(@"PickerViewController initWithPurpose: %d", index);
		
		// update the picker
		[customPickerView selectRow:index inComponent:0 animated:YES];
		
		pickerCategory = [[NSUserDefaults standardUserDefaults] integerForKey:@"pickerCategory"];
        if (pickerCategory == 0) {
            // picker defaults to top-most item => update the description
            [self pickerView:customPickerView didSelectRow:0 inComponent:0];
        }
        else if (pickerCategory == 3){
            // picker defaults to top-most item => update the description
            [self pickerView:customPickerView didSelectRow:6 inComponent:0];
        }
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (pickerCategory == 0) {
        [cancelButton setTitle:@"Discard"];
    }
    else {
        [cancelButton setTitle:@"Cancel"];
    }
    
    if (pickerCategory == 3) {
        description.text = kIssueDescPavementIssue;
        description.hidden = NO;
    }
}

- (void)viewDidLoad
{
    pickerCategory = [[NSUserDefaults standardUserDefaults] integerForKey:@"pickerCategory"];
    
    if (pickerCategory == 0) {
        navBarItself.topItem.title = @"Trip Purpose";
        self.descriptionText.text = @"Please select your trip purpose & tap Save";
        [self.navigationItem.leftBarButtonItem setTitle:@"Discard"];
        detailTextView.text = @"";
//        detailTextView.text = @"Test Post -- Please Delete";
    }
    else if (pickerCategory == 1){
        navBarItself.topItem.title = @"Boo this...";
        self.descriptionText.text = @"Please select the issue type & tap Save";
    }
    else if (pickerCategory == 2){
        navBarItself.topItem.title = @"This is rad!";
        self.descriptionText.text = @"Please select the asset type & tap Save";
    }
    else if (pickerCategory == 3){
        navBarItself.topItem.title = @"Note This";
        self.descriptionText.text = @"Please select the type & tap Save";
        [self.customPickerView selectRow:6 inComponent:0 animated:NO];
        if ([self.customPickerView selectedRowInComponent:0] == 6) {
            navBarItself.topItem.rightBarButtonItem.enabled = NO;
        }
        else{
            navBarItself.topItem.rightBarButtonItem.enabled = YES;
        }
    }

	[super viewDidLoad];
    
	

	//self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	// self.view.backgroundColor = [[UIColor alloc] initWithRed:40. green:42. blue:57. alpha:1. ];

	// Set up the buttons.
	/*
	UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
															  target:self action:@selector(done)];
	done.enabled = YES;
	self.navigationItem.rightBarButtonItem = done;
	 */
	//[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	//description = [[UITextView alloc] initWithFrame:CGRectMake( 18.0, 280.0, 284.0, 130.0 )];
	description = [[UITextView alloc] initWithFrame:CGRectMake( 18.0, 280.0, 284.0, 200.0 )];
	description.editable = NO;
    description.scrollEnabled = false;
    description.backgroundColor = [UIColor clearColor];
    description.textColor = [UIColor whiteColor];
    
	description.font = [UIFont fontWithName:@"Arial" size:16];
	[self.view addSubview:description];
    
    //Addtions for single view
    detailTextView.delegate = self;
    detailTextView.returnKeyType = UIReturnKeyDefault;
    detailTextView.enablesReturnKeyAutomatically = NO;
    [doneButton setHidden:YES];
    [doneButton setEnabled:NO];
    
    if(pickerCategory == 0) {
        [self showViewsForTripDetails];
    }
    else if(pickerCategory == 3) {
        [self hideViewsForNotes];
    }
}

- (void)showViewsForTripDetails {
    tookPublicTransitLabel.hidden = NO;
    tookPublicTransitSwitch.hidden = NO;
    answerYesNo.hidden = NO;
    additionalDetails.hidden = NO;
    detailTextView.hidden = NO;
}

- (void)hideViewsForNotes {
    tookPublicTransitLabel.hidden = YES;
    tookPublicTransitSwitch.hidden = YES;
    answerYesNo.hidden = YES;
    additionalDetails.hidden = YES;
    detailTextView.hidden = YES;
}

// called after the view controller's view is released and set to nil.
// For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
// So release any properties that are loaded in viewDidLoad or can be recreated lazily.
//

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark UIPickerViewDelegate


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerCategory == 3){
        if ([self.customPickerView selectedRowInComponent:0] == 6) {
            navBarItself.topItem.rightBarButtonItem.enabled = NO;
        }
        else{
            navBarItself.topItem.rightBarButtonItem.enabled = YES;
        }
    }
	//NSLog(@"parent didSelectRow: %d inComponent:%d", row, component);
    
    pickerCategory = [[NSUserDefaults standardUserDefaults] integerForKey:@"pickerCategory"];
    
    if (pickerCategory == 0) {
        switch (row) {
            case 0:
                description.text = @"";
                break;
            case 1:
                description.text = @"";
                break;
            case 2:
                description.text = @"";
                break;
            case 3:
                description.text = @"";
                break;
            default:
                description.text = @"";
                break;
        }
    }

    else if (pickerCategory == 1){
        switch (row) {
            case 0:
                description.text = kIssueDescPavementIssue;
                break;
            case 1:
                description.text = kIssueDescTrafficSignal;
                break;
            case 2:
                description.text = kIssueDescBikeLaneIssue;
                break;
            default:
                description.text = kIssueDescNoteThisSpot;
                break;
        }
    }
    else if (pickerCategory == 2){
        switch (row) {
            default:
                description.text = @"";
                break;
        }
    }
    else if (pickerCategory == 3){
        
        NSMutableAttributedString *descriptionAttributedText = [[NSMutableAttributedString alloc] initWithString:kIssueDescCrashNearMiss];
        NSMutableAttributedString *link = [[NSMutableAttributedString alloc] initWithString:@"More info on what to do after a crash is on our website"];
        [link addAttribute:NSLinkAttributeName value:@"http://www.ibikeknx.com/brochures" range:NSMakeRange(0, link.length)];
        [descriptionAttributedText appendAttributedString:link];
        [descriptionAttributedText addAttribute:NSForegroundColorAttributeName
                                          value:[UIColor whiteColor]
                                          range:NSMakeRange(0, descriptionAttributedText.length)];
        [descriptionAttributedText addAttribute:NSFontAttributeName
                                          value:[UIFont fontWithName:@"Arial" size:16]
                                          range:NSMakeRange(0, descriptionAttributedText.length)];

        
        switch (row) {
            case 0:
                description.attributedText = nil;
                description.text = kIssueDescPavementIssue;
                break;
            case 1:
                description.attributedText = nil;
                description.text = kIssueDescTrafficSignal;
                break;
            case 2:
                description.attributedText = nil;
                description.text = kIssueDescBikeLaneIssue;
                break;
            case 3:
                description.text = nil;
                description.attributedText = descriptionAttributedText;
                break;
            case 4:
                description.attributedText = nil;
                description.text = kIssueDescNoteThisSpot;
                break;
            default:
                description.text = @"";
                break;

        }
    }
}



- (void)dealloc
{
    self.delegate = nil;
    self.customPickerView = nil;
	self.customPickerDataSource = nil;
    self.description = nil;
    self.descriptionText = nil;

	[customPickerDataSource release];
	[customPickerView release];
    [delegate release];
    [description release];
    [descriptionText release];
    
    [navBarItself release];
	
	[super dealloc];
}

#pragma mark - Additions for single view submission

- (IBAction)answerChanged:(UISwitch *)sender
{
    NSLog(@"Switch moved");
    if (self.tookPublicTransitSwitch.on) {
        self.answerYesNo.text = @"Yes";
    } else {
        self.answerYesNo.text = @"No";
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    backgroundView = [[UIView alloc] initWithFrame:detailTextView.frame];
    backgroundView.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:backgroundView belowSubview:detailTextView];
    
    [UIView animateWithDuration:0.25 animations:^{
        [doneButton setHidden:NO];
        [doneButton setEnabled:YES];
        
        detailTextView.center = CGPointMake(detailTextView.center.x, detailTextView.center.y - 200);
        backgroundView.frame = self.view.frame;
        backgroundView.center = CGPointMake(self.view.center.x, self.view.center.y + 44);
        additionalDetails.center = CGPointMake(additionalDetails.center.x, additionalDetails.center.y - 200);
        doneButton.center = CGPointMake(doneButton.center.x, doneButton.center.y - 200);
    }];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.25 animations:^{
        detailTextView.center = CGPointMake(detailTextView.center.x, detailTextView.center.y + 200);
        backgroundView.frame = detailTextView.frame;
        backgroundView.center = CGPointMake(detailTextView.center.x, detailTextView.center.y + 200);
        additionalDetails.center = CGPointMake(additionalDetails.center.x, additionalDetails.center.y + 200);
        doneButton.center = CGPointMake(doneButton.center.x, doneButton.center.y + 200);
        
        [doneButton setHidden:YES];
        [doneButton setEnabled:NO];
    }];
    
    [backgroundView removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if(!CGRectContainsPoint(detailTextView.frame, touchLocation)) {
        [detailTextView resignFirstResponder];
    }
}

- (void)doneButtonPressed:(id)sender {
    [detailTextView resignFirstResponder];
}

#pragma mark - Additons for Note saving

- (void)finishSavingNote {
    NSInteger row = [customPickerView selectedRowInComponent:0];
    
    pickedNotedType = [[NSUserDefaults standardUserDefaults] integerForKey:@"pickedNotedType"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:row forKey: @"pickedNotedType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    pickedNotedType = [[NSUserDefaults standardUserDefaults] integerForKey:@"pickedNotedType"];
}

@end
