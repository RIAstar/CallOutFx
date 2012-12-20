package net.riastar.components {

import flash.events.Event;
import flash.events.MouseEvent;

import mx.core.ClassFactory;
import mx.core.IFactory;

import net.riastar.components.supportClasses.IDropDownContainer;

import spark.components.Button;
import spark.components.supportClasses.DropDownController;
import spark.events.DropDownEvent;
import spark.events.PopUpEvent;
import spark.layouts.supportClasses.LayoutBase;


[Event(name="close", type="spark.events.DropDownEvent")]
[Event(name="open", type="spark.events.DropDownEvent")]

[DefaultProperty("calloutContent")]

public class CallOutButton extends Button implements IDropDownContainer {

    [SkinPart(required="false")]
    public var dropDown:IFactory;


    private var _callout:CallOut;
    [Bindable("calloutChanged")]
    public function get callout():CallOut {
        return _callout;
    }
    protected function setCallout(value:CallOut):void {
        _callout = value;
        if (hasEventListener("calloutChanged")) dispatchEvent(new Event("calloutChanged"));
    }

    private var _calloutContent:Array;
    [ArrayElementType("mx.core.IVisualElement")]
    public function get calloutContent():Array {
        return _calloutContent;
    }
    public function set calloutContent(value:Array):void {
        _calloutContent = value;
        if (callout) callout.mxmlContent = value;
    }

    private var _calloutLayout:LayoutBase;
    public function get calloutLayout():LayoutBase {
        return _calloutLayout;
    }
    public function set calloutLayout(value:LayoutBase):void {
        _calloutLayout = value;
        if (callout) callout.layout = value;
    }

    [Inspectable(category="General", enumeration="rollOver,mouseOver,click", defaultValue="rollOver")]
    public var triggerEvent:String = MouseEvent.ROLL_OVER;


    private var dropDownController:DropDownController;


    override public function initialize():void {
        dropDownController = new DropDownController();
        dropDownController.closeOnResize = false;
        dropDownController.addEventListener(DropDownEvent.OPEN, handleDropDownOpen);
        dropDownController.addEventListener(DropDownEvent.CLOSE, handleDropDownClose);
        dropDownController.rollOverOpenDelay = 0;
        dropDownController.openButton = this;

        super.initialize();
    }

    override protected function partAdded(partName:String, instance:Object):void {
        super.partAdded(partName, instance);

        if (partName == "dropDown") {
            var calloutInstance:CallOut = instance as CallOut;

            if (calloutInstance && dropDownController) {
                calloutInstance.id = "callout";
                dropDownController.dropDown = calloutInstance;

                calloutInstance.addEventListener(PopUpEvent.OPEN, handleCalloutOpen);
                calloutInstance.addEventListener(PopUpEvent.CLOSE, handleCalloutClose);

                calloutInstance.mxmlContent = _calloutContent;
                if (_calloutLayout) calloutInstance.layout = _calloutLayout;
            }
        }
    }

    override protected function attachSkin():void {
        super.attachSkin();
        if (!dropDown && !("dropDown" in skin)) dropDown = new ClassFactory(CallOut);
    }


    private function handleDropDownOpen(event:DropDownEvent):void {
        if (!callout) setCallout(createDynamicPartInstance("dropDown") as CallOut);
        if (!callout) return;

        addEventListener(Event.REMOVED_FROM_STAGE, handleButtonRemoved);
        callout.open(this, false);
    }

    private function handleDropDownClose(event:DropDownEvent):void {
        if (!callout) return;

        removeEventListener(Event.REMOVED_FROM_STAGE, handleButtonRemoved);
        callout.close();
    }

    private function handleCalloutOpen(event:PopUpEvent):void {
        dispatchEvent(new DropDownEvent(DropDownEvent.OPEN));
    }

    private function handleCalloutClose(event:PopUpEvent):void {
        if (dropDownController.isOpen) closeDropDown();

        /*if (calloutDestructionPolicy == ContainerDestructionPolicy.AUTO)
         destroyCallout();*/

        dispatchEvent(new DropDownEvent(DropDownEvent.CLOSE));
    }

    private function handleButtonRemoved(event:Event):void {
        if (!isDropDownOpen) return;

        callout.visible = false;
        closeDropDown();
    }


    public function get isDropDownOpen():Boolean {
        return dropDownController ? dropDownController.isOpen : false;
    }

    public function openDropDown():void {
        dropDownController.openDropDown();
    }

    public function closeDropDown():void {
        dropDownController.closeDropDown(false);
    }

}
}
