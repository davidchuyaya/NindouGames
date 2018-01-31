package 
{
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	//for the drag
	import flash.geom.Rectangle;

	public class PageMVC extends MovieClip
	{
		private var _model:Object;
		private var _controller:Object;
		//movieclips
		private var _upButton = new UpButton;
		private var _downButton = new DownButton;
		private var _graphic;
		//values
		private var _currentPage:uint;
		private var _gotoNext:Boolean;
		private var _gotoPrevious:Boolean;

		public function PageMVC(model:Object, controller:Object):void
		{
			_model = model;
			_controller = controller;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_model.addEventListener(Event.CHANGE, onChange);
			_currentPage = 0;
			_gotoNext = false;
			_gotoPrevious = false;
			initialize();
		}
		private function initialize():void
		{
			//adding scrolling stuff
			addChild(_upButton);
			_upButton.x = 450;
			_upButton.y = 550;
			addChild(_downButton);
			_downButton.x = 450;
			_downButton.y = 650;
			_upButton.addEventListener(MouseEvent.CLICK, onUpClick);
			_downButton.addEventListener(MouseEvent.CLICK, onDownClick);
			//add the first page of whatever;
			addFirstPage();
		}
		private function onChange(event:Event):void
		{
			//scrolling to the next page
			if (_gotoNext)
			{
				//keep moving the picture up
				if (_graphic.y > -400)
				{
					_graphic.y -= 20;
				}
				//when it's done, go to the next frame
				else
				{
					_gotoNext = false;
					_currentPage++;
					_graphic.gotoAndStop(_currentPage);
					_graphic.y = 400;
				}
			}
			//scrolling to the previous page
			if (_gotoPrevious)
			{
				if (_graphic.y < 400)
				{
					_graphic.y += 20;
				}
				else
				{
					_gotoPrevious = false;
					_currentPage--;
				}
			}
		}
		private function addFirstPage():void
		{
			//change what the "graphics" are by looking at what the stage is
			switch (_model.currentStage)
			{
				case "AboutScreen" :
					_graphic = new AboutScreen;
					_graphic.officialSiteButton.addEventListener(MouseEvent.CLICK, onOfficialSiteClick);
					_graphic.myWebLink.addEventListener(MouseEvent.CLICK, onMyWebLinkClick);
					break;
				case "SettingsScreen":
					_graphic = new SettingsScreen;
					_graphic.scoochBar.nob.addEventListener(MouseEvent.MOUSE_DOWN, onNobDrag);
					//find out the percent of the model's scooch and reflect that (the -200 is because the axis is in the middle)
					_graphic.scoochBar.nob.x = _model.scooch / _model.ORIGINAL_SCOOCH * 200 - 200;
					_graphic.scoochBar.numDisplay.text = _model.scooch;
					break;
				default :
					trace("something is wrong with addFirstPage");
					trace(_model.currentStage);
					break;
			}
			addChild(_graphic);
			_graphic.x = 240;
			_graphic.y = 400;
			_graphic.gotoAndStop(1);
			//push the buttons to by higher than the graphic
			_upButton.parent.setChildIndex(_upButton, _upButton.parent.getChildIndex(_graphic));
			_downButton.parent.setChildIndex(_downButton, _downButton.parent.getChildIndex(_graphic));
			_currentPage = 1;
		}
		/*
		* BUTTON EVENT LISTENERS
		*/
		private function onUpClick(event:MouseEvent):void
		{
			gotoNextPage(false);
		}
		private function onDownClick(event:MouseEvent):void
		{
			gotoNextPage(true);
		}
		//from aboutScreen
		private function onOfficialSiteClick(event:MouseEvent):void
		{
			_controller.processOfficialSiteClick();
		}
		private function onMyWebLinkClick(event:MouseEvent):void
		{
			_controller.processMyWebLinkClick();
		}
		//from settingsScreen
		private function onNobDrag(event:MouseEvent):void
		{
			var boundary:Rectangle = new Rectangle(-200, 0, 400, 0);
			event.target.startDrag(false, boundary);
			event.target.nob.addEventListener(MouseEvent.MOUSE_UP, onNobDragStop);
		}
		private function onNobDragStop(event:MouseEvent):void
		{
			event.target.stopDrag();
			//send the new value to the controller. The nob's x is +200 because it is in the center of a bar that's 400px wide
			_controller.processNewScooch(event.target.x + 200, event.target.parent.name);
			//now reset the number based on what bar this is
			switch (event.target.parent.name)
			{
				case "scoochBar":
					event.target.parent.numDisplay.text = _model.scooch;
					break;
				default:
					trace("something wrong with onNobDragStop in PageMVC");
					break;
			}
			event.target.removeEventListener(MouseEvent.MOUSE_UP, onNobDragStop);
		}
		/*
		* OTHER IMPORTANT FUNCTIONS
		*/
		private function gotoNextPage(yeaOrNay:Boolean):void
		{
			if (! _gotoNext && ! _gotoPrevious)
			{
				//go to the next page
				if (yeaOrNay && (_currentPage + 1 <= _graphic.totalFrames))
				{
					_gotoNext = true;
				}
				//go to the previous page
				else if (! yeaOrNay && (_currentPage - 1 > 0))
				{
					_gotoPrevious = true;
					_graphic.gotoAndStop(_currentPage - 1);
					_graphic.y = -400;
				}
			}
		}
		private function onRemovedFromStage(event:Event):void
		{
			//go back to the first page to get rid of weird TypeError bug
			_graphic.gotoAndStop(1);
			//remove most eventlisteners
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_model.removeEventListener(Event.CHANGE, onChange);
			_upButton.removeEventListener(MouseEvent.CLICK, onUpClick);
			_downButton.removeEventListener(MouseEvent.CLICK, onDownClick);
			//remove specific eventlisteners
			switch (_model.currentStage)
			{
				case "AboutScreen":
					_graphic.officialSiteButton.removeEventListener(MouseEvent.CLICK, onOfficialSiteClick);
					_graphic.myWebLink.removeEventListener(MouseEvent.CLICK, onMyWebLinkClick);
					break;
				case "SettingsScreen":
					_graphic.scoochBar.nob.removeEventListener(MouseEvent.MOUSE_DOWN, onNobDrag);
					break;
				default:
					trace("something went wrong in 'onRemovedFromStage");
					break;
			}
			removeChild(_upButton);
			removeChild(_downButton);
			removeChild(_graphic);
		}
	}
}