/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

//CKEDITOR.editorConfig = function( config )
//{
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
//};

CKEDITOR.editorConfig = function( config )
{
  config.height = '250px';
  config.width = '690px';
  config.uiColor = '#ddd';

  config.toolbar = 'Easy';
  config.toolbar_Easy =
    [
        ['Source','-','-', 'Cut','Copy','Paste','PasteText','PasteFromWord',],
        ['Undo','Redo','-','SelectAll','RemoveFormat'],
        ['Link','Unlink','-','Embed'], 
        '/',
        ['Format', 'Bold','Italic','Underline','Strike','-', 'TextColor'],
        ['NumberedList','BulletedList','-'],
        ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
    ];

};
  
