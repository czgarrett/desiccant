
#import "desiccant_controllers.h"
#import "desiccant_views.h"

@class DTSingleTextFieldEditorViewController;

@protocol DTSingleTextFieldEditorViewControllerDelegate

- (void) editsWereSavedInSingleTextFieldEditor: (DTSingleTextFieldEditorViewController *) editor;

@end


@interface DTSingleTextFieldEditorViewController : DTCustomTableViewController <UITextFieldDelegate> {
   IBOutlet UITextField *textField;
   NSString *placeholder;
   NSString *initialText;
   id <DTSingleTextFieldEditorViewControllerDelegate> delegate;
   NSInteger tag;
   UITextAutocapitalizationType autocapitalizationType;
}

@property (nonatomic, assign) id <DTSingleTextFieldEditorViewControllerDelegate> delegate;
@property (nonatomic, readonly) UITextField *textField;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) NSString *initialText;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) UITextAutocapitalizationType autocapitalizationType;

- (void) savePressed: (id) source;
- (void) cancelPressed: (id) source;


@end
