##CallOutFx: A Flex/Spark CallOut and CallOutButton for web or desktop applications

The Flex SDK already has these components, but they are purely mobile implementations and as such they cannot be used in
a regular web or desktop application.
CallOutFx aims to bring a similar functionality to traditional applications. Note that for the time being it is merely
an ad-hoc implementation. It is hardly configurable, though you can go a long way with custom skins already.

##CallOut
Extends [SkinnablePopUpContainer][]

###Additional SkinParts
 - arrow:IVisualElement (optional)

###Usage:
For now the only use case for CallOut is in composition with CallOutButton. No explicit usage has been envisaged.

##CallOutButton
Extends [Button][] and implements IDropDownContainer

###Additional SkinParts
 - dropDown:IFactory (optional)

###Additional properties
 - callout:CallOut
 - calloutContent:Array<IVisualElement> (default property)
 - calloutLayout:LayoutBase
 - triggerEvent:String (**rollOver**, mouseOver, click)

###Additional events
 - DropDownEvent.OPEN
 - DropDownEvent.CLOSE

###Usage:
    <rs:CallOutButton id="calloutButton" label="{list.selectedItem || 'Select an item'}">
        <s:List id="list" dataProvider="{listItems}" left="0" right="0" change="calloutButton.closeDropDown()"/>
    </rs:CallOutButton>

    <rs:CallOutButton id="helpButton" icon="@Embed('/../gfx/icon-16/help.png')">
        <rs:calloutLayout>
            <s:VerticalLayout gap="10"/>
        </rs:calloutLayout>

        <s:Button id="manualButton" label="Manual" width="100%" click="helpButton.closeDropDown()"/>
        <s:Button id="releaseNotesButton" label="Release notes" width="100%" click="helpButton.closeDropDown()"/>
    </rs:CallOutButton>

[SkinnablePopUpContainer]: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/spark/components/SkinnablePopUpContainer.html
[Button]: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/spark/components/Button.html
