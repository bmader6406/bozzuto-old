/*
 Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
 For licensing, see LICENSE.html or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function(config)
{
  config.PreserveSessionOnFileBrowser = true;
  config.language = 'en';

  //config.ContextMenu = ['Generic','Anchor','Flash','Select','Textarea','Checkbox','Radio','TextField','HiddenField','ImageButton','Button','BulletedList','NumberedList','Table','Form'] ;

  config.height = '250px';
  config.width = '690px';
  config.uiColor = '#ddd';

  // works only with en, ru, uk languages
  config.extraPlugins = "attachment";

  config.toolbar = 'Easy';
  config.toolbar_Easy =
  [
    ['Source','-','-', 'Cut','Copy','Paste','PasteText','PasteFromWord'],
    ['Undo','Redo','-','SelectAll','RemoveFormat'],
    ['Link','Unlink','-','Embed'],
    '/',
    ['Format', 'Bold','Italic','Underline','Strike','-', 'TextColor'],
    ['NumberedList','BulletedList','-'],
    ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
    ['Image','Attachment']
  ];
};
