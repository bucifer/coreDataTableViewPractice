//
//  ViewController.h
//  Terry Practice Core Data
//
//  Created by Aditya Narayan on 9/19/14.
//  Copyright (c) 2014 NM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Celeb.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    
}

@property NSMutableArray *celebs;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *ageField;

- (IBAction)addButton:(id)sender;


-(NSString *) archivePath;
- (void) initModelContext;

-(void)createCeleb:(NSNumber*)celeb_id name:(NSString*)name age:(NSNumber*)age;
-(void)deleteCeleb:(int)index;
-(void)saveChanges;

-(void)loadAllCelebs;



@end
