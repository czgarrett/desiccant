//
//  DTGLKitBaseEffectEditorViewController.h
//  word-game-3
//
//  Created by Garrett Christopher on 10/26/11.
//  Copyright (c) 2011 ZWorkbench, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface DTGLKitBaseEffectEditorViewController : UITableViewController

@property (nonatomic, retain) GLKBaseEffect *effect;
@property (nonatomic, retain) NSMutableArray *sections;

- (id)initWithEffect: (GLKBaseEffect *) newEffect;


- (void) addLightEffect: (NSInteger) lightIndex;
- (void) addGeneralEffectProperties;
- (void) addMaterialProperties;
- (void) addFogProperties;

- (void) addSectionTitled: (NSString *) title rows: (NSArray *) rows;


@end
